# Clio HOWTO

This guide builds a small Clio application from scratch, exercising
the three core mechanisms Clio provides: a custom Lisp-pushed
message type, a Lisp-minted UI element with a Lisp-side click
handler, and an HTMX fragment served from Lisp. The finished example
lives at `examples/howto/`; this document explains how it's put
together and why each piece is the way it is.

## 1. Introduction

The application is an "announcement page." A Lisp-side
`*announcements*` list is the model. Three independent mechanisms feed
it:

- A `(howto:announce "...")` REPL call appends to the list and
  pushes a custom `announcement` message over the WebSocket; a
  handler registered in the page's `<head>` appends an `<li>`.
- A `(howto:install-button)` REPL call creates a button on the page;
  clicking it invokes a Lisp closure that calls the same
  `(announce ...)` function.
- A "Show stats" button on the page issues an HTMX `GET` to
  `/howto/stats`; the Lisp handler reads `*announcements*` and
  returns a fragment that HTMX swaps into the page.

Sections 2 through 6 build the page incrementally. By the end of
section 6 the source matches `examples/howto/howto.lisp`. 

Section 7 covers the deployment workflow: how to build a
standalone executable that serves the same page from its own asset
bundle.

### What's Clio API and what's a project template

Two things mix in this guide that are worth distinguishing.

**Clio's API** is a small, deliberate surface. The seven exported
symbols (`serve-static-folder`, `asset-directory`,
`executable-relative-pathname`, `*deployment-mode*`, `deployed-p`,
`with-deployment-mode`, `diagnose-asset-resolution`) plus the
`encode-create-*` functions, `register-message-handler`, and
`send-server-message` constitute the contract. This guide doesn't
deviate from any of it.

**Project templates** are recommendations, not requirements. The
`.asd` keys for building an executable, the `cl-user::main` entry-
point shim, the package nickname, the Makefile with `CLIO_DIR` at the
top, the deploy-bundle layout — these are a reasonable way to
structure a project, but not the only way. If you build executables
differently, name entry points differently, or organizes assets
differently, that doesn't mean you're doing it wrong.  Clio doesn't
have an opinion.

## 2. Project skeleton

Three files: a system definition, a package definition, and a
landing-page handler. The directory layout is:

```
howto/
  clio-example-howto.asd
  package.lisp
  howto.lisp
```

### The system definition

```lisp
(asdf:defsystem #:clio-example-howto
  :description "Clio synthesis example"
  :depends-on (:clio)
  :serial t
  :build-operation "program-op"
  :build-pathname "howto"
  :entry-point "cl-user::main"
  :components ((:file "package")
               (:file "howto")))
```

Only `:depends-on (:clio)` is required for the project to load and run
from a REPL. The three `:build-*` keys are part of the project
template: they make the system a candidate for `asdf:make`, which
calls `save-lisp-and-die` to produce a standalone executable named
`howto` (or `howto.exe` on Windows). `:entry-point "cl-user::main"`
names the function the dumped image calls on startup. Section 7
returns to this.

### The package

```lisp
(defpackage #:clio-example-howto
  (:nicknames #:howto)
  (:use #:cl #:spinneret)
  (:export #:start
           #:install-button
           #:announce))
```

The `#:howto` nickname is what the REPL calls use: `(howto:start)`,
`(howto:announce "...")`, `(howto:install-button)`. The full package
name preserves the per-example naming convention used elsewhere in
`examples/`. The `:use` of `#:spinneret` imports its HTML-generation
symbols so the page handler can call `with-html-string` and the
element macros directly.

### The landing-page handler

The third file is the application code. We'll start with the
smallest thing that loads: a single easy-handler that serves a
"Hello" page, with everything else added in subsequent sections.

```lisp
(in-package #:clio-example-howto)

(hunchentoot:define-easy-handler (howto-landing :uri "/howto") ()
  (setf (hunchentoot:content-type*) "text/html")
  (with-html-string
    (:doctype)
    (:html
     (:head (:title "Clio HOWTO example"))
     (:body (:h1 "Clio HOWTO example")
            (:p "Hello.")))))

(defun start ()
  (clio:start-server)
  (clio:start-browser
   (format nil "http://localhost:~A/howto"
           clio:*clio-server-port*)))
```

