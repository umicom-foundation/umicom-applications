<!--
  Umicom Framework
  File: docs/architecture/ADR-0013-framework-owned-vector-identity.md

  PURPOSE:
    Record the single branding rule used by every native Umicom workstation.
    The rule prevents a missing asset or a copied raster file from creating a
    different identity in Studio, Trader, Bank or a future application.

  AUTHOR AND ORGANISATION:
    Sammy Hegab
    Umicom Foundation

  LICENCE:
    MIT
-->

# ADR-0013 — Framework-owned vector application identity

**Status:** Accepted  
**Date:** 6 September 2026  
**Owners:** Umicom Framework and Umicom Applications

## Decision

Every native Umicom header and startup surface uses the packaged SVG mark from
the Framework resource catalogue. The canonical masters are:

- `framework/resources/brand/umicom-icon.svg` for light surfaces;
- `framework/resources/brand/umicom-icon-on-dark.svg` for dark surfaces;
- the matching `umicom-logo*.svg` files when a full wordmark is appropriate.

The product name remains readable text beside the mark. A missing packaged
asset does **not** draw a textual `<>` substitute and does not invent a second
application-owned logo. The image is left hidden, the product name remains
visible, and packaging/conformance diagnostics report the missing resource.

The Windows `.ico` is a shell integration format only. It is not the source
artwork and must not replace the SVG masters in GTK, Qt, web or mobile UI.
Optional PNG files remain compatibility outputs for an explicitly selected
legacy target; they are never the design source of truth.

## Why

SVG keeps one sharp, small, colour-aware identity across display densities and
desktop, web and mobile frontends. It also avoids the white cut-out and blue-on-
blue contrast problems that appeared when a raster screenshot was treated as
the logo. Central ownership means a colour or accessibility correction is made
once and all applications receive it.

## Constraints

1. Application modules may choose their title, subtitle, mode badge and
   appearance profile, but may not copy or redraw the Umicom mark.
2. CMake branding helpers must require the canonical SVG resources before a
   branded target can be configured.
3. Runtime resource resolution may search a configured install root or the
   executable's `branding` directory, but it must not silently change the
   logical resource name.
4. A missing asset is a release defect. A graceful text-only state is allowed
   during diagnostics, but a fake logo is not.
5. Existing comments, public names and compatibility APIs remain intact unless
   a later accepted decision replaces them.

## Acceptance evidence

- `framework/adapters/gtk4/workstation/shell_header_gtk4.c` presents only the
  resolved SVG picture and leaves it hidden when resolution fails.
- `framework/cmake/UmicomApplicationBranding.cmake` and the composition root
  check the required SVG files at configure time and stage them beside each
  branded executable.
- Header snapshots expose `icon_visible`, allowing headless and UI acceptance
  tests to detect a packaging defect without scraping GTK widgets.
- The canonical decision register and application-header validation require
  the Framework-owned SVG mark and contain no `<>` branding fallback rule.

## Consequences

The startup surface can still report useful progress if a package is damaged,
but release automation must fail or flag the package before publication. A
future Qt or web adapter can consume the same logical resource names and keep
the same conformance rule without sharing GTK implementation details.
