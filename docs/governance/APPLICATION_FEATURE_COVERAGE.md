# Umicom Application Feature Coverage

**Status:** Canonical living coverage record  
**Owner:** Umicom Foundation  
**Last reviewed:** 4 September 2026  
**Revision control:** Git history; do not create numbered copies.

## Purpose

This document prevents shared Framework work from covering only a small subset of the application family. It records every application registered by the suite repository and the evidence required when a shared lifecycle, workbench, panel, layout, accessibility or command-state capability changes.

## Coverage rule

A shared feature is implemented once in Umicom Framework. Every application is then assessed for:

- portfolio registration;
- Framework experience registration;
- thin runtime adoption;
- startup and identity adoption;
- host, tab, panel and layout adoption;
- product-specific configuration;
- application journey tests;
- build and startup evidence;
- remaining migration work.

Coverage never requires meaningless source edits. A clean application repository can be fully covered when it consumes a corrected Framework capability and its tests prove adoption.

## Current registered applications

| Repository path | Application ID | Product | Current Framework adoption | Product workspace focus |
|---|---|---|---|---|
| `applications/desktop` | `org.umicom.desktop` | Umicom Desk | Framework portfolio registered; application host and catalogue are the primary product responsibility. | Universal host, application catalogue, sessions, recent work, notifications and system status. |
| `applications/studio` | `org.umicom.studio` | Umicom Studio IDE | Framework portfolio and experience registered; Framework workbench enabled; local startup and legacy compatibility paths require controlled migration. | Projects, editors, visual design, build, test, debug, terminal, source control, documentation and AI assistance. |
| `applications/trader` | `org.umicom.trader` | Umicom Trader | Framework portfolio and experience registered; shared product workstation and startup composition present. | Market data, watchlists, charts, depth, orders, risk, positions, account and blotter. |
| `applications/tms` | `org.umicom.tms` | Umicom TMS | Framework portfolio and experience registered; thin runtime enabled; product journey and specialised panel maturity remain under coverage. | Trade capture, lifecycle, workflow, pricing, positions, risk, settlement, accounting and operations. |
| `applications/llm` | `org.umicom.llm` | Umicom LLM | Framework portfolio and experience registered; thin runtime enabled; product journey and specialised panel maturity remain under coverage. | Model catalogue, runtime, chat, tools, sessions, serving and performance. |
| `applications/bank` | `org.umicom.bank` | Umicom Bank | Framework portfolio and experience registered; shared product workstation and startup composition present. | Overview, customers, accounts, balances, payments, beneficiaries, approvals, reconciliation and liquidity. |
| `applications/exchange` | `org.umicom.exchange` | Umicom Commodity Exchange | Framework portfolio and experience registered; thin runtime enabled; product journey and specialised panel maturity remain under coverage. | Markets, listings, matching, orders, contracts, logistics, surveillance and operations. |
| `applications/os` | `org.umicom.os` | Umicom OS Control Centre | Framework portfolio and experience registered; thin runtime enabled; product journey and specialised panel maturity remain under coverage. | Systems, services, processes, storage, network, packages, users and security. |
| `applications/music` | `org.umicom.music-studio` | Umicom Music Studio | Framework portfolio and experience registered; thin runtime enabled; product journey and specialised panel maturity remain under coverage. | Library, arrangement, timeline, mixer, instruments, effects and properties. |
| `applications/media` | `org.umicom.media-studio` | Umicom Media Studio | Framework portfolio and experience registered; thin runtime enabled; product journey and specialised panel maturity remain under coverage. | Media library, timeline, preview, effects, audio, captions and export. |
| `applications/accountant` | `org.umicom.accountant` | Umicom Accountant | Framework portfolio and experience registered; thin runtime enabled; product journey and specialised panel maturity remain under coverage. | Dashboard, chart of accounts, journals, ledger, reconciliation, close and reporting. |
| `applications/rag` | `org.umicom.rag` | Umicom RAG | Framework portfolio and experience registered; thin runtime enabled; product journey and specialised panel maturity remain under coverage. | Collections, sources, ingestion, chunks, retrieval, evaluation and knowledge chat. |
| `applications/games` | `org.umicom.games` | Umicom Games | Framework portfolio and experience registered; thin runtime enabled; product journey and specialised panel maturity remain under coverage. | Projects, scenes, game view, assets, scripts, properties and runtime diagnostics. |
| `applications/creator` | `org.umicom.creator` | Umicom AI Creator | Framework portfolio and experience registered; thin runtime enabled; product journey and specialised panel maturity remain under coverage. | Projects, generation canvas, prompts, history, assets and export. |
| `applications/kitchen` | `org.umicom.kitchen-designer` | Umicom Kitchen Designer | Framework portfolio and experience registered; thin runtime enabled; product journey and specialised panel maturity remain under coverage. | Catalogue, plan, three-dimensional view, materials, properties and estimate. |
| `applications/cad` | `org.umicom.cad` | Umicom CAD | Framework portfolio and experience registered; thin runtime enabled; product journey and specialised panel maturity remain under coverage. | Model tree, drawing area, three-dimensional view, constraints, layers and properties. |
| `applications/web-studio` | `org.umicom.web-studio` | Umicom Web Studio | Framework portfolio and experience registered; thin runtime enabled; product journey and specialised panel maturity remain under coverage. | Projects, source editor, visual designer, preview, console and network activity. |
| `applications/mobile-studio` | `org.umicom.mobile-studio` | Umicom Mobile Studio | Framework portfolio and experience registered; thin runtime enabled; product journey and specialised panel maturity remain under coverage. | Projects, device preview, designer, components, properties, build and deployment. |
| `applications/database-studio` | `org.umicom.database-studio` | Umicom Database Studio | Framework portfolio and experience registered; thin runtime enabled; product journey and specialised panel maturity remain under coverage. | Connections, schemas, query editor, results, execution plans and data inspection. |
| `applications/integration-studio` | `org.umicom.integration-studio` | Umicom Integration Studio | Framework portfolio and experience registered; thin runtime enabled; product journey and specialised panel maturity remain under coverage. | Flows, connectors, mappings, messages, monitoring and failures. |
| `applications/operations` | `org.umicom.operations` | Umicom Operations | Framework portfolio and experience registered; thin runtime enabled; product journey and specialised panel maturity remain under coverage. | Service health, deployments, jobs, logs, metrics, incidents and recovery. |
| `applications/security-centre` | `org.umicom.security-centre` | Umicom Security Centre | Framework portfolio and experience registered; thin runtime enabled; product journey and specialised panel maturity remain under coverage. | Identity, permissions, policy, secrets, events, findings and response. |
| `applications/marketplace` | `org.umicom.marketplace` | Umicom Marketplace | Framework portfolio and experience registered; thin runtime enabled; product journey and specialised panel maturity remain under coverage. | Catalogue, installed components, updates, publishing, licences and reviews. |
| `applications/education` | `org.umicom.education` | Umicom Education Studio | Framework portfolio and experience registered; thin runtime enabled; product journey and specialised panel maturity remain under coverage. | Courses, lessons, learner preview, assessment, progress and teaching assistance. |