The `define-easy-handler` form mounts the handler at `/howto` rather
than `/` so Clio's default landing page is left alone.

Load and start:

```lisp
(asdf:load-system :clio-example-howto)
(howto:start)
```

A browser window opens on `http://localhost:8080/howto` showing
"Hello." The `cl-user::main` definition that the `.asd`'s
`:entry-point` names doesn't exist yet — it's a thin shim defined
in section 7, and the REPL workflow doesn't need it.

## 3. Serving assets: the drop-in pattern

The page so far loads no CSS, no JavaScript, and no favicon. To
exercise Clio's asset-serving machinery, this section adds a
stylesheet served from the project's own `public/` directory and
arranges for Clio's bundled JavaScript to be served from the same
directory tree. The page declares no explicit favicon link; the
browser's implicit `/favicon.ico` request is handled along the way.

### The drop-in convention

Clio is a library a developer drops into their project. The
recommended deployment is: the project's `public/` directory is the
only asset tree, and Clio's bundled assets — the JavaScript, the
favicon images — live as a subdirectory inside it at
`public/clio/`. The project copies Clio's `public/` contents into its
own `public/clio/` once, treating it the way one would treat any
vendored library asset.

The runtime consequence is that one `serve-static-folder` mount at `/`
is sufficient. The same on-disk URL structure
(`/clio/js/clio-protocol.js`, `/css/howto.css`) works in both
development and deployment. The only difference between development
and deployment is where `public/` itself is found: resolved via
`asdf:system-relative-pathname` in development, via
`clio:executable-relative-pathname` in deployment. Section 7 returns
to the deployment side.

### Setting up the directory

Create the `public/` tree:

```
howto/
  public/
    css/
      howto.css
    clio/
      (contents of clio's own public/ directory)
```

The `clio/` subdirectory is populated by copying — literally
`cp -R /path/to/clio/public/. public/clio/`. The example's
`Makefile` has a `refresh-clio-assets` target that re-runs this
copy whenever Clio's bundled assets change; section 7 shows it.

Add a small stylesheet at `public/css/howto.css`. Anything that
makes the page look intentional rather than browser-default is
fine; the example uses about thirty lines of CSS with rules for
`body`, `h1`, `h2`, `code`, and a couple of element ids that
appear later. The point isn't the styling; it's that the project
serves an asset of its own from `public/css/`, distinct from the
Clio assets it serves from `public/clio/`.

### Wiring the dispatcher

Update `start` to register a single static-folder dispatcher at `/`,
and link the stylesheet from the page:

```lisp
(hunchentoot:define-easy-handler (howto-landing :uri "/howto") ()
  (setf (hunchentoot:content-type*) "text/html")
  (with-html-string
    (:doctype)
    (:html
     (:head
      (:title "Clio HOWTO example")
      (:link :rel "stylesheet" :href "/css/howto.css"))
     (:body (:h1 "Clio HOWTO example")
            (:p "Hello.")))))

(defun start ()
  (clio:serve-static-folder
   "/"
   (if (clio:deployed-p)
       (clio:executable-relative-pathname "public/")
       (asdf:system-relative-pathname :clio-example-howto "public/")))
  (clio:start-server)
  (clio:start-browser
   (format nil "http://localhost:~A/howto"
           clio:*clio-server-port*)))
```

Reload the system, call `(howto:start)` again, and the page should
arrive styled. The browser's implicit favicon request lands too — not
on the project's `public/`, but on Clio's bundled favicon shim, which
is an easy-handler. The next subsection explains why mounting at `/`
doesn't shadow it.

### Why mounting at `/` works

Hunchentoot's built-in folder dispatcher, the one created by
`create-folder-dispatcher-and-handler`, claims every URI matching its
prefix: a request that prefix-matches but has no file on disk gets a
404 from the folder dispatcher rather than falling through to
easy-handlers. That behavior is fine when you mount at a side prefix
like `/clio/`, since URLs outside that prefix never reach the
dispatcher. It's a hazard when you mount at `/`, because the
dispatcher then shadows every easy-handler on the server, including
Clio's `/favicon.ico` shim.

