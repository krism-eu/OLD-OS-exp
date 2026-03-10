#!/usr/bin/env bash
# post-build-overlay.sh
# Runs after the main image build.
# Reads /usr/share/rakuos/packages.list and installs each package into
# the image overlay using `rakuos install`, which is available by this
# point in the build pipeline.
#
# Usage (from your Containerfile / build workflow):
#   RUN /usr/libexec/rakuos/build/post-build-overlay.sh
#
# packages.list format — one package per line, blank lines and # comments ignored:
#   firefox
#   vlc
#   # this is a comment
#   steam

set -euo pipefail

PACKAGES_LIST="/usr/share/rakuos/packages.list"
STATE_FILE="/var/lib/rakuos/overlay.state"
RAKUOS_BIN="/usr/bin/rakuos"

# ── Sanity checks ─────────────────────────────────────────────────────────────

if [[ ! -f "$PACKAGES_LIST" ]]; then
    echo "[rakuos] No packages.list found at $PACKAGES_LIST — skipping overlay bake."
    exit 0
fi

if [[ ! -x "$RAKUOS_BIN" ]]; then
    echo "[rakuos] ERROR: $RAKUOS_BIN not found or not executable."
    echo "[rakuos] rakuos must be installed before running this script."
    exit 1
fi

# ── Parse packages.list ───────────────────────────────────────────────────────

mapfile -t PACKAGES < <(
    grep -v '^\s*#' "$PACKAGES_LIST" \
    | grep -v '^\s*$' \
    | sed 's/\s*#.*//' \
    | tr -d '[:space:]'
)

if [[ ${#PACKAGES[@]} -eq 0 ]]; then
    echo "[rakuos] packages.list is empty — nothing to install."
    exit 0
fi

echo "[rakuos] Installing ${#PACKAGES[@]} packages from $PACKAGES_LIST ..."

# ── Install via rakuos ────────────────────────────────────────────────────────

FAILED=()

for pkg in "${PACKAGES[@]}"; do
    echo "[rakuos] Installing: $pkg"
    if ! "$RAKUOS_BIN" install "$pkg"; then
        echo "[rakuos] WARNING: Failed to install $pkg — continuing."
        FAILED+=("$pkg")
    fi
done

# ── Report failures ───────────────────────────────────────────────────────────

if [[ ${#FAILED[@]} -gt 0 ]]; then
    echo "[rakuos] WARNING: The following packages failed to install:"
    printf '  - %s\n' "${FAILED[@]}"
fi

# ── Record what we baked in ───────────────────────────────────────────────────
# The software center reads this to know which packages came from the
# baked overlay vs user-installed ones.

INSTALLED=()
for pkg in "${PACKAGES[@]}"; do
    if ! printf '%s\n' "${FAILED[@]}" | grep -qx "$pkg"; then
        INSTALLED+=("$pkg")
    fi
done

mkdir -p "$(dirname "$STATE_FILE")"
{
    echo "# RakuOS baked overlay — generated at build time"
    echo "# $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
    printf '%s\n' "${INSTALLED[@]}"
} > "$STATE_FILE"

echo "[rakuos] Overlay bake complete — ${#INSTALLED[@]} packages installed."
echo "[rakuos] State written to $STATE_FILE"

if [[ ${#FAILED[@]} -gt 0 ]]; then
    exit 1
fi