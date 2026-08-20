# ADR-0001: Framework-Owned Shared Resources and Branding

- **Status:** Accepted
- **Date:** 20 August 2026
- **Owner:** Sammy Hegab, Umicom Foundation

## Context

Common logos, icons, theme values and reusable layout templates were previously stored beside one application. That made Studio appear to own resources required by every application and by normal Umicom OS user space. Hard-coded root paths also prevented clean use from another superproject or an installed Framework SDK.

## Decision

Umicom Framework owns immutable resources meaningful to more than one product:

```text
framework/resources
├── brand
├── icons
├── themes
├── schemas
├── layouts
└── windows
```

Applications consume logical resource identifiers through Framework contracts. Product-specific media remains in the owning application module. Resources required before Framework starts remain in the full `umicom-os` repository.

The old Studio-specific Windows `.rc` file is not made global. Framework supplies a product-neutral template; each product supplies its own name, version and executable identity at configure time.

## Consequences

- Common assets have one source of truth.
- GTK4, Qt, Wt, native web, headless and OS packaging can resolve the same logical identifiers.
- Applications no longer need repository-relative paths to another product's resources.
- Trademark files must be copied exactly, not redrawn or generated.
- The current Studio module temporarily receives ignored compatibility copies generated from Framework resources.
