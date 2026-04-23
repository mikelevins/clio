var ClioSocket = new WebSocket("ws://" + window.location.host + "/ws");
let heartbeatInterval;

// ---------------------------------------------------------------------
// KSUID minting (browser side)
// ---------------------------------------------------------------------
// Symmetric with the net.bardcode.ksuid Common Lisp library. Uses the
// same epoch constant (+ksuid-unix-epoch-seconds+ = 1400000000) so
// byte layouts round-trip between Lisp and the browser. BigInt is
// required because KSUIDs encode a 160-bit integer as 27 base62
// characters and 160 bits doesn't fit in a Number.

const CLIO_KSUID_UNIX_EPOCH_SECONDS = 1400000000n;
const CLIO_KSUID_BASE62_ALPHABET =
    "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
const CLIO_KSUID_STRING_LENGTH = 27;

function makeKsuid() {
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
    return makeKsuid();
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
// set a heartbeat to keep the websocket open
// ---------------------------------------------------------------------

ClioSocket.onopen = function() {
    console.log('Connected');
    // Send heartbeat every 20 seconds
    heartbeatInterval = setInterval(() => {
        if (ClioSocket.readyState === WebSocket.OPEN) {
            ClioSocket.send(JSON.stringify({ type: 'ping' }));
        }
    }, 20000);
};

// ---------------------------------------------------------------------
// receiving messages
// ---------------------------------------------------------------------

ClioSocket.onmessage = function (event) {
    var data = JSON.parse(event.data);
    //console.log(data);
    handleWSEvent(data);
}

function handleWSEvent(eventData) {
    let eventType = eventData['type'];
    if (eventType == 'ping') {
        console.log("Received WS ping");
        sendObject({type: 'pong'});
    } else if (eventType == 'pong') {
        console.log("Received WS pong");
    } else if (eventType == 'reload') {
        window.location.reload();
    } else if (eventType == 'create-element') {
        handleCreateElement(eventData);
    } else {
        console.log("Received WS event: ");
        console.log(eventData);
    }    
}

function handleCreateElement(eventData){
    let elementType = eventData['elementType'];
    if (elementType == 'button') {
        handleCreateButton(eventData);
    } else {
        console.log("Received create element: ");
        console.log(eventData);
    }    
    
}

function handleCreateButton(eventData){
    console.log(eventData);
    let elementText = eventData['text'];
    let elementId = eventData['id'];
    let elementScriptText = eventData.onclick;
    let elementScript = eval(elementScriptText);
    let mainContainer = document.getElementById('main-container');
    let btn = document.createElement("button");
    btn.setAttribute('id',elementId);
    btn.innerHTML = elementText;
    btn.onclick = elementScript;
    mainContainer.appendChild(btn);
    registerElement(elementId, 'button', btn, null);
}


// ---------------------------------------------------------------------
// sending messages
// ---------------------------------------------------------------------

function sendObject(object){
    ClioSocket.send(JSON.stringify(object));
}


function pingLisp () {
    sendObject({type: 'ping'});
}
