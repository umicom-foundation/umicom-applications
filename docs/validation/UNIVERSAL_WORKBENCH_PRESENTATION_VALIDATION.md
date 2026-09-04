# Umicom Universal Workbench Presentation Validation

## Scope

This record describes what was verified while rebuilding the delivery archive.
It does not claim that a Windows UCRT64 compiler was available in this artifact
environment.

## Archive validation

- the archive contains complete files rather than patch fragments;
- the archive root is `umicom-applications/`;
- the obsolete empty archive is not embedded;
- the old numbered UX document is excluded;
- every manifest entry records size and SHA-256;
- ZIP integrity testing passes;
- all text files use UTF-8-compatible bytes and end with a newline;
- no merge-conflict markers are present.

## Source consistency checks

The rebuilt overlay uses the newer workstation contract-alignment files where
they supersede the earlier presentation files. Static checks confirm that the
known obsolete identifiers reported by the failed build are absent from the
delivered workstation sources:

- `UMI_WS_ID_CAPACITY`;
- `umi_gtk4_automation_set_id`;
- `UmiGtk4WorkspaceLayoutPanelActionHandler`;
- `UmiGtk4PanelFrameActionHandler`;
- `UMI_UI_WORKSPACE_MAX_WINDOWS`;
- the missing GTK table-surface include.

## Required local validation

After overlaying the files, configure and build with the Windows UCRT64 preset
and run the complete registered test estate. The local compiler output remains
the authoritative confirmation for the user's repository state, dependency
versions and submodule revisions.
