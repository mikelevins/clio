# Clio examples

Small, self-contained projects that exercise Clio's current
capabilities and, secondarily, surface design pressure as evidence
for Clio's own next round of work. Each example lives in its own
subdirectory with its own `.asd` and is deliberately structured to
be copy-and-edit friendly: pull the directory out, rename the system
and package, and edit in place to get a starting skeleton for a new
Clio app.

## Suggested reading order

1. **hello** — The simplest interactive Clio page: one text input,
   one button, one checkbox. Demonstrates a Clio-served landing
   page, inline Parenscript, and a round-trip from browser to Lisp
   via a custom WebSocket message type. No use of the element
   registry.

2. **counters** — Three buttons minted from the Lisp REPL after the
   page is up. Each button has its own Lisp-side click handler
   dispatched through the element registry. Demonstrates the
   FUNCTION-lane event handler of `encode-create-button`, dynamic
   element minting over the WebSocket, and per-button state via
   Lisp closures.

3. **htmx** — A button that fetches a greeting fragment from Lisp,
   and a live-filter input that re-renders a list as the user
   types. Demonstrates HTMX over plain HTTP — no WebSocket, no
   registry — and confirms that Clio's `hx-*` attribute prefix
   registration composes cleanly with Spinneret.

4. **howto** — A synthesis example: a custom Lisp-pushed message
   type, a FUNCTION-lane Lisp-minted button, and an HTMX fragment,
   all feeding one Lisp-side `*announcements*` model on a single
   page. Demonstrates the three core Clio mechanisms cohering on
   one page, and exercises the recommended drop-in asset layout
   (one `serve-static-folder` mount at `/`, with Clio's bundled
   assets copied into the project's own `public/clio/`). The
   project-root `HOWTO.md` walks through it section by section.

More examples will be added in subsequent rounds; the ordering above
is intended to introduce one Clio concept per step, with the final
entry combining all three on one page.

## Running an example

Each example depends on `:clio`, so the Clio system must be
discoverable by ASDF before the example can load. Two common ways:

- Symlink or clone Clio into `~/common-lisp/` or
  `~/quicklisp/local-projects/`. ASDF searches both by default.
- Or push Clio's directory onto `asdf:*central-registry*` at the
  REPL:
  ```lisp
  (push #p"/path/to/clio/" asdf:*central-registry*)
  ```

The same applies to the example directory itself: it must be
discoverable by ASDF. The simplest approach is to symlink the
example's subdirectory into `~/common-lisp/` alongside Clio.

Once both are discoverable, each example has its own run
instructions in its own `README.md`.
