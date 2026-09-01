<!-- --------------------------------------------------------------------------
Umicom Applications
File: docs/roadmaps/UMICOM-SUITE-DELIVERY-ROADMAP.md

PURPOSE:
Define the major feature updates needed to complete Umicom Framework and adopt
its reusable building blocks across every Umicom application.

AUTHOR AND ORGANISATION:
Sammy Hegab
Umicom Foundation

LICENCE:
MIT
---------------------------------------------------------------------------- -->

# Umicom Suite Delivery Roadmap

## How to use this roadmap

Each titled section is a major update that can be planned, reviewed and merged
independently. The title describes the user outcome. Update numbers do not
belong in filenames, source identifiers or public documentation.

The order matters. Framework contracts and tested behaviour come first. A
reference application adopts them next. Other applications then reuse the same
pieces. This keeps applications thin and makes new products feel like building
with a box of compatible parts.

A feature is not complete because a header, panel name or empty screen exists.
Completion requires four kinds of evidence:

- **Contract:** stable public types, ownership rules and failure behaviour.
- **Behaviour:** tested toolkit-neutral logic in Framework.
- **Integration:** a thin application and any external adapter use the contract.
- **Acceptance:** a person can finish the complete journey, including recovery.

## Current foundation

Framework already contains broad foundations for application experiences,
components, workspaces, docking, commands, documents, editors, data, AI,
knowledge, finance, trading, media, security, observability and delivery. The
main risk is creating another foundation instead of joining and proving what
already exists.

The Source Guidance work now provides:

- per-file function and decision documentation reports;
- allocation-free workspace totals that can accept thousands of reports;
- reusable quality-session integration;
- a toolkit-neutral Studio Quality Centre view;
- a generated catalogue of engines, components, panels and feature maturity.

The Application Workspace Guidance work now provides:

- bounded welcome-screen choices derived from canonical layouts;
- one recommended starting layout without restricting user customisation;
- truthful feature maturity and next-priority guidance;
- a compact, validated portfolio for suite launchers;
- thin adoption wrappers and focused checks in all application repositories.

## Framework Contract and ABI Completion

**Outcome:** applications can depend on stable contracts without guessing
ownership, structure lifetime or compatibility.

Framework work:

- audit public structures for size, API identity and append-only extension;
- document borrowed, owned and transferred pointers;
- introduce compatibility tests for every exported library;
- catalogue deprecated symbols and supported migration paths;
- add header-coexistence and C/C++ consumption tests;
- finish Source Guidance coverage for public headers and important internals.

Application integration:

- Studio displays compatibility and documentation evidence;
- every application compiles an aggregate public-header consumer;
- the release process rejects unexplained breaking changes.

Completion evidence: API baseline, ABI layout, header conformance and migration
tests pass on every supported target.

## Component Model and Composition

**Outcome:** a new application selects reusable components instead of copying
panels, commands or models.

Framework work:

- consolidate component, recipe, capability and experience catalogues;
- validate stable IDs, required capabilities and maturity;
- add dependency ordering and optional-component negotiation;
- provide component lifecycle, state, command and diagnostic contracts;
- generate application starter manifests from selected components.

Application integration:

- Studio gains a Component and Engine Explorer;
- the application launcher explains unavailable capabilities;
- every application records which Framework components it adopts.

Completion evidence: catalogue validation and generated thin-application tests
prove there are no duplicate IDs or hidden application paths.

## Docking, Windows and Multi-Monitor Workspaces

**Outcome:** users can dock, split, tab, float, group, link, hide, lock and move
panels across monitors in every graphical application.

Framework work:

- complete drag targets, tab groups, split trees and floating windows;
- add monitor identity, scale-aware placement and off-screen recovery;
- support cloned layouts, named perspectives and layout locking;
- persist linked context groups and active selections;
- provide undo, preview and reset for layout editing;
- verify GTK and headless adapters against one conformance suite.

Application integration:

