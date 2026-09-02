# Automated user-interface testing

Umicom Automated Tests, shortened to UAT, checks an application in the same
order that a person uses it. A scenario can open a menu, click a button, type
into a field, choose an item, wait for a result and compare displayed text with
an expected value.

The automation contracts live in Umicom Framework. Studio and every other
Umicom application can therefore share the same scenario runner, GTK4 driver,
reports and safety rules.

## Why controls have stable IDs

A test must not search for a button by its screen position. The position moves
when a panel is docked, floated, resized or moved to another monitor. A visible
caption can also change when wording or language changes.

Each testable control receives a stable ID such as:

```text
umicom.command.search
umicom.appearance.menu
studio.local.layout-browser
```

The ID describes the purpose of the control. It stays the same when the layout,
theme, font or caption changes.

## What a scenario contains

Each step has five parts:

1. `step_id` identifies the step in a report.
2. `target_id` identifies the control.
3. `operation` says what the user does.
4. `value` carries text, a selection index or an expected value when needed.
5. `timeout_ms` prevents a wait from continuing forever.

Scenario and report storage is allocated on the heap. This is important because
a complete run can contain many steps and observations, and placing that much
data on a small thread stack can terminate a program.

## Small C example

```c
UmiUiAutomationScenario *scenario = NULL;
UmiUiAutomationReport *report = NULL;
UmiUiAutomationStep step = {0};

umi_ui_automation_scenario_create(
    "studio.search.journey",
    "Search for a command",
    &scenario);

snprintf(step.step_id, sizeof(step.step_id), "%s", "enter-search");
snprintf(step.target_id, sizeof(step.target_id), "%s", "umicom.command.search");
step.operation = UMI_UI_AUTOMATION_TYPE_TEXT;
snprintf(step.value, sizeof(step.value), "%s", "build");
umi_ui_automation_scenario_add(scenario, &step);

umi_ui_automation_run(&driver, scenario, &report);

/* The caller reads pass and failure counts before releasing owned storage. */
printf("passed=%zu failed=%zu\n",
       umi_ui_automation_report_passed(report),
       umi_ui_automation_report_failed(report));

umi_ui_automation_report_destroy(report);
umi_ui_automation_scenario_destroy(scenario);
```

The `driver` in this example is supplied by the application adapter. GTK4
applications create it from their root window or container with
`umi_gtk4_automation_driver_create`.

## Supported GTK4 actions

The first GTK4 driver supports:

- focus a control;
- activate a button or command control;
- type into an editable field;
- select a drop-down row by index;
- set or reverse a toggle;
- open a menu button;
- wait for a control to become visible or enabled;
- compare visible text;
- capture control role, text and state as evidence.

The driver works inside the Umicom application process. It does not use a
global mouse or keyboard hook, so an automated test cannot accidentally click
or type into another desktop application.

## Studio wiring gate

Studio also has a headless wiring audit. It checks that:

- every visible action names a command that exists in the Framework registry;
- every non-separator menu row names an action that exists;
- every non-separator toolbar item names an action that exists.

Disabled controls are counted separately. A disabled command may be correct
when no project, document or debug session is active. Missing references are
always reported as failures.

The automated test is named `studio.automation.wiring`. The reusable Framework
scenario-runner test is named `framework.ui.automation`.

## Adding a new testable control

Framework-rendered actions are tagged automatically. A product-specific GTK4
control uses this call after it is created:

```c
umi_gtk4_automation_tag_widget(widget, "product.area.control-purpose");
```

Choose an ID that describes purpose, keep it below the Framework ID capacity,
and do not include a caption, colour, position or version number. The control
can then be moved to another panel or restyled without changing its tests.
