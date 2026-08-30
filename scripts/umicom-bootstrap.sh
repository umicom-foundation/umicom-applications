#!/usr/bin/env bash
#-----------------------------------------------------------------------------
# Umicom Applications
# File: scripts/umicom-bootstrap.sh
#
# PURPOSE:
#   Give a new Linux developer a readable fallback before the native Umicom
#   command has been compiled. The script installs or checks common tools,
#   clones the project, configures, builds, tests and performs simple Git steps.
#
# AUTHOR AND ORGANISATION:
# Sammy Hegab
# Umicom Foundation
#
# LICENCE:
# MIT
#-----------------------------------------------------------------------------

set -euo pipefail

ACTION="${1:-help}"
PROJECT_ROOT="${UMICOM_PROJECT_ROOT:-$HOME/umicom/umicom-applications}"
DESTINATION="${UMICOM_DESTINATION:-$HOME/umicom/umicom-applications}"
REPOSITORY_URL="${UMICOM_REPOSITORY_URL:-https://github.com/umicom-foundation/umicom-applications.git}"
PRESET="${UMICOM_PRESET:-headless-debug}"
JOBS="${UMICOM_JOBS:-2}"
VALUE="${2:-}"

show_help() {
    cat <<'EOF'
Umicom beginner bootstrap for Linux

Use one action at a time:
  help                 Show this page.
  install              Install the common development tools.
  doctor               Check that the computer is ready.
  clone                Download Umicom Applications and every submodule.
  configure            Prepare the CMake build directory.
  build                Compile the project.
  test                 Run the complete test suite.
  all                  Run doctor, configure, build and test in that order.
  run-studio           Run Studio Console when it is available.
  status               Show changes in the parent project and submodules.
  add                  Stage every change in one repository.
  commit "message"     Commit staged changes.
  push                 Push the current branch.
  new-branch "name"    Create a contribution branch.

Defaults:
  Project:  $HOME/umicom/umicom-applications
  Preset:   headless-debug

Override a default only when needed:
  UMICOM_PROJECT_ROOT=/work/umicom-applications ./scripts/umicom-bootstrap.sh doctor
  UMICOM_PRESET=headless-debug ./scripts/umicom-bootstrap.sh all
EOF
}

need_root_command() {
    if command -v sudo >/dev/null 2>&1; then
        printf '%s\n' "sudo"
    elif [ "$(id -u)" -eq 0 ]; then
        printf '%s\n' ""
    else
        echo "Administrator access is required to install packages." >&2
        exit 1
    fi
}

install_tools() {
    local elevate
    elevate="$(need_root_command)"

    if command -v apt-get >/dev/null 2>&1; then
        $elevate apt-get update
        $elevate apt-get install -y \
            build-essential clang cmake ninja-build pkg-config git gh gdb \
            libgtk-4-dev libgtksourceview-5-dev libjson-glib-dev \
            libsoup-3.0-dev libcurl4-openssl-dev libsqlite3-dev
    elif command -v dnf >/dev/null 2>&1; then
        $elevate dnf install -y \
            gcc gcc-c++ clang cmake ninja-build pkgconf-pkg-config git gh gdb \
            gtk4-devel gtksourceview5-devel json-glib-devel libsoup3-devel \
            libcurl-devel sqlite-devel
    elif command -v pacman >/dev/null 2>&1; then
        $elevate pacman -Syu --needed --noconfirm \
            base-devel clang cmake ninja pkgconf git github-cli gdb gtk4 \
            gtksourceview5 json-glib libsoup3 curl sqlite
    else
        echo "This script supports apt, dnf and pacman package managers." >&2
        echo "Install Git, Clang, CMake, Ninja, pkg-config, SQLite and GTK4 manually, then run doctor." >&2
        exit 1
    fi

    echo "Tool installation completed. Open a new terminal, then run doctor."
}

