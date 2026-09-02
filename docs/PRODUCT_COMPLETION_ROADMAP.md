# Umicom Product Completion Roadmap

## Why this roadmap exists

The Umicom repositories already contain a large number of contracts, engines,
layouts and tests. That is valuable groundwork, but a catalogue entry or a
visible panel does not by itself make a finished product. A working product
must let a person complete a useful task, save the result, close the program,
open it again and continue safely.

This roadmap separates what exists from what still needs implementation. It is
also the order in which large updates should be delivered. Shared behavior is
implemented in Umicom Framework first. Application repositories then provide
only their product identity, business rules and specialist integrations.

## What “fully working” means

Every product must pass the same six completion gates:

1. **Start and recover** — the program starts, reports a useful error when a
   dependency is missing, restores its previous workspace and can recover an
   interrupted session.
2. **Complete a real journey** — a person can finish the product's main task
   from beginning to end without placeholder actions.
3. **Keep data safely** — data is validated, stored, migrated, backed up and
   restored without relying on a widget remaining open.
4. **Integrate honestly** — unavailable providers are shown as disconnected;
   simulated and live operations are clearly separated; secrets never enter
   source control or logs.
5. **Remain understandable** — panels explain empty states and failures, every
   command has a predictable result, and keyboard and accessibility paths work.
6. **Provide evidence** — strict builds, focused tests, full tests, security
   checks, installer checks and real user-journey tests all pass.

## Shared Framework work

### Implemented foundations

- Canonical application identities, panels, layouts and feature roadmaps.
- Reusable workspace windows with docking, floating, grouping, locking,
  context linking, layout editing, import, export and recovery checkpoints.
- Shared appearance profiles and product branding.
- Toolkit-neutral view models and a reusable GTK4 renderer.
- Product presentation recipes, lifecycle state, safe controller dispatch,
  refresh policies, background policies and diagnostic snapshots.
- Common finance, trading, AI, document, data, security, runtime and developer
  contracts at different maturity levels.

### Implemented in this update

- A toolkit-neutral product-panel projection joins friendly layout windows to
  their live reusable presentation components.
- Product panels now report copied title, purpose, capability, state, message,
  progress, focus, dirty state, badge and guarded action information.
- Coverage reports count panels that are bound, actionable or still unbound.
- Desk and OS panel aliases are covered by the same projection model, allowing
  their existing native hosts to adopt it without changing system services.
- A reusable native product workstation now combines product controllers,
  layouts, panel rendering, commands, appearance and customisation.
- Bank, TMS and Music Studio now have thin native workstation executables in
  addition to their console verification programs.

### Framework work still required

- Durable user profiles for layouts, appearance, recent work and application
  preferences, including migration and conflict recovery.
- A single task service for foreground work, background jobs, cancellation,
  progress, retry, scheduling and restart recovery.
- A provider registry with capability discovery, health, permission, rate
  limits, offline behavior and test doubles.
- Complete encrypted secret storage adapters for supported operating systems.
- Database migrations, transaction boundaries, backup, restore and repair
  tools shared by all local-data applications.
- A notification centre joining task progress, failures, approvals and audit
  evidence without applications inventing separate message systems.
- Complete document loading, encoding, generation and export adapters.
- Complete build, test, compiler, debugger and source-control providers.
- A signed extension model with permissions, isolation, compatibility checks
  and a recoverable package lifecycle.
- Accessibility verification for keyboard use, screen readers, contrast,
  scaling, reduced motion and high-density displays.
- Installer, updater, repair, uninstall and per-application component checks.

## Product status and required implementation

### Umicom Studio IDE

Studio has the largest application implementation and already owns a native
workbench, editor surfaces, project services, terminal, diagnostics, layouts,
testing views, source-control views and AI workspace foundations. Several older
source paths still contain placeholders and must be either connected to the
current runtime or retired only after their replacement is proven.

The remaining product journeys are:

- Open, index, search, edit, save, save as, rename and safely delete files.
- Create, configure, build, test, run, debug, package and install a project.
- Browse diagnostics, navigate to source, apply a fix and verify the result.
- Inspect changes, stage selected work, commit, branch, merge and resolve
  conflicts through complete source-control providers.
- Design forms and workspaces with undo, redo, property editing, validation,
  preview and source generation.
- Install, update, disable and remove signed extensions.
- Use a permission-aware coding assistant that can inspect the workspace,
  propose a plan, edit files, show a review and run only approved operations.
- Restore open projects, documents, cursor positions, terminals, layouts and
  unfinished safe tasks after restart.

### Umicom Trader

Trader has a native workstation, deterministic simulation, market views,
orders, positions, risk controls, layouts and replay foundations. Live trading
must remain disabled until provider, reconciliation and operational evidence is
complete.

The remaining product journeys are:

- Connect an approved market-data provider with session, entitlement, stale
  data and reconnect handling.
- Configure a paper account, submit guarded orders, amend or cancel them and
  reconcile acknowledgements, fills, positions, cash and fees.
- Implement a complete trade tape, depth ladder, options chain, sensitivities,
  volatility views and reviewed strategy builder.
- Save scanners, schedule scans and calculate filter and indicator columns.
- Import or create strategies, run deterministic backtests, optimise selected
  parameters, perform walk-forward checks and preserve reproducible evidence.
- Produce performance, drawdown, execution-quality and attribution reports.
- Add provider-neutral news, events, fundamentals and research adapters.
- Add live execution only behind explicit permissions, account readiness,
  limits, kill switch, audit, recovery and paper-acceptance gates.

### Umicom Bank

Bank now has a native Framework-rendered workstation for everyday banking,
global money and digital assets. Its existing controllers deliberately stage
financial commands for authorisation instead of pretending a payment ran.

The remaining product journeys are:

- Create and authenticate a local customer profile with secure device and
  recovery controls.
- Connect approved account providers and reconcile balances and transactions.
- Manage beneficiaries, prepare a payment, show fees and recipient value,
  authorise it and track every lifecycle state.
- Provide statements, categories, budgets, recurring payments and cash-flow
  forecasts from persisted ledger evidence.
- Manage physical and virtual cards through a provider-neutral adapter.
- Add regulated identity, screening, fraud, dispute, limit and audit workflows.
- Add external-bank and digital-asset adapters without coupling the UI to one
  provider.
- Verify accessibility, privacy, backup, restore and incident recovery before
  any real-money release.

### Umicom TMS

TMS now has a native role-based workstation with front-office, middle-office
and back-office layouts. Commands continue to be staged for approval by its
existing controllers.

The remaining product journeys are:

- Capture, validate, enrich, amend, cancel and audit complete trade lifecycles.
- Load governed market data, construct curves and preserve pricing inputs.
- Price supported products with cash-flow and valuation evidence.
- Calculate positions, P&L, sensitivities, scenarios, limits and explanations.
- Route exceptions, four-eyes approvals and timed tasks through one workflow
  service.
- Create confirmations, settlement instructions, messages and reconciliations.
- Manage collateral calls, eligibility, inventory, disputes and settlement.
- Generate accounting events, journals, ledgers and general-ledger exports.
- Operate engines, queues, schedules, retries, cut-offs and end-of-day controls.
- Add reference data, legal entities, books, portfolios, users, roles and full
  audit retention before production use.

### Umicom Music Studio

Music Studio now has a native compose, arrange and master workstation. The
current controllers expose honest empty states until audio or generation
providers are connected.

The remaining product journeys are:

- Create, open, save, migrate, bundle and recover a music project.
- Import audio and MIDI with waveform, metadata and missing-asset handling.
- Record, play, pause, seek, loop and render through a real-time audio graph.
- Edit tracks, clips, fades, tempo, time signatures, notes, chords and
  expression with undo and redo.
- Mix channels, buses, sends, automation and supported effects safely.
- Discover audio and MIDI devices and survive device changes during a session.
- Connect local or online generation providers, preserve prompts and settings,
  compare results and track source and licence information.
