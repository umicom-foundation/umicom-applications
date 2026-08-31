<!-- --------------------------------------------------------------------------
Umicom Applications
File: docs/roadmaps/FRAMEWORK-FIRST-APPLICATION-DEVELOPMENT-ROADMAP.md

PURPOSE:
Explain the Framework-first development order for every Umicom application,
including reusable contracts, layouts and panels and the thin product work that
must remain inside each application repository.

AUTHOR AND ORGANISATION:
Sammy Hegab
Umicom Foundation

LICENCE:
MIT
---------------------------------------------------------------------------- -->

# Framework-First Application Development Roadmap

## The simple idea

Umicom applications should be assembled like a Lego model. A Lego brick has a
known shape and can connect to many other bricks. In the same way, an Umicom
panel, layout, command or service needs a stable Framework contract before an
application uses it.

The development order is therefore:

1. Complete and stabilise Umicom Framework.
2. Complete Umicom Studio IDE as the first full Framework development product.
3. Complete Umicom Trader as the first full real-time operational product.
4. Complete the remaining applications by reusing the same contracts.

An application repository should stay thin. It chooses product identity,
layouts and components; supplies product-specific controllers and external
adapters; and proves complete user journeys. It should not copy Framework
commands, docking, forms, persistence, security, diagnostics or UI state.

## What already exists

The canonical catalogue currently projects every declared application panel to
a Framework component. It also has deterministic layout projections. This is a
strong structural base, but a projection is not proof that a graphical product,
external service or real-world workflow is finished.

The next updates must close four different kinds of work:

- **Definition:** a stable public C contract describing the idea.
- **Behavior:** tested product-neutral logic behind the contract.
- **Adapter:** GTK4, web, database, broker, device or service integration.
- **Acceptance:** evidence that a person can complete the whole user journey.

## Shared Framework updates required before product expansion

### Development lifecycle and Umicom command

Framework owns environment discovery, dependency inventory, CodeGuard scans,
configure/build/link/test execution and safe repository workflows. Continue with:

- structured results for every CLI stage, including duration and evidence;
- `umicom workflow` history, cancellation, resumable steps and machine-readable
  JSON/SARIF reports;
- native dependency inventory plus the reusable CodeGuard dependency-audit
  service for optional OSV vulnerability matching;
- compiler warning, clang-tidy, Cppcheck and compilation-database adapters;
- AddressSanitizer/UndefinedBehaviorSanitizer build profiles and runtime evidence;
- safe portfolio publication that commits child repositories before locking the
  parent gitlinks;
- release manifests containing tool versions, dependency versions, test results,
  package hashes and Software Bill of Materials data.

### Universal application shell

Complete one reusable shell with:

- application menu, command palette, toolbar, status bar and notifications;
- dock, split, tab, floating window and multi-monitor layout management;
- learning, standard and focus workspace profiles;
- keyboard navigation, focus restoration, scaling, contrast and screen-reader
  descriptions;
- loading, empty, stale, disconnected, permission-denied, error and recovery
  states;
- session checkpoint, crash recovery and versioned layout migration.

### Universal interaction components

Complete reusable definitions and adapters for:

- validated forms, field groups, wizards and confirmation flows;
- data grid, tree grid, property grid, cards and master/detail views;
- chart, timeline, canvas, graph, map and media transport controls;
- search, filter, sort, grouping, pagination, selection and clipboard behavior;
- undo/redo, history, activity journal and evidence viewer;
- file picker, credential picker, date/time, currency, quantity and instrument
  inputs;
- commands that support preview, permission checks, cancellation and retry.

### Shared service contracts

Complete product-neutral services for:

- identity, roles, permissions, approval and tamper-evident audit;
- settings, secrets, workspace trust and policy;
- background jobs, scheduling, queues, progress and notifications;
- data source health, caching, offline behavior, stale-data rules and reconnect;
- import/export, reports, print, PDF and document handling;
- telemetry, logs, metrics, traces, profiling and health checks;
- plugin discovery, capability negotiation, versioning and isolation;
- localization, time zones, number formats and right-to-left layouts.

### Adapter conformance and release evidence

Every adapter should pass the same Framework-owned contract suite. This applies
to GTK4, web, databases, language servers, debuggers, market feeds, brokers,
audio engines and AI providers. A product becomes release-ready only after its
journeys, accessibility, recovery, packaging, upgrade and rollback evidence are
accepted.

