#!/usr/bin/env bash
set -euo pipefail

# myrakuOS package composition
# Keep the RakuOS base/overlay lifecycle intact; this file only defines
# the additional desktop payload for the derived image.

PACKAGE_DIR="/usr/share/myrakuos/packages"
mkdir -p "$PACKAGE_DIR"

cat > "$PACKAGE_DIR/kde-core.txt" <<'EOF'
plasma-desktop
plasma-workspace
plasma-workspace-wayland
plasma-browser-integration
kscreen
powerdevil
plasma-nm
plasma-pa
xdg-desktop-portal-kde
xorg-x11-server-Xwayland
plasma-login-manager
kcm-plasmalogin
kde-settings-plasmalogin
kde-gtk-config
kde-settings
kde-settings-plasma
kio-fuse
kdegraphics-thumbnailers
bluedevil
EOF

cat > "$PACKAGE_DIR/kde-optional.txt" <<'EOF'
plasma-systemmonitor
plasma-discover
plasma-discover-flatpak
plasma-print-manager
kde-connect
kdeplasma-addons
kwalletmanager5
kcalc
skanpage
kompare
EOF

# These lists are intentionally explicit: no @fonts or @hardware-support groups.
# Package installation must be invoked by the caller in the image's build stage.
if [[ "${MYRAKUOS_INSTALL_PACKAGES:-0}" == "1" ]]; then
    mapfile -t packages < <(cat "$PACKAGE_DIR/kde-core.txt" "$PACKAGE_DIR/kde-optional.txt" | sed '/^#/d;/^$/d')
    dnf5.real -y install --setopt=install_weak_deps=False "${packages[@]}"
fi
