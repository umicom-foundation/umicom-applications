<!-- --------------------------------------------------------------------------
Umicom Applications
File: docs/learning/UMICOM_FOUNDATIONS_CURRICULUM.md

PURPOSE:
Describe the interactive beginner lesson series shared by Umicom Framework and
the Umicom Studio Learning Centre.

AUTHOR AND ORGANISATION:
Sammy Hegab
Umicom Foundation

LICENCE:
MIT
---------------------------------------------------------------------------- -->

# Umicom Foundations Curriculum

This course starts before programming. Each lesson explains one small idea,
shows an example, gives the learner a safe exercise and records evidence before
the next lesson unlocks.

The reusable catalogue lives in Umicom Framework. Studio displays it, but does
not own a second copy. A future web classroom, console teacher or school edition
can use exactly the same lesson identifiers and progression data.

## How an interactive lesson should feel

Every lesson screen should contain:

- **What you will learn**, using ordinary language;
- **Why it matters**, connected to a real Umicom task;
- **Show me**, with a small runnable example;
- **Let me try**, in a disposable practice workspace;
- **Give me a hint**, without revealing the complete answer immediately;
- **Check my work**, using compiler, test or knowledge evidence;
- **Explain my mistake**, translating diagnostics into friendly language;
- **What comes next**, shown only after the current objective is understood.

The AI Teacher may explain or offer hints, but deterministic tests and mastery
rules decide whether a coding exercise passes.

## Stage 1: Orientation

1. **Welcome to building software** — programs, source code, compilers,
   repositories and applications.
2. **Folders, files and safe paths** — create a practice area and recognise an
   absolute path.

## Stage 2: Development tools

3. **Your first terminal commands** — change folder, list files and return.
4. **Check the development tools** — run the bootstrap doctor and understand
   Git, CMake, Ninja, GCC or Clang, pkg-config and libraries.

## Stage 3: C programming

5. **A tiny C program** — `main`, headers, output and success codes.
6. **Names, values and decisions** — meaningful variables, types, `if` and
   loops.
7. **Functions and clear contracts** — inputs, outputs and focused behavior.
8. **Pointers, arrays and memory safety** — addresses, `NULL`, bounds,
   ownership and cleanup.
9. **Headers, source files and tests** — public contracts, private
   implementation and warning-free checks.

## Stage 4: Umicom Framework

10. **Git without mystery** — working tree, staging, commits, branches, remotes
    and pushes.
11. **Clone Umicom and its submodules** — parent repository, independent module
    history and pinned revisions.
12. **How Umicom Framework fits together** — public header, implementation,
    focused test, adapter and thin application composition.
13. **Build applications like Lego** — shared components, panels, commands,
    layouts, contracts and services.

## Stage 5: Contribution

14. **Make one quality Framework change** — additive contract,
    implementation, comments, tests and beginner documentation.
15. **Prepare a contribution branch** — inspect a diff, check it, commit one
    idea and push the branch.
16. **Open and improve a pull request** — fork, explain evidence, request review
    and respond to feedback.

## Suggested exercise safety

- Exercises run in a generated practice workspace, never in the learner's main
  checkout.
- File operations remain inside that workspace.
- Destructive source-control commands are not part of beginner exercises.
- AI-generated changes remain previews until the learner approves them.
- API keys and tokens are represented by opaque secret references.
- Compiler and test output is retained as evidence and translated, not hidden.

## Completion evidence

A learner completes the course after they can:

1. prepare a computer using the bootstrap doctor;
2. clone the project and initialise submodules;
3. explain a small C module and its test;
4. find the Framework contract behind an application panel;
5. implement an additive, reusable change;
6. build and test it without a new warning;
7. review the staged diff for secrets and accidental files;
8. submit a clear pull request from a contribution branch.

The course is intentionally small enough to finish. Advanced C, application
architecture, security, data, AI, trading and treasury subjects should be
separate follow-on tracks that reuse the same teacher contracts.