## Priority product: Umicom Studio IDE

### Framework definitions and behavior

- editor document, buffer, cursor, selection, markers and multi-file transaction;
- project, solution, target, configuration, task and launch-profile models;
- language intelligence, diagnostics, symbols, completion and refactoring;
- build, test, debug, terminal and source-control services;
- visual designer, property binding, preview and source round-trip;
- extension host, SDK browser, template catalogue and package manager;
- governed AI context, retrieval, tool approval, patch review and revert.

### Layouts

- Learning Workspace
- Development Workspace
- Debug Workspace
- Visual Design Workspace
- Source Review Workspace
- AI Assisted Workspace
- Focus Workspace

### Panels

- Resource Explorer, Editor, Outline and Properties
- Problems, Output, Test Explorer and Terminal
- Debug Console, Variables, Watch, Call Stack and Breakpoints
- Source Control, Changes, History, Diff and Merge
- Component Toolbox, Designer Canvas and Preview
- AI Assistant, Context Inspector, Retrieval Evidence and Patch Review
- Production Centre, Dependency Health and Release Evidence

### Studio repository work

- bind the existing Framework models to complete GTK4 interactions;
- prove save/configure/build/test/debug as cancellable end-to-end journeys;
- finish drag/drop, responsive preview, undo/redo and source round-trip;
- complete multi-monitor recovery and keyboard/screen-reader acceptance;
- prove clean install, extension compatibility, upgrade and rollback.

## Priority product: Umicom Trader

### Framework definitions and behavior

- instrument, venue, quote, trade, order book and market-session contracts;
- chart series, indicators, drawing tools, replay clock and linked context;
- order draft, validation, confirmation, OMS state and execution lifecycle;
- position, cash, P&L, exposure, limits and independent risk decisions;
- strategy, scanner, signal, factor, backtest and research evidence;
- feed, broker and news adapter health, reconnect and reconciliation;
- immutable operational journal and emergency-control contracts.

### Layouts

- Simulation Trading Workspace
- Market Research Workspace
- Strategy Development Workspace
- Risk and Exposure Workspace
- Replay and Review Workspace
- Multi-Monitor Execution Workspace

### Panels

- Watchlist, Chart, Market Depth, Time and Sales and News
- Order Ticket, Orders, Executions and Reconciliation
- Positions, Portfolio, Account, P&L and Risk
- Scanner, Strategy, Predictive Research Lab and Research Output
- Replay, Event Journal, Latency Monitor and Connection Health
- Kill Switch, Limit Status and Permission/Environment Banner

### Trader repository work

- complete simulation-first parameter entry and explicit order confirmation;
- connect accepted streaming feeds without moving feed state into GTK widgets;
- add optional paper-broker connectivity behind independent risk and
  reconciliation;
- prove reconnect, partial fill, reject, cancel, bust/correct and recovery flows;
- keep live execution disabled until security, risk and operator evidence passes.

## Umicom TMS

### Framework components

Treasury trade, counterparty, cash account, settlement, payment, market data,
valuation, exposure, limit, workflow, approval and accounting-event contracts.

### Layouts

Cash and Liquidity; Trading and Deal Capture; Risk and Valuation; Settlements
and Operations; Accounting and Reporting; Focus.

### Panels

Cash Position, Cash Forecast, Deal Ticket, Trade Blotter, Pricing, Market Data,
Risk, Limits, Collateral, Settlements, Payments, Accounting, Reconciliation,
Workflow Inbox and Audit Trail.

### Product updates

Adopt the shared product surface, implement realistic lifecycle controllers,
connect approved bank/market/accounting adapters, then prove front-to-back trade
and payment journeys with four-eye approval.

## Umicom Bank

### Framework components

Customer, identity/KYC, account, wallet, beneficiary, payment, card, FX,
statement, fee, fraud alert, dispute, approval and ledger contracts.

### Layouts

Personal Banking; Business Banking; Payments Operations; Treasury and FX;
Compliance and Fraud; Focus.

### Panels

Accounts, Transactions, Payments, Beneficiaries, Cards, Wallets, FX, Statements,
Approvals, Fraud Alerts, Cases, Customer Profile and Audit.

### Product updates

