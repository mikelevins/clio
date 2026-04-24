# Hello example — design pressure log

Observations recorded while writing this example, for
encode-create-canvas and later Clio design work to consult.
Each item is evidence about where Clio's current boundaries sit,
not a proposal for Clio changes.

## Everything interesting in Clio is internal

The example reaches into Clio's package via double-colon at five
distinct call sites:

- `clio::register-message-handler`
- `clio::register-handler-initializer`
- `clio::start-server`
- `clio::start-browser`
- `clio::*clio-server-port*`

This works today because Clio's package exports nothing. Any
external user of Clio — and this example is in some sense the first
such user — will need at least these five symbols. They are a
reasonable candidate first-cut public API, but the evidence here is
just that no deliberate choice has yet been made about what Clio
offers externally, and the first witness surfaces the question.

## `/` path collision avoided, not resolved

The example serves at `/hello` rather than `/` specifically to dodge
Clio's existing default landing handler in `src/ui.lisp`. The
underlying issue — that Clio's built-in landing page wants `/`, and
so will every Clio-based app that doesn't prefix its own routes —
is deferred, not solved. The known-architectural-issues list
already flags "duplicate landing handler"; this example is more
evidence that the right long-term shape for Clio's default `/` is
probably "nothing, until an app installs one."

## Page-embedded elements don't get the four-lane treatment

`encode-create-button` and `encode-create-input` offer a four-lane
event-handler dispatch (nil / string / Parenscript cons / Lisp
function) for buttons and inputs minted at runtime over the
WebSocket. Elements defined inline in a Spinneret page, like this
example's button, get none of that: the onclick is wired in a
bottom-of-page script block by hand. Both the inline page and the
runtime-minted paths are first-class ways to put a button on a page
in Clio, but only one of them has the registry-integrated event
dispatch.

This is not a problem for hello-world specifically. It is evidence
about an asymmetry in Clio's current feature surface that later
examples (counters, in particular) will feel more sharply.

## `start-server` always signals a warning on restart

`(clio::start-server)` is idempotent in effect — calling it again
when the server is already running does nothing harmful — but it
signals a WARN condition rather than returning quietly. The
example's `start` function calls it unconditionally for simplicity,
which means re-running `(clio-example-hello:start)` produces a
warning at the REPL. Alternative would be to check
`clio::listening?` and branch, which is two more lines of
boilerplate per example. Kept as-is; the noise is acceptable for
a worked example and the simpler `start` reads better.

## Handler-initializer pattern is more plumbing than a newbie expects

To register a single message handler, this example defines a
zero-argument `initialize-hello-example-message-handlers` function
and passes its name to `register-handler-initializer` at top level.
The alternative of a single top-level call

```lisp
(clio::register-message-handler "hello-greeting" 'handle-hello-greeting)
```

would work on a fresh load but lose the registration the next time
Clio's handler table is rebuilt (which happens inside
`start-server`). The initializer indirection is the price of
survival across handler-table rebuilds. Worth flagging that for a
simple single-handler case the scaffolding feels heavy; a
convenience along the lines of

```lisp
(clio:define-message-handler "hello-greeting" (parsed) ...body...)
```

that hides the initializer function would be cheap and reader-
friendly — but no reason to commit to one from a single witness.

## Inbound message parsing: two conventions in the codebase

`handle-ping` in `server.lisp` reads its payload by ignoring
`parsed` entirely. `handle-element-event` in `browser-api.lisp`
passes `parsed` through `as-message-payload` to get a keyword-keyed
plist with a uniqueness check. This example follows neither pattern
exactly: it needs a single field and reads it with
`(cdr (assoc :text parsed))` directly on the cl-json alist.

Three extraction styles coexisting is evidence that the inbound-
payload convention is not yet settled. `as-message-payload` looks
like the intended direction but it is not yet used uniformly. Not a
problem for one-field reads; will matter more as payloads get
richer.

## Parenscript `create` with keyword keys

`(create :type "hello-greeting" :text greeting)` emitted the object
literal we wanted on the first try. This is worth confirming because
the same form with hyphenated keyword keys (e.g. `:element-type`)
would be worth double-checking — Parenscript's camelCase conversion
applies to symbol names, but keyword keys in `create` may or may not
receive the same treatment depending on version. Only keys used
here were single-word, so the question is deferred.
