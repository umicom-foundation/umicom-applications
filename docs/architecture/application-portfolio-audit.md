# Umicom Application Portfolio Integrity Audit
Audits the composition root, Framework and every configured
application submodule before extending the thin-product runtime boundary. The
authoritative portfolio contains one Framework repository and 24 application
repositories. No planned application is represented by a second path, product
identifier or executable.

## Repository inventory

| Application repository | Product identifier | Executable | Current role |
|---|---|---|---|
| accountant | `org.umicom.accountant` | `umicom-accountant-console` | Thin Framework consumer |
| bank | `org.umicom.bank` | `umicom-bank-console` | Finance reference composition |
| cad | `org.umicom.cad` | `umicom-cad-console` | Thin Framework consumer |
| creator | `org.umicom.creator` | `umicom-ai-creator-console` | AI reference composition |
| database-studio | `org.umicom.database-studio` | `umicom-database-studio-console` | Thin Framework consumer |
| desktop | `org.umicom.desktop` | `umicom-desk` | Desktop shell composition |
| education | `org.umicom.education` | `umicom-education-console` | Thin Framework consumer |
| exchange | `org.umicom.exchange` | `umicom-exchange-console` | Thin Framework consumer |
| games | `org.umicom.games` | `umicom-games-console` | Thin Framework consumer |
| integration-studio | `org.umicom.integration-studio` | `umicom-integration-studio-console` | Thin Framework consumer |
| kitchen | `org.umicom.kitchen-designer` | `umicom-kitchen-designer-console` | Thin Framework consumer |
| llm | `org.umicom.llm` | `umicom-llm-console` | Thin Framework consumer |
| marketplace | `org.umicom.marketplace` | `umicom-marketplace-console` | Thin Framework consumer |
| media | `org.umicom.media-studio` | `umicom-media-studio-console` | Thin Framework consumer |
| mobile-studio | `org.umicom.mobile-studio` | `umicom-mobile-studio-console` | Thin Framework consumer |
| music | `org.umicom.music-studio` | `umicom-music-studio-console` | Thin Framework consumer |
| operations | `org.umicom.operations` | `umicom-operations-console` | Thin Framework consumer |
| os | `org.umicom.os` | `umicom-os-control-centre` | OS control composition |
| rag | `org.umicom.rag` | `umicom-rag-console` | Thin Framework consumer |
| security-centre | `org.umicom.security-centre` | `umicom-security-centre-console` | Thin Framework consumer |
| studio | `org.umicom.studio` | `umicom-studio-ide` | Full developer workbench composition |
| tms | `org.umicom.tms` | `umicom-tms-console` | Treasury composition |
| trader | `org.umicom.trader` | `umicom-trader-console` | Trading composition |
| web-studio | `org.umicom.web-studio` | `umicom-web-studio-console` | Thin Framework consumer |

## Ownership and duplication rules

- Framework owns reusable application runtime, readiness, workspace commands,
  layouts, panels, controls, persistence and domain services.
- Application repositories own product identity, feature/panel/layout
  composition, executable wiring and product-specific acceptance tests.
- Bank and AI Creator already supplied reference runtime/readiness/command
  bridges; the portfolio composition update does not recreate them.
- Studio, Trader, TMS, Desktop and OS keep their specialised composition and
  are not forced through the generic thin-application bridge.
- The other 17 products use `UmicomThinApplicationRuntime.cmake` so target and
  test registration logic exists once in Framework.
- The root `manifests/applications.json`, each `application.umicom.yaml`, and
  `.gitmodules` are checked together by `applications.portfolio_integrity`.

## Thin application composition closure

Each of the 17 thin products now exposes three small composition contracts:

1. `runtime` starts and evaluates the Framework-owned workspace runtime.
2. `readiness` projects canonical feature status without a product-local
   roadmap engine.
3. `workspace_commands` forwards layout, panel and context actions to the
   Framework runtime.

Each product receives focused runtime, readiness and command tests, while its
existing workspace test remains registered exactly once.

## Submodule lock workflow

`umicom repo lock .` resolves the current HEAD of every configured submodule
and stages only the parent repository gitlinks. It does not fetch, pull, commit
or push. Therefore Framework and all modified application repositories must be
committed and pushed first. Run the lock command from the composition root,
review `git status`, and then commit the parent repository with `git add -A`.
