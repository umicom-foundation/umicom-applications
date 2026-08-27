# Application Production Gap Matrix
Authority: Umicom Framework

Products in direct adoption scope: Umicom Studio IDE and Umicom Trader
Portfolio coverage: all 25 canonical application experiences

## Decision

Umicom Framework remains the single source of truth for reusable contracts,
layout semantics, panel binding, commands, capability readiness, persistence,
acceptance and portfolio diagnostics. Product repositories own only executable
identity, frontend placement, product-specific composition and external adapter
integration.

The Master Controller coordinates lifecycle and routing. Slave Controllers own
domain operations. The Master Controller must not contain editor mutations,
pricing, order decisions, publishing logic or frontend widgets.

## Audited portfolio
The native `umicom-application-production-audit` command derives this matrix
from the checked-in experience catalogue. The audit uses a structural capability
probe: it proves declared Framework contracts exist, but does not claim that an
external service, broker, device or live environment is operational.

The catalogue contains 25 experiences while the composition repository
currently registers 24 independently versioned product modules. Umicom Author
has a canonical Framework experience but no dedicated application submodule in
the parent portfolio; its product repository/executable contribution therefore
remains an explicit composition gap.

| Application | Panels | Layouts | Features | Planned | Foundation | Implemented | Verified | Open app work | Open adapter work |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Studio IDE | 12 | 3 | 9 | 1 | 3 | 3 | 2 | 0 | 1 |
| Trader | 15 | 3 | 8 | 2 | 2 | 4 | 0 | 2 | 1 |
| AI Creator | 8 | 3 | 7 | 1 | 6 | 0 | 0 | 1 | 0 |
| Bank | 13 | 3 | 10 | 4 | 3 | 3 | 0 | 2 | 2 |
| TMS | 15 | 3 | 8 | 1 | 5 | 2 | 0 | 1 | 0 |
| LLM | 13 | 3 | 9 | 4 | 4 | 1 | 0 | 4 | 0 |
| Exchange | 13 | 3 | 8 | 1 | 2 | 5 | 0 | 1 | 0 |
| Music Studio | 12 | 3 | 8 | 3 | 5 | 0 | 0 | 2 | 0 |
| Media Studio | 15 | 3 | 8 | 3 | 5 | 0 | 0 | 2 | 0 |
| Accountant | 15 | 3 | 8 | 3 | 4 | 1 | 0 | 1 | 0 |
| RAG | 7 | 2 | 8 | 2 | 6 | 0 | 0 | 1 | 0 |
| Desktop | 8 | 2 | 5 | 0 | 2 | 3 | 0 | 0 | 0 |
| OS | 10 | 2 | 5 | 2 | 3 | 0 | 0 | 0 | 2 |
| Games | 9 | 3 | 4 | 4 | 0 | 0 | 0 | 1 | 1 |
| Kitchen Designer | 6 | 2 | 4 | 4 | 0 | 0 | 0 | 0 | 1 |
| CAD | 7 | 2 | 4 | 4 | 0 | 0 | 0 | 0 | 2 |
| Author | 12 | 3 | 5 | 0 | 3 | 2 | 0 | 0 | 0 |
| Web Studio | 9 | 2 | 5 | 2 | 3 | 0 | 0 | 0 | 0 |
| Mobile Studio | 9 | 2 | 4 | 4 | 0 | 0 | 0 | 0 | 2 |
| Database Studio | 10 | 2 | 5 | 1 | 1 | 3 | 0 | 1 | 0 |
| Integration Studio | 10 | 2 | 5 | 1 | 1 | 3 | 0 | 1 | 0 |
| Operations | 9 | 2 | 5 | 1 | 1 | 3 | 0 | 1 | 0 |
| Security Centre | 9 | 2 | 5 | 1 | 0 | 4 | 0 | 1 | 0 |
| Marketplace | 9 | 2 | 5 | 1 | 0 | 4 | 0 | 1 | 0 |
| Education | 8 | 2 | 5 | 5 | 0 | 0 | 0 | 1 | 0 |
| **Total** | **263** | **62** | **157** | **55** | **59** | **41** | **2** | **24** | **12** |

All 263 panels currently project to a Framework component. All 62 layouts have
deterministic Framework projections. The principal gap is therefore executable
product adoption and acceptance, not another parallel panel catalogue.

## Framework production contracts delivered

