# Umicom Repository Architecture Audit

**Audit date:** 4 September 2026  
**Suite baseline:** `1b36798ba214bf17f76b394968b6ed4c9f28b905`  
**Framework baseline:** `9af3da7b95c12b265de5e2edc940fc0e14b8fe2d`  
**Scope:** `umicom-applications`, `umicom-framework`, all registered application submodules, canonical workbench design and build integration.

## Executive finding

The current repositories already contain the correct foundational direction:

- the suite repository composes one authoritative Framework checkout with thin application modules;
- the Framework application portfolio is the canonical catalogue used by launchers, Studio, operating-system tooling, installers and audits;
- the Framework experience catalogue defines application panels, layouts and feature roadmaps;
- the application-experience build integration attaches the full experience family to the canonical application target;
- the thin-application runtime helper centralises shared runtime and test registration;
- the all-application preset can enable every checked-in application module.

The correct update is therefore **not** another application registry, another experience catalogue or another workbench implementation. The update strengthens governance and conformance around the existing authoritative structures.

## Registered suite estate

The suite currently registers 24 application submodules under `applications/`. The full list is maintained in `APPLICATION_FEATURE_COVERAGE.md` and is checked automatically against `.gitmodules`.

## Existing strengths

### Framework-owned application portfolio

`include/umicom/application/portfolio.h` and `src/application/portfolio.c` already define the long-lived application portfolio as Framework-owned declarative composition data.

### Framework-owned experiences

`include/umicom/application/experience.h`, `include/umicom/application/experience_catalogue.h` and the experience source family already define toolkit-neutral panels, layouts, feature maturity, ownership and default layouts.

### Existing alignment test

`tests/application_experience/test_portfolio_alignment.c` already proves that experience entries resolve to portfolio definitions.

### Existing workbench mechanics

Framework already contains shared GTK4 adapters and toolkit-neutral models for identity, panels, tabs, layouts, customisation, context linking and product presentation.

## Gaps found

1. Approved product-design and architecture decisions were distributed across chat and several historical documents instead of one enforced canonical governance set.
2. No configure-time rule proved that all `.gitmodules` application paths appeared in an application coverage record.
3. Canonical documentation naming and terminology rules were not automated.
4. The existing portfolio-alignment test checked existence but did not verify the universal application contract expected by every experience.
5. Optional generated code documentation existed, but it did not enforce product governance.
6. Future source deliveries could omit applications from UX coverage without causing a build or test failure.

## Corrections introduced

- canonical governance, decision, coverage, adoption, workbench and roadmap documents;
- an automated CMake governance audit;
- configure-time enforcement and a CTest entry;
- automatic reconciliation of `.gitmodules` application paths with the coverage document;
- duplicate decision-ID detection;
- canonical document-name and terminology checks;
- stronger Framework portfolio and experience alignment assertions;
- explicit preservation and delivery constraints.

## Remaining implementation work

This update establishes enforceable project memory and application-family conformance. It does not claim that every visible application workflow is complete. Product-focused layouts, startup migration, application-surface hosting, full docking interaction, specialised panels and vertical user journeys remain on the workbench feature roadmap.

## Audit conclusion

Future major source work can now be judged against durable rules. A delivery that forgets an application, introduces a parallel workbench mechanism, omits decision documentation or uses non-canonical documentation naming will fail configuration or tests instead of silently changing the architecture.
