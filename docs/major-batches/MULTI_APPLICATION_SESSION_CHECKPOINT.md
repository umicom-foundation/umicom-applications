<!--
  Umicom Framework
  File: docs/major-batches/MULTI_APPLICATION_SESSION_CHECKPOINT.md

  PURPOSE:
    Explain the bounded checkpoint used to restore several selected products.

  AUTHOR AND ORGANISATION:
    Sammy Hegab
    Umicom Foundation

  LICENCE:
    MIT
-->

# Multi-application session checkpoint

The Framework can now capture and restore the products selected in one Desk
session. This makes a multi-monitor workspace repeatable without making the
launcher or a product own another product's process state.

## What is saved

`UmiApplicationLaunchSelectionCheckpoint` stores a bounded list of stable
application IDs, each registered default layout ID and the selection revision.
It stores identifiers rather than process handles, GTK widgets or pointers, so
the value can safely be handed to a persistence service.

## Capture and restore

1. Call `umi_application_launch_selection_checkpoint_capture` before closing
   the host or when the user saves a workspace.
2. Store the returned value using the application's approved session storage.
3. Create and refresh a new launch selection when the host starts.
4. Call `umi_application_launch_selection_checkpoint_restore` before showing
   the launch choices.

Desk frontends can use the wrapper functions
`umi_desk_runtime_capture_selection_checkpoint` and
`umi_desk_runtime_restore_selection_checkpoint`. These keep the UI independent
of the selection object's internal storage and advance the Desk revision only
after a restore succeeds.

Restore validates every saved field, rejects duplicate IDs, confirms that each
product still exists and applies the current launch-readiness gate. If any
entry is missing or unavailable, the live selection is left unchanged. This
prevents a partially restored session from appearing successful.

The checkpoint does not launch processes or write files by itself. Storage,
encryption, backup and multi-monitor geometry remain responsibilities of the
Framework session/persistence service. Product frontends only display the
result and request the governed launch operation.
