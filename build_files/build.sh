#!/bin/bash

set -ouex pipefail
FEDORA_VERSION="${FEDORA_VERSION:-43}"
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

#fix Fonts
rm -rf /usr/local/share/fonts

## Install packages
dnf5 -y install @fonts @hardware-support \
  plasma-desktop \
  plasma-workspace \
  plasma-workspace-wayland \
  plasma-browser-integration \
  kscreen \
  plasma-login-manager \
  konsole \
  dolphin \
  kwin \
  kmenuedit \
  kinfocenter \
  plasma-nm \
  plasma-pa \
  kdegraphics-thumbnailers \
  breeze-icon-theme \
  breeze-gtk \
  bluedevil \
  bluez \
  bluez-obexd \
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

## Remove Fedora Look and Feel
rm -rf /usr/share/plasma/look-and-feel/org.fedoraproject.fedora.desktop
rm -rf /usr/share/plasma/look-and-feel/org.fedoraproject.fedoradark.desktop
rm -rf /usr/share/plasma/look-and-feel/org.fedoraproject.fedoralight.desktop

## Remove Fedora Wallpapers
rm /usr/share/wallpapers/Fedora
rm -rf /usr/share/wallpapers/F43

## Enable Services
systemctl enable plasmalogin.service
