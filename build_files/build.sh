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
  plasma-discover

## Remove packages
dnf5 -y remove plasma-discover-offline-updates \
  plasma-discover-packagekit \
  PackageKit-command-not-found

## Enable Services
systemctl enable sddm.service

## Install bundled Flatpaks
flatpak install -y flathub org.mozilla.firefox