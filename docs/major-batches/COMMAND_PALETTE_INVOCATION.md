<!--
  Umicom Framework
  File: docs/major-batches/COMMAND_PALETTE_INVOCATION.md

  PURPOSE:
    Explain how a product turns one selected command-palette result into a
    checked, approved and product-owned action.

  AUTHOR AND ORGANISATION:
    Sammy Hegab
    Umicom Foundation

  LICENCE:
    MIT
-->

# Governed command-palette invocation

The command palette now has a safe path from search result to product action.
The Framework resolves the selected command, checks its maturity and required
capability, asks for approval when requested, and only then calls a product
executor. This keeps menus, keyboard shortcuts and future assistant panels on
the same rules.

## The flow

1. Build `UmiApplicationProductionCommandBindings` from the product adoption.
2. Put the command kind and stable target ID from the palette result into an
   `UmiApplicationProductionCommandInvocationRequest`.
3. Provide a capability probe when the product needs to check a provider,
   permission or connection before the action is offered.
4. Set `require_approval` for actions that need a visible user decision and
   provide an approval callback owned by the product UI.
5. Provide an executor callback. It receives the resolved immutable descriptor
   and can call the product controller without exposing product state to the
   Framework catalogue.
6. Call `umi_application_production_command_bindings_invoke` and inspect the
   result. `available`, `approved` and `executed` explain which gate was passed.

When a product already owns an `UmiApplicationProductionRuntime`, call
`umi_application_production_runtime_invoke_command` instead. It applies the
same gates and automatically records the outcome in the runtime journal.

The function returns `UMI_STATUS_NOT_FOUND` for stale palette entries,
`UMI_STATUS_UNAVAILABLE` for disabled or unsupported commands,
`UMI_STATUS_PERMISSION_DENIED` when approval was required but not granted, and
the executor's status after the product action runs. A missing executor gives a
safe `UMI_STATUS_NOT_IMPLEMENTED` dry-run result without changing application
state.

## Why this belongs in the Framework

The Framework owns stable IDs, capability checks, bounded memory and the order
of safety gates. Products own business rules, network calls, document changes
and user-facing confirmation. This separation means a GTK4 menu, a web
command palette, a keyboard shortcut and an assistant can all invoke the same
action without copying policy.

The API does not run shell text or arbitrary code. It calls only the callback
that the product deliberately supplies, after the descriptor has been found
and all requested gates have passed.

Every resolved request can also be retained in the bounded runtime command
journal. The journal is useful for an activity panel, diagnostics and session
evidence; see [command invocation journal](COMMAND_INVOCATION_JOURNAL.md).

## Testing expectations

Each product should test at least these paths:

- a known command executes after approval;
- a missing approval callback blocks a request that requires approval;
- an unavailable capability blocks before the executor is called;
- a stale or malformed command is rejected;
- a request with no executor reports a dry-run without mutating state.

These cases can run headlessly and do not require a desktop toolkit or a live
provider.
