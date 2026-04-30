# clio-example-howto

A from-scratch synthesis example demonstrating the three core Clio
mechanisms on a single page:

1. **A custom Lisp-pushed message type.** Lisp announces, the page
   updates over the WebSocket via a consumer-side
   `registerMessageHandler` registration in the page's `<head>`.
2. **A FUNCTION-lane Lisp-minted button.** The button is created at
   runtime by Lisp; clicks round-trip back as `element-event`
   messages and fire a Lisp closure that recorded its identity at
   mint time.
3. **An HTMX-driven fragment.** A "Show stats" button GETs an HTML
   fragment from `/howto/stats` and HTMX swaps it into the page.

All three feed the same `*announcements*` model owned by Lisp, so
the demonstration coheres around one observable thing.

## Running it

From a Lisp REPL with this directory on your ASDF source registry:

```lisp
(asdf:load-system :clio-example-howto)
(howto:start)
```

A browser window opens on `http://localhost:8080/howto`. Once it
has loaded and the WebSocket has connected, try:

```lisp
(howto:announce "first announcement")
(howto:install-button)        ; creates "Announce my click" on the page
(howto:announce "another one")
```

Then click the page's "Show stats" button to see the HTMX swap.

## Building a deployable executable

See the project-root `HOWTO.md` for the deployment workflow, or just
run `make` (or `make.bat` on Windows) from this directory. The build
produces a `deploy/` bundle containing the `howto` executable next
to a populated `public/` tree.

## Walkthrough

For a section-by-section walkthrough that builds this example from
scratch, see `HOWTO.md` at the project root. This README is only the
README; `HOWTO.md` is the explanation.