`clio:serve-static-folder` is a fall-through dispatcher: it
returns NIL when the requested path isn't a regular file under
the served folder, letting the request continue down
`hunchentoot:*dispatch-table*` to easy-handlers and other
dispatchers. Path components containing `..` are rejected before
the file lookup, so traversal outside the served folder isn't
reachable. That fall-through is what makes one mount at `/`
compose with easy-handlers — no shadowing of the favicon shim,
no conflict with `/howto` or `/howto/stats`, no need for a side
prefix.

The page's lack of an explicit favicon link is part of the
demonstration: the implicit `/favicon.ico` request flows through the
dispatcher (no matching file in `public/`), past the fall-through, and
lands on Clio's easy-handler shim. No favicon plumbing in the
project's source.

### A note on `asset-directory`

Clio also exports `asset-directory`, which returns the path to Clio's
bundled `public/` directory directly. Earlier versions of Clio
recommended a two-dispatcher pattern: one folder dispatcher for the
project's own assets at a side prefix, and a second one calling
`asset-directory` to serve Clio's bundled files from `/clio/`. That
pattern still works and remains supported as an escape hatch for
projects that can't use the drop-in workflow.  The recommended path
doesn't touch it. See `asset-directory`'s docstring for details if you
need it.

## 4. Lisp creates a button

This section adds a button to the page that doesn't exist in the
HTML. It's created at runtime by Lisp, over the WebSocket, with its
click handler living on the Lisp side as a closure. The mechanism is
`clio:encode-create-button` paired with `clio:send-server-message`,
and the click round-trip uses Clio's element registry.

### The two Clio script tags

The browser side of this needs Clio's JavaScript loaded. There are two
files: `clio-protocol.js`, which defines the message-handler registry,
the element-creation dispatch, and the built-in handlers; and
`clio-ws.js`, which opens the WebSocket and routes inbound traffic
into the dispatcher. Add both to the page's `<head>`, in that order:

```lisp
(:head
 (:title "Clio HOWTO example")
 (:link :rel "stylesheet" :href "/css/howto.css")
 (:script :src "/clio/js/clio-protocol.js")
 (:script :src "/clio/js/clio-ws.js"))
```

The order matters: `clio-protocol.js` defines `dispatchClioMessage`
and the `registerMessageHandler` function; `clio-ws.js` calls
`dispatchClioMessage` from its `onmessage` hook. Section 5 inserts a
third script tag *between* these two and gives the load-order rule a
full treatment.

### A container for created elements

Clio's button-creation handler appends the new button to a DOM element
identified by id. The id is supplied per call via the `:into` keyword
on `encode-create-button` (and `encode-create-input`), with
`"main-container"` as the default. Add an empty `<div>` to the page
where you want minted buttons to appear:

```lisp
(:body
 (:h1 "Clio HOWTO example")
 (:p "...")
 (:div :id "main-container"))
```

The example uses the default. To direct a minted element somewhere
else, pass `:into "some-id"` and ensure the page contains an element
with that id. If the id doesn't resolve at handler time, the browser
warns to the console and skips the append rather than throwing.

### Creating the button

Add the model and the install function:

```lisp
(defparameter *announcements* '()
  "List of (universal-time . text) cons cells, newest first.")

(defun announce (text)
  (push (cons (get-universal-time) text) *announcements*)
  text)

(defun install-button ()
  (clio:send-server-message
   (clio:encode-create-button
    "Announce my click"
    :onclick (lambda (element payload)
               (declare (ignore element payload))
               (announce "Lisp-minted button was clicked"))))
  (values))
```

`encode-create-button` builds the JSON envelope for a `create-element`
message and registers the closure in Clio's element registry under a
freshly-created KSUID. `send-server-message` ships the envelope over
the WebSocket. On the browser side, `handleCreateButton` creates the
DOM button, wires its `onclick` to a relay closure that sends an
`element-event` message back to Lisp, and registers the wrapper in
the browser-side element registry under the same KSUID.

