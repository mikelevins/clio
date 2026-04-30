# clio-example-counters

Three buttons labeled A, B, and C, minted from the Lisp REPL after
the page is up. Each button has its own Lisp-side click handler.
Clicking any button increments that button's counter and prints
`A: n, B: n, C: n` to the REPL.

## What this example demonstrates

- Minting browser elements dynamically from the Lisp REPL after the
  page has loaded, rather than building them into the page at render
  time.
- The FUNCTION lane of `encode-create-button`: passing a Lisp
  function as `:onclick` so that the button's click event is routed
  back to Lisp for handling, not to browser-side JavaScript.
- Clio's element registry as the routing mechanism that makes this
  work: three buttons all emit identical-type messages distinguished
  only by element id, and the registry is what maps id back to the
  right Lisp handler.
- Per-button state via ordinary Lisp closures. Each button's
  handler closes over its own `(label . count)` cell.

Compared to the hello example, this one uses **no inline
Parenscript** and **no custom message types**: everything flows
through Clio's built-in `element-event` plumbing.

## Running

Load Clio and this example:

```lisp
(asdf:load-system :clio-example-counters)
(clio-example-counters:start)
```

A browser window opens at `http://localhost:8080/counters`. Wait for
it to load and connect (a `Connected` line should appear in the
REPL). Then install the buttons:

```lisp
(clio-example-counters:install-buttons)
```

Three buttons appear. Click them in any order; watch the REPL
update with running tallies.

Re-running `install-buttons` resets the Lisp-side counters but does
not remove the previous DOM buttons from the browser. Reload the
page to get a fresh container.

## Files

- `clio-example-counters.asd` — system definition.
- `package.lisp` — package, uses `cl` and `spinneret`, exports
  `start` and `install-buttons`.
- `counters.lisp` — landing page, per-button handlers, entry points.
- `NOTES.md` — design pressure surfaced while writing this example.

## Shutting down

```lisp
(clio:stop-server)
```
