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

More examples will be added in subsequent rounds; the ordering above
is intended to introduce one Clio concept per step.

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
