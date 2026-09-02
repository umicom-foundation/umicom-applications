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

# Provide the show help operation used by this module and its client applications.
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

# Provide the need root command operation used by this module and its client applications.
need_root_command() {
    # Apply this branch only when its contract condition is satisfied.
    if command -v sudo >/dev/null 2>&1; then
        printf '%s\n' "sudo"
    # Apply this branch only when its contract condition is satisfied.
    elif [ "$(id -u)" -eq 0 ]; then
        printf '%s\n' ""
    # Use this fallback path when the earlier condition does not apply.
    else
        echo "Administrator access is required to install packages." >&2
        exit 1
    fi
}

# Provide the install tools operation used by this module and its client applications.
install_tools() {
    local elevate
    elevate="$(need_root_command)"

    # Apply this branch only when its contract condition is satisfied.
    if command -v apt-get >/dev/null 2>&1; then
        $elevate apt-get update
        $elevate apt-get install -y \
            build-essential clang cmake ninja-build pkg-config git gh gdb \
            libgtk-4-dev libgtksourceview-5-dev libjson-glib-dev \
            libsoup-3.0-dev libcurl4-openssl-dev libsqlite3-dev
    # Apply this branch only when its contract condition is satisfied.
    elif command -v dnf >/dev/null 2>&1; then
        $elevate dnf install -y \
            gcc gcc-c++ clang cmake ninja-build pkgconf-pkg-config git gh gdb \
            gtk4-devel gtksourceview5-devel json-glib-devel libsoup3-devel \
            libcurl-devel sqlite-devel
    # Apply this branch only when its contract condition is satisfied.
    elif command -v pacman >/dev/null 2>&1; then
        $elevate pacman -Syu --needed --noconfirm \
            base-devel clang cmake ninja pkgconf git github-cli gdb gtk4 \
            gtksourceview5 json-glib libsoup3 curl sqlite
    # Use this fallback path when the earlier condition does not apply.
    else
        echo "This script supports apt, dnf and pacman package managers." >&2
        echo "Install Git, Clang, CMake, Ninja, pkg-config, SQLite and GTK4 manually, then run doctor." >&2
        exit 1
    fi

    echo "Tool installation completed. Open a new terminal, then run doctor."
}

# Provide the doctor operation used by this module and its client applications.
doctor() {
    local failed=0
    local command_name
    local library

    # Visit each bounded item once so every record receives the same rule.
    for command_name in git clang cmake ninja pkg-config; do
        # Apply this branch only when its contract condition is satisfied.
        if command -v "$command_name" >/dev/null 2>&1; then
            echo "[OK] $command_name"
        # Use this fallback path when the earlier condition does not apply.
        else
            echo "[MISSING] $command_name" >&2
            failed=1
        fi
    done

    # Preserve the original failure result so the caller can respond to the correct cause.
    if [ "$failed" -eq 0 ]; then
        git --version
        clang --version | sed -n '1p'
        cmake --version | sed -n '1p'
        ninja --version

        # Visit each bounded item once so every record receives the same rule.
        for library in gtk4 gtksourceview-5 json-glib-1.0 libsoup-3.0 libcurl sqlite3; do
            # Apply this branch only when its contract condition is satisfied.
            if pkg-config --exists "$library"; then
                echo "[OK] library $library $(pkg-config --modversion "$library")"
            # Use this fallback path when the earlier condition does not apply.
            else
                echo "[MISSING] library $library" >&2
                failed=1
            fi
        done
    fi

    # Apply this branch only when its contract condition is satisfied.
    if [ -f "$PROJECT_ROOT/CMakePresets.json" ]; then
        echo "[OK] Umicom project $PROJECT_ROOT"
    # Use this fallback path when the earlier condition does not apply.
    else
        echo "[INFO] The Umicom project has not been cloned at $PROJECT_ROOT yet."
    fi

    # Preserve the original failure result so the caller can respond to the correct cause.
    if [ "$failed" -ne 0 ]; then
        echo "This computer is not ready. Run install, open a new terminal, and run doctor again." >&2
        exit 1
    fi
    echo "Your computer passed the Umicom checks."
}

# Provide the assert project exists operation used by this module and its client
# applications.
assert_project_exists() {
    # Apply this branch only when its contract condition is satisfied.
    if [ ! -f "$PROJECT_ROOT/CMakePresets.json" ]; then
        echo "Umicom Applications was not found at $PROJECT_ROOT. Run clone first." >&2
        exit 1
    fi
}

# Provide the clone project operation used by this module and its client applications.
clone_project() {
    # Apply this branch only when its contract condition is satisfied.
    if [ -e "$DESTINATION" ]; then
        echo "The destination already exists: $DESTINATION" >&2
        exit 1
    fi
    mkdir -p "$(dirname "$DESTINATION")"
    git clone --recurse-submodules "$REPOSITORY_URL" "$DESTINATION"
    echo "Umicom Applications was cloned to $DESTINATION"
}

# Provide the configure project operation used by this module and its client applications.
configure_project() {
    assert_project_exists
    (cd "$PROJECT_ROOT" && cmake --preset "$PRESET")
}

# Provide the build project operation used by this module and its client applications.
build_project() {
    assert_project_exists
    (cd "$PROJECT_ROOT" && cmake --build --preset "$PRESET" --parallel "$JOBS")
}

# Provide the test project operation used by this module and its client applications.
test_project() {
    assert_project_exists
    (cd "$PROJECT_ROOT" && ctest --preset "$PRESET")
}

# Provide the repository status operation used by this module and its client applications.
repository_status() {
    git -C "$PROJECT_ROOT" status --short
    (cd "$PROJECT_ROOT" && \
        git submodule foreach --recursive \
            'echo ===== $displaypath =====; git status --short')
}

# Apply this branch only when its contract condition is satisfied.
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
        # Apply this branch only when its contract condition is satisfied.
        if [ -x "$PROJECT_ROOT/build/$PRESET/bin/umicom-studio-console" ]; then
            "$PROJECT_ROOT/build/$PRESET/bin/umicom-studio-console"
        # Use this fallback path when the earlier condition does not apply.
        else
            echo "Studio Console is not available. Run build first and check that the selected preset includes it." >&2
            exit 1
        fi
        ;;
    status) repository_status ;;
    add) git -C "$PROJECT_ROOT" add -A ;;
    commit)
        # Apply this branch only when its contract condition is satisfied.
        if [ -z "$VALUE" ]; then
            echo 'Usage: ./scripts/umicom-bootstrap.sh commit "a meaningful description"' >&2
            exit 1
        fi
        git -C "$PROJECT_ROOT" commit -m "$VALUE"
        ;;
    push) git -C "$PROJECT_ROOT" push ;;
    new-branch)
        # Apply this branch only when its contract condition is satisfied.
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