| Contract group | Responsibility |
|---|---|
| Identity and application binding | Validate product identity against the canonical experience and adoption snapshot |
| Panel, layout and feature binding | Project declared surfaces without product-owned widget or domain logic |
| Command binding | Materialise panel, layout and feature commands from existing Framework metadata |
| Production registry | Register bounded, independently versioned application contributions |
| Capability requirements and probes | Deduplicate panel/feature requirements and resolve availability |
| Capability readiness | Separate critical blockers from optional degradation |
| Readiness report | Combine feature maturity, capability, adoption, layout and test readiness |
| Workspace checkpoints | Capture revisioned session state without owning durable storage |
| Checkpoint store and recovery | Retain bounded recovery points and restore compatible sessions |
| Manifest contract and snapshot | Derive expected and observed product shape from canonical metadata |
| Manifest drift | Detect identity, executable, frontend, panel, layout, feature and availability drift |
| Evidence requirements and records | Define and retain manifest, layout, feature, test and acceptance evidence |
| Acceptance rules and reports | Enforce production gates without treating declarations as proof |
| Lifecycle gates and launch plan | Order resolution, validation, layout, capability, recovery, binding and start |
| Product runtime | Coordinate the preceding contracts for one application |
| Portfolio and report | Evaluate all canonical applications with one reusable model |
| Diagnostics | Emit bounded drift, coverage, application-work and adapter-work findings |
| Control commands | Provide stable commands for product centres and quality views |
| Master Controller control plane | Coordinate portfolio lifecycle without absorbing Slave Controller logic |
| Native audit command | Export current portfolio gaps without Python or PowerShell |

## Studio implementation remaining

Framework already owns editor, workbench, layout, command, diagnostics, build,
debug, source-control, designer, AI/RAG and productisation mechanics. Studio
therefore needs product adoption and frontend completion rather than duplicate
services.

| Area | Current direction | Remaining product work |
|---|---|---|
| Production Centre | New thin panel and command contributions | Render Framework diagnostics, evidence and launch-plan models in GTK4 |
| Workbench layouts | Three canonical layouts project successfully | Complete multi-monitor frontend recovery and interaction acceptance |
| Editor platform | Core editing and intelligence contracts exist | Finish language/frontend parity and executable user-flow acceptance |
| Build/test/debug | Framework services exist | Close end-to-end toolchain, task, test and debugger UI journeys |
| Visual designer | Framework contracts and Studio foundations exist | Complete drag/drop, preview, source round-trip and accessibility acceptance |
| AI/RAG | Framework context, retrieval and model services exist | Finish Studio permissions, evidence and offline/online model UX |
| External adapters | One open adapter-owned feature | Supply real adapter integration and acceptance evidence outside Framework |
| Packaging | Productisation contracts exist | Prove install, upgrade, rollback and signed release flows |

The Batch update we added `UmiStudioProductionProfile`,
`UmiStudioProductionPanelCatalogue`,
`UmiStudioProductionCommandCatalogue` and
`UmiStudioProductionReadiness`. These are deliberately thin projections.

## Trader implementation remaining

Framework already owns market data models, analytics, strategies, OMS, risk,
positions, replay and trading views. Trader must compose those contracts and
integrate governed external connectivity.

| Area | Current direction | Remaining product work |
|---|---|---|
| Trading workspace | Fifteen panels and three layouts project successfully | Complete GTK4 multi-monitor workspace and context-link interaction |
| Market data | Framework feature implemented | Connect accepted real/paper feeds and prove session/recovery behaviour |
| OMS and executions | Framework feature implemented | Complete application workflow, reconciliation and operator acceptance |
| Independent risk | Framework feature implemented | Prove UI cannot bypass risk and emergency controls |
| IBKR paper adapter | External-adapter feature remains planned | Implement TWS transport, subscriptions, orders, fills and reconciliation |
| Research/replay | Implemented/foundation Framework features | Complete charts, scanners, factors, replay evidence and UX |
| Live execution | Product-owned feature remains planned | Keep disabled until paper, OMS, risk and acceptance evidence are verified |
| Latency evidence | Required by the Trader blueprint | Surface receive, normalize, decide, submit, acknowledge and fill timestamps |

We added `UmiTraderProductionProfile`,
`UmiTraderProductionPanelCatalogue`,
`UmiTraderProductionCommandCatalogue` and
`UmiTraderProductionReadiness`. The readiness projection makes paper and live
conditions explicit; it does not send orders or make risk decisions.

## Remaining suite applications

The other application repositories already expose thin adoption declarations.
Their open work is represented by the 24 application-owned and 12
external-adapter-owned catalogue features above. The next product-completion
sequence should use the same control plane:

1. Close Framework-owned planned/foundation capabilities shared by multiple
   products.
2. Render the production centre, diagnostics and recovery models in Studio.
3. Complete Trader GTK4 paper workflow and IBKR adapter behind independent risk.
4. Move each remaining product from declaration to executable acceptance in
   priority order, without copying Framework mechanics.
5. Record tests and user-flow evidence before advancing a feature to verified.

## Acceptance rules

A product launch is accepted only when:

- its canonical experience and thin contribution agree;
- its default and alternate layouts project successfully;
- critical capabilities are available;
- its workspace can start fresh or recover a compatible checkpoint;
- its executable and tests are available;
- every required evidence item is accepted;
- no manifest drift or uncovered critical panel remains.

A structural audit does not authorize Trader live execution. Live execution
continues to require explicit paper, OMS, risk, reconciliation and live-release
evidence.

## Executable experience audit

The architecture and product-reference blueprints were rechecked against the
current remote repositories after the GTK Application Suite layout batch. The
design sources consistently require Framework-first commands, panels,
documents, notifications, docking and persistence; a thin GTK4 Studio adapter;
and a Trader layout with chart, order/position, research and diagnostics areas.
They also require the Master Controller to remain a composition root while
Slave Controllers own editor, market, OMS, risk and other domain operations.

Batch 51 adds sixteen executable, evidence-bearing user journeys rather than a
second feature catalogue. Every journey resolves its layout and panel references
through the existing canonical experience catalogue. The catalogue contains
eight Studio journeys and eight Trader journeys, each with five ordered steps.
All eighty references resolve; there are no missing application, layout or
panel identifiers.

| Product | Journeys | Steps | Release blocking | Confirmation steps | Initial evidence state |
|---|---:|---:|---:|---:|---|
| Studio IDE | 8 | 40 | 8 | 6 | Pending |
| Trader | 8 | 40 | 8 | 8 | Pending |
| **Total** | **16** | **80** | **16** | **14** | **Pending** |

The journey runtime is deliberately data-only: it orders steps, records bounded
evidence, blocks on critical failures and produces completion reports. It does
not drive GTK widgets, edit files, place orders or bypass a Slave Controller.

## Current layout and panel closure

| Product | Canonical layouts | Canonical panels | Native GTK status | Remaining layout work |
|---|---:|---:|---|---|
| Studio IDE | Development, Review, AI Assisted | 12 | Existing production workbench plus suite-layout binding | Prove canonical-to-live surface mapping, parameterised command flows, multi-monitor recovery, keyboard/focus traversal and clean restart |
| Trader | Trading, Research, Strategy Development | 15 | All 15 panels now have Framework view factories and the GTK workstation can render each layout | Complete parameter-entry interactions, context propagation, real chart/replay/news adapters, multi-monitor recovery and operator acceptance |

Trader previously returned `UMI_STATUS_NOT_IMPLEMENTED` for Scanner, Predictive
Research Lab, News, Context Inspector, Strategy, Replay and Research Output.
Those panels now produce toolkit-neutral Framework view models. News and Replay
report explicit provider/stream empty states until an accepted external source
is connected; this is a complete UI state, not a claim that the adapter exists.

## Remaining Framework work to product readiness

| Priority | Contract/module group | Required implementation and proof |
|---|---|---|
| P0 | Build graph closure | Keep every source directory composed once; build registered validation executables before CTest; validate Windows UCRT64 debug and all-module presets in CI |
| P0 | Journey automation bridge | Bind the new journey contracts to GTK interaction drivers, headless view-model drivers, evidence persistence, cancellation, timeouts and reproducible failure capture |
| P0 | Live surface adoption audit | Compare each product's executable panel factories, command handlers and GTK surface registry with its canonical experience and journey references |
| P0 | Release evidence store | Persist journey evidence, build/test provenance, package hashes, adapter versions and recovery checkpoints with retention and tamper-evident records |
| P1 | Parameterised command interaction | Reusable forms, validation, confirmation and cancellation for commands that require instrument, quantity, price, path, configuration or credentials |
| P1 | UI state contract | Standard loading, empty, stale, disconnected, permission-denied, error and recovery states for every panel and frontend adapter |
| P1 | Visual/accessibility acceptance | Keyboard-only navigation, focus order, screen-reader roles, contrast, scaling, RTL/locale and screenshot/golden-layout evidence |
| P1 | Multi-monitor runtime acceptance | Monitor topology change, floating-window recovery, off-screen correction, density/DPI migration and crash-safe layout persistence |
| P1 | Process isolation contracts | Supervised boundaries and health/restart protocols for critical Trader market data, OMS, risk and execution Slave Controllers |
| P1 | Latency and sequence evidence | Receive, normalize, decide, submit, acknowledge and fill timestamps; queue depth, sequence gaps, stale-data policy and journal position |
| P2 | Adapter certification | Common conformance suites for language servers, debuggers, compilers, source control, broker/news feeds, replay sources and packaging backends |
| P2 | Frontend parity | Finish behavior-level conformance for supported GTK4, Qt6 and web adapters without moving domain state into UI code |
| P2 | Clean-machine delivery | Install, upgrade, rollback, signing, SBOM, offline mode and unprivileged-user validation for product packages |

## Remaining Studio IDE implementation