## Shared workstation contract alignment

The Framework GTK4 workstation correction is inherited by every registered application. It preserves compact normal-mode panel chrome, explicit Edit Layout controls, managed tab close, detached windows, linked-context presentation, truthful product view-model rendering and existing chart behaviour while aligning every adapter with the public Framework contracts.

| Coverage item | Result |
|---|---|
| Implementation owner | Umicom Framework only |
| Application-local duplicate | None permitted or required |
| Direct application source impact | None for this shared repair |
| Inherited consumers | Every application listed above when it renders a Framework workstation or surface |
| Contract evidence | Existing public panel-frame, workspace-host, tab-stack, automation, view-model, property, command and chart contracts |
| Build evidence required | Framework UI target, normal suite build and all-application build |
| Journey evidence required | Application startup plus affected panel, tab, detach, close and layout journeys |
| Remaining limitation | Complete Windows UCRT64 and GTK4 integration validation must be recorded after local execution |

## Common acceptance matrix

Every registered graphical application must eventually satisfy:

| Capability | Required evidence |
|---|---|
| Startup lifecycle | Truthful tasks, progress, mode, failure and recovery through Framework presentation. |
| Application identity | Umicom icon, full name, active context, mode and health remain readable at supported scaling. |
| Application surface | The product can run independently and participate in a Framework host where supported. |
| Tabs | Correct separation of application, document/tool and layout tabs. |
| Panels | Declared close, hide, move, resize, dock, float, detach, reattach, maximise and auto-hide behaviours work. |
| Layouts | Default profile, edit transaction, cancel, apply, lock, save, restore and reset are validated. |
| Context links | Typed group membership, compatibility checks and accessibility are validated. |
| Commands | Every visible action is functional or carries a truthful unavailable reason. |
| Product content | Normal mode shows product tasks rather than internal identifiers. |
| Persistence | User state uses Framework Data Server contracts and recovers safely. |
| Accessibility | Keyboard, focus, labels, high contrast and supported scaling are tested. |
| Architecture | No application-local duplicate of a reusable Framework mechanism. |
| Quality | All-application build, strict warnings, tests and startup smoke journey succeed. |

## Update protocol

Every shared delivery updates this document. For each affected application, record:

- inherited Framework change;
- direct product-profile change, if any;
- test or startup evidence;
- known limitation;
- next roadmap action.

A missing application row is a governance failure.

## Universal application header and launcher coverage

The shared GTK4 application header now provides a semantic active-application
tab, searchable application catalogue, plus action, new-window action and
window-close action. The catalogue is populated from the canonical Framework
portfolio; no application repository owns another product list.

### Coverage classification

| Consumer | Coverage | Evidence required on Windows |
|---|---|---|
| Umicom Desk | Inherited through the managed Framework shell header used by the Desk GTK entry point. | Header shows the active Desk tab, catalogue search, plus action, new-window action and close action. |
| Umicom Studio IDE | Inherited through the managed Framework shell header in the existing Studio application bar. | Header shows `<>` or the packaged mark, the application catalogue opens, and closing follows the Studio close guard. |
| Umicom Trader and Umicom Bank | Inherited through the Framework product workstation and suite workstation. | Each product shows its own identity and can discover the canonical application portfolio. |
| TMS, LLM, Exchange, Music, Media, Accountant, RAG, Games, Creator, Kitchen, CAD, Web Studio, Mobile Studio, Database Studio, Integration Studio, Operations, Security Centre, Marketplace, Education and OS Control Centre | Inherited when their graphical surface uses the Framework product or managed shell-header composition. | Each configured graphical executable or surface must show the same controls; an unavailable executable reports a reason rather than a false success. |

### Source-of-truth evidence

- application names, purposes, repository slugs and executable names come from
  `UmiApplicationDefinition` records;
- catalogue enumeration uses `umi_application_portfolio_count()` and
  `umi_application_portfolio_at()`;
- selection resolves again through `umi_application_portfolio_find()` before
  launch;
- a future universal host supplies one callback and does not replace the
  catalogue or copy its rows;
- no application-local source file is changed merely to reproduce shared
  controls.

### Current limitation

The implementation opens an independently runnable process unless a host
installs the new application-open callback. Several application surfaces in one
native host, drag transfer between host windows and state rehydration remain
roadmap capabilities. They are not represented as complete by this update.
