# Rendering

This note commits Clio's rendering architecture ahead of
`encode-create-canvas` work. When drawing-vocabulary code lands, it
should be concrete calls against an agreed frame, not open-ended
design under the pressure of a specific feature.

## Mode: retained

Clio maintains a live dynamic link between Lisp and the browser.
Under that assumption, the natural interaction is mutation: move
this, recolor that, start this animation, now stop it. Retained mode
matches the live link; it matches the existing element registry,
which already tracks Lisp-side handles for browser-side objects; and
it matches Fabric, which manages retained-mode scene graphs as its
native business.

Immediate mode would fight all three. We'd be rebuilding frames on
every change, routing every mutation through a re-render, and
working against both the registry and Fabric. There is no gain to
offset the cost.

## Scene-node shape

Every rendering object -- primitive or composite, bottom of the
stack or application-specific -- is a JSON envelope:

    {type: "...", id?: "...", ...}

The shape is uniform; dispatch is table-driven on `type` on the JS
side. An application that wants its own rendering vocabulary does
not write a bespoke dispatcher; it registers entries in the shared
table under its own type tags. The dispatch table has one structure,
not N.

This is not new architecture. It is the existing Clio wire-format
invariants applied to scene content: Lisp ships unique-keyed JSON
envelopes with a `type` field, JS routes on the type, registered
handlers do the work. Scene nodes are envelopes by another name.

## Primitive / composite layering

Two layers, different policies.

**Primitives**. A closed set, maintained by Clio. Authored against
the chosen renderer's semantics. Not extensible by applications.
This is where Fabric (or SVG, or a future renderer) enters the
picture concretely.

**Composites**. An open set, extensible by applications. A composite
is either a transformation that expands to a tree of primitives when
it reaches the renderer, or a named type with its own dispatch-table
entry that handles its rendering directly.

The two-layer shape is familiar from the domain: Vega-Lite's marks
over SVG primitives, D3's selections over SVG elements. The pattern
shows up in every reasonable graphical DSL.

## Atoms at the renderer's level

The primitive set's semantic level is whatever the chosen renderer
operates at. For Fabric: `rect`, `line`, `circle`, `path`, `group`,
`gradient`, `animate-property`, `apply-filter`, and so on. The level
is non-uniform -- drawing primitives sit next to animation and
filter primitives -- and that is deliberate.

The alternative is to pick a lower semantic floor and reconstruct
the renderer's capabilities out of smaller atoms. That either
over-engineers (re-implementing hit-testing on paths, offscreen
caching, SVG path parsing, animation timing from scratch) or ships
degraded versions of things the renderer already does well. Neither
is an improvement.

The primitive set is where Clio meets the renderer. Meet it at its
own semantic level.

## Renderer neutrality

Fabric is the first renderer. It is not the privileged one. Inline
SVG as Vega-Lite uses it is a plausible second; WebGL is a plausible
third for performance-demanding applications. The architecture has
to stay usable when these arrive.

Four concrete disciplines uphold this:

The outer envelope stays renderer-agnostic. Message shape (`type`,
`id`, event names) is Clio's. Renderer-specific payload lives below,
keyed under a field owned by that renderer.

`clio-element` stays renderer-agnostic. The Lisp-side wrapper
carries an id, an element type, and metadata. Renderer choice is
element metadata, not a structural property of the wrapper.

Event payloads carry semantic coordinates, not renderer pixels. A
click in data space reaches Lisp as data-space coordinates. Each
renderer owns its own coordinate-to-semantics translation and hands
Lisp the semantic result.

No renderer object references are visible to Lisp. Lisp never holds
a Fabric handle or an SVG element handle. The bridge is the id.
Renderer-specific objects live only on the JS side of the element
registry.

These are the same disciplines that made the current event-handler
four-lane dispatch portable. They scale.

## Registered vs anonymous inside a canvas

A canvas will contain children. Some need event round-trip back to
Lisp -- a data point the user clicks to drill down. Others do not --
one of a thousand non-interactive dots in a scatter plot. The
boundary: children that need round-trip get KSUID-registered as
`clio-element` instances and participate in the element registry;
anonymous primitives are addressed structurally inside their canvas
wrapper and carry no id.

Cost asymmetry drives the split. A KSUID per element is fine at
tens; at tens of thousands it is registry bloat for no gain.
Anonymous primitives skip the registry entirely and are handled as
part of their canvas's internal structure.

The canvas wrapper itself is always registered. Addressing an
anonymous primitive means first routing to the canvas, then locating
within it. That is an acceptable indirection for the common case
where the canvas as a whole is the event target, and for the rarer
structural cases where a specific anonymous primitive has to be
reached.

This split is the one identity boundary worth drawing carefully up
front. Most other decisions can be deferred until the first
concrete vocabulary asks for them.

## Temporal events on the existing channel

Rendering produces events that are not user interactions: animation
completion, transition milestones, timer firings. These do not need
a second back-channel. They flow through the existing `element-event`
dispatcher with appropriate event names (`animation-complete`,
`transition-midpoint`, and so on), land in the handler registered on
the target element under that name, and come out as Lisp funcalls on
the element, exactly as user-interaction events already do.

One channel. One dispatcher. The existing infrastructure already
does this.

## Escape hatch: Parenscript-authored composites

An application that needs a rendering vocabulary Clio does not
provide can author it in Parenscript. The Parenscript form compiles
to a JS function that gets registered on the JS side under a type
tag; from then on, the application emits envelopes of that type and
Clio routes them to the registered handler.

This is the escape hatch at the rendering layer, and it is a natural
one. No third language is introduced: the composite is authored in
the same Parenscript idiom already used for in-browser event
handlers. No build step is added. When a vocabulary authored this
way proves broadly useful, it becomes a candidate for promotion into
Clio proper.

## Scope of this note

Committing this frame does not commit to specific primitive names,
specific wire-format field names, or a canvas implementation. Those
decisions happen in the `encode-create-canvas` round, constrained by
this frame but not dictated by it.
