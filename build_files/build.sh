#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
#dnf5 install -y tmux 

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

## Install packages
dnf5 -y install @base-x @fonts @hardware-support \
  plasma-desktop \
  plasma-workspace \
  plasma-workspace-wayland \
  sddm \
  sddm-breeze \
  konsole \
  dolphin \
  kwin \
  kmenuedit \
  plasma-nm \
  plasma-pa \
  kdegraphics-thumbnailers \
  breeze-icon-theme \
  breeze-gtk \
  kde-gtk-config \
  kcm_systemd \
  kde-partitionmanager \
  kwalletmanager5 \
  kate \
  ark \
  spectacle \
  plasma-discover \
  plasma-systemmonitor \
  scx-manager

## Remove packages
dnf5 -y remove plasma-discover-offline-updates \
  plasma-discover-packagekit \
  PackageKit-command-not-found

## install flatpaks
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y --noninteractive flathub org.mozilla.firefox
flatpak install -y --noninteractive flathub org.kde.gwenview
flatpak install -y --noninteractive flathub org.kde.kcalc
flatpak install -y --noninteractive flathub org.kde.okular
flatpak install -y --noninteractive flathub org.gtk.Gtk3theme.Breeze

#!/usr/bin/env bash
set -euo pipefail

echo "Creating RakuOS first-boot Flatpak installer..."

# Create the first-boot install script
cat << 'EOF' > /usr/libexec/rakuos-firstboot-flatpaks.sh
#!/usr/bin/env bash
set -euo pipefail

echo "RakuOS: Installing default Flatpaks..."

# Ensure Flathub exists
if ! flatpak remote-list | grep -q flathub; then
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

# Install Flatpaks system-wide
flatpak install -y --noninteractive --system flathub \
    org.mozilla.firefox \
    org.kde.gwenview \
    org.kde.kcalc \
    org.kde.okular \
    org.gtk.Gtk3theme.Breeze

echo "Flatpak installation complete."

# Disable service so it never runs again
systemctl disable rakuos-firstboot-flatpaks.service
EOF

chmod +x /usr/libexec/rakuos-firstboot-flatpaks.sh

# Create systemd service
cat << 'EOF' > /etc/systemd/system/rakuos-firstboot-flatpaks.service
[Unit]
Description=RakuOS First Boot Flatpak Installer
After=network-online.target
Wants=network-online.target
ConditionPathExists=/usr/local/bin/rakuos-firstboot-flatpaks.sh

[Service]
Type=oneshot
ExecStart=/usr/local/bin/rakuos-firstboot-flatpaks.sh
RemainAfterExit=false

[Install]
WantedBy=multi-user.target
EOF

## Enable Services
systemctl enable rakuos-firstboot-flatpaks.service
systemctl enable sddm.service