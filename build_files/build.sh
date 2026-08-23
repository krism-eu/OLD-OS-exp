#!/usr/bin/env bash

set -euo pipefail

FEDORA_VERSION="$(rpm -E %fedora)"

# Se dnf5.real esiste usa quello, altrimenti usa il dnf5 di sistema
if command -v dnf5.real >/dev/null 2>&1; then
  DNF_CMD="dnf5.real"
else
  DNF_CMD="dnf5"
fi

# Plugin COPR se non presente
if ! rpm -q dnf5-plugins >/dev/null 2>&1; then
  "$DNF_CMD" -y install dnf5-plugins
fi

# Abilita il COPR RakuOS
"$DNF_CMD" -y copr enable \
  tohur/RakuOS \
  "fedora-${FEDORA_VERSION}-x86_64"

# Pacchetti specifici del layer Custom
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
  "$DNF_CMD" -y install "${TO_INSTALL[@]}"
fi

# Rimozione pacchetti non desiderati
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
  "$DNF_CMD" -y remove --no-autoremove "${TO_REMOVE[@]}"
fi

# Pulizia look and feel generico Fedora
rm -f /usr/lib64/qt6/plugins/plasma/kcms/systemsettings/kcm_gamecontroller.so 2>/dev/null || true
rm -rf \
  /usr/share/plasma/look-and-feel/org.fedoraproject.fedora.desktop \
  /usr/share/plasma/look-and-feel/org.fedoraproject.fedoradark.desktop \
  /usr/share/plasma/look-and-feel/org.fedoraproject.fedoralight.desktop \
  /usr/share/wallpapers/Fedora \
  /usr/share/wallpapers/F43 2>/dev/null || true

# Layout del pannello RakuOS
PINS_FILE="/usr/share/plasma/shells/org.kde.plasma.desktop/contents/updates/rakuos-pins.js"
LAYOUT_FILE="/usr/share/plasma/layout-templates/org.kde.plasma.desktop.defaultPanel/contents/layout.js"

if [[ -f "$PINS_FILE" && -f "$LAYOUT_FILE" ]]; then
  sed -i "$r $PINS_FILE" "$LAYOUT_FILE"
fi

systemctl enable plasmalogin.service 2>/dev/null || true
