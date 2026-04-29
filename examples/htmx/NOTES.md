# HTMX example — design pressure log

Observations recorded while writing this example, for
encode-create-canvas and later Clio design work to consult. This
example is the first that exercises none of Clio's WebSocket
infrastructure, so most of the observations are about what is and
isn't composable across Clio's two delivery mechanisms.

## HTMX works entirely over HTTP; Clio's WebSocket infrastructure is untouched

No use of `send-server-message`, no `encode-*` functions, no
message handlers, no element registry. The example is three
Hunchentoot easy-handlers, one of which serves the landing page
and two of which serve HTML fragments. Clio's role reduces to
"an HTTP server that happens to also support WebSocket upgrade on
a separate path." This is not a criticism — it is a confirmation
that the two layers are cleanly independent.

## `hx-` attribute prefix registration worked silently

The `pushnew` of `"hx-"` onto
`spinneret:*unvalidated-attribute-prefixes*` in
`src/parameters.lisp` did its job: no compile-time warnings from
Spinneret about the `hx-get`, `hx-target`, `hx-swap`, or
`hx-trigger` attributes used in the landing page. No evidence of
drift here.

## WebSocket and HTMX do not compose

The fruit list on the landing page is server-rendered at page
load; filtering replaces it wholesale via HTMX swap. There is no
way today to make each `<li>` a registry-backed Clio element that
subsequent WebSocket messages could address individually. An app
that wanted hybrid behaviour — HTMX-initiated creation of elements
that Lisp could later update via push messages — would need
either a bridge that registers post-swap elements with the Clio
registry (probably via an `hx-swap`-observing mutation observer on
the browser side) or a convention that HTMX fragments emit
registry-known IDs and the server side calls `make-element` to
pre-register them.

No urgency for this; the example works fine without composition.
Recording as evidence that the two mechanisms are independent
today and will remain so until a concrete app needs them to
interoperate.

## Fragment-endpoint boilerplate is minimal but uniform

Each fragment endpoint looks the same:

```lisp
(hunchentoot:define-easy-handler (... :uri ...) (...)
  (setf (hunchentoot:content-type*) "text/html")
  (with-html-string
    ...))
```

Three lines of boilerplate per endpoint. A Clio-level convenience
along the lines of `define-fragment-endpoint` would collapse this
to one line, but the savings are modest and the direct-Hunchentoot
pattern is transparently discoverable for a newbie. Recording as
non-pressure: no Clio change warranted from this one witness.

## Debounce is load-bearing

The `hx-trigger="keyup changed delay:200ms"` attribute is what
makes the live filter feel responsive rather than thrashing. With
`keyup changed` alone (no `delay`), every keystroke triggers an
immediate request; on a fast typist that's a request burst rather
than a filter. The `changed` modifier additionally suppresses
requests when the keystroke didn't alter the value (arrow keys,
modifier keys). Evidence that HTMX's trigger modifiers carry
real weight for the live-input pattern; this is not a place to
invent a Clio-specific alternative.

## Substring-filter plateaus are an honest limitation

Adjacent typed characters sometimes yield identical displayed
subsets — e.g., typing `a` then `ap` then `app` narrows the fruit
list to 22, 6, 2, and then `appl` and `apple` stay at 2 because no
fruit has `appe` or `apply` in it and `apple` is already fully
matched. Plateaus are inherent to substring matching over a finite
list, not an artifact of the implementation. The fruit list was
chosen to minimize plateaus in common typings; a more adversarial
input (typing `zzz`) will hit an empty-result plateau immediately.

Not a design-pressure item, but worth recording because a reader
may initially interpret the plateau as a bug.

## Input value extraction via GET parameter: Hunchentoot carries the concern

HTMX sends the input's current value as a query parameter whose
name matches the input's `name` attribute. On the Hunchentoot
side, naming `q` in the easy-handler's lambda list is enough;
`(q)` receives the URL-decoded string. No additional Clio work,
no encoding concerns on the wire. Evidence that Hunchentoot's
easy-handler is well-aligned with HTMX's conventions; no
intermediary layer is needed.
