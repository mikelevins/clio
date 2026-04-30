# Clio

Clio is a Common Lisp library that turns a web browser into a
presentation and UI server for a Lisp application. The browser
connects over a WebSocket; Lisp owns the application model and
pushes updates to the page through custom message types. UI
elements can be minted from Lisp at runtime, with click and change
handlers that live as Lisp closures — events round-trip back to
Lisp and fire the right closure via an element registry. Clio
coexists with HTMX over plain HTTP, so the same page can drive
part of its UI through the WebSocket channel and another part
through HTMX without friction. Clio is a library you drop into
your own project, not a framework that organizes the project for
you.

Under the hood, Clio sits on Hunchentoot and Hunchensocket for the
HTTP and WebSocket sides, generates HTML with Spinneret, and
compiles browser-side code from Parenscript. It supports both
REPL-driven development and standalone-executable deployment; the
project-root HOWTO.md walks through both workflows.
