/*-----------------------------------------------------------------------------
 * Umicom Applications
 * File: applications/model-router/src/desktop.c
 *
 * PURPOSE:
 *   Provide an optional terminal-launchable native Framework desktop host.
 *
 * EDUCATIONAL OVERVIEW:
 *   The existing GTK workspace is the desktop foundation. Web-specific media
 *   controls are not copied here; feature parity requires further shared adapters.
 *
 * AUTHOR AND ORGANISATION:
 *   Sammy Hegab
 *   Umicom Foundation
 *
 * LICENCE:
 *   MIT
 *---------------------------------------------------------------------------*/

#include "umicom/ui/gtk4/ai_workspace.h"

/* Reuse the Framework GTK workspace instead of duplicating its widgets and jobs. */
int main(int argc, char **argv)
{
    return UmiAiWorkspaceGtkRun("foundation.umicom.modelrouter", "Umicom AI Workspace", argc, argv);
}
