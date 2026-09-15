# Learning with Umicom

[Open the shared lessons](../../framework/docs/learning/index.html).

[Build, test, install and publish the workshop](../../framework/docs/learning/workshop-build.html).

The Framework repository owns the lesson catalogue, reading material, exercise sources and native resource checks. Studio projects that catalogue through its existing learning surface. No second application-specific curriculum is maintained here.

The sequence covers files and terminals, C, Git, CMake, Framework composition, GTK events, contributions, bits and Assembly. The first Git exercise changes a comment and records the change in a separate practice repository. All examples use C or Assembly.

Use a practice directory outside the shared checkout. Start with a small console build; build a graphical window after the Framework and GTK toolchain are ready. Read the next expected output before running each command.

The existing Studio documentation preview resolves lesson paths from the current workspace. Open the Applications checkout for those links. Open the HTML index directly in a browser for offline or installed reading. An arbitrary-workspace installed resource resolver remains a separate implementation task.

A changed Framework checkout must be committed and pushed before the parent records its new revision. A published Linux build uses the parent's pinned child commits. The workshop runbook contains the complete Windows-first procedure.
