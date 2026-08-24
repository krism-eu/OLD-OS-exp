#!/usr/bin/env bash

set -euo pipefail

DEFAULT_PACKAGES_LIST="/usr/share/rakuos/packages.list"
PACKAGES_LIST="/var/lib/rakuos/packages.list"
UPPER_DIR="/var/lib/rakuos/overlay/upper"
WORK_DIR="/var/lib/rakuos/overlay/work"
STATE_FILE="/var/lib/rakuos/overlay.state"
DIRTY_FILE="/var/lib/rakuos/overlay.dirty"
PROTECTED_FILE="/usr/share/rakuos/protected-packages.txt"

echo "[rakuos-kde] preparing KDE overlay state..."

mkdir -p \
    /var/lib/rakuos \
    "$UPPER_DIR" \
    "$WORK_DIR" \
    /usr/share/rakuos

if [[ -f "$DEFAULT_PACKAGES_LIST" ]]; then
    cp "$DEFAULT_PACKAGES_LIST" "$PACKAGES_LIST"
else
    : > "$PACKAGES_LIST"
fi

sed -i -e '$a\' "$PACKAGES_LIST"

rm -f \
    "$STATE_FILE" \
    "$DIRTY_FILE"

cat > "$PROTECTED_FILE" << 'EOF'
# RakuOS base packages
NetworkManager
udisks2
linux-firmware
glibc-langpack-en
glibc-langpack-it
pipewire
pipewire-alsa
pipewire-pulseaudio
wireplumber
mt7xxx-firmware
mesa-vulkan-drivers
mesa-va-drivers
podman
bash-completion
fzf
openssh-server
rakuos-rum
rum-dnf-shim

# KDE desktop packages
plasma-desktop
plasma-workspace
plasma-login-manager
kcm-plasmalogin
kde-settings
kde-settings-plasma
kde-settings-plasmalogin
kscreen
powerdevil
plasma-nm
plasma-pa
plasma-systemmonitor
kde-gtk-config
bluedevil
kwalletmanager5
kio-fuse
xdg-desktop-portal-kde
xorg-x11-server-Xwayland
dolphin
dolphin-plugins
konsole
ark
gwenview
spectacle
kinfocenter
kdeplasma-addons
okular
kfind
filelight
kio-admin
kate
kwrite
kf6-sonnet-hunspell
fastfetch
hunspell-it
unrar-free
system-config-printer
f44-backgrounds-base
f44-backgrounds-kde
amd-gpu-firmware
plasma-browser-integration
kdegraphics-thumbnailers
kcm_systemd
rakuos-welcome-qt
rakuos-software-qt
EOF

chmod 0644 "$PROTECTED_FILE"

if [[ ! -x /usr/libexec/rakuos/generate-base-manifest ]]; then
    echo "ERROR: missing generate-base-manifest" >&2
    exit 1
fi

/usr/libexec/rakuos/generate-base-manifest

echo "[rakuos-kde] KDE overlay preparation complete."