Keep financial commands staged until permissions and confirmations pass; add
sandbox payment adapters first; implement reconciliation, failure recovery and
accessible customer journeys before any production connection.

## Umicom Music Studio

### Framework components

Project, track, clip, region, transport, timeline, routing, mixer, automation,
plugin, instrument, MIDI, audio asset, render job and generative-audio contracts.

### Layouts

Compose; Record; Arrange; Mix; Master; AI Creation; Focus.

### Panels

Browser, Arrangement, Piano Roll, Score, Mixer, Channel Strip, Plugin Rack,
Automation, Transport, Recording, Stems, Generation, Prompt, Render Queue and
Loudness/Analysis.

### Product updates

Add a real audio-engine boundary, non-destructive editing and crash-safe project
storage; keep missing devices/models as honest empty states; then prove record,
edit, mix and export journeys.

## Umicom Accountant

### Framework components

Organisation, chart of accounts, journal, ledger, tax, invoice, bill, payment,
bank feed, reconciliation, payroll, employee, period close and report contracts.

### Layouts

Daily Bookkeeping; Sales and Purchases; Banking; Payroll and HR; Period Close;
Management Reporting.

### Panels

Dashboard, Accounts, Journals, Customers, Suppliers, Invoices, Bills, Banking,
Reconciliation, Payroll, Employees, Tax, Fixed Assets, Reports and Audit.

### Product updates

Build double-entry validation and immutable posting first, then bank-import and
reconciliation adapters, payroll workflows, statutory reports and close/reopen
acceptance.

## Umicom AI Creator

### Framework components

Creative project, prompt, asset, generation request, model capability, seed,
variant, provenance, moderation, rights, render queue and export contracts.

### Layouts

Create; Storyboard; Asset Library; Generation Review; Publish; Focus.

### Panels

Prompt Editor, Canvas, Timeline, Storyboard, Assets, Variants, Model Settings,
Generation Queue, Provenance, Safety Review, Metadata and Export.

### Product updates

Add provider-neutral generation adapters, visible cost/permission gates,
reproducible provenance, human selection and reversible publishing.

## Umicom CAD

### Framework components

Document, part, assembly, sketch, constraint, feature tree, geometry selection,
unit, material, layer, viewport, tool and export contracts.

### Layouts

Sketch; Part Design; Assembly; Drawing; Review; Focus.

### Panels

Model Tree, Viewport, Sketch Tools, Constraints, Properties, Layers, Materials,
Measurements, Assembly, Drawing Sheets, History, Validation and Export.

### Product updates

Define a geometry-kernel adapter boundary, transactional feature operations,
large-model viewport behavior, precise unit handling and interchange tests.

## Umicom Database Studio

### Framework components

Connection, credential reference, catalogue, schema, table, query document,
result set, transaction, migration, execution plan and data-change contracts.

### Layouts

Query; Schema Design; Data Review; Administration; Migration; Focus.

### Panels

Connections, Object Explorer, Query Editor, Results Grid, Explain Plan, Schema
Diagram, Properties, Data Editor, Migration, Jobs, Logs and Permissions.

### Product updates

Add database adapter conformance, read-only-by-default sessions, transaction
confirmation, cancellation, paged results, secure credentials and migration
rollback evidence.

## Umicom Desktop

### Framework components

Application discovery, launch, task, window, notification, search, recent item,
session, workspace and user preference contracts.

### Layouts

Desktop; Application Overview; Focus; Accessibility.

### Panels

Launcher, Taskbar, Application Grid, Search, Notifications, Recent Items,
Workspace Switcher, Session Recovery and System Status.

### Product updates

Finish application lifecycle supervision, keyboard-first navigation, workspace
restore, multi-monitor placement and integration with OS Control Centre.

## Umicom Education

### Framework components

Course, lesson, section, resource, exercise, assessment, rubric, learner,
progress, classroom, submission, feedback and accessibility contracts.

### Layouts

Learn; Teach; Course Design; Assessment; Classroom; Focus.

### Panels

Course Library, Lesson Viewer, Resource Browser, Exercise, Code Lab, Assessment,
Gradebook, Rubric, Progress, Classroom, Discussion, Feedback and Accessibility.

### Product updates

Implement offline lesson packs, progress synchronization, safe assessment,
teacher workflows, age-appropriate privacy and accessible learning journeys.

## Umicom Commodity Exchange

