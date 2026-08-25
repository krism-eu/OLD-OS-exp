#!/usr/bin/env bash
set -euo pipefail

DEFAULT_PACKAGES_LIST="/usr/share/rakuos/packages.list"
PACKAGES_LIST="/var/lib/rakuos/packages.list"
UPPER_DIR="/var/lib/rakuos/overlay/upper"
WORK_DIR="/var/lib/rakuos/overlay/work"
STATE_FILE="/var/lib/rakuos/overlay.state"
DIRTY_FILE="/var/lib/rakuos/overlay.dirty"
PROTECTED="/usr/share/rakuos/protected-packages.txt"

mkdir -p /usr/share/rakuos /var/lib/rakuos "$UPPER_DIR" "$WORK_DIR"

cat > "$DEFAULT_PACKAGES_LIST" <<'EOF'
qemu-kvm
libvirt
virt-install
virt-manager
rclone
btop
fastfetch
openssh-server
hunspell-it
unrar-free
fzf
bash-completion
EOF

cp "$DEFAULT_PACKAGES_LIST" "$PACKAGES_LIST"
rm -f "$STATE_FILE" "$DIRTY_FILE"
sed -i -e '$a\\' "$PACKAGES_LIST"

cat >> "$PROTECTED" <<'EOF'

# myrakuOS KDE packages
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

/usr/libexec/rakuos/generate-base-manifest
