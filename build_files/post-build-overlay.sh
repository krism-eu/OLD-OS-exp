#!/usr/bin/env bash

set -euo pipefail

DEFAULT_PACKAGES_LIST="/usr/share/rakuos/packages.list"
PACKAGES_LIST="/var/lib/rakuos/packages.list"
UPPER_DIR="/var/lib/rakuos/overlay/upper"
WORK_DIR="/var/lib/rakuos/overlay/work"
STATE_FILE="/var/lib/rakuos/overlay.state"
DIRTY_FILE="/var/lib/rakuos/overlay.dirty"
PROTECTED_FILE="/usr/share/rakuos/protected-packages.txt"

echo "[rakuos] Seeding overlay state for first-boot install..."

mkdir -p \
  /var/lib/rakuos \
  "$UPPER_DIR" \
  "$WORK_DIR" \
  "$(dirname "$PROTECTED_FILE")"

if [[ -f "$DEFAULT_PACKAGES_LIST" ]]; then
  cp "$DEFAULT_PACKAGES_LIST" "$PACKAGES_LIST"
  PKG_COUNT="$(
    grep -Ev '^[[:space:]]*(#|$)' "$PACKAGES_LIST" | wc -l
  )"
  echo "[rakuos] packages.list seeded with $PKG_COUNT packages."
else
  echo "[rakuos] WARNING: missing $DEFAULT_PACKAGES_LIST"
  : > "$PACKAGES_LIST"
fi

rm -f "$STATE_FILE" "$DIRTY_FILE"
sed -i -e '$a\' "$PACKAGES_LIST"

touch "$PROTECTED_FILE"

KDE_PROTECTED_PACKAGES=(
  plasma-desktop
  plasma-workspace
  plasma-workspace-wayland
  plasma-browser-integration
  kscreen
  plasma-login-manager
  kwin
  kmenuedit
  kinfocenter
  plasma-nm
  plasma-pa
  kdegraphics-thumbnailers
  breeze-icon-theme
  breeze-gtk
  bluedevil
  bluez
  bluez-obexd
  kde-gtk-config
  kcm_systemd
  kwalletmanager5
  plasma-setup
  rakuos-welcome-qt
  rakuos-software-qt
)

for package in "${KDE_PROTECTED_PACKAGES[@]}"; do
  if ! grep -qxF "$package" "$PROTECTED_FILE"; then
    printf '%s\n' "$package" >> "$PROTECTED_FILE"
  fi
done

/usr/libexec/rakuos/generate-base-manifest

echo "[rakuos] Post-build seed complete."
