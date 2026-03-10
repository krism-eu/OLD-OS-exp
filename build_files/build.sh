#!/bin/bash

set -ouex pipefail
FEDORA_VERSION="${FEDORA_VERSION:-43}"

## Install packages
dnf5 -y install @fonts @hardware-support \
  plasma-desktop \
  plasma-workspace \
  plasma-workspace-wayland \
  plasma-browser-integration \
  kscreen \
  plasma-login-manager \
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
  kwalletmanager5 \
  plasma-setup \
  QtWebEngine

## Remove packages
dnf5 -y remove plasma-discover \
  plasma-discover-offline-updates \
  plasma-discover-packagekit

## Remove Fedora Look and Feel
rm -rf /usr/share/plasma/look-and-feel/org.fedoraproject.fedora.desktop
rm -rf /usr/share/plasma/look-and-feel/org.fedoraproject.fedoradark.desktop
rm -rf /usr/share/plasma/look-and-feel/org.fedoraproject.fedoralight.desktop

## Remove Fedora Wallpapers
rm /usr/share/wallpapers/Fedora
rm -rf /usr/share/wallpapers/F43

## Enable Services
systemctl enable plasmalogin.service \
  plasma-setup.service
