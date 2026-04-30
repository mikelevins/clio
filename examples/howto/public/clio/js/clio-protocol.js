// ---------------------------------------------------------------------
// clio-protocol.js
// ---------------------------------------------------------------------
// Browser-side Clio protocol layer: KSUID minting, element registry,
// message-handler registry, dispatch, and the built-in handlers
// (ping, pong, reload, create-element). Loaded before clio-ws.js.
// Knows nothing about the WebSocket itself; clio-ws.js owns the
// socket lifecycle and routes inbound traffic into the dispatcher
// defined here.
//
// Consumer code registers its own inbound message handlers via
// registerMessageHandler. The registration must run after this file
// loads and before clio-ws.js loads, so that the dispatcher has the
// handler available by the time the socket starts delivering
// messages. The HOWTO walks through this load-order pattern; see
// also the warning emitted by dispatchClioMessage when a message
// arrives for a type that has no registered handler.

// ---------------------------------------------------------------------
// wire-format invariants
// ---------------------------------------------------------------------
// Clio-produced envelopes (in both directions) are JSON objects with
// unique keys. On this side:
//
//   Outbound: all messages are built as plain object literals and
//   shipped via sendObject. Object literals have unique keys by
//   language rule.
//
//   Inbound:  JSON.parse discards duplicate keys by spec, keeping the
//   last. The Lisp side guarantees outbound messages have unique keys
//   by construction, so this is not exercised in practice.
//
// See registry.lisp for the matching Lisp-side invariants and the
// as-message-payload backstop on inbound traffic. Any change that
// produces messages by a path other than sendObject on an object
// literal must preserve the uniqueness invariant.

// ---------------------------------------------------------------------
// KSUID minting (browser side)
// ---------------------------------------------------------------------
// Symmetric with the net.bardcode.ksuid Common Lisp library. Uses the
// same epoch constant (+ksuid-unix-epoch-seconds+ = 1400000000) so
// byte layouts round-trip between Lisp and the browser. BigInt is
// required because KSUIDs encode a 160-bit integer as 27 base62
// characters and 160 bits doesn't fit in a Number.

const CLIO_KSUID_UNIX_EPOCH_SECONDS = 1400000000n;
const CLIO_KSUID_BASE62_ALPHABET = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
const CLIO_KSUID_STRING_LENGTH = 27;

function make_ksuid() {
    // 20 bytes = 4 big-endian timestamp bytes + 16 random payload bytes
    const bytes = new Uint8Array(20);
    const unixNow = BigInt(Math.floor(Date.now() / 1000));
    const ts = unixNow - CLIO_KSUID_UNIX_EPOCH_SECONDS;
    bytes[0] = Number((ts >> 24n) & 0xFFn);
    bytes[1] = Number((ts >> 16n) & 0xFFn);
    bytes[2] = Number((ts >> 8n)  & 0xFFn);
    bytes[3] = Number( ts         & 0xFFn);
    crypto.getRandomValues(bytes.subarray(4, 20));
    // Pack all 20 bytes big-endian into a single BigInt
    let n = 0n;
    for (let i = 0; i < 20; i++) {
        n = (n << 8n) | BigInt(bytes[i]);
    }
    // Base62 encode, building the string most-significant digit first
    let digits = "";
    if (n === 0n) {
        digits = "0";
    } else {
        while (n > 0n) {
            digits = CLIO_KSUID_BASE62_ALPHABET[Number(n % 62n)] + digits;
            n = n / 62n;
        }
    }
    return digits.padStart(CLIO_KSUID_STRING_LENGTH, "0");
}

function makeElementId() {
    return make_ksuid();
}

// ---------------------------------------------------------------------
// element registry (browser side)
// ---------------------------------------------------------------------
// Parallel to the Lisp-side *element-registry*. The DOM stays the
// source of truth for the element itself; this registry holds the
// Clio wrapper (id, elementType, domNode, metadata) for fast
// id-based lookup and enumeration.

const clioElementRegistry = new Map();

function registerElement(id, elementType, domNode, metadata) {
    const wrapper = {
        id: id,
        elementType: elementType,
        domNode: domNode,
        metadata: metadata || null
    };
    clioElementRegistry.set(id, wrapper);
    return wrapper;
}

function lookupElement(id) {
    return clioElementRegistry.get(id);
}

function unregisterElement(id) {
    return clioElementRegistry.delete(id);
}

// ---------------------------------------------------------------------
// message-handler registry
// ---------------------------------------------------------------------
// Mirrors the Lisp-side *message-handlers* hash table. Inbound
// messages are dispatched by their `type` field; each registered
// handler receives the parsed envelope as its single argument.
//
// Built-in handlers (ping, pong, reload, create-element) register at
// the bottom of this file. Consumer code registers additional
// handlers from its own script blocks or files; that code must load
// after this file and before clio-ws.js so the registration is in
// place by the time the socket begins delivering messages.
//
// dispatchClioMessage is called from clio-ws.js's onmessage hook.
// Its fallback path warns explicitly about the load-order rule, so
// a misordered consumer registration produces a self-explaining
// console message rather than silent inactivity.

