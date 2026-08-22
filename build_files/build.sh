#!/bin/bash

set -ouex pipefail

FEDORA_VERSION=$(rpm -E %fedora)

# Enable the DNF5 COPR plugin.
dnf5 -y install dnf5-plugins

# Enable only the official RakuOS COPR.
dnf5 -y copr enable \
  tohur/RakuOS \
  fedora-${FEDORA_VERSION}-x86_64

# Install only packages not already provided by
# ghcr.io/krism-eu/rakuos-base:kde.
dnf5 -y install \
  plasma-browser-integration \
  kdegraphics-thumbnailers \
  kcm_systemd \
  rakuos-welcome-qt \
  rakuos-software-qt

# Remove packages that are not wanted in RakuOS KDE.
REMOVE_PACKAGES=(
  plasma-discover
  plasma-discover-offline-updates
  plasma-discover-packagekit
  plasma-welcome
  plasma-welcome-fedora
)

INSTALLED_REMOVE_PACKAGES=()

for package in "${REMOVE_PACKAGES[@]}"; do
  if rpm -q "$package" >/dev/null 2>&1; then
    INSTALLED_REMOVE_PACKAGES+=("$package")
  fi
done

if ((${#INSTALLED_REMOVE_PACKAGES[@]})); then
  dnf5 -y remove --no-autoremove \
    "${INSTALLED_REMOVE_PACKAGES[@]}"
fi

# Remove Fedora Look and Feel packages.
rm -rf \
  /usr/share/plasma/look-and-feel/org.fedoraproject.fedora.desktop \
  /usr/share/plasma/look-and-feel/org.fedoraproject.fedoradark.desktop \
  /usr/share/plasma/look-and-feel/org.fedoraproject.fedoralight.desktop

# Remove Fedora wallpapers.
rm -rf \
  /usr/share/wallpapers/Fedora \
  /usr/share/wallpapers/F43

# Add RakuOS Plasma panel pins.
PINS_FILE="/usr/share/plasma/shells/org.kde.plasma.desktop/contents/updates/rakuos-pins.js"
LAYOUT_FILE="/usr/share/plasma/layout-templates/org.kde.plasma.desktop.defaultPanel/contents/layout.js"

if [[ -f "$PINS_FILE" && -f "$LAYOUT_FILE" ]]; then
    sed -i "\$r $PINS_FILE" "$LAYOUT_FILE"
else
    echo "WARNING: RakuOS Plasma pins or layout file not found"
fi

# Enable Plasma Login Manager.
systemctl enable plasmalogin.service
