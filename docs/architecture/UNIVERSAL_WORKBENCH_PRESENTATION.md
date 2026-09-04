# Umicom Universal Workbench Presentation

## Purpose

This document records the presentation rules used by Umicom Framework and all
thin Umicom applications. It is a durable product and architecture decision,
not a delivery-number record.

## Governing rule

Umicom Framework owns reusable application identity, panel chrome, tab hosts,
docking, layout editing, responsive region geometry, appearance, command
discovery and layout persistence. Applications provide product identity,
composition, configuration and genuinely product-specific behaviour. They do
not recreate the shared shell.

## Application identity

Every native application header presents an Umicom mark and a readable product
name. The preferred mark is the packaged contrast-aware vector resource. When
that resource cannot be resolved, the Framework-owned `<>` mark remains
visible beside the product name. A resource packaging fault must never remove
the complete application identity.

## Normal workspace mode

Normal mode prioritises product work. Panel headers remain compact and expose
the title, linked-context state, close action and a compact menu for eligible
operations. Move, dock, detach, maximise, pin and settings actions continue to
exist; they are not removed to obtain a cleaner layout.

An eligible unpinned panel may be closed during normal use. Framework performs
the close through the authoritative workspace model, validates the result and
rebuilds the visible layout. The panel definition remains in the shared window
catalogue so it can be restored.

## Edit Layout mode

Structural controls become prominent only during an explicit reversible edit
session. The user can move, resize, dock, detach, group, auto-hide or close
eligible panels. Apply commits the validated arrangement. Cancel restores the
pre-edit snapshot. Protected and critical panels retain their declared policy.

## Responsive regions

Layouts use semantic regions rather than application-specific pixel constants:
left navigation, centre workspace, right context, top specialist strip, bottom
activity and floating surfaces. The centre remains the dominant flexible work
area. Empty regions do not consume permanent space. Saved user state may adjust
proportions while remaining within shared readability bounds.

## Scrolling

Generic panel bodies begin at their logical left edge and scroll vertically.
Specialised tables, timelines, diagrams, charts, editors and design canvases
may provide their own horizontal navigation where the content requires it.

## Application adoption

Umicom Studio IDE, Umicom Trader, Umicom TMS, Umicom Bank, Umicom Exchange,
Umicom Accountant, Umicom LLM and every other registered thin application must
consume these Framework contracts. Application repositories may add a small
presentation composition only when their product surface is genuinely unique;
they must not implement another generic shell, panel frame, layout store or
docking engine.

## Acceptance rules

1. The product name and Umicom mark remain visible at supported scaling levels.
2. Generic panels begin at the left edge and do not inherit stale horizontal
   scroll offsets.
3. Normal close routes through the workspace model and is recoverable through
   the panel catalogue.
4. Entering and leaving Edit Layout mode is visually and behaviourally clear.
5. Cancel restores the exact baseline; Apply persists only validated state.
6. Empty semantic regions do not create blank split panes.
7. Every visible command is functional, disabled with a reason, busy with
   progress, or hidden by policy.
8. The same rules apply to all applications through Framework ownership.
