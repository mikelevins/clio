# clio-example-htmx

Two HTMX patterns on one page: a button that fetches a greeting
fragment from Lisp, and a live-filter input that re-renders a list
as the user types. Both are pure HTTP — no WebSocket, no element
registry.

## What this example demonstrates

- Serving HTML fragments from Lisp-side Hunchentoot easy-handlers
  built with Spinneret's `with-html-string`.
- HTMX's request/response pattern with `hx-get`, `hx-target`, and
  `hx-swap` for the button case.
- HTMX's `hx-trigger="keyup changed delay:200ms"` for the live-
  filter case. The debounce is essential: without it, every
  keystroke hits the server.
- That Clio's `hx-*` attribute prefix registration (in
  `src/parameters.lisp`) suppresses Spinneret's unknown-attribute
  warnings without interfering with anything.

Compared to the earlier examples:

- **hello** round-tripped via WebSocket with inline Parenscript;
  this example uses HTTP only.
- **counters** minted elements dynamically over the WebSocket and
  routed click events through the Lisp-side registry; this example
  pre-renders its elements on the page and swaps server-rendered
  fragments into place over HTTP.

The two mechanisms (WebSocket + registry, HTMX) coexist cleanly in
the same Clio server but do not compose — see `NOTES.md`.

## Running

Load Clio and this example:

```lisp
(asdf:load-system :clio-example-htmx)
(clio-example-htmx:start)
```

A browser window opens at `http://localhost:8080/htmx`. Click the
"Greet me" button a few times — the greeting fragment updates each
time with a fresh timestamp. Then type in the filter input. The
list narrows with each keystroke (200ms after you stop typing);
deleting characters widens it again; emptying the field restores
the full list.

### Network requirement

The page pulls HTMX from `https://unpkg.com/htmx.org@2.0.4`. If
you're offline, the HTMX attributes won't fire and the example
will appear inert.

## Files

- `clio-example-htmx.asd` — system definition.
- `package.lisp` — package, uses `cl` and `spinneret`, exports
  `start`.
- `htmx.lisp` — landing page and fragment endpoints.
- `NOTES.md` — design pressure surfaced while writing this example.

## Shutting down

```lisp
(clio:stop-server)
```
