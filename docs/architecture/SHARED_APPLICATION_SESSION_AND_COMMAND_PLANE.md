<!-- --------------------------------------------------------------------------
Umicom Applications
File: docs/architecture/SHARED_APPLICATION_SESSION_AND_COMMAND_PLANE.md

PURPOSE:
Explain how every Umicom application now starts and controls its shared
workspace through one Framework-owned product session.

AUTHOR AND ORGANISATION:
Sammy Hegab
Umicom Foundation

LICENCE:
MIT
---------------------------------------------------------------------------- -->

# Shared Application Session and Command Plane

## The idea in one sentence

Every Umicom application supplies its identity and specialist domain features,
while Umicom Framework supplies the reusable application session.

Think of the session as the connector on a Lego brick. A banking screen and a
code editor contain very different pieces, but both connect to the same rules
for layouts, panels, context, readiness and state snapshots.

## What the shared session owns

`UmiProductApplicationSession` joins Framework capabilities that previously
had to be used separately:

- canonical application and experience metadata;
- the default layout and active panels;
- selecting a layout;
- opening and closing panels;
- locking a layout;
- linked context values, such as the selected account or instrument;
- feature readiness;
- runtime capability health;
- operation and command counts; and
- a bounded snapshot suitable for persistence, diagnostics and frontends.

The session contains no GTK4, Qt, web or console widget code. A frontend asks
the same session to perform an action and then renders the resulting snapshot.

## One command shape for every frontend

The command plane currently supports:

1. select a layout;
2. activate a panel;
3. deactivate a panel;
4. publish a context value;
5. lock or unlock the layout;
6. refresh readiness; and
7. synchronise an attached Framework workbench.

This means a toolbar click, a keyboard shortcut, a console command, an
automation and an AI assistant can request the same operation without copying
the rules behind it.

## A small C example

```c
UmiProductApplicationSession session;
UmiProductApplicationSessionSnapshot snapshot;
UmiProductApplicationSessionCommand command = {
    sizeof(UmiProductApplicationSessionCommand),
    UMI_PRODUCT_SESSION_REFRESH_READINESS,
    NULL,
    NULL,
    false
};

umi_bank_product_session_init(&session);
umi_product_application_session_execute(&session, &command);
umi_product_application_session_snapshot(&session, &snapshot);
```

The Bank module does not calculate readiness or rebuild a layout. Its
initializer supplies the canonical Bank adoption record, and Framework does
the rest.

## Applications adopting the connector

The following independently versioned modules expose a product-session
initializer and exercise it in their productisation test:

- Accountant, Bank, Trader, TMS and Commodity Exchange;
- Studio IDE, Web Studio, Mobile Studio, Database Studio and Integration Studio;
- LLM, RAG and AI Creator;
- Desktop, OS, Operations, Security Centre and Marketplace;
- Music Studio, Media Studio, Games, CAD, Kitchen Designer and Education.

The parent repository also initialises all 24 sessions in one integration test.
This catches a missing symbol, mismatched application identity or broken
cross-repository contract before release.

## What is complete in this update

The common product-session contract, command dispatch, snapshots, health
delegation, reset behavior, per-module initializers and suite integration
coverage are implemented. Existing application APIs and specialist behavior
remain available.

## What this does not claim

This update does not claim every banking, trading, treasury, operating-system,
model-hosting or creative feature is production complete. Those are domain
engines built on top of the shared connector. Their completion must still be
proved with executable acceptance evidence, security review, accessibility
checks, recovery tests and real user journeys.

Framework's existing productisation gap analysis and completion plan remain
the source of truth for that work. A feature is complete only when the evidence
ledger marks it accepted; a declaration or an empty panel is not completion.

## How to add a future application

1. Add its canonical experience, panels and layouts to Framework.
2. Compose those panels from registered Framework components.
3. Create a thin productisation contribution in the application repository.
4. Expose an initializer that calls
   `umi_product_application_session_init()` with that contribution.
5. Test the application session, snapshot and at least one command.
6. Add the initializer to the parent portfolio integration test.
7. Record real acceptance evidence for each visible feature and journey.

Following these steps makes a new application fit the suite without copying a
runtime, layout manager or readiness calculator.