doctor() {
    local failed=0
    local command_name
    local library

    for command_name in git clang cmake ninja pkg-config; do
        if command -v "$command_name" >/dev/null 2>&1; then
            echo "[OK] $command_name"
        else
            echo "[MISSING] $command_name" >&2
            failed=1
        fi
    done

    if [ "$failed" -eq 0 ]; then
        git --version
        clang --version | sed -n '1p'
        cmake --version | sed -n '1p'
        ninja --version

        for library in gtk4 gtksourceview-5 json-glib-1.0 libsoup-3.0 libcurl sqlite3; do
            if pkg-config --exists "$library"; then
                echo "[OK] library $library $(pkg-config --modversion "$library")"
            else
                echo "[MISSING] library $library" >&2
                failed=1
            fi
        done
    fi

    if [ -f "$PROJECT_ROOT/CMakePresets.json" ]; then
        echo "[OK] Umicom project $PROJECT_ROOT"
    else
        echo "[INFO] The Umicom project has not been cloned at $PROJECT_ROOT yet."
    fi

    if [ "$failed" -ne 0 ]; then
        echo "This computer is not ready. Run install, open a new terminal, and run doctor again." >&2
        exit 1
    fi
    echo "Your computer passed the Umicom checks."
}

assert_project_exists() {
    if [ ! -f "$PROJECT_ROOT/CMakePresets.json" ]; then
        echo "Umicom Applications was not found at $PROJECT_ROOT. Run clone first." >&2
        exit 1
    fi
}

clone_project() {
    if [ -e "$DESTINATION" ]; then
        echo "The destination already exists: $DESTINATION" >&2
        exit 1
    fi
    mkdir -p "$(dirname "$DESTINATION")"
    git clone --recurse-submodules "$REPOSITORY_URL" "$DESTINATION"
    echo "Umicom Applications was cloned to $DESTINATION"
}

configure_project() {
    assert_project_exists
    (cd "$PROJECT_ROOT" && cmake --preset "$PRESET")
}

build_project() {
    assert_project_exists
    (cd "$PROJECT_ROOT" && cmake --build --preset "$PRESET" --parallel "$JOBS")
}

test_project() {
    assert_project_exists
    (cd "$PROJECT_ROOT" && ctest --preset "$PRESET")
}

repository_status() {
    git -C "$PROJECT_ROOT" status --short
    (cd "$PROJECT_ROOT" && \
        git submodule foreach --recursive \
            'echo ===== $displaypath =====; git status --short')
}

case "$ACTION" in
    help) show_help ;;
    install) install_tools ;;
    doctor) doctor ;;
    clone) clone_project ;;
    configure) configure_project ;;
    build) build_project ;;
    test) test_project ;;
    all)
        doctor
        configure_project
        build_project
        test_project
        ;;
    run-studio)
        assert_project_exists
        if [ -x "$PROJECT_ROOT/build/$PRESET/bin/umicom-studio-console" ]; then
            "$PROJECT_ROOT/build/$PRESET/bin/umicom-studio-console"
        else
            echo "Studio Console is not available. Run build first and check that the selected preset includes it." >&2
            exit 1
        fi
        ;;
    status) repository_status ;;
    add) git -C "$PROJECT_ROOT" add -A ;;
    commit)
        if [ -z "$VALUE" ]; then
            echo 'Usage: ./scripts/umicom-bootstrap.sh commit "a meaningful description"' >&2
            exit 1
        fi
        git -C "$PROJECT_ROOT" commit -m "$VALUE"
        ;;
    push) git -C "$PROJECT_ROOT" push ;;
    new-branch)
        if [ -z "$VALUE" ]; then
            echo 'Usage: ./scripts/umicom-bootstrap.sh new-branch "feature/short-name"' >&2
            exit 1
        fi
        git -C "$PROJECT_ROOT" switch -c "$VALUE"
        ;;
    *)
        echo "Unknown action: $ACTION" >&2
        show_help
        exit 2
        ;;
esac
