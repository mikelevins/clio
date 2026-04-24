# clio-example-hello

The simplest interactive Clio page. One text input, one "Hello"
button, and a "Send to Lisp?" checkbox. Clicking the button pops a
JS alert; if the checkbox is checked, the same greeting is also sent
back to Lisp over the websocket and printed to the REPL.

## What this example demonstrates

- Serving a Clio-hosted landing page via `hunchentoot:define-easy-handler`
  on a URI other than `/`, so Clio's own default landing page is left
  alone.
- HTML generation with Spinneret (`with-html-string`).
- Wiring browser-side behavior in Parenscript via a bottom-of-body
  `<script>` block that uses `addEventListener`.
- Sending a custom message type from the browser to Lisp via the
  `sendObject` global exposed by `clio-ws.js`.
- Registering a Lisp-side handler for the custom message type using
  Clio's handler-initializer pattern so it survives server restarts.

It does **not** use the Clio element registry. Later examples
introduce that.

## Running

Load Clio and then this example:

```lisp
(asdf:load-system :clio-example-hello)
(clio-example-hello:start)
```

A browser window should open at
`http://localhost:8080/hello`. Type a name (or leave blank), click
"Hello", observe the alert. Check "Send to Lisp?" and click again:
the alert still pops, and the greeting string additionally prints
to the Lisp REPL.

If ASDF cannot find either system, see the top-level
`examples/README.md` for ASDF-discoverability instructions.

## Files

- `clio-example-hello.asd` — system definition.
- `package.lisp` — package, uses `cl`, `spinneret`, `parenscript`,
  and exports `start`.
- `hello.lisp` — landing page, message handler, entry point.
- `NOTES.md` — design pressure surfaced while writing this example.

## Shutting down

```lisp
(clio::stop-server)
```