When the button is clicked, the browser sends:

```json
{"type": "element-event", "event": "click", "id": "<the ksuid>"}
```

Lisp's `handle-element-event` looks up the element by id, retrieves
the closure registered under `:click`, and calls it with the element
and the payload plist. In this case the closure ignores both and
calls `(announce ...)`. The page doesn't update yet — `*announcements*`
gets a new entry but nothing visible happens. Section 5 wires up the
visible side.

### The four event-handler lanes

The `:onclick` argument to `encode-create-button` accepts four shapes,
dispatched by type:

- A **function** is registered in the element registry under the
  event name and called when the matching `element-event` arrives
  back from the browser. This is the lane the example uses.
- A **string** is treated as literal JavaScript source, evaluated by
  the browser, and assigned to the DOM button's `onclick` slot. The
  click never crosses the wire.
- A **cons** is treated as a Parenscript form, compiled to JavaScript
  at encode time, and otherwise behaves like the string lane.
- **NIL** (the default) wires no handler at all. The button is inert.

The `encode-create-input` function uses the same four-lane dispatch
on its `:onchange` argument. The same lanes apply to any future
`encode-create-*` Clio adds.

## 5. A custom message type pushed from Lisp

Clio ships built-in handlers for `ping`, `pong`, `reload`, and
`create-element`. Beyond those, a project registers its own
message types. This section adds an `announcement` message type:
Lisp pushes it over the WebSocket, the browser handler appends an
`<li>` to a list on the page.

### The browser-side handler and the load-order rule

A consumer registers a message handler by calling
`registerMessageHandler` from a script that runs after
`clio-protocol.js` has loaded (so the function exists) and before
`clio-ws.js` has loaded (so the registration is in the dispatcher
table by the time the socket opens and messages start arriving).
The clean place for that is an inline `<script>` block between the
two Clio script tags:

```lisp
(:head
 (:title "Clio HOWTO example")
 (:link :rel "stylesheet" :href "/css/howto.css")
 (:script :src "/clio/js/clio-protocol.js")
 (:script
  (:raw
   "registerMessageHandler('announcement', function(envelope) {
    const ul = document.getElementById('announcements');
    const li = document.createElement('li');
    li.textContent = '[' + envelope.timestamp + '] ' + envelope.text;
    ul.appendChild(li);
});"))
 (:script :src "/clio/js/clio-ws.js"))
```

If the registration lands in the wrong place — typically at the
bottom of `<body>`, where the developer's instinct says scripts
belong — the WebSocket may already be open and delivering messages
by the time the handler registers. The first few `announcement`
messages reach `dispatchClioMessage` with no handler in the table;
the dispatcher's fall-through path warns to the console with a
self-explaining reminder:

```
Clio: no handler registered for message type "announcement". If you
registered one in your own code, ensure that script loads after
clio-protocol.js and before clio-ws.js. Envelope: {...}
```

That message exists so a misordered registration produces something
the developer can pattern-match, rather than the page being silently
inert. For a non-trivial project the same registration belongs in a
separate JavaScript file referenced by `<script src=...>` from the
same slot between the two Clio tags. Inline is fine for a tutorial.

### The `<ul>` the handler targets

Add an empty list to the page; the handler appends `<li>` elements
to it as announcements arrive:

```lisp
(:body
 (:h1 "Clio HOWTO example")
 (:p "...")
 (:ul :id "announcements")
 (:p "...")
 (:div :id "main-container"))
```

### The Lisp side

Update `announce` to push the message after recording it:

```lisp
(defun announce (text)
  (let ((timestamp (get-universal-time)))
    (push (cons timestamp text) *announcements*)
    (clio:send-server-message
     (cl-json:encode-json-plist-to-string
      `(:type "announcement"
        :text ,text
        :timestamp ,(format-timestamp timestamp))))
    text))

(defun format-timestamp (universal-time)
  (multiple-value-bind (sec min hour) (decode-universal-time universal-time)
    (format nil "~2,'0D:~2,'0D:~2,'0D" hour min sec)))