- Studio proves development, debug, design, review and focus workspaces;
- Trader proves dense linked workstations and multiple monitors;
- TMS, Bank, Media and Operations reuse the same behaviours.

Completion evidence: keyboard, pointer, restart, monitor removal and corrupted
layout recovery journeys all pass.

## Universal Application Shell

**Outcome:** every product has a familiar, clean shell while keeping its own
specialist tools and identity.

Framework work:

- application title bar, menu bar, command palette and toolbars;
- activity bar, status bar, notifications and background-task progress;
- welcome screen, recent work, learning links and recovery choices;
- window catalogue, panel catalogue and searchable command catalogue;
- loading, empty, stale, disconnected, denied, error and recovery states;
- application logo, icon, theme and accessibility metadata.

Application integration: all applications adopt the shell and contribute only
their own commands, menus, panels, layouts and specialist status indicators.

Completion evidence: one shell acceptance suite runs against every application.

## Workspace Persistence and Recovery

**Outcome:** work survives restart, crash, upgrade and monitor changes.

Framework work:

- atomic checkpoints, autosave and journal recovery;
- layout schema migration and forward-compatible unknown fields;
- document dirty-state and unsaved-change protection;
- session restore policy for applications launched together;
- safe-mode startup and selective workspace reset;
- recovery evidence and user-readable explanations.

Application integration: Studio restores projects and editors; Trader restores
safe views but never silently resubmits orders; creative applications restore
timelines and assets; business applications restore drafts and task context.

Completion evidence: forced termination and incompatible-layout fixtures recover
without data loss or unsafe external actions.

## Accessibility, Appearance and Localisation

**Outcome:** every application is usable with keyboard navigation, assistive
technology, scaling, high contrast and local formats.

Framework work:

- semantic roles, names, descriptions and focus order;
- complete keyboard alternatives for docking and complex controls;
- colour tokens, icon states, density and typography scales;
- right-to-left layout and translation resource contracts;
- locale-aware dates, times, quantities, currencies and numbers;
- automated contrast, missing-label and focus-trap checks.

Application integration: each product supplies domain wording and verifies its
most important journeys without a pointer device.

Completion evidence: automated checks plus documented keyboard and screen-reader
acceptance passes.

## Data Grid, Tree and Analytical Surfaces

**Outcome:** large datasets behave consistently across developer, financial,
operational and creative products.

Framework work:

- virtualised grid and tree data providers;
- sorting, filtering, grouping, pivoting and pagination;
- streaming updates, stale-state markers and stable row identity;
- column layouts, formulas, totals and safe export;
- chart, graph, timeline and drill-down context linking;
- accessible cell navigation and editor validation.

Application integration: Studio explorers, Trader market data, TMS positions,
Bank transactions, Database Studio results and Operations logs share the model.

Completion evidence: large, streaming and partially failing data-source tests.

## Forms, Workflow and Approval

**Outcome:** applications can build safe data-entry journeys from reusable,
validated pieces.

Framework work:

- schema-backed fields, field groups and conditional sections;
- synchronous and asynchronous validation;
- draft, dirty, submitted, approved, rejected and cancelled states;
- wizard navigation, review screens and confirmation summaries;
- permission, approval and separation-of-duty hooks;
- undo, audit and resubmission evidence.

Application integration: Bank payments, TMS deal capture, Accountant journals,
Trader orders and Marketplace publishing use the same workflow foundations.

Completion evidence: invalid, duplicate, interrupted and permission-denied paths
are tested as carefully as the successful path.

## Security, Secrets and Trust

**Outcome:** credentials and powerful actions remain local, encrypted, least
privileged and reviewable.

Framework work:

- platform secret-store adapter and encrypted fallback;
- secret references that never expose plaintext in layouts or logs;
- workspace trust, extension permissions and tool approval;
- authentication, roles, capabilities and policy evaluation;
- redaction, tamper-evident audit and security evidence;
- dependency, vulnerability and unsafe-API review.