### Framework components

Commodity, grade, lot, warehouse, listing, bid, offer, match, contract, delivery,
inspection, settlement, price and market-surveillance contracts.

### Layouts

Marketplace; Trading; Physical Operations; Clearing and Settlement; Surveillance.

### Panels

Market Board, Order Entry, Orders, Trades, Contracts, Inventory, Warehouses,
Quality Certificates, Logistics, Settlement, Prices, Participants and Alerts.

### Product updates

Build simulation and physical-lot traceability first, then matching/clearing,
inspection, delivery and regulated adapter acceptance.

## Umicom Games

### Framework components

Game project, scene, entity/component, asset, input, animation, physics, script,
audio, build target, play session and profiler contracts.

### Layouts

World Editing; Scripting; Animation; Play and Debug; Profiling; Focus.

### Panels

Scene Tree, Viewport, Inspector, Assets, Script Editor, Animation, Physics,
Input Map, Audio, Console, Profiler, Build and Play Controls.

### Product updates

Define engine/runtime adapter boundaries, deterministic asset import, safe play
isolation, hot reload, packaging and performance acceptance.

## Umicom Integration Studio

### Framework components

Connector, endpoint, credential reference, message, schema, mapping, route,
transformation, trigger, retry, dead-letter and deployment contracts.

### Layouts

Flow Design; Mapping; Runtime Operations; Testing; Deployment; Focus.

### Panels

Connector Catalogue, Flow Canvas, Properties, Schema, Mapping, Test Data,
Execution Trace, Queue, Errors, Deployment, Secrets and Metrics.

### Product updates

Add connector conformance, visual flow validation, replayable test harnesses,
secret isolation, idempotency and deployment rollback.

## Umicom Kitchen Designer

### Framework components

Room, wall, opening, cabinet, appliance, worktop, material, measurement,
constraint, quotation, bill of materials and render contracts.

### Layouts

Plan; 3D Design; Catalogue; Quotation; Installation Review.

### Panels

Floor Plan, 3D View, Product Catalogue, Properties, Measurements, Materials,
Constraints, Price, Bill of Materials, Render and Installation Notes.

### Product updates

Reuse CAD canvas/constraint contracts, add product-catalogue adapters, enforce
measurement accuracy, and prove quotation and export journeys.

## Umicom LLM Workspace

### Framework components

Model, provider, endpoint, conversation, message, context, token budget, tool,
approval, evaluation, safety policy, usage and provenance contracts.

### Layouts

Chat; Model Lab; Prompt Engineering; Agent Tools; Evaluation; Operations.

### Panels

Conversations, Chat, Prompt Editor, Context, Models, Parameters, Tools,
Approvals, Evaluations, Usage, Safety, Logs and Provider Health.

### Product updates

Complete local/remote provider adapters, explicit data-boundary UX, tool
approval, reproducible evaluations, cost controls and offline degradation.

## Umicom Marketplace

### Framework components

Publisher, package, product, version, compatibility, licence, price, purchase,
download, install, update, review, trust and signature contracts.

### Layouts

Discover; Product Detail; Library; Publisher; Review and Trust.

### Panels

Catalogue, Search, Categories, Product Detail, Versions, Compatibility, Cart,
Purchases, Downloads, Installed Items, Updates, Reviews and Trust Evidence.

### Product updates

Implement signed packages, dependency resolution, sandboxed install, licence
and payment adapters, rollback and moderation journeys.

## Umicom Media Studio

### Framework components

Media project, source, clip, track, timeline, transition, effect, caption,
storyboard, avatar, render job, proxy, colour and export contracts.

### Layouts

Edit; Storyboard; Effects; Audio; Colour; AI/Avatar; Deliver.

### Panels

Media Browser, Preview, Timeline, Storyboard, Effects, Inspector, Captions,
Audio Mixer, Colour, Avatar, Generation, Render Queue, Metadata and Export.

### Product updates

Add codec/render adapter boundaries, proxy workflow, non-destructive editing,
rights/provenance and resilient long-running renders.

## Umicom Mobile Studio

### Framework components

Mobile project, screen, navigation, responsive breakpoint, device profile,
permission, resource, localization, build target, emulator and deployment.

### Layouts

Screen Design; Code; Navigation; Device Preview; Test and Deploy.

### Panels

