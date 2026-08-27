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