Application integration: AI providers, broker sessions, bank connectors,
database connections and remote development use secret references only.

Completion evidence: leakage scans, permission tests, locked-store recovery and
credential-rotation journeys pass.

## Umicom Command and Developer Workflow

**Outcome:** a beginner can check their computer, obtain dependencies, build,
test, inspect and safely publish repositories through one guided command.

Framework work:

- environment and required-library discovery with plain-language remedies;
- configure, build, test, install and package workflow plans;
- cancellation, resumable stages and machine-readable evidence;
- safe repository status, add, commit, push, clone and submodule workflows;
- lock detection, child-first publication and parent-gitlink verification;
- dependency, source-quality, memory and portability gates.

Application integration: Studio renders the same plans in Toolchain, Quality and
Release Centres; bootstrap PowerShell and shell scripts remain available before
the native command is built.

Completion evidence: clean-machine and contributor pull-request journeys pass.

## Studio Core Development Workbench

**Outcome:** Studio completes the everyday edit, build, test, debug and source
control loop using Framework services.

Features:

- project and solution explorer, symbols, outline and properties;
- multi-document editor, split views, navigation and refactoring;
- configurations, tasks, builds, problems and output;
- test discovery, execution, coverage and history;
- debug sessions, breakpoints, variables, watches and call stacks;
- changes, history, branches, diffs, merge and review;
- terminal, remote workspace and toolchain health.

Integration: language, compiler, debugger and repository providers remain
replaceable adapters. Native widgets render Framework view models only.

Completion evidence: open-to-debug and change-to-commit journeys run end to end.

## Studio Visual Design and Extension Platform

**Outcome:** Studio visually creates Framework applications and safely extends
its own workbench.

Features:

- component palette, canvas, hierarchy, properties and event binding;
- snapping, constraints, responsive previews and source round-trip;
- application template and component-recipe authoring;
- extension SDK, declared permissions, isolated activation and quarantine;
- package discovery, install, update, rollback and compatibility evidence;
- database, integration, web and mobile designer surfaces.

Integration: all designers share Framework document, undo, selection, property
and layout contracts.

Completion evidence: create, edit, preview, generate, reopen and upgrade journeys.

## Studio AI-Assisted Workbench

**Outcome:** users can chat, research and ask an agent to make reviewed changes
inside Studio using local or remote models.

Features:

- conversation, task, context, plan and approval panels;
- provider-neutral streaming and multi-model comparison;
- local model discovery and runtime health;
- knowledge collections, citations and retrieval inspection;
- proposed patch, diff review, test evidence and revert;
- permission boundaries for files, commands, network and external systems;
- encrypted local API-key references and usage controls.

Integration: LLM supplies model runtime; RAG supplies knowledge; Studio supplies
workspace context; CodeGuard supplies quality evidence.

Completion evidence: no tool acts outside granted scope, and every modification
has reviewable provenance and recovery.

## Trader Market and Research Workstation

**Outcome:** Trader provides professional market observation, charting, research
and simulation through configurable linked workspaces.

Features:

- watchlists, quotes, market depth, time and sales and news;
- charts, indicators, drawings, alerts and replay;
- scanners, fundamentals, calendars and research notebooks;
- strategy editor, backtest, prediction workspace and evidence;
- linked instruments, colour groups and cross-panel navigation;
- simulation portfolio, performance and trade journal.

Integration: Framework owns streaming, chart, context, layout and simulation
contracts. Market and news feeds remain external adapters.

Completion evidence: reconnect, stale data, replay and multi-monitor recovery.

## Trader Execution, Risk and Broker Integration

**Outcome:** optional live trading is controlled, reconciled and visibly distinct
from simulation.

Features:

- order ticket, staged order, validation and explicit confirmation;
- orders, executions, positions, cash, margin and profit/loss;
- pre-trade limits, independent risk decision and emergency controls;
- broker session, account mapping, reconciliation and health;
- partial fills, rejects, cancel/replace, corrections and recovery;
- immutable operational journal and environment banner.

