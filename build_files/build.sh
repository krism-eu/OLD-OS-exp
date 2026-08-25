#!/usr/bin/env bash
set -euo pipefail

# myrakuOS targeted KDE composition

dnf5.real -y install --setopt=install_weak_deps=False \
  glibc-langpack-en \
  glibc-langpack-it \
  snapper \
  btrfs-assistant \
  btrfsmaintenance \
  rclone \
  pipewire \
  pipewire-alsa \
  pipewire-pulseaudio \
  wireplumber \
  mt7xxx-firmware \
  mesa-vulkan-drivers \
  mesa-va-drivers \
  plasma-desktop \
  plasma-workspace \
  plasma-workspace-wayland \
  plasma-browser-integration \
  kscreen \
  powerdevil \
  plasma-nm \
  plasma-pa \
  plasma-systemmonitor \
  plasma-discover \
  plasma-discover-flatpak \
  plasma-print-manager \
  kde-connect \
  kde-gtk-config \
  kdeplasma-addons \
  bluedevil \
  kde-settings \
  kde-settings-plasma \
  kwalletmanager5 \
  kio-fuse \
  kdegraphics-thumbnailers \
  plasma-login-manager \
  kcm-plasmalogin \
  kde-settings-plasmalogin \
  xdg-desktop-portal-kde \
  xorg-x11-server-Xwayland \
  dolphin \
  dolphin-plugins \
  kate \
  kwrite \
  konsole \
  ark \
  gwenview \
  spectacle \
  okular \
  kfind \
  filelight \
  kinfocenter \
  kio-admin \
  kde-partitionmanager \
  kf6-sonnet-hunspell \
  btop \
  fastfetch \
  openssh-server \
  hunspell-it \
  unrar-free \
  fzf \
  bash-completion

systemctl enable plasmalogin.service
