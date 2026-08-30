<!-- --------------------------------------------------------------------------
Umicom Applications
File: docs/getting-started/ABSOLUTE_BEGINNER_GUIDE.md

PURPOSE:
Help a complete beginner prepare a computer, clone Umicom, build it, learn the
important words and make a first contribution without assuming prior knowledge.

AUTHOR AND ORGANISATION:
Sammy Hegab
Umicom Foundation

LICENCE:
MIT
---------------------------------------------------------------------------- -->

# Start Here: Umicom for Complete Beginners

Welcome. You do not need to know C, Git, CMake or Umicom before reading this
guide. Work through one small step at a time. It is normal to stop, reread a
step and ask for help.

## Five words to learn first

- A **program** is a list of instructions a computer can run.
- **Source code** is the human-readable text used to make a program.
- A **compiler** changes C source code into a program the computer can run.
- A **repository** is a project folder whose changes are recorded by Git.
- A **submodule** is another Git repository pinned inside a parent repository.

Umicom Applications is the parent repository. Umicom Framework and each Umicom
application are submodules with their own history.

## Choose your computer

- Follow the Windows section if you use Windows 10 or Windows 11.
- Follow the Linux section if you use Ubuntu, Fedora, Arch or a related Linux
  distribution.
- Never paste an administrator command you do not understand. Read it first.

## Windows: prepare a new computer

The beginner script works before `umicom.exe` exists. Download
[`umicom-bootstrap.ps1`](../../scripts/umicom-bootstrap.ps1) from the repository
and save it as `C:\umicom\umicom-bootstrap.ps1`.

Open PowerShell and install the development tools:

```powershell
Set-Location "C:\umicom"

powershell -ExecutionPolicy Bypass -File ".\umicom-bootstrap.ps1" install
```

Restart PowerShell after the installer completes. Then check the computer:

```powershell
Set-Location "C:\umicom"

powershell -ExecutionPolicy Bypass -File ".\umicom-bootstrap.ps1" doctor
```

Every required item should show `[OK]`. A `[MISSING]` line tells you exactly
which tool still needs attention.

Clone the complete project:

```powershell
Set-Location "C:\umicom"

powershell -ExecutionPolicy Bypass -File ".\umicom-bootstrap.ps1" clone
```

The new checkout contains its own copy of the script. Use that copy from now on:

```powershell
Set-Location "C:\umicom\umicom-applications"

powershell -ExecutionPolicy Bypass -File ".\scripts\umicom-bootstrap.ps1" configure

powershell -ExecutionPolicy Bypass -File ".\scripts\umicom-bootstrap.ps1" build

powershell -ExecutionPolicy Bypass -File ".\scripts\umicom-bootstrap.ps1" test
```

Open Studio after a successful build:

```powershell
Set-Location "C:\umicom\umicom-applications"

powershell -ExecutionPolicy Bypass -File ".\scripts\umicom-bootstrap.ps1" run-studio
```

## Linux: prepare a new computer

Download [`umicom-bootstrap.sh`](../../scripts/umicom-bootstrap.sh), inspect it,
then save it in a folder you control. Do not pipe a downloaded script directly
into a shell.

```bash
mkdir -p "$HOME/umicom"
cd "$HOME/umicom"
chmod +x ./umicom-bootstrap.sh
./umicom-bootstrap.sh install
```

Open a new terminal, check the computer, and clone the project:

```bash
cd "$HOME/umicom"
./umicom-bootstrap.sh doctor
./umicom-bootstrap.sh clone
```

Configure, build and test the portable headless development preset:

```bash
cd "$HOME/umicom/umicom-applications"
./scripts/umicom-bootstrap.sh configure
./scripts/umicom-bootstrap.sh build
./scripts/umicom-bootstrap.sh test
```

## Use the native Umicom command after it is built

On Windows, this block checks for the compiled command and adds its directory to
the current PowerShell session. It does not hide the executable behind another
variable:

```powershell
Set-Location "C:\umicom\umicom-applications"

if (Test-Path -LiteralPath "C:\umicom\umicom-applications\build\windows-ucrt64-debug\bin\umicom.exe") {
    $env:Path = "C:\umicom\umicom-applications\build\windows-ucrt64-debug\bin;$env:Path"
    umicom version
} else {
    Write-Host "Umicom CLI has not been compiled yet. Use scripts\umicom-bootstrap.ps1 or Git commands."
}
```

The PATH change above lasts for the current PowerShell window. To add it to your
user PATH, run the following once and then open a new PowerShell window:

```powershell
[Environment]::SetEnvironmentVariable("Path", "C:\umicom\umicom-applications\build\windows-ucrt64-debug\bin;" + [Environment]::GetEnvironmentVariable("Path", "User"), "User")
```

The current CLI accepts familiar repository commands:

```powershell
umicom add -A
umicom status
umicom commit -m "docs: explain one beginner topic"
umicom push
```

If an older compiled `umicom.exe` says `Unknown command`, rebuild it or use the
equivalent Git commands. Source code can be newer than an executable compiled
on an earlier day.

## Understand the build steps

1. **Configure** reads CMake files and prepares Ninja build instructions.
2. **Build** compiles source files and links programs.
3. **Test** runs automated checks that protect existing behavior.
4. **Run** opens a compiled application.

Warnings and errors are different. A warning says something may be unsafe or
unclear. An error stops the build. Read the first complete error message, the
file path and the line number. The Umicom command now retains the final part of
long compiler output and prints the child program's exit code, so the real
diagnostic is no longer replaced by only `Internal error`.

## Learn C before changing Framework contracts

Open the Studio Learning Centre and follow **Learn C and Umicom from the
beginning**. Its lessons cover:

1. files, folders and the terminal;
2. the development toolchain;
3. C values, decisions, functions, pointers and memory;
4. headers, source files and tests;
5. Git, submodules and Umicom architecture;
6. reusable components, layouts and a first pull request.

The full lesson map is in
[`UMICOM_FOUNDATIONS_CURRICULUM.md`](../learning/UMICOM_FOUNDATIONS_CURRICULUM.md).

## Make a contribution through a fork

A fork is your GitHub copy of a repository. A branch is a short-lived line of
work inside that copy. A pull request asks the Umicom maintainers to review and
merge your branch.

1. Sign in to GitHub.
2. Open the Umicom repository you want to change and select **Fork**.
3. Clone your fork, including submodules.
4. Create a branch whose name explains the work.
5. Make one related change and add a focused test.
6. Build and test before committing.
7. Review the diff, commit, and push the branch.
8. On GitHub, select **Compare & pull request**.
9. Explain the purpose, important design choices and test evidence.
10. Respond kindly to review feedback and update the same branch.

GitHub's official guides explain [contributing to open source](https://docs.github.com/en/get-started/exploring-projects-on-github/contributing-to-open-source)
and [creating a pull request from a fork](https://docs.github.com/en/pull-requests/how-tos/create-pull-requests/creating-a-pull-request-from-a-fork).

Create a branch with Git:

```powershell
Set-Location "C:\umicom\umicom-applications\framework"

git switch -c "feature/beginner-learning-improvement"
```

Review and commit the Framework change:

```powershell
Set-Location "C:\umicom\umicom-applications\framework"

git add -A
git status
git diff --cached --check
git commit -m "feat(learning): improve beginner lesson guidance"
git push --set-upstream origin "feature/beginner-learning-improvement"
```

When a submodule commit changes, the parent repository must record its new
pinned revision in a separate parent commit.

## A simple quality checklist

- I understand what my change is meant to do.
- I reused Framework capabilities instead of copying logic into an application.
- New public names explain their purpose.
- New C files have the Umicom header comment.
- New logic has a comment where the reason is not obvious.
- Existing behavior was preserved.
- A focused test covers the new or repaired behavior.
- The build has no new warning.
- No password, API key, token or personal path is staged.
- My commit contains one related idea and has a meaningful message.

You are ready to contribute when you can explain your change in plain language,
not when you have memorised every command.