Integration: the broker adapter translates protocols but cannot bypass Framework
permissions, validation, risk, confirmation or reconciliation.

Completion evidence: simulation first, then approved paper connectivity; live
connectivity remains disabled until security and operational evidence is accepted.

## Treasury Management

**Outcome:** TMS supports a controlled front-to-back treasury lifecycle.

Features: cash positions and forecasts, deal capture, pricing, market data,
positions, risk, limits, collateral, settlement, payments, accounting events,
reconciliation, workflow inbox and audit.

Integration: finance, trading, forms, approval, data-grid, workflow, document and
adapter contracts remain Framework-owned. Bank, market and accounting connections
remain replaceable.

Completion evidence: representative trade and payment lifecycles, including
amendment, cancellation, failure and four-eye approval.

## Digital Banking and Wallets

**Outcome:** Bank offers safe personal and business account journeys.

Features: identity and onboarding, accounts, wallets, beneficiaries, transfers,
cards, foreign exchange, statements, budgeting, notifications, disputes, fraud
cases, limits and approvals.

Integration: ledger, payment, money, identity, forms, documents, audit and secret
contracts are shared. Regulated decisions and bank-network adapters remain
specialist modules.

Completion evidence: sandbox journeys, reconciliation, accessible authentication,
failed-payment recovery and audit completeness.

## Local Models and Knowledge Workspaces

**Outcome:** LLM and RAG provide reusable private AI and knowledge services to
every application.

Features:

- model install, catalogue, load, unload, health and resource limits;
- conversations, templates, tools, evaluations and model comparison;
- collections, source connectors, ingestion and chunk inspection;
- lexical, vector and hybrid retrieval, reranking and citations;
- access policy, provenance, freshness and deletion;
- local folders plus approved external knowledge adapters.

Integration: Studio, Author, Trader, Education, Operations and creative products
consume the same AI and knowledge contracts.

Completion evidence: offline operation, deterministic evaluation fixtures,
citation traceability and permission isolation.

## Desktop, Launcher and OS Control Centre

**Outcome:** users can install, discover, launch and coordinate several Umicom
applications across one desktop session.

Features: application selection, multi-launch, task surfaces, notifications,
search, settings, session recovery, monitor workspaces, process and service views,
storage, network, updates, logs and developer controls.

Integration: Desktop owns user-space shell presentation; OS adapters expose only
approved platform operations; application communication uses typed Framework
commands and context channels.

Completion evidence: multiple simultaneous applications, safe shutdown, privilege
denial and restart recovery.

## Creative Media, Music and Publishing

**Outcome:** Music, Media, Creator and Author share production assets and job
pipelines while keeping specialist editing surfaces.

Framework work: asset catalogue, timeline, transport, graph, animation, image,
audio, video, document, storyboard, review, provenance and render-job contracts.

Application features:

- Music: tracks, clips, MIDI, mixer, automation, recording and mastering;
- Media: storyboard, timeline, compositing, subtitles, review and delivery;
- Creator: generation graphs, variants, provenance and asset export;
- Author: outline, chapters, citations, revisions and publication formats.

Completion evidence: save/reopen, missing assets, background render cancellation,
version review and deterministic export manifests.

## Three-Dimensional Design and Games

**Outcome:** CAD, Kitchen and Games reuse one renderer-neutral scene and asset
foundation.

Framework work: scene graph, transforms, cameras, materials, meshes, animation,
input, collision, spatial queries, navigation, assets, scripting, profiling and
packaging.

Application features:

- CAD: sketches, constraints, parametric history, assemblies and interchange;
- Kitchen: floor plans, catalogues, rules, costing, documentation and preview;
- Games: worlds, entities, sessions, multiplayer adapters and deployment.

Completion evidence: deterministic scene serialization, resource cleanup,
large-scene performance and adapter conformance.

## Business, Education and Marketplace Applications

**Outcome:** remaining information products reuse mature forms, workflow,
documents, reporting and security.

