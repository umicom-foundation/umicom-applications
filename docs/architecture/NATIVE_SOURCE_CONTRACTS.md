# Native Source Contracts

Author: Sammy Hegab  
Organisation: Umicom Foundation  
Licence: MIT

## Ownership and scope

The Framework owns `Umicom::source_contracts`, `umicom-source-contracts`, the semantic source metadata parser, balanced source tokenizer and workbench contract definitions. The Applications parent selects the source root and registers its established test name. Applications do not contain copies of the parser. Existing immutable contracts and production graphical implementations are not renamed.

New implementation is C23. Build declarations are CMake; the existing Framework JSON reader is compiled from its canonical source into the small tool closure. No new JSON parser, scripting implementation or GUI dependency is introduced. The general-purpose JSON reader itself is not changed.

## Attribution policy implemented

A leading block comment must contain a nonempty author OR organisation, either on the label line or following lines. Separate Author / Organisation and combined AUTHOR AND ORGANISATION sections are accepted. Labels ignore case and spacing; Organization, Created by and SPDX-License-Identifier are accepted compatibility spellings. Contributor names are not hard-coded. A metadata label cannot satisfy the previous field's missing value. A string literal after the comment cannot provide attribution.

Purpose, File and Licence remain independent nonempty fields. The checker records declared licence metadata; it does not legally verify licensing or manufacture MIT notices. Matching include guards and duplicate-guard detection remain. Declaration-dependency tests are unchanged.

## Stable C boundary

The public header is `include/umicom/source_contracts/source_contracts.h`. Diagnostics are callbacks with source path, line, rule and message. Input buffers remain caller-owned. The command does not edit files, read credentials, launch products, push repositories or delete user state. Exit codes are 0 for no findings, 1 for contract failures and 2 for input/I/O errors. Callers initialise report counters and retain the callback context for the duration of the operation.

## Build and migration

`cmake/UmicomSourceContracts.cmake` creates one target set and reuses it on subsequent registration calls. Existing CMake audit entry points dispatch to the native executable. CTest names and public helper names are preserved. Audits now need the compiled native tool: a missing executable is a failure with a build instruction, never a silent interpreter skip.

The parent native-window custom target depends on the compiled native command. The ordinary build does not execute source scans as an untracked side effect; CTest and the explicit source-check target do that. Existing Python source remains untouched as a parity reference but is no longer registered for this guard. Removal of other scripting dependencies is not claimed.

The library and command join the existing Framework export set. Imported native command targets can be reused by the registration helper. This update does not claim a separately qualified complete installed SDK or cross-compilation host-tool setup. Source checks should run in native host qualification builds; a cross-target executable requires a host-tool build or appropriate emulator, not an assumption that it runs on the build machine.

## Coverage mapping

There are 21 source-check groups matching the prior checker. Eighteen are native rule groups with 168 predicates; identity, preset inheritance and portfolio traversal have dedicated C implementations. The seven prior preset regression methods are represented in `framework.source_contracts.presets`. Counts identify coverage organisation, not a product-completion metric.

| Existing source-check group | Native implementation |
|---|---|
| `shared_sizing_header_and_both_renderer_source_lists` | `workbench_rules.inc + workbench.c` |
| `each_existing_native_product_uses_shared_sizing` | `workbench_rules.inc + workbench.c` |
| `monitor_selection_order_and_reference_ownership_wiring` | `workbench_rules.inc + workbench.c` |
| `small_monitor_guard_precedes_dimension_clamp` | `workbench_rules.inc + workbench.c` |
| `studio_imports_and_calls_shared_window_policy` | `workbench_rules.inc + workbench.c` |
| `all_four_studio_stacks_size_only_the_selected_page` | `workbench_rules.inc + workbench.c` |
| `all_four_studio_switchers_have_horizontal_scrollers` | `workbench_rules.inc + workbench.c` |
| `studio_splitters_allow_both_children_to_shrink` | `workbench_rules.inc + workbench.c` |
| `geometry_restoration_waits_for_nonzero_allocations` | `workbench_rules.inc + workbench.c` |
| `identity_and_menu_are_separate_scrollable_rows` | `workbench_rules.inc + workbench.c` |
| `shared_runner_is_built_and_has_portable_gui_entry_points` | `workbench_rules.inc + workbench.c` |
| `window_identity_uses_packaged_svg_and_preserves_missing_icon_fallback` | `workbench_rules.inc + workbench.c` |
| `windows_resource_lookup_uses_actual_executable_directory` | `workbench_rules.inc + workbench.c` |
| `runner_cancels_callbacks_before_stack_state_expires` | `workbench_rules.inc + workbench.c` |
| `runner_replaces_splash_before_releasing_its_controller` | `workbench_rules.inc + workbench.c` |
| `preview_controller_is_explicitly_offline_and_rejects_commands` | `workbench_rules.inc + workbench.c` |
| `shared_host_build_wiring_preserves_dedicated_frontends` | `workbench_rules.inc + workbench.c` |
| `branding_refresh_and_embedded_dependencies_are_wired` | `workbench_rules.inc + workbench.c` |
| `every_native_main_window_requests_shared_icon_identity` | `identity.c + workbench.c` |
| `headless_presets_explicitly_disable_all_gui_switches` | `presets.c + Framework language_runtime/json.c` |
| `all_24_products_have_catalogued_experiences_and_standard_recipes` | `portfolio.c` |

## Deliberate limits

The scanner is not a C compiler, full preprocessor, static lifetime analyser or GUI automation engine. It checks specific source wiring without claiming that a window rendered correctly. It does not expand conditional compilation or macros, except recognising transparent GTK_WINDOW/GTK_WIDGET expression wrappers for identity checks. Do not use its output as a security sandbox verdict. It is intended for the trusted source checkout under development.

CMake preset resolution is limited to literal configure presets in the input document. It accepts single/multiple parents, first-parent precedence, child overrides, explicit null, typed values and boolean settings. Cycles, unknown parents and duplicate names/keys fail. Nonempty external preset includes fail as unsupported rather than being ignored; macro values are not evaluated. Input nesting and file sizes are bounded; embedded NUL representations are rejected by this C-string API.

Portfolio source inspection reads the current small manifest identity subset and canonical C catalogue declarations; it is not a replacement for Framework's runtime YAML parser or the existing application-native-manifest tests. The portfolio count is deliberately 24 and must be reviewed when another product is registered. Source enumeration excludes generated build trees and Git metadata, refuses a symlink/reparse root and does not traverse linked descendants. These are read-only test boundaries, not a hostile-filesystem race guarantee.

## Validation and remaining work

Seven native groups cover attribution, lexical boundaries, window identity, preset inheritance, filesystem/guards, portfolio fixtures and rule matching. GCC, Clang and Clang sanitizers pass those groups in the preparation environment. The real registration helper and dispatch wrappers pass a small integration fixture. The installed command is smoke-tested. A missing root, unknown group, missing licence and deliberately broken lifecycle source all fail as intended.

This does not establish a complete root Applications configure/build/test, all 21 groups against the whole live checkout, Windows runtime execution, native GTK behaviour, complete product installation or a bootable OS. Run the user-machine qualification guide, retain the results and mark the roadmap outcome accepted only after the applicable evidence exists.