| Area | Existing base | Product work still required | Acceptance journey |
|---|---|---|---|
| First-run/workspace | Framework workspace/session and Resource Explorer | Clean-profile onboarding, real recent workspaces, missing-path recovery and session restore | `studio.first-run-workspace` |
| Editor/build/test | Editor, task/build/test and Problems contracts | Prove save/configure/build/test/diagnostics as one cancellable user flow on GCC/Clang/MSVC profiles | `studio.edit-build-test` |
| Debugger | DAP runtime and Debug workbench | Configuration UX, breakpoint persistence, variable/watch editing, attach/restart and failure recovery | `studio.debug-session` |
| Source control/review | Git, diff/merge and quality contracts | Complete staged/unstaged operations, three-way conflicts, review navigation and safe confirmation | `studio.source-control-review` |
| Visual designer | Declarative designer and preview foundations | Drag/drop, property binding, responsive preview, source round trip, undo/redo and accessibility proof | `studio.visual-designer-round-trip` |
| AI/RAG | Context, routing, retrieval, approval and tool contracts | Explicit context inspection, offline/online model UX, permission prompts, patch review/revert and provenance | `studio.ai-assisted-change` |
| Layout/accessibility | Docking, layout persistence and GTK host | Canonical live-surface audit, multi-monitor recovery, keyboard/focus, scaling and RTL/locale evidence | `studio.layout-recovery` |
| Distribution | SDK, packaging and update foundations | Clean install, signed package, upgrade, rollback, extension compatibility and release acceptance | `studio.package-release` |
| Production Centre | Production profiles, panels, commands and readiness | Render live Framework diagnostics, journey status, evidence, launch plan and recovery actions in the existing Quality/production surfaces | All Studio journeys |
| Legacy path closure | Some older Studio files still contain explicit placeholders | Prove they are unreachable, migrate them to current Framework services or replace them only after regression evidence | All Studio journeys |

Studio is not ready merely because its many focused model tests pass. Product
readiness requires all eight journeys to pass on the installed GTK executable,
plus clean-machine packaging and accessibility evidence.

## Remaining Trader implementation

| Area | Existing base | Product work still required | Acceptance journey |
|---|---|---|---|
| Safe startup | Simulation-default workspace, risk and kill switch | Visible environment banner, broker/data/risk health, live-disarmed proof and operator diagnostics | `trader.simulation-startup` |
| Market navigation | Watchlist, chart, depth and linked context models | Real streaming adapter, timestamp display, stale/gap states, chart history and context propagation | `trader.market-data-navigation` |
| Order workflow | Draft order, pre-trade risk, OMS and order ticket | Parameter controls, risk explanation, explicit confirmation, idempotency and simulation/paper execution UX | `trader.simulation-order` |
| Cancellation/reconciliation | OMS, executions, positions, account view | Broker reconciliation, partial fills, rejects, bust/correct handling, immutable audit and recovery | `trader.cancel-reconcile` |
| Emergency controls | Independent risk and kill switch | Isolated risk process, privileged reset, reason journal, rejection proof and controlled restart | `trader.kill-switch-recovery` |
| Research/replay | Replay, factors, predictive models and all research panels | Historical data/replay adapter, strategy runner, MFE/MAE and follow-through evidence, export and reproducibility | `trader.replay-strategy` |
| IBKR paper | Framework boundary and planned external adapter | TWS/Gateway lifecycle, subscriptions, reconnect, orders, fills, account state and reconciliation conformance | `trader.paper-session-recovery` |
| Live execution | Explicitly planned and disabled | Production credentials, independent approvals, operational runbook, security, monitoring and all prior accepted evidence | `trader.live-release-gate` |
| News | Capability-aware empty state | Optional licensed/provider adapter, symbol/entity linking, timestamps, source attribution and stale state | Market/research journeys |
| Multi-monitor workstation | Three canonical layouts and GTK host | Persisted windows, DPI/topology recovery, focus/keyboard support and layout acceptance | All Trader journeys |

Live order routing remains prohibited until every step of the live-release gate
has accepted evidence. A rendered order ticket or a connected paper session is
not sufficient authorization.

## Recommended completion sequence

1. Merge Batch 51 and validate the fixed root build graph with
   `windows-ucrt64-debug`, then validate Studio and Trader together with
   `windows-ucrt64-all-debug`.
2. Implement the Framework live-surface adoption audit and GTK/headless journey
   driver; persist evidence and render it in Studio's Production Centre.
3. Close the eight Studio journeys, including clean-machine packaging, before
   widening Studio feature scope.
4. Complete Trader parameterised controls and simulation journeys; then add the
   IBKR paper adapter behind independent risk and reconciliation.
5. Keep live execution disabled while paper, recovery, security, latency and
   operator evidence remain incomplete.
6. Reuse the same Framework journey/evidence contracts for the remaining suite
   applications instead of adding product-specific acceptance engines.