```

Reload, call `(howto:start)`, wait for the page to load and the
WebSocket to connect, then:

```lisp
(howto:announce "first")
(howto:install-button)
(howto:announce "second")
```

Both `announce` calls add lines to the announcements list on the
page. Clicking the minted button adds a third — the click closure
calls `announce`, which pushes through the same channel.

If `announce` is called before the browser has connected — for
example, right after `start` returns and before the page finishes
loading — `send-server-message` silently drops the outbound message;
`*announcements*` is still updated. This matches the behavior of the
`counters` example. In practice: open the page first, wait, then
announce.

## 6. An HTMX fragment

The third mechanism is an HTMX swap. A "Show stats" button on the
page issues a `GET` to `/howto/stats`; a Lisp easy-handler reads
`*announcements*` and returns an HTML fragment; HTMX swaps the
fragment into a `<div>` on the page.

This section uses no Clio mechanisms. The handler is a plain
Hunchentoot easy-handler returning a string. HTMX runs entirely
in the browser. The point is that Clio coexists with HTMX without
friction: the same page can drive part of its UI through Clio's
WebSocket channel and another part through HTMX over plain HTTP,
and the two don't interact. The `htmx` example demonstrates the
all-HTMX case in isolation; this section just shows the pieces
sitting next to each other.

### The HTMX library

Add the HTMX script tag to the page's `<head>`. The example loads
it from a CDN; vendoring it into `public/` is equally fine.

```lisp
(:head
 (:title "Clio HOWTO example")
 (:link :rel "stylesheet" :href "/css/howto.css")
 (:script :src "https://unpkg.com/htmx.org@2.0.4")
 (:script :src "/clio/js/clio-protocol.js")
 (:script (:raw "..."))
 (:script :src "/clio/js/clio-ws.js"))
```

The HTMX tag is placed above the two Clio script tags purely as a
visual convention: it keeps the two Clio tags adjacent, with the
inline registration script wedged between them, so the load-order
rule from section 5 stays self-evident at a glance. There is no
functional ordering constraint between HTMX and Clio.

### The button and the swap target

Add a button with `hx-get`, `hx-target`, and `hx-swap` attributes,
and an empty `<div>` for the fragment to land in:

```lisp
(:body
 (:h1 "Clio HOWTO example")
 (:p "...")
 (:ul :id "announcements")
 (:p "...")
 (:div :id "main-container")
 (:p "...")
 (:button :hx-get "/howto/stats"
          :hx-target "#stats"
          :hx-swap "innerHTML"
          "Show stats")
 (:div :id "stats"))
```

Spinneret would emit `:hx-get "/foo"` as `hx-get="/foo"` either way
— the keyword name is kebab-cased into the attribute name — but it
warns about attributes it doesn't recognize. Clio adds `"hx-"` to
`spinneret:*unvalidated-attribute-prefixes*` at load time so the
`hx-*` attributes pass without warning.

### The fragment handler

The Lisp side is a second easy-handler that reads `*announcements*`
and returns an HTML fragment:

```lisp
(hunchentoot:define-easy-handler (howto-stats :uri "/howto/stats") ()
  (setf (hunchentoot:content-type*) "text/html")
  (with-html-string
    (cond
      ((null *announcements*)
       (:span "No announcements yet."))
      (t
       (:span ("~A announcement~:P, last at ~A."
               (length *announcements*)
               (format-timestamp (car (first *announcements*)))))))))
