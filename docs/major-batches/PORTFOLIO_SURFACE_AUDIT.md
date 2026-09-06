# Portfolio surface audit

The Framework now has one report for checking that every application can be
shown and started safely. This keeps the launcher honest: an application is
not advertised as ready just because a name appears in a menu.

## What is checked

For each application in the canonical portfolio, the audit joins three pieces
of Framework data:

1. The portfolio supplies the display name and executable name.
2. The experience catalogue supplies panels and a default layout.
3. The presentation catalogue supplies the icon, taskbar group and launcher
   layout name.

The report marks an application as ready only when all three are present, the
default layout names a real recipe with at least one panel, and the executable
name is not empty. Missing information stays in the row as a status so a
launcher or installer can explain what needs attention.

## C API

Include `umicom/application/productisation/surface_audit.h` and call
`umi_product_portfolio_surface_audit_build`. The result is a bounded structure
that is safe to display in a table or copy into another report. Use
`umi_product_portfolio_surface_audit_find` when a screen needs one application.

The report contains separate totals for layouts, user interfaces, start entry
points and complete launch surfaces. This makes it possible to show progress
without guessing from a single percentage.

## Source-level check

The `umicom-application-surface-audit` build target scans the `applications`
directory and writes `umicom-application-surface-audit.json` in the build
directory. Every application folder must contain both `CMakeLists.txt` and
`src/console/main.c`. The console entry point is a small, dependency-light way
to verify startup and Framework contracts before an optional graphical
frontend is used.

The same check is registered as
`framework.application.surface.audit` when tests are enabled. It does not
launch an application, access credentials or modify source files.

## Current result

The copied worktree contains 26 portfolio definitions and 24 application
folders. The focused IDE entry deliberately reuses the Studio experience
rather than duplicating panel data; the Author experience is currently a
Framework portfolio entry without a thin application folder. All 24 existing
application folders have a CMake entry and a console start source, and the
Framework publishes a presentation and a matching default layout for all 26
portfolio entries. Native graphical frontends are a separate product
adoption concern; this audit proves the shared Framework surface and a safe
headless start path first.
