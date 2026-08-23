#!/usr/bin/env bash

set -euo pipefail

FEDORA_VERSION="$(rpm -E %fedora)"

if ! command -v dnf5.real >/dev/null 2>&1; then
  echo "ERROR: dnf5.real is missing from the KDE layer" >&2
  exit 1
fi

if ! command -v rakuos >/dev/null 2>&1; then
  echo "ERROR: rakuos is missing from the KDE layer" >&2
  exit 1
fi

if ! rpm -q dnf5-plugins >/dev/null 2>&1; then
  dnf5.real -y install dnf5-plugins
fi

dnf5.real -y copr enable \
  tohur/RakuOS \
  "fedora-${FEDORA_VERSION}-x86_64"

INSTALL_PACKAGES=(
  amd-gpu-firmware
  fish
  plasma-browser-integration
  kdegraphics-thumbnailers
  kcm_systemd
  rakuos-welcome-qt
  rakuos-software-qt
)

TO_INSTALL=()

for package in "${INSTALL_PACKAGES[@]}"; do
  if ! rpm -q "$package" >/dev/null 2>&1; then
    TO_INSTALL+=("$package")
  fi
done

if ((${#TO_INSTALL[@]})); then
  dnf5.real -y install "${TO_INSTALL[@]}"
fi

REMOVE_PACKAGES=(
  plasma-discover
  plasma-discover-offline-updates
  plasma-discover-packagekit
  plasma-welcome
  plasma-welcome-fedora
)

TO_REMOVE=()

for package in "${REMOVE_PACKAGES[@]}"; do
  if rpm -q "$package" >/dev/null 2>&1; then
    TO_REMOVE+=("$package")
  fi
done

if ((${#TO_REMOVE[@]})); then
  dnf5.real -y remove --no-autoremove "${TO_REMOVE[@]}"
fi

for required_file in \
  /usr/bin/rakuos \
  /usr/libexec/rakuos/rakuos-install \
  /usr/libexec/rakuos/software/rakuos-software-qt
do
  if [[ ! -x "$required_file" ]]; then
    echo "ERROR: missing required executable: $required_file" >&2
    exit 1
  fi
done

if ! /usr/bin/python3 -c 'import encodings' >/dev/null 2>&1; then
  echo "ERROR: system Python cannot import encodings" >&2
  exit 1
fi

rm -f \
  /usr/lib64/qt6/plugins/plasma/kcms/systemsettings/kcm_gamecontroller.so

rm -rf \
  /usr/share/plasma/look-and-feel/org.fedoraproject.fedora.desktop \
  /usr/share/plasma/look-and-feel/org.fedoraproject.fedoradark.desktop \
  /usr/share/plasma/look-and-feel/org.fedoraproject.fedoralight.desktop \
  /usr/share/wallpapers/Fedora \
  /usr/share/wallpapers/F43

PINS_FILE="/usr/share/plasma/shells/org.kde.plasma.desktop/contents/updates/rakuos-pins.js"
LAYOUT_FILE="/usr/share/plasma/layout-templates/org.kde.plasma.desktop.defaultPanel/contents/layout.js"

if [[ -f "$PINS_FILE" && -f "$LAYOUT_FILE" ]]; then
  sed -i "$r $PINS_FILE" "$LAYOUT_FILE"
else
  echo "WARNING: RakuOS Plasma pins or layout file not found"
fi

systemctl enable plasmalogin.service
