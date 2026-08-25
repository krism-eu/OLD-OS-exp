#!/usr/bin/env bash
set -euo pipefail

# myrakuOS post-build integration point.
# The upstream RakuOS base post-build remains authoritative for overlay,
# DNF wrappers, bootc metadata and base manifest generation.

PROTECTED="/usr/share/rakuos/protected-packages.txt"
PACKAGE_DIR="/usr/share/myrakuos/packages"

if [[ ! -f "$PROTECTED" ]]; then
    echo "ERROR: missing RakuOS protected package manifest: $PROTECTED" >&2
    exit 1
fi

if [[ -f "$PACKAGE_DIR/kde-core.txt" ]]; then
    {
        printf '\n# myrakuOS KDE protected packages\n'
        cat "$PACKAGE_DIR/kde-core.txt"
    } >> "$PROTECTED"
fi

# Do not alter RakuOS overlay services or migration logic here.