Application features:

- Accountant: ledgers, sales, purchases, reconciliation, tax, payroll and HR;
- Education: lessons, resources, exercises, assessment and learner progress;
- Marketplace: discovery, signing, permissions, install, update and publishing;
- Exchange: instruments, matching operations, surveillance, clearing and settlement.

Integration: common grids, forms, approvals, jobs, audit, notifications and
document generation remain in Framework.

Completion evidence: complete domain journeys with permission, failure and
reconciliation paths.

## Data, Integration, Security and Operations Centres

**Outcome:** technical operators can connect, observe, protect and repair the
whole suite through consistent workspaces.

Application features:

- Database Studio: connections, schema, queries, plans, editing and migration;
- Integration Studio: connectors, flow graph, mappings, tests and schedules;
- Security Centre: posture, secrets, vulnerabilities, incidents and remediation;
- Operations: services, jobs, queues, logs, metrics, incidents and runbooks.

Integration: connector, secret, graph, job, observability, evidence and permission
contracts are shared with every other application.

Completion evidence: disconnected operation, retry, cancellation, redaction,
incident audit and least-privilege tests.

## Web, Mobile and Cross-Target Delivery

**Outcome:** Framework applications can be designed, previewed, tested and
packaged for supported targets without forking their domain logic.

Features: responsive constraints, component previews, browser and device bridges,
target capabilities, accessibility checks, packaging, signing and deployment
plans.

Integration: Web Studio and Mobile Studio use the same designer, document,
language, diagnostic, test and delivery contracts as Studio.

Completion evidence: shared project logic, target-specific adapter tests and
reproducible signed packages.

## Installer, Updates and Suite Release

**Outcome:** a new user can install selected applications, launch several at
once, update safely and roll back.

Framework work:

- suite/application selection manifest and dependency calculation;
- signed packages, licences, hashes and software bill of materials;
- install locations, shortcuts, file associations and repair;
- update channels, staged rollout, rollback and migration;
- launcher discovery and side-by-side compatibility checks;
- release evidence combining builds, tests, security and package verification.

Application integration: every application declares its files, capabilities,
optional integrations, migration steps and health check.

Completion evidence: clean install, selective install, repair, upgrade, rollback
and uninstall journeys on supported operating systems.

## Integration dependency map

| Consumer | Framework providers it must reuse | External adapter boundary |
|---|---|---|
| Studio | Workbench, documents, editor, project, build, test, debug, VCS, AI, knowledge, CodeGuard | Language, compiler, debugger, remote host, model provider |
| Trader | Workbench, context, chart, trading, risk, journal, jobs, secrets | Market data, news, broker |
| TMS | Finance, trading, workflow, approvals, data, documents, audit | Bank, market, accounting, settlement |
| Bank | Identity, ledger, payments, money, forms, documents, security | Payment network, card, identity verification |
| LLM and RAG | AI, knowledge, jobs, security, data, observability | Model runtime, model service, source connector |
| Desktop and OS | Shell, launcher, sessions, commands, notifications, platform | Operating-system privileged helper |
| Creative applications | Media, timeline, assets, documents, AI, jobs | Codec, device, model and publishing service |
| CAD, Kitchen and Games | 3D, designer, assets, animation, input, jobs | Renderer, hardware and interchange format |
| Operations applications | Data, integration, observability, security, evidence | Database, service, cloud and network provider |

## Rule for choosing the next update

Choose the earliest incomplete section whose dependencies already exist. Pick
one complete user journey, not a large collection of disconnected declarations.
Before adding code:

1. Search Framework catalogues and public headers.
2. Improve an existing contract instead of creating a second name for it.
3. State pointer ownership, limits, failures and external side effects.
4. Put reusable behaviour in Framework and keep applications thin.
5. Add a Framework test and one application adoption test.
6. Update feature maturity honestly.
7. Record build, test, accessibility, security and recovery evidence.

This process is how the suite becomes complete without becoming tangled.