- Separate, replace, arrange and export stems without losing the original.
- Export mixes, stems, MIDI and portable project bundles with progress and
  cancellation.

### Umicom Desk

Desk already has application discovery, launching, process supervision,
multi-launch and shared workspace foundations. Completion requires durable
session restoration, crash recovery, global search, notifications, recent work,
per-application health, update status and reliable multi-monitor recovery.

### Umicom OS Control Centre

The Control Centre has portable contracts for system information, devices,
storage, network, services, processes, security, updates and logs. Each
supported operating system still needs read-only discovery adapters first,
followed by separately permissioned mutation adapters. Update, service and
security actions need privilege prompts, rollback, audit and failure recovery.

### Umicom LLM and Umicom RAG

The AI applications have model, provider, workspace and retrieval foundations.
Completion requires model installation and verification, local process
supervision, provider health, streaming, cancellation, conversation storage,
encrypted credentials, document ingestion, extraction, chunking, embedding,
index migration, citations, deletion, evaluation and permission-aware agent
tools. Local and remote providers must use the same capability contract.

### Web, mobile, database and integration studios

These products have application identities, layouts and product-surface
foundations. They need complete project models, preview/run targets, inspectors,
diagnostics, source generation, deployment adapters and Framework product-host
adoption. Database and integration products additionally need connection
profiles, encrypted secrets, schema or message discovery, visual design,
validation, execution evidence and rollback.

### Accountant, Exchange, Marketplace and Operations

These products require persisted domain ledgers, workflow, reports, permissions
and external adapters. Accountant needs invoicing, expenses, tax, payroll and
period close. Exchange needs orders, matching, clearing, settlement and market
surveillance. Marketplace needs catalogue, identity, listing, order, payment,
delivery and dispute lifecycles. Operations needs service inventory, health,
logs, metrics, alerts, runbooks, approvals and audit.

### CAD, Kitchen, Creator, Media, Games and Education

These applications depend on shared engines before their thin product layers
can be complete: scene and asset graphs, geometry and rendering, animation,
audio/video timelines, document generation, simulation, input, learning plans,
progress and safe content generation. Engines must remain independent of any
one application and expose deterministic headless tests as well as frontend
view models.

### Security Centre

Security Centre requires a complete asset inventory, secret and dependency
scanning, source findings, severity and suppression policy, remediation state,
evidence export and continuous monitoring. Mutating or destructive remediation
must always be separately authorised and recoverable.

## Delivery order

### Product Workstation Adoption

Adopt the new Framework product workstation in the remaining thin desktop
applications. Add panel bindings only when a friendly layout name cannot be
resolved automatically. A product must keep honest unavailable states until a
real engine or adapter exists.

### Durable Application State

Complete profile storage, database migrations, backups, recovery checkpoints,
recent work, task persistence and application-session restoration. This makes
all later feature work recoverable instead of temporary.

### Studio Development Loop

Finish the complete edit, search, build, test, run, debug, source-control and
package journey. Consolidate older placeholder paths only after their current
replacement has tests and migration evidence.

### Safe Trading and Treasury Operations

Finish paper trading, reconciliation, market data, TMS trade lifecycle, pricing,
risk, workflow, settlement and accounting before enabling any live provider.

### Banking and Financial Controls

Finish customer identity, accounts, payments, ledgers, statements, approvals,
fraud, reconciliation and audit behind simulated adapters, then add separately
reviewed external providers.

### Creative Media Production

Finish project graphs, device handling, timelines, editing, rendering and
export before expanding generative provider coverage.

### Local Intelligence and Retrieval

Finish model lifecycle, ingestion, citations, evaluation, encrypted provider
settings and permission-aware tools, then connect assistants to each product.

### Installer and Release Evidence

Complete selectable installation, repair, update, uninstall, file associations,
desktop identity, dependency checks and end-to-end user journeys. A feature
moves to verified only when its implementation, tests and release evidence all
exist.
