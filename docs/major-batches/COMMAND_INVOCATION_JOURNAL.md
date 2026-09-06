<!--
  Umicom Framework
  File: docs/major-batches/COMMAND_INVOCATION_JOURNAL.md

  PURPOSE:
    Explain the bounded command history shared by product runtimes.

  AUTHOR AND ORGANISATION:
    Sammy Hegab
    Umicom Foundation

  LICENCE:
    MIT
-->

# Command invocation journal

The production runtime now keeps a small in-memory history of command-palette
actions. Each retained record says which command was selected, whether its
capability was available, whether approval was requested and granted, whether
the product executor ran, and which status was returned.

## How products use it

1. Initialise a `UmiApplicationProductionRuntime` as usual. Its command journal
   is cleared and its sequence starts at one for the new session.
2. Call `umi_application_production_runtime_invoke_command` for a selected
   command. The runtime attaches its own journal before routing the request.
3. Read `runtime->command_journal.count` to show how many recent actions are
   retained.
4. Use `umi_application_production_command_journal_at` to display one record.
   Index zero is the oldest retained record and the last index is the newest.

Products that manage their own runtime object can instead initialise a
`UmiApplicationProductionCommandJournal`, attach it to a direct invocation
request, and inspect the same entry contract.

## Bounded and recoverable behaviour

The journal uses fixed-size storage and never allocates memory. When it reaches
capacity, it removes only the oldest record so the newest failure or approval
decision remains visible. Command execution status is never replaced by a
journal maintenance status. A journal is evidence for the UI and diagnostics;
it is not a permission bypass and it does not replay commands.

The runtime revision increases whenever a command has been resolved, including
when approval, capability or execution blocks it. This lets a session
checkpoint notice that command evidence changed even when application data did
not.

For the complete path from searching to execution, see
[governed command-palette invocation](COMMAND_PALETTE_INVOCATION.md).
