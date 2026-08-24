#!/usr/bin/env bash

set -ouex pipefail

dnf5.real -y \
    --setopt=install_weak_deps=false \
    --setopt=clean_requirements_on_remove=true \
    install \
    plasma-desktop \
    plasma-workspace \
    plasma-login-manager \
    kcm-plasmalogin \
    kde-settings \
    kde-settings-plasma \
    kde-settings-plasmalogin \
    kscreen \
    powerdevil \
    plasma-nm \
    plasma-pa \
    plasma-systemmonitor \
    kde-gtk-config \
    bluedevil \
    kwalletmanager5 \
    kio-fuse \
    xdg-desktop-portal-kde \
    xorg-x11-server-Xwayland \
    dolphin \
    dolphin-plugins \
    konsole \
    ark \
    gwenview \
    spectacle \
    kinfocenter \
    kdeplasma-addons \
    okular \
    kfind \
    filelight \
    kio-admin \
    kate \
    kwrite \
    kf6-sonnet-hunspell \
    fastfetch \
    hunspell-it \
    unrar-free \
    system-config-printer \
    f44-backgrounds-base \
    f44-backgrounds-kde \
    amd-gpu-firmware \
    plasma-browser-integration \
    kdegraphics-thumbnailers \
    kcm_systemd \
    rakuos-welcome-qt \
    rakuos-software-qt

dnf5.real -y \
    remove \
    plasma-discover \
    plasma-discover-offline-updates \
    plasma-discover-packagekit \
    plasma-welcome \
    plasma-welcome-fedora

dnf5.real clean all

rm -rf \
    /var/cache/dnf \
    /var/cache/libdnf5 \
    /var/log/dnf5.log \
    /run/dnf \
    /run/mdadm

rm -f \
    /usr/lib64/qt6/plugins/plasma/kcms/systemsettings/kcm_gamecontroller.so

rm -rf \
    /usr/share/plasma/look-and-feel/org.fedoraproject.fedora.desktop \
    /usr/share/plasma/look-and-feel/org.fedoraproject.fedoradark.desktop \
    /usr/share/plasma/look-and-feel/org.fedoraproject.fedoralight.desktop \
    /usr/share/wallpapers/Fedora \
    /usr/share/wallpapers/F44

PINS_FILE="/usr/share/plasma/shells/org.kde.plasma.desktop/contents/updates/rakuos-pins.js"
LAYOUT_FILE="/usr/share/plasma/layout-templates/org.kde.plasma.desktop.defaultPanel/contents/layout.js"

if [[ -f "$PINS_FILE" && -f "$LAYOUT_FILE" ]]; then
    if ! grep -q 'rakuos-pins' "$LAYOUT_FILE"; then
        cat "$PINS_FILE" >> "$LAYOUT_FILE"
    fi
else
    echo "WARNING: RakuOS Plasma pins or layout file not found"
fi
