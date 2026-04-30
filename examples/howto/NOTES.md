# NOTES

Design notes specific to this example. Cross-cutting Clio design is
in `HOWTO.md` at the project root.

## The fall-through static-folder dispatcher

Hunchentoot's built-in `create-folder-dispatcher-and-handler` claims
every URI matching its prefix: a request that prefix-matches but has
no file on disk gets a 404 from the folder dispatcher rather than
falling through to easy-handlers. That's fine when you mount the
dispatcher at a side prefix like `/clio/` (as `hello` and `counters`
do), since URLs outside that prefix never reach it. It's a hazard
when you mount at `/`, because the dispatcher then shadows every
easy-handler on the server, including Clio's built-in
`/favicon.ico` shim.

Clio's `serve-static-folder` resolves this by being a fall-through
dispatcher: it returns NIL when the requested path isn't a regular
file, letting the request continue down `*dispatch-table*` to
easy-handlers. That's what makes the recommended drop-in layout
work — one mount at `/`, no shadowing. See the preamble comment on
`serve-static-folder` in `clio/src/deployment.lisp` for the full
story.

In this example, the consequence is that the page declares no
explicit favicon link. The implicit `/favicon.ico` request the
browser makes falls through the `/`-mounted dispatcher and lands on
Clio's favicon shim, which serves the bundled icon. No favicon
plumbing in the example's source.

## `send-server-message` silently drops when no client is connected

Same behavior the `counters` example documents. `(announce ...)`
called before the browser has connected updates `*announcements*`
but doesn't reach the page; the browser will see future
announcements but not the early ones. The stats endpoint reads
`*announcements*` directly and is unaffected. In practice this
means: open the page first, wait for the WebSocket to connect, then
announce.

## The page is its own primary documentation

Each `<h2>` block on the landing page has a brief intro paragraph
explaining what the section demonstrates and how to drive it from
the REPL. A reader who lands on the page can orient without
flipping to the HOWTO. The HOWTO covers the *why* of each
mechanism; the page covers the *what* and the *how*.

## Why the announcement handler is registered inline in `<head>`

Three options were available for placing the consumer-side handler
registration:

1. Inline `<script>` in the page's `<head>`, between the two Clio
   script tags. (Chosen.)
2. A separate static JS file referenced by `<script src=...>`,
   loaded between the two Clio scripts.
3. Inline at the bottom of `<body>`, after both Clio scripts.

Option 3 is wrong: by the time `<body>` finishes parsing, the
WebSocket may already be open and delivering messages. Option 2 is
correct but adds a file. Option 1 is the smallest thing that works
and keeps the load-order rule visible at the same place where the
consumer reads the rest of the page. The HOWTO discusses option 2
as the appropriate choice for a non-trivial app.

## Why `(start)` resets `*announcements*`

A second call to `(howto:start)` is a no-op for the running server
(`start-server` warns and returns), but it's a fresh entry point
for the developer's mental model: "I'm starting over." Resetting
the Lisp-side list matches that. The browser-side list lives in the
DOM and is whatever's currently rendered; reload the page to clear
it. The mismatch is intentional and documented in `START`'s
docstring.