Project, Screen Tree, Designer, Toolbox, Properties, Code, Navigation Graph,
Device Preview, Resources, Localization, Tests, Build and Deployment.

### Product updates

Reuse Studio editor/designer contracts, add Android/iOS toolchain adapters,
device/emulator discovery, permission validation and signed deployment evidence.

## Umicom Operations

### Framework components

Service, environment, deployment, job, runbook, incident, alert, metric, log,
trace, change, approval and recovery contracts.

### Layouts

Operations Overview; Incident Response; Deployments; Observability; Runbooks.

### Panels

Services, Environments, Deployments, Jobs, Alerts, Incidents, Logs, Metrics,
Traces, Runbooks, Changes, Approvals and Audit.

### Product updates

Add read-only observability adapters first, then governed operations, change
approval, rollback and incident evidence without embedding provider logic in UI.

## Umicom OS Control Centre

### Framework components

Device, service, process, storage, network, update, account, permission,
appearance, accessibility, power and diagnostic contracts.

### Layouts

Control Centre; Diagnostics; Accessibility; Updates and Recovery.

### Panels

Overview, Devices, Network, Storage, Processes, Services, Accounts, Security,
Updates, Appearance, Accessibility, Power, Logs and Recovery.

### Product updates

Keep the boundary user-space and permission-aware; add platform adapters,
preview/confirmation for privileged actions and recovery-safe settings.

## Umicom RAG

### Framework components

Corpus, source, connector, document, chunk, embedding, index, retrieval query,
result, citation, evaluation, refresh job and access-policy contracts.

### Layouts

Corpus Management; Retrieval Lab; Evaluation; Operations; Focus.

### Panels

Sources, Documents, Chunks, Indexes, Ingestion, Retrieval, Results, Citations,
Evaluation, Access Policy, Jobs, Errors and Metrics.

### Product updates

Implement connector/index adapters, incremental ingestion, deletion guarantees,
permission-filtered retrieval, citation evidence and repeatable evaluations.

## Umicom Security Centre

### Framework components

Identity, asset, finding, vulnerability, secret, policy, control, event, alert,
case, remediation, evidence and risk contracts.

### Layouts

Security Overview; Code and Dependency Review; Identity; Incidents; Compliance.

### Panels

Assets, Findings, Vulnerabilities, CodeGuard, Dependencies, Secrets, Policies,
Identities, Events, Alerts, Cases, Remediation and Evidence.

### Product updates

Render CLI/CodeGuard evidence, add scanner adapters with provenance, protect
secrets, separate advisory findings from verified exposure and prove response.

## Umicom Web Studio

### Framework components

Web project, route, page, component, style token, asset, API binding, responsive
preview, accessibility audit, browser target and deployment contracts.

### Layouts

Page Design; Code; Responsive Preview; API/Data; Test and Deploy.

### Panels

Project, Page Tree, Designer, Components, Properties, Styles, Code, Assets,
Responsive Preview, Browser, Accessibility, Tests and Deployment.

### Product updates

Reuse Studio and Mobile designer contracts, add browser/dev-server adapters,
round-trip HTML/CSS/component code, accessibility checks and deployment evidence.

## Umicom Author repository gap

The Framework catalogue includes Umicom Author, but the parent portfolio does
not yet contain a dedicated application repository. Do not duplicate the
experience under another name.

### Framework components

Document, chapter, scene, character, reference, citation, comment, revision,
outline, style, export and collaboration contracts.

### Layouts and panels

Writing, Outline, Research, Review and Publish layouts using Editor, Outline,
Characters, Research, Citations, Comments, Revisions, Styles, Preview and Export.

### Future repository work

Create the thin repository only when its identity, executable name, recipes and
acceptance journeys can be added atomically to the parent manifest.

## Rules for every future update

Before adding product code, ask: “Could another application use this?” If the
answer is yes, define and test it in Framework first.

For each major update:

1. Write the public contract and beginner-friendly documentation.
2. Implement headless product-neutral behavior.
3. Add focused tests and portfolio-level contract tests.
4. Add the frontend or external adapter behind the contract.
5. Keep honest loading, empty, disconnected and error states.
6. Adopt the capability from a thin application controller.
7. Prove complete user journeys and recovery.
8. Record build, dependency, security, test and package evidence.

This sequence preserves existing features while making every new piece easier
to reuse, review and teach.