```

The handler reads `*announcements*` directly. The model is owned
by Lisp, so the HTMX request is just a synchronous read; no
coordination with the WebSocket channel is needed.

Reload, call `(howto:start)`, push a few announcements, and click
"Show stats." The stats panel updates. Push more announcements and
click again — the panel updates again with the new count.

The example's source matches `examples/howto/howto.lisp` at this
point. Section 7 turns to the deployment workflow.

## 7. Deployment

The development workflow above runs out of a Lisp REPL: ASDF
finds the project, the project's `start` function resolves
`public/` via `asdf:system-relative-pathname`, the server is up,
the browser opens. This section covers the alternate workflow:
producing a standalone executable that runs without ASDF, without
a REPL, and without the project source on disk.

### The mechanism

Clio's runtime needs to know, on each call to `start`, where
`public/` is. In development, ASDF answers that. In a deployed
executable, ASDF isn't available; `public/` is resolved relative
to the running executable instead, via `uiop:argv0`.

Clio cannot infer which mode it's in. A freshly-built executable
sitting on the dev host looks identical from disk to a
development image running from the same project directory: same
filesystem layout, same `public/` directory at the same relative
path. The build script sets the mode explicitly before
`save-lisp-and-die`:

```lisp
(setf clio:*deployment-mode* :deployed)
```

`clio:deployed-p` returns true if the mode is `:deployed` and false
otherwise. The example's `start` function uses it to choose the
resolution path:

```lisp
(clio:serve-static-folder
 "/"
 (if (clio:deployed-p)
     (clio:executable-relative-pathname "public/")
     (asdf:system-relative-pathname :clio-example-howto "public/")))
```

`clio:executable-relative-pathname` reads `uiop:argv0` and merges
its argument relative to the directory containing the running
executable. So a deployed `howto` binary sitting next to a
`public/` directory finds it; a development image running from
the project root finds the same `public/` via ASDF instead. The
on-disk URL structure under `public/` is the same either way —
`/clio/js/clio-protocol.js`, `/css/howto.css` — so the page's
HTML doesn't change between the two modes.

For a sanity check at the REPL, `clio:diagnose-asset-resolution`
prints the current deployment mode and the resolved asset
directory:

```
CL-USER> (clio:diagnose-asset-resolution)
Deployment mode: DEVELOPMENT
Resolved asset directory: /Users/you/repos/lisp/clio/public/
ASDF source directory for :clio: /Users/you/repos/lisp/clio/
```

### The two build workflows

There are two reasonable ways to drive a deployed build: from a
running REPL, and from a transient SBCL invoked by `make`. Both
end up at the same place — a `howto` (or `howto.exe`) binary next
to a populated `public/` tree — but they differ in how they set
the deployment mode.

#### From the REPL

`clio:with-deployment-mode` binds `*deployment-mode*` for the
dynamic extent of its body, restoring the prior value on exit.
The dev REPL stays in `:development` mode after the build:

```lisp
(clio:with-deployment-mode (:deployed)
  (asdf:make :clio-example-howto))
```

`asdf:make` invokes the system's `:build-operation`, which is
`"program-op"` per the `.asd`. ASDF calls `save-lisp-and-die`,
which dumps the current image — including the `:deployed` value
of `*deployment-mode*` baked into the dumped `*deployment-mode*`
slot — to a binary named per `:build-pathname`. The result is
`howto` in the project directory. The deploy bundle (assembled
in the next subsection) needs `public/` placed next to it.

#### From `make`

The Makefile workflow is what the example actually uses for builds
of record. It invokes a fresh SBCL, sets `*deployment-mode*`
explicitly, and calls `asdf:make`:

```make
CLIO_DIR ?= ../..
LISP     ?= sbcl

build:
	$(LISP) --non-interactive \
	    --eval '(asdf:load-system :clio)' \
	    --eval '(setf clio:*deployment-mode* :deployed)' \
	    --eval '(asdf:load-system :clio-example-howto)' \
	    --eval '(asdf:make :clio-example-howto)'
	rm -rf deploy
	mkdir -p deploy/public/clio
	mv howto deploy/
	cp -R public/css deploy/public/
	cp -R $(CLIO_DIR)/public/. deploy/public/clio/
