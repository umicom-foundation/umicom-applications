# Workspace state protection

## Delivered scope

This is a native C correctness increment within the Working workbench baseline.
It repairs seven existing workspace-layout text operations. It does not add a
second layout engine, replace a client application, or claim completion of the
canvas, application-tab transfer, monitor restoration or GUI acceptance roadmap.

The inspected Applications baseline is `ffc96543291692106dd33533947f16428dea830b`.
Its Framework pin is `ee6662332c1765dc184777983913d977c5f8c3ff`.
The modified implementation is `framework/src/ui/workspace_layout.c`.

## The defect and the change

The old implementation called `snprintf` on live fields and only then checked
whether the input fitted. A rejected rename, tab-group, placement or context
update could therefore change state without advancing its revision. `init`
cleared the entire destination before checking capacity; `clone` replaced the
destination before checking both replacement labels. Passing a layout's own
strings back into these functions also exposed overwrite and overlapping-copy
problems.

The corrected code measures within the destination limit before copying. It
stages both names before initialisation/cloning, and stages the shared stack
value before updating `group_id` and `stack_id`. Text copies use `memmove` when
aliasing is allowed. No heap allocation is introduced in production code; the
largest new automatic staging is the two bounded ID/name arrays.

## Preserved contract

- Existing exported function names, parameters, structures and constants stay
  unchanged. The public header has explanatory comments only.
- Every original source comment is preserved. Existing field and parameter names
  are retained. Two old `written` locals and the `first`/`second` locals now hold
  `UmiStatus` instead of a formatted-output length because the copy returns status.
- A failed `init`, `clone`, `rename`, `set_group`, `set_stack`, `set_placement` or
  `set_context_group` leaves the destination byte-for-byte unchanged.
- Successful initialisation still intentionally clears the old layout. Successful
  cloning still resets revision to one. Existing mutation counters, lock rules,
  empty-context clearing and geometry rules are not changed.
- `group_id` and `stack_id` keep their legacy/canonical relationship. The context
  group remains independent. Text limits remain byte limits, including UTF-8.
- The helper is failure-atomic for one owning thread. It is not a concurrency
  primitive, database transaction or replacement for the existing workspace
  customisation edit/commit/cancel mechanisms.
- Malformed arbitrary pointers, revision overflow and general persisted-layout
  validation are outside this increment. Callers must still obey public buffer
  and ownership requirements.

## Shared implementation and application adoption

The repository's existing `Umicom::ui` target already compiles this source.
The new parent test registration links that same target; application repositories
need no duplicate logic. Every consumer that reaches these functions receives
the corrected behaviour after relinking. This is not evidence that every
application's visible command or renderer has been exercised.

No Studio source file is included, so this archive cannot overwrite the pending
Studio work reported in the conversation. No separate UmicomOS source or
Framework pin is changed; that repository needs its own qualification before
adopting the newer Framework.

## Regression coverage

Ten native groups cover initialisation, cloning, rename, group, stack, placement,
context, locked-state preservation, UTF-8 byte boundaries and an in-memory
three-panel editing journey. They check complete destination bytes on failure,
self/suffix aliases, boundary sizes, both stack fields, null/empty inputs,
existing panel open/move/hide/reopen/floating/pin/maximise/remove operations and
legacy geometry rejection. They do not create GTK windows or access user files.

The tests use active checks, not `assert`, so Release/NDEBUG still exercises the
operations. Large layout fixtures live on the heap, not native thread stacks.

Against the actual baseline source, nine groups failed and the lock group
passed. With the correction, all ten passed in GCC Debug, Clang Debug, GCC
Release and Clang AddressSanitizer/UndefinedBehaviorSanitizer configurations.
A separate CMake fixture checked the existing-target registration path; it uses
the actual production source, but is not the full application build.

No Windows execution, complete Framework/application regression, GUI interaction,
installed application or user-machine performance result is claimed here.

## Roadmap record

| Outcome | State after this delivery | Remaining gate |
|---|---|---|
| FW-CANVAS: preserve layout during rejected edits | Implemented; isolated native validation passed | Windows full build/tests; Linux full build/tests |
| FW-CANVAS: visible canvas interactions | Not completed by this delivery | Actual Windows/Linux GTK journeys |
| FW-LAYOUT-STORAGE: durable save/restart/recovery | Unchanged | Data Server and multi-monitor acceptance |
| FW-HOST-TRANSFER: cross-process application tabs | Unchanged | Ownership, unsaved-state and permissions integration |

Accept this increment only after the published Windows-first procedure succeeds,
then qualify the identical recorded revisions in Linux. Do not equate the ten
regression groups with a product-completion percentage.
