<!--
Umicom Applications
File: docs/roadmaps/PROFESSIONAL_DEVELOPMENT_AND_TRADING_CAPABILITY_ROADMAP.md

PURPOSE:
Give junior developers a truthful, product-neutral map of completed and missing
professional IDE and trading-workstation capabilities.

AUTHOR AND ORGANISATION:
Sammy Hegab
Umicom Foundation

LICENCE:
MIT
-->

# Professional Development and Trading Capability Roadmap

## How to read the status

- **Available** means reusable logic and a usable application path exist.
- **Foundation** means working contracts or models exist, but the complete
  native screen, adapter or end-to-end workflow is unfinished.
- **Planned** means the capability is still missing and must not be advertised
  as complete.

The names of other products are intentionally not used here. The goal is to
describe familiar professional behaviour in Umicom’s own language.

## Umicom Studio IDE

### Available

| Capability | Umicom owner |
|---|---|
| Project and workspace lifecycle | Framework project and workspace services |
| Source/document editing, splits and navigation | Framework editor and document services |
| Language intelligence and refactoring foundations | Framework language runtime and editor services |
| Build, test and debug workflow | Framework build, test and debug services |
| Source control status, history, diff and commands | Framework VCS and repository services |
| Visual application designer model | Framework declarative, designer and workbench-designer services |
| Terminal and process sessions | Framework terminal services |
| AI chat, model comparison, approvals and knowledge context | Framework AI, knowledge and Studio runtime services |
| Reusable Engine Explorer | Framework engine catalogue with a thin Studio view |

### Foundations that still need complete native workflows

| Capability | Remaining work |
|---|---|
| Docking, floating and multi-monitor layouts | Atomic panel editing, linked context and Studio native floating/redocking are available. Finish visible drag targets, generic-suite detached windows, keyboard docking and monitor recovery verification. |
| Remote development | Connect welcome screen, host manager, remote project opening, builds, tests and debugging into one guided workflow. |
| Performance tools | Connect live capture adapters to call tree, flame graph, CPU, memory, coverage and regression panels. |
| Database development | Complete production drivers, schema comparison/publish, data editor safety and query-result streaming. |
| Extension lifecycle | Complete online discovery, verified download, activation/restart, failure recovery and permissions UI. |
| Executable notebooks | Complete cell editor, kernel/runner adapters, rich outputs, history and saved execution state. |
| Collaboration | Complete secure transport, participant permissions, shared editing and conflict recovery. |
| Device and responsive preview | Connect target profiles, previews, accessibility checks and launch/deploy actions. |
| Deployment centre | Complete target adapters, secrets, remote logs, rollback and evidence views. |

### Missing Studio capabilities

| Capability | Framework work required first |
|---|---|
| Localisation editor | Resource catalogue, translation units, locale validation and preview contracts. |
| Complete interactive HTTP/API client | Request collections, environments, secret references, response history and test assertions. |
| Production application-server management | Server adapter, deployment, log, health and debug-attach contracts. |
| Full visual data modelling | Reusable schema diagram editing, forward/reverse engineering and migration review. |
| End-to-end hot reload | Safe build delta, runtime capability negotiation, state migration and rollback. |
| Complete UI accessibility audit | Automated focus, contrast, label, keyboard and screen-reader evidence. |

## Umicom Trader

### Available

| Capability | Umicom owner |
|---|---|
| Instruments, quotes, bars and market depth | Framework trading engine |
| Orders, fills, executions and positions | Framework order and execution services |
| Matching buyers and sellers | Framework matching engine and order books |
| Pre-trade/post-trade risk, limits and kill switch | Framework trading risk services |
| Portfolio, buying power and profit/loss foundations | Framework trading and finance services |
| Simulation, replay and market session state | Framework trading engine |
| Charts, indicators, drawings and annotations | Framework chart engine |
| Custom layouts, tab groups and linked context | Framework layout, desktop and context services |

### Foundations that still need complete native workflows

| Capability | Remaining work |
|---|---|
| Trading workstation presentation | Shared panel controls and linked context are integrated. Complete high-density native tables, saved columns, detached monitors and keyboard workflows. |
| Time and sales | Add filtered sequence-checked tape storage, pause/resume, direction inference and native view. |
| Market scanner | Add saved rules, calculated columns, live ranking, schedules and alert actions. |
| Strategy analysis | Add multi-run coordinator, optimisation, walk-forward validation, simulation assumptions and evidence reports. |
| Price ladder | Add ladder gestures, guarded order movement, stops, permissions and complete audit evidence. |
| Trade performance | Add reports, drawdown analysis, execution attribution and drill-down navigation. |
| Predictive research | Add dataset lineage, validation splits, comparison, calibration and approved deployment. |

### Missing Trader capabilities

| Capability | Framework work required first |
|---|---|
| Options chain and strategy analysis | Instrument chain, volatility surface, sensitivities, scenario and reviewed multi-leg order contracts. |
| Economic calendar, news and fundamentals | Provider-neutral event/feed records, provenance, entitlements and cache policy. |
| Full alert engine | Condition graph for price, indicator, drawing, strategy, risk and scheduled events. |
| Advanced order-flow analytics | Trade classification, footprint, volume profile, imbalance and liquidity event models. |
| Portfolio rebalance workflow | Targets, constraints, proposals, review, staged orders and reconciliation evidence. |
| Production live broker connection | Authenticated session, subscriptions, order routing, reconciliation, reconnect and acceptance gates. |
| Mobile and web companion | Secure session projection, notification and restricted remote action contracts. |

## Delivery order

1. Finish generic detached windows, drag targets, keyboard docking and monitor
   recovery because every application uses them.
2. Finish Studio’s Engine Explorer and project templates for the new engines.
3. Finish Studio remote development, profiler, extension and database workflows.
4. Add Trader time-and-sales, scanner, alert and options contracts to Framework.
5. Render those contracts as thin Trader panels with simulation-first tests.
6. Add external data and execution adapters only after capability, security,
   reconciliation and failure-recovery tests are complete.

This order keeps application code thin and makes each new building block useful
to future Umicom applications.