```

`with-deployment-mode` is dynamic-extent, so wrapping the
`asdf:make` call with it inside this script wouldn't reliably
survive `save-lisp-and-die` across implementations.
`(setf clio:*deployment-mode* :deployed)` does the same job at top
level, and the SBCL process exits when the script finishes, so
there's no dev session to leave in the wrong mode.

Two variables at the top: `CLIO_DIR` is the path to the Clio
repository checkout (default `../..`, correct when the example
builds from inside the Clio repo), and `LISP` is the
implementation name (default `sbcl`). Override either on the
command line: `make CLIO_DIR=/path/to/clio LISP=sbcl`.

The bundle-assembly steps after the build:

- `mv howto deploy/` — move the binary into the bundle.
- `cp -R public/css deploy/public/` — copy the project's own
  assets.
- `cp -R $(CLIO_DIR)/public/. deploy/public/clio/` — copy Clio's
  bundled assets into `public/clio/`. The trailing `/.` copies
  the contents of `public/` rather than the directory itself.

The `refresh-clio-assets` target re-runs the third copy on its
own, for use during development when Clio's bundled assets
change:

```make
refresh-clio-assets:
	rm -rf public/clio
	mkdir -p public/clio
	cp -R $(CLIO_DIR)/public/. public/clio/
```

A `make.bat` in the example directory provides the Windows
equivalent: same `CLIO_DIR` and `LISP` defaults, same three
targets, `xcopy` and `move` instead of `cp` and `mv`,
`howto.exe` instead of `howto`. See `examples/howto/make.bat`.

### The deploy bundle

After `make build`, the bundle layout is:

```
deploy/
  howto                     (or howto.exe on Windows)
  public/
    css/
      howto.css
    clio/
      js/
        clio-protocol.js
        clio-ws.js
      img/
        favicon.ico
        favicon-16x16.png
        favicon-32x32.png
```

Run it:

```
cd deploy
./howto
```

The binary calls `cl-user::main`, which calls `(howto:start)`,
which sets up the static-folder dispatcher (resolving `public/`
via `executable-relative-pathname` because `*deployment-mode*` is
`:deployed`), starts the server, and opens the browser. The
process then blocks on `(loop (sleep 60))` so the image keeps
running; close the terminal or hit Ctrl+C to shut it down.

The `cl-user::main` function itself is small enough to show in
full. Add it to the bottom of `howto.lisp`:

```lisp
(in-package :cl-user)

(defun main ()
  (howto:start)
  (format t "~&Clio HOWTO example running.~%~
             This terminal is a Lisp REPL. Type (quit) to shut down.~%")
  #+sbcl
  (progn
    (sb-ext:enable-debugger)
    (sb-impl::toplevel-init)))
```

The `(in-package :cl-user)` switch is the point of the shim:
`save-lisp-and-die` looks up the entry point by symbol name in
`cl-user`, so `main` has to be defined there. The body delegates
to the project package, then enters SBCL's REPL on stdin/stdout
so the launching terminal becomes a Lisp prompt. The deployed
app is something a Lisper can drive: `(howto:announce "...")`
and `(howto:install-button)` work exactly as they do in
development, which is what the page's body text already assumes.
`(quit)` shuts the app down. `(sb-ext:enable-debugger)` reverses
ASDF program-op's default of disabling the debugger; without it,
a typo at the prompt would trigger the fatal-condition handler
and terminate the image rather than letting the user recover
from the debugger.

### Building without a terminal REPL

If the deployed app runs as a service under a process supervisor,
or as a desktop application launched from a window manager rather
than a terminal, the REPL on stdin/stdout is the wrong shape. The
alternative is to keep `main` blocking and let the user shut it
down with Ctrl+C:

```lisp
(in-package :cl-user)

(defun main ()
  (howto:start)
  (format t "~&Clio HOWTO example running. ~
             Press Ctrl+C to shut down.~%")
  (handler-case
      (loop (sleep 60))
    #+sbcl
    (sb-sys:interactive-interrupt ()
      (format t "~&Shutting down.~%")
      (uiop:quit 0))))
```

The `handler-case` catches SBCL's `interactive-interrupt` so
Ctrl+C exits cleanly; without it, ASDF program-op's debugger-
disabled setting would turn Ctrl+C into a backtrace before
exiting. For Swank-driven live debugging — the canonical Lisp
pattern for production services — start a Swank server from
`main` before the blocking loop and connect from your editor.
That's beyond this guide.
