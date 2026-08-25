#!/usr/bin/env bash
set -euo pipefail

PROTECTED=/usr/share/rakuos/protected-packages.txt

if [[ ! -f "$PROTECTED" ]]; then
    echo "ERROR: missing $PROTECTED" >&2
    exit 1
fi

cat >> "$PROTECTED" <<'EOF'

# myrakuOS KDE protected packages
plasma-desktop
plasma-workspace
plasma-workspace-wayland
plasma-browser-integration
kscreen
powerdevil
plasma-nm
plasma-pa
plasma-login-manager
kcm-plasmalogin
kde-settings-plasmalogin
xdg-desktop-portal-kde
xorg-x11-server-Xwayland
kde-gtk-config
kde-settings
kde-settings-plasma
kio-fuse
kdegraphics-thumbnailers
bluedevil
EOF
