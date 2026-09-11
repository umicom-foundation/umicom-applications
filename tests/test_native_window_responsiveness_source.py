#!/usr/bin/env python3
"""Guard native sizing source wiring without compiling or starting GTK.

These checks protect the selected integration points and known regression
patterns. They do not measure rendered geometry, prove GTK runtime behavior,
or replace native interaction tests on real monitors.

Author: Sammy Hegab
Organisation: Umicom Foundation
Licence: MIT
"""

import argparse
import json
from pathlib import Path
import re
import sys
import unittest


SOURCE_ROOT = Path(__file__).resolve().parents[1]
STUDIO_RUNTIME = "applications/studio/src/gui/workbench/runtime/"
FIT_HEADER = "umicom/ui/gtk4/workstation/window_fit.h"
PRODUCT_RUNNER = "framework/adapters/gtk4/application_product_application_gtk4.c"
DEDICATED_APPS = {"desktop", "studio", "trader", "bank", "tms", "music"}
C_TOKEN = re.compile(r'/\*.*?\*/|//[^\n]*|"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'', re.S)


def source(relative_path):
    """Read repository text, preserving strings while ignoring C comments."""
    text = (SOURCE_ROOT / relative_path).read_text(encoding="utf-8-sig")
    if relative_path.endswith(".cmake") or Path(relative_path).name == "CMakeLists.txt":
        text = re.sub(r"(?m)^[ \t]*#[^\n]*", "", text)
    return C_TOKEN.sub(
        lambda token: " " * len(token[0]) if token[0].startswith("/") else token[0],
        text,
    )


def compact(text):
    """Ignore formatting so line wrapping does not change wiring checks."""
    return re.sub(r"\s+", "", text)


def function_body(text, name):
    """Find a C definition and balance braces, ignoring quoted literals."""
    masked = C_TOKEN.sub(lambda token: " " * len(token[0]), text)
    match = re.search(r"\b" + re.escape(name) + r"\s*\([^;{}]*\)\s*\{", masked)
    if match is None:
        raise AssertionError(f"Missing C function definition: {name}")
    start = match.end()
    depth = 1
    for index in range(start, len(masked)):
        depth += (masked[index] == "{") - (masked[index] == "}")
        if depth == 0:
            return text[start:index]
    raise AssertionError(f"Unclosed C function: {name}")


def resolve_cache_variables(presets, name):
    """Resolve literal cache values across in-file configure-preset inheritance.

    Earlier parents take precedence; the child overrides all parents. Retain
    null entries during merging so an explicit unset cannot accidentally expose
    a later parent's value. This is not a general CMake macro/include evaluator.
    """
    index = {}
    for preset in presets:
        if not isinstance(preset, dict) or not isinstance(preset.get("name"), str):
            raise AssertionError("Every configure preset needs a string name")
        if preset["name"] in index:
            raise AssertionError(f"Duplicate configure preset: {preset['name']}")
        index[preset["name"]] = preset
    active = set()
    resolved = {}

    def visit(current):
        if current in active:
            raise AssertionError(f"Cyclic configure-preset inheritance: {current}")
        if current not in index:
            raise AssertionError(f"Unknown inherited configure preset: {current}")
        if current in resolved:
            return resolved[current]
        active.add(current)
        preset = index[current]
        parents = preset.get("inherits", [])
        if isinstance(parents, str):
            parents = [parents]
        if not isinstance(parents, list) or not all(isinstance(parent, str) for parent in parents):
            raise AssertionError(f"Invalid inherits value in preset: {current}")
        values = {}
        for parent in reversed(parents):
            values.update(visit(parent))
        own = preset.get("cacheVariables", {})
        if not isinstance(own, dict):
            raise AssertionError(f"Invalid cacheVariables in preset: {current}")
        values.update(own)
        active.remove(current)
        resolved[current] = values
        return values

    values = {}
    for key, value in visit(name).items():
        if isinstance(value, dict):
            if "value" not in value:
                raise AssertionError(f"Typed cache variable has no value: {name}/{key}")
            value = value["value"]
        if isinstance(value, bool):
            value = "ON" if value else "OFF"
        if value is not None and not isinstance(value, str):
            raise AssertionError(f"Unsupported cache value: {name}/{key}")
        values[key] = value
    return values


class NativeWindowSourceWiring(unittest.TestCase):
    """Check source contracts only; each failure identifies missing wiring."""

    def test_shared_sizing_header_and_both_renderer_source_lists(self):
        header = source("framework/include/" + FIT_HEADER)
        self.assertIn('#include "umicom/base/status.h"', header)
        self.assertIn("UmiStatus umi_gtk4_ws_window_fit(", header)
        cmake = source("framework/cmake/UmicomGtk4WorkstationPlatform.cmake")
        renderer = "adapters/gtk4/workstation/window_fit_gtk4.c"
        for command in (
            r"target_sources\s*\(\s*umicom_ui_gtk4\s+(.*?)\)",
            r"set_source_files_properties\s*\((.*?)\)",
        ):
            with self.subTest(command=command):
                match = re.search(command, cmake, re.S)
                self.assertIsNotNone(match)
                self.assertIn(renderer, match[1])

    def test_each_existing_native_product_uses_shared_sizing(self):
        paths = [f"applications/{app}/src/gtk/main.c"
                 for app in ("bank", "tms", "music", "trader")]
        paths.append("framework/adapters/gtk4/desk_gtk4.c")
        for path in paths:
            with self.subTest(path=path):
                text = source(path)
                self.assertIn(f'#include "{FIT_HEADER}"', text)
                self.assertRegex(text, r"umi_gtk4_ws_window_fit\s*\(")
                self.assertNotRegex(text, r"gtk_window_set_default_size\s*\(")
        self.assertNotIn("fit_workstation_to_monitor", source(paths[3]))

    def test_monitor_selection_order_and_reference_ownership_wiring(self):
        text = source("framework/adapters/gtk4/workstation/window_fit_gtk4.c")
        body = compact(function_body(text, "umi_gtk4_ws_window_fit"))
        lookups = [body.index(name) for name in (
            "gtk_native_get_surface(",
            "gdk_device_get_surface_at_position(",
            "gdk_display_get_monitors(",
        )]
        self.assertEqual(lookups, sorted(lookups))
        self.assertIn("monitor_owned=FALSE", body)
        self.assertIn("monitor_owned=monitor!=NULL", body)
        self.assertIn("if(monitor_owned)g_object_unref(monitor)", body)
        self.assertEqual(body.count("g_object_unref(monitor)"), 1)
        self.assertIn("gtk_window_set_resizable(window,TRUE)", body)

    def test_small_monitor_guard_precedes_dimension_clamp(self):
        text = source("framework/adapters/gtk4/workstation/window_fit_gtk4.c")
        body = compact(function_body(text, "fit_dimension"))
        positive = body.index("if(available<=0)available=1;")
        bounded = body.index("if(safe_minimum>available)safe_minimum=available;")
        fitted = body.index("clamp_dimension(preferred,safe_minimum,available)")
        self.assertLess(positive, bounded)
        self.assertLess(bounded, fitted)
        self.assertNotIn("returnpreferred;", body)

    def test_studio_imports_and_calls_shared_window_policy(self):
        window = source("applications/studio/src/gui/workbench/workbench_window.c")
        shell = source(STUDIO_RUNTIME + "runtime_shell.inc")
        self.assertIn(f'#include "{FIT_HEADER}"', window)
        body = compact(function_body(shell, "runtime_build_shell"))
        self.assertIn("umi_gtk4_ws_window_fit(runtime->owner->window,", body)
        self.assertNotIn("gtk_window_set_default_size(", body)

    def test_all_four_studio_stacks_size_only_the_selected_page(self):
        # Retain this regression's identity while following the shared owner:
        # Studio owns the editor stack; Framework owns all four tool edges.
        shell = source(STUDIO_RUNTIME + "runtime_shell.inc")
        body = compact(function_body(shell, "runtime_build_shell"))
        self.assertIn("runtime_workspace_create(runtime)", body)
        for axis in ("h", "v"):
            self.assertIn(f"gtk_stack_set_{axis}homogeneous("
                          "GTK_STACK(runtime->centre_stack),FALSE)", body)
        host = source("framework/adapters/gtk4/workstation/workspace_layout_host_gtk4.c")
        self.assertIn('#include "workspace_tool_windows_gtk4.inc"', host)
        edges = compact(function_body(host, "tool_window_edge_index"))
        for edge in ("left", "right", "top", "bottom"):
            self.assertIn(f'"auto-hide:{edge}"', edges)
        tools = source("framework/adapters/gtk4/workstation/workspace_tool_windows_gtk4.inc")
        helper = compact(function_body(tools, "build_tool_edge"))
        for axis in ("h", "v"):
            self.assertIn(f"gtk_stack_set_{axis}homogeneous(GTK_STACK(edge->stack),FALSE)", helper)
        self.assertIn("build_tool_edge(host,edge_index)",
                      compact(function_body(tools, "build_tool_windows")))
        panel = compact(function_body(host, "create_panel"))
        for axis in ("width", "height"):
            self.assertIn(f"gtk_scrolled_window_set_propagate_natural_{axis}("
                          "GTK_SCROLLED_WINDOW(viewport),FALSE)", panel)

    def test_all_four_studio_switchers_have_horizontal_scrollers(self):
        # Dock stacks use the shared scrollable notebook, not four local
        # Studio switchers. Edge rails scroll along their own orientation.
        host = source("framework/adapters/gtk4/workstation/workspace_layout_host_gtk4.c")
        stack = compact(function_body(host, "build_stack"))
        self.assertIn("umi_gtk4_ws_tab_host_create(NULL)", stack)
        tabs = source("framework/adapters/gtk4/workstation/tab_host_gtk4.c")
        helper = compact(function_body(tabs, "umi_gtk4_ws_tab_host_create"))
        self.assertIn("gtk_notebook_set_scrollable(GTK_NOTEBOOK(notebook),TRUE)", helper)
        tools = source("framework/adapters/gtk4/workstation/workspace_tool_windows_gtk4.inc")
        edge = compact(function_body(tools, "build_tool_edge"))
        self.assertIn("vertical?GTK_POLICY_NEVER:GTK_POLICY_AUTOMATIC,"
                      "vertical?GTK_POLICY_AUTOMATIC:GTK_POLICY_NEVER", edge)
        self.assertIn("gtk_scrolled_window_set_child(GTK_SCROLLED_WINDOW(edge->rail),rail_box)", edge)

    def test_studio_splitters_allow_both_children_to_shrink(self):
        shell = source(STUDIO_RUNTIME + "runtime_shell.inc")
        body = compact(function_body(shell, "runtime_build_shell"))
        self.assertIn("umi_gtk4_workspace_layout_host_widget(runtime->workspace_host)", body)
        self.assertNotIn("gtk_paned_new(", body)
        host = source("framework/adapters/gtk4/workstation/workspace_layout_host_gtk4.c")
        helper = compact(function_body(host, "join_regions"))
        for side in ("start", "end"):
            self.assertIn(f"gtk_paned_set_shrink_{side}_child(GTK_PANED(paned),TRUE)", helper)
        create = helper.index("gtk_paned_new(")
        self.assertLess(helper.index("if(start==NULL)returnend;"), create)
        self.assertLess(helper.index("if(end==NULL)returnstart;"), create)

    def test_geometry_restoration_waits_for_nonzero_allocations(self):
        # Normalised canvas rectangles are allocated by Framework. Pointer
        # projection must reject zero dimensions before recording a gesture.
        canvas = source("framework/adapters/gtk4/workstation/workspace_canvas_gtk4.inc")
        begin = compact(function_body(canvas, "on_canvas_drag_begin"))
        guard = "if(entry->viewport_width<=0.0||entry->viewport_height<=0.0)return;"
        self.assertIn(guard, begin)
        self.assertLess(begin.index(guard), begin.index("entry->start_rect="))
        self.assertLess(begin.index(guard), begin.index("entry->active=1"))
        allocate = compact(function_body(canvas, "canvas_layer_allocate"))
        for dimension in ("width", "height"):
            self.assertIn(f"MAX(1,(int)(rect->{dimension}*{dimension}+0.5))", allocate)
        host = source("framework/adapters/gtk4/workstation/workspace_layout_host_gtk4.c")
        self.assertIn('#include "workspace_canvas_gtk4.inc"', host)

    def test_identity_and_menu_are_separate_scrollable_rows(self):
        # Identity now lives in the native Framework titlebar. The ordinary
        # command strip must keep its menu scrollable without duplicating it.
        bar = source(STUDIO_RUNTIME + "runtime_application_bar.inc")
        body = compact(function_body(bar, "runtime_build_application_bar"))
        self.assertIn("gtk_scrolled_window_set_child("
                      "GTK_SCROLLED_WINDOW(menu_scroll),runtime->menu_bar)", body)
        self.assertIn("GTK_POLICY_AUTOMATIC,GTK_POLICY_NEVER", body)
        self.assertIn("gtk_scrolled_window_set_propagate_natural_width("
                      "GTK_SCROLLED_WINDOW(menu_scroll),FALSE)", body)
        self.assertIn("gtk_box_append(GTK_BOX(bar),menu_scroll)", body)
        self.assertIn("returnbar;", body)
        self.assertNotIn("umi_gtk4_ws_shell_header_create(", body)
        window = compact(source("applications/studio/src/gui/workbench/workbench_window.c"))
        self.assertIn("umi_gtk4_ws_window_titlebar_create(workbench->window,", window)

    def test_shared_runner_is_built_and_has_portable_gui_entry_points(self):
        main = source("framework/examples/product_workstation_main.c")
        self.assertIn('#include "umicom/application/suite_layout/'
                      'gtk4_product_application.h"', main)
        body = compact(function_body(main, "main"))
        self.assertIn("UMICOM_PRODUCT_APPLICATION_ID,UMICOM_PRODUCT_TITLE,NULL,NULL", body)
        self.assertIn("umi_application_product_gtk4_run(&config,argc,argv)", body)
        self.assertIn("#ifdef _WIN32", main)
        self.assertIn("returnmain(__argc,__argv)", compact(function_body(main, "WinMain")))
        cmake = source("framework/cmake/UmicomApplicationSuiteGtk4Platform.cmake")
        target = re.search(r"target_sources\s*\(\s*umicom_ui_gtk4\s+(.*?)\)", cmake, re.S)
        self.assertIsNotNone(target)
        self.assertIn("adapters/gtk4/application_product_application_gtk4.c", target[1])

    def test_every_native_main_window_requests_shared_icon_identity(self):
        paths = [f"applications/{app}/src/gtk/main.c"
                 for app in ("bank", "tms", "music", "trader")]
        paths.extend(("framework/adapters/gtk4/desk_gtk4.c", PRODUCT_RUNNER,
                      STUDIO_RUNTIME + "runtime_shell.inc"))
        for path in paths:
            with self.subTest(path=path):
                text = source(path)
                identities = {compact(argument) for argument in re.findall(
                    r"\bumi_gtk4_ws_apply_window_identity\s*\(\s*([^()]+)\s*\)", text)}
                self.assertTrue(identities, "No shared window identity request")
                if path.endswith("runtime_shell.inc"):
                    self.assertIn("runtime->owner->window", identities)
                    continue
                self.assertIn('#include "umicom/ui/gtk4/workstation/shell_header.h"', text)
                # Main and splash are independent windows. Check each actual
                # creation target instead of rejecting a second identity call.
                windows = {compact(target) for target in re.findall(
                    r"([A-Za-z_]\w*(?:(?:->|\.)[A-Za-z_]\w*)*)\s*=\s*"
                    r"(?:GTK_WINDOW\s*\(\s*)?gtk_(?:application_)?window_new\s*\(", text)}
                self.assertTrue(windows, "Native window construction was not found")
                self.assertTrue(windows.issubset(identities),
                                f"Windows missing identity: {sorted(windows - identities)}")

    def test_window_identity_uses_packaged_svg_and_preserves_missing_icon_fallback(self):
        header = source("framework/include/umicom/ui/gtk4/workstation/shell_header.h")
        self.assertIn("UmiStatus umi_gtk4_ws_apply_window_identity(GtkWindow *window)", header)
        implementation = source("framework/adapters/gtk4/workstation/shell_header_gtk4.c")
        body = compact(function_body(implementation, "apply_themed_window_identity"))
        self.assertIn('resolve_resource_from_root(NULL,"branding/umicom-icon.svg")', body)
        missing = body.index("if(resolved==NULL)returnUMI_STATUS_NOT_FOUND;")
        register = body.index("gtk_icon_theme_add_search_path(theme,directory)")
        request = body.index('gtk_window_set_icon_name(window,"umicom-icon")')
        self.assertLess(missing, register)
        self.assertLess(register, request)
        self.assertIn('if(!gtk_icon_theme_has_icon(theme,"umicom-icon"))'
                      '{returnUMI_STATUS_NOT_FOUND;}', body)
        self.assertIn("g_strfreev(search_paths)", body)
        self.assertNotIn("g_object_unref(theme)", body)
        self.assertNotIn("gtk_window_set_default_icon_name(", body)
        identity = compact(function_body(implementation, "umi_gtk4_ws_apply_window_identity"))
        self.assertIn("apply_themed_window_identity(window)", identity)
        self.assertIn("prepare_native_window_identity(window)", identity)
        self.assertIn("if(native_status==UMI_STATUS_OK)returnUMI_STATUS_OK;", identity)
        self.assertIn("if(themed_status!=UMI_STATUS_OK)returnnative_status;", identity)
        self.assertIn("returnthemed_status;", identity)

    def test_windows_resource_lookup_uses_actual_executable_directory(self):
        implementation = source("framework/adapters/gtk4/workstation/shell_header_gtk4.c")
        body = compact(function_body(implementation, "executable_directory"))
        self.assertIn("GetModuleFileNameW(NULL,buffer,capacity)", body)
        self.assertIn("g_new(WCHAR,capacity)", body)
        self.assertIn("g_utf16_to_utf8(", body)
        self.assertIn("g_path_get_dirname(filename)", body)
        self.assertNotIn("g_win32_get_package_installation_directory_of_module", body)
        resolver = compact(function_body(implementation, "resolve_resource_from_root"))
        self.assertIn("directory=executable_directory()", resolver)
        self.assertIn("g_build_filename(directory,resource,NULL)", resolver)

    def test_runner_cancels_callbacks_before_stack_state_expires(self):
        runner = source(PRODUCT_RUNNER)
        body = compact(function_body(runner, "umi_application_product_gtk4_run"))
        cleanup = body[body.index("result=g_application_run("):]
        cancel = cleanup.index("g_source_remove(state.startup_source)")
        startup = cleanup.index("product_release_window(&state,&state.startup_window)")
        window = cleanup.index("product_release_window(&state,&state.window)")
        dispose = cleanup.index("product_content_dispose(&state)")
        release = cleanup.index("g_object_unref(application)")
        self.assertLess(cancel, startup)
        self.assertLess(startup, window)
        self.assertLess(window, dispose)
        self.assertLess(dispose, release)
        release_window = compact(function_body(runner, "product_release_window"))
        destroy = release_window.index("gtk_window_destroy(window)")
        self.assertLess(release_window.index("*slot=NULL"), destroy)
        self.assertLess(release_window.index("g_signal_handlers_disconnect_by_data("), destroy)
        self.assertLess(release_window.index("g_object_weak_unref("), destroy)
        # Destruction can precede GObject finalisation when a caller retains a
        # window. Both lifetime paths must invalidate pending startup work.
        for callback in ("product_window_finalized", "product_window_destroyed"):
            finalizer = compact(function_body(runner, callback))
            self.assertIn("state->window=NULL", finalizer)
            self.assertIn("state->startup_window=NULL", finalizer)
            self.assertIn("g_source_remove(state->startup_source)", finalizer)
            self.assertIn("state->startup_source=0U", finalizer)

    def test_runner_replaces_splash_before_releasing_its_controller(self):
        runner = source(PRODUCT_RUNNER)
        startup = compact(function_body(runner, "product_complete_startup"))
        guard = "if(state->window==NULL||state->startup_window==NULL)returnG_SOURCE_REMOVE;"
        self.assertIn(guard, startup)
        self.assertLess(startup.index("state->startup_source=0U"), startup.index(guard))
        content = startup.index("gtk_window_set_child(state->window,content)")
        finish = startup.index("product_finish_startup_window(state,0)")
        dispose = startup.index("umi_gtk4_ws_startup_splash_destroy(state->splash)")
        self.assertLess(content, finish)
        self.assertLess(finish, dispose)
        self.assertIn("state->startup_failed=1", startup)
        finished = compact(function_body(runner, "product_finish_startup_window"))
        self.assertLess(finished.index("product_release_window(state,&state->startup_window)"),
                        finished.index("gtk_window_present(state->window)"))
        self.assertLess(finished.index("gtk_window_set_child(state->startup_window,NULL)"),
                        finished.index("gtk_window_set_child(state->window,"))
        activate = compact(function_body(runner, "product_activate"))
        self.assertIn("gtk_window_present(state->startup_window!=NULL?"
                      "state->startup_window:state->window)", activate)
        for window in ("window", "startup_window"):
            self.assertIn(f"umi_gtk4_ws_window_fit(state->{window},", activate)
        self.assertIn("g_idle_add(product_complete_startup,state)", activate)
        self.assertIn("product_cancel_startup(state->startup_window,state)", activate)

    def test_preview_controller_is_explicitly_offline_and_rejects_commands(self):
        runner = source(PRODUCT_RUNNER)
        body = compact(function_body(runner, "preview_controller"))
        self.assertIn("update->state=UMI_APPLICATION_PRESENTATION_STATE_OFFLINE", body)
        self.assertIn("update->state=UMI_APPLICATION_PRESENTATION_STATE_DORMANT", body)
        self.assertIn("UMI_APPLICATION_PRESENTATION_EVENT_UNMOUNT", body)
        self.assertIn("UMI_APPLICATION_PRESENTATION_EVENT_DEACTIVATE", body)
        self.assertIn("UMI_APPLICATION_PRESENTATION_EVENT_COMMAND?"
                      "UMI_STATUS_UNAVAILABLE:UMI_STATUS_OK", body)
        self.assertNotIn("UMI_APPLICATION_PRESENTATION_STATE_READY", body)
        run = compact(function_body(runner, "umi_application_product_gtk4_run"))
        self.assertIn("if(state.config.register_controllers==NULL){"
                      "state.config.register_controllers=register_preview_controllers;", run)
        self.assertLess(run.index("state.config.application_id=experience->application_id"),
                        run.index("g_strconcat(state.config.application_id,\".gtk\",NULL)"))

    def test_shared_host_build_wiring_preserves_dedicated_frontends(self):
        cmake = source("cmake/UmicomSharedNativeApplications.cmake")
        text = compact(cmake)
        root = compact(source("CMakeLists.txt"))
        self.assertIn("umicom_add_shared_native_applications()", root)
        self.assertIn("UMICOM_SUITE_APPLICATION_DIRECTORIES", cmake)
        # Known manifest edits must regenerate both GUI and headless graphs.
        dependency = 'set_property(DIRECTORYAPPENDPROPERTYCMAKE_CONFIGURE_DEPENDS"${manifest}")'
        self.assertIn(dependency, text)
        self.assertLess(text.index(dependency),
                        text.index('file(STRINGS"${manifest}"'))
        self.assertIn("if(NOTUMICOM_APPLICATIONS_BUILD_SHARED_GTK4)return()endif()", text)
        skip = re.search(r'MATCHES\s+"\^\(([^)]+)\)\$"', cmake)
        self.assertIsNotNone(skip)
        self.assertEqual(set(skip[1].split("|")), DEDICATED_APPS)
        for expected in (
            "framework/examples/product_workstation_main.c",
            'UMICOM_PRODUCT_APPLICATION_ID="${_umicom_id}"',
            'UMICOM_PRODUCT_TITLE="${_umicom_title}"',
            '"${_umicom_module_target}"Umicom::ui_gtk4',
            "umicom_apply_application_branding(",
            "DESKTOP_ENTRYWINDOWS_GUI",
            'add_dependencies(umicom-desktop-products"${_umicom_native_target}")',
            'install(TARGETS"${_umicom_native_target}"',
            "UMICOM_APPLICATION_INSTALL_COMPONENT",
        ):
            self.assertIn(expected, text)
        # Native targets come from explicit per-product declarations, never
        # guessed console suffixes or an application-specific naming branch.
        self.assertIn('umicom_native_manifest_field("${_umicom_manifest}"native_executable'
                      '_umicom_native_targetOPTIONAL)', text)
        self.assertNotIn('string(REGEXREPLACE"-console$"', text)
        self.assertNotIn('set(_umicom_native_target"umicom-os-control-centre-gtk")', text)

    def test_all_24_products_have_catalogued_experiences_and_standard_recipes(self):
        catalogue = source("framework/src/application/experience_catalogue.c")
        getters = re.search(r"GETTERS\[\]\s*=\s*\{(.*?)\};", catalogue, re.S)
        self.assertIsNotNone(getters)
        aliases = dict(re.findall(r'\{\s*"(org\.umicom\.[^"]+)"\s*,\s*'
                                  r'"(org\.umicom\.[^"]+)"\s*\}', catalogue))
        experiences = {}
        for getter in re.findall(r"umi_application_experience_(\w+)", getters[1]):
            text = source(f"framework/src/application/experiences/{getter}.c")
            definition = re.search(r"UmiApplicationExperienceDefinition\s+DEFINITION"
                                   r"\s*=\s*\{(.*?)\};", text, re.S)
            self.assertIsNotNone(definition, getter)
            identity, title, default_layout = re.findall(r'"([^"\n]*)"', definition[1])[:3]
            layouts = re.findall(r'\{\s*sizeof\(UmiExperienceLayoutDefinition\),\s*"([^"]+)"', text)
            self.assertIn(default_layout, layouts, identity)
            self.assertTrue(title)
            self.assertNotIn(identity, experiences)
            self.assertIn("sizeof(UmiExperiencePanelDefinition)", text)
            experiences[identity] = (getter, layouts)
        recipes_root = "framework/src/application/component/recipes/"
        includes = source(recipes_root + "recipes.inc")
        records = source(recipes_root + "recipe_records.inc")
        manifests = sorted((SOURCE_ROOT / "applications").glob("*/application.umicom.yaml"))
        self.assertEqual(len(manifests), 24, "Update the explicit portfolio guard when adding products")
        shared_count = 0
        root_modules = source("CMakeLists.txt") + source("cmake/UmicomExtendedApplicationModules.cmake")
        for manifest in manifests:
            with self.subTest(product=manifest.parent.name):
                text = manifest.read_text(encoding="utf-8-sig")
                identity = re.search(r"^  id:\s*(\S+)", text, re.M)[1]
                canonical = aliases.get(identity, identity)
                self.assertIn(canonical, experiences)
                recipe_path = canonical[len("org.umicom."):] + "/standard.inc"
                self.assertIn(f'#include "{recipe_path}"', includes)
                recipe = source(recipes_root + recipe_path)
                symbol = re.search(r"UmiApplicationComponentRecipe\s+(\w+)\s*=", recipe)
                self.assertIsNotNone(symbol)
                self.assertRegex(records, r"&" + re.escape(symbol[1]) + r"\b")
                self.assertIn(f'"{canonical}"', recipe)
                self.assertIn("UMI_APPLICATION_COMPONENT_RECIPE_AUDIENCE_STANDARD", recipe)
                if manifest.parent.name not in DEDICATED_APPS:
                    shared_count += 1
                    self.assertEqual(identity, canonical, "Shared branding and GTK IDs must agree")
                    self.assertIn(f'"applications/{manifest.parent.name}"', root_modules)
                    module = source(f"applications/{manifest.parent.name}/CMakeLists.txt")
                    self.assertRegex(module, r"add_library\(\s*umicom_\w+_module\b")
                    self.assertRegex(text, r"(?m)^  name:\s*\S")
                    self.assertRegex(text, r"(?m)^  executable:\s*\S")
        self.assertEqual(shared_count, 18)

    def test_branding_refresh_and_embedded_dependencies_are_wired(self):
        text = compact(source("framework/cmake/UmicomApplicationBranding.cmake"))
        for expected in (
            'add_custom_target("${UMICOM_BRAND_TARGET}-branding"',
            'add_dependencies("${UMICOM_BRAND_TARGET}""${UMICOM_BRAND_TARGET}-branding")',
            "DEPENDS${_umicom_runtime_brand_files}",
            'APPENDPROPERTYOBJECT_DEPENDS"${_umicom_brand_root}/brand/umicom.ico"',
            '"${_umicom_brand_root}/brand/umicom-icon-on-dark.svg"',
            "-Ecopy_if_different",
            "UMICOM_RUNTIME_BRANDING_LAST_TARGET",
            'add_dependencies("${UMICOM_BRAND_TARGET}-branding"'
            '"${_umicom_previous_branding_target}")',
        ):
            self.assertIn(expected, text)

    def test_headless_presets_explicitly_disable_all_gui_switches(self):
        presets = json.loads((SOURCE_ROOT / "CMakePresets.json").read_text(encoding="utf-8-sig"))
        self.assertFalse(presets.get("include"),
                         "Extend the audit to load included presets before using preset includes")
        headless = [preset for preset in presets["configurePresets"] if "headless" in preset["name"]]
        self.assertTrue(headless)
        switches = ("UMICOM_DESKTOP_BUILD_GTK", "UMICOM_STUDIO_BUILD_GTK",
                    "UMICOM_TRADER_BUILD_GTK4", "UMICOM_BANK_BUILD_GTK4",
                    "UMICOM_TMS_BUILD_GTK4", "UMICOM_MUSIC_STUDIO_BUILD_GTK4",
                    "UMICOM_APPLICATIONS_BUILD_SHARED_GTK4")
        for preset in headless:
            for switch in switches:
                with self.subTest(preset=preset["name"], switch=switch):
                    values = resolve_cache_variables(presets["configurePresets"], preset["name"])
                    self.assertEqual(values.get(switch), "OFF")


class PresetInheritanceRegression(unittest.TestCase):
    """Exercise the audit's merge logic without configuring a product build."""

    def test_nested_inheritance_and_child_override(self):
        presets = [
            {"name": "base", "cacheVariables": {"GUI": "OFF", "CC": "clang"}},
            {"name": "middle", "inherits": "base"},
            {"name": "leaf", "inherits": "middle", "cacheVariables": {"CC": "gcc"}},
        ]
        self.assertEqual(resolve_cache_variables(presets, "leaf"), {"GUI": "OFF", "CC": "gcc"})
        self.assertEqual(presets[0]["cacheVariables"]["CC"], "clang")

    def test_first_parent_precedes_later_parent(self):
        presets = [
            {"name": "first", "cacheVariables": {"GUI": "OFF"}},
            {"name": "second", "cacheVariables": {"GUI": "ON", "EXTRA": "ON"}},
            {"name": "leaf", "inherits": ["first", "second"]},
        ]
        self.assertEqual(resolve_cache_variables(presets, "leaf"), {"GUI": "OFF", "EXTRA": "ON"})

    def test_null_does_not_resurrect_later_parent(self):
        presets = [
            {"name": "first", "cacheVariables": {"GUI": None}},
            {"name": "second", "cacheVariables": {"GUI": "OFF"}},
            {"name": "leaf", "inherits": ["first", "second"]},
        ]
        self.assertIsNone(resolve_cache_variables(presets, "leaf")["GUI"])

    def test_typed_and_boolean_cache_values(self):
        presets = [{"name": "base", "cacheVariables": {
            "GUI": {"type": "BOOL", "value": "OFF"}, "OTHER": False, "TEST": True}}]
        self.assertEqual(resolve_cache_variables(presets, "base"),
                         {"GUI": "OFF", "OTHER": "OFF", "TEST": "ON"})

    def test_cycles_and_missing_parents_are_rejected(self):
        for presets in (
            [{"name": "a", "inherits": "b"}, {"name": "b", "inherits": "a"}],
            [{"name": "a", "inherits": "missing"}],
        ):
            with self.subTest(presets=presets), self.assertRaises(AssertionError):
                resolve_cache_variables(presets, "a")

    def test_duplicate_names_and_malformed_fields_are_rejected(self):
        for presets in (
            [{"name": "a"}, {"name": "a"}],
            [{"name": "a", "inherits": 1}],
            [{"name": "a", "cacheVariables": []}],
            [{"name": "a", "cacheVariables": {"GUI": {"type": "BOOL"}}}],
        ):
            with self.subTest(presets=presets), self.assertRaises(AssertionError):
                resolve_cache_variables(presets, "a")

    def test_child_can_reenable_gui_and_audit_must_notice(self):
        presets = [{"name": "base", "cacheVariables": {"GUI": "OFF"}},
                   {"name": "leaf", "inherits": "base", "cacheVariables": {"GUI": "ON"}}]
        self.assertNotEqual(resolve_cache_variables(presets, "leaf")["GUI"], "OFF")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-dir", type=Path, default=SOURCE_ROOT)
    arguments, unittest_arguments = parser.parse_known_args()
    SOURCE_ROOT = arguments.source_dir.resolve()
    print("Source-wiring checks only: no GTK execution, rendering or compilation.",
          file=sys.stderr)
    unittest.main(argv=[sys.argv[0], *unittest_arguments], verbosity=2)