const clioMessageHandlers = new Map();

function registerMessageHandler(type, handler) {
    clioMessageHandlers.set(type, handler);
}

function unregisterMessageHandler(type) {
    return clioMessageHandlers.delete(type);
}

function dispatchClioMessage(envelope) {
    const messageType = envelope.type;
    const handler = clioMessageHandlers.get(messageType);
    if (handler) {
        handler(envelope);
    } else {
        console.warn(
            `Clio: no handler registered for message type "${messageType}". ` +
            `If you registered one in your own code, ensure that script ` +
            `loads after clio-protocol.js and before clio-ws.js. ` +
            `Envelope:`,
            envelope
        );
    }
}

// ---------------------------------------------------------------------
// event-handler resolution
// ---------------------------------------------------------------------
// resolveEventHandler encapsulates the three-lane dispatch that pairs
// with the Lisp-side ENCODE-EVENT-HANDLER in browser-api.lisp. Each
// handleCreate* function calls it once per event attribute it
// supports, passing the envelope's value for that attribute and a
// relay closure.
//
//   spec absent / null -- no handler wired; returns null. Interaction
//                          is inert.
//   spec === true       -- FUNCTION lane on the Lisp side. Returns the
//                          relay closure, which sends an element-event
//                          message back to Lisp. The closure is
//                          constructed by the caller because its
//                          payload is event-specific (e.g. button
//                          clicks carry only id; input changes also
//                          carry the current value).
//   spec is string      -- STRING or CONS (Parenscript) lane. Trimmed
//                          of trailing whitespace and semicolons, then
//                          wrapped in parens before eval, so both
//                          anonymous function literals and
//                          Parenscript's statement-form output parse
//                          as expressions.
//
// Keeping this helper ignorant of event names and payload shapes is
// what lets it stay small. Event-specific concerns (which payload
// fields to include, which DOM slot to assign the result to) stay in
// the handleCreate* caller.

function resolveEventHandler(spec, buildRelay) {
    if (spec === true) {
        return buildRelay;
    } else if (typeof spec === 'string') {
        return eval('(' + spec.replace(/[\s;]+$/, '') + ')');
    } else {
        return null;
    }
}

// ---------------------------------------------------------------------
// element creation
// ---------------------------------------------------------------------
// handleCreateElement is the second-level dispatcher for
// create-element messages, branching on elementType. It is closed
// over the two element types Clio currently supports (button and
// input); extending it requires editing this file. Promoting the
// inner dispatch to its own registry is a future increment.

function handleCreateElement(envelope) {
    let elementType = envelope['elementType'];
    if (elementType == 'button') {
        handleCreateButton(envelope);
    } else if (elementType == 'input') {
        handleCreateInput(envelope);
    } else {
        console.warn(
            `Clio: unknown elementType "${elementType}" in create-element envelope:`,
            envelope
        );
    }
}

function handleCreateButton(envelope) {
    let elementText = envelope['text'];
    let elementId = envelope['id'];
    let mainContainer = document.getElementById('main-container');
    let btn = document.createElement("button");
    btn.setAttribute('id', elementId);
    btn.innerHTML = elementText;
    const onclick = resolveEventHandler(
        envelope.onclick,
        () => sendObject({type: 'element-event', event: 'click', id: elementId}));
    if (onclick) { btn.onclick = onclick; }
    mainContainer.appendChild(btn);
    registerElement(elementId, 'button', btn, null);
}

function handleCreateInput(envelope) {
    let elementId = envelope['id'];
    let initialValue = envelope['value'];
    let mainContainer = document.getElementById('main-container');
    let input = document.createElement("input");
    input.setAttribute('id', elementId);
    input.setAttribute('type', 'text');
    input.value = initialValue || '';
    const onchange = resolveEventHandler(
        envelope.onchange,
        () => sendObject({type: 'element-event',
                          event: 'change',
                          id: elementId,
                          value: input.value}));
    if (onchange) { input.onchange = onchange; }
    mainContainer.appendChild(input);
    registerElement(elementId, 'input', input, null);
}

// ---------------------------------------------------------------------
// built-in handler registrations
// ---------------------------------------------------------------------
// Registered at the bottom of this file so that all handler
// definitions above are visible at registration time. These are
// installed alongside any consumer registrations; if a consumer
// registers their own handler for one of these built-in types, the
// later registration wins. That is the same overridability story as
// on the Lisp side and intentional.

registerMessageHandler('ping', (envelope) => {
    console.log("Received WS ping");
    sendObject({type: 'pong'});
});

registerMessageHandler('pong', (envelope) => {
    console.log("Received WS pong");
});

registerMessageHandler('reload', (envelope) => {
    window.location.reload();
});

registerMessageHandler('create-element', handleCreateElement);
