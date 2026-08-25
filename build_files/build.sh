#!/usr/bin/env bash
set -euo pipefail

dnf5.real -y install --setopt=install_weak_deps=False \
  glibc-langpack-en glibc-langpack-it \
  snapper btrfs-assistant btrfsmaintenance rclone \
  pipewire pipewire-alsa pipewire-pulseaudio wireplumber \
  mt7xxx-firmware mesa-vulkan-drivers mesa-va-drivers \
  plasma-desktop plasma-workspace plasma-workspace-wayland \
  plasma-browser-integration kscreen powerdevil plasma-nm plasma-pa \
  plasma-systemmonitor plasma-discover plasma-discover-flatpak \
  plasma-print-manager kde-connect kde-gtk-config kdeplasma-addons \
  bluedevil kde-settings kde-settings-plasma kwalletmanager5 kio-fuse \
  kdegraphics-thumbnailers plasma-login-manager kcm-plasmalogin \
  kde-settings-plasmalogin xdg-desktop-portal-kde \
  xorg-x11-server-Xwayland \
  dolphin dolphin-plugins kate konsole ark gwenview spectacle okular \
  kfind filelight kinfocenter kio-admin kde-partitionmanager \
  kf6-sonnet-hunspell \
  btop fastfetch openssh-server hunspell-it unrar-free fzf bash-completion \
  qemu-kvm libvirt virt-install virt-manager

# Remove only unwanted payload; do not remove the virtualization host stack.
dnf5.real -y remove --setopt=clean_requirements_on_remove=False --skip-unavailable \
  gamemode gamemode.i686 mangohud mangohud.i686 goverlay lutris \
  heroic-games-launcher protonplus steam \
  virtualbox-guest-additions open-vm-tools open-vm-tools-desktop \
  spice-vdagent spice-webdavd qemu-guest-agent qemu-user-static-aarch64 \
  hyperv-daemons hyperv-daemons-license hypervfcopyd hypervkvpd hypervvssd \
  ibus-anthy ibus-anthy-python ibus-chewing ibus-hangul ibus-libpinyin \
  ibus-m17n ibus-typing-booster kasumi-common kasumi-unicode anthy-unicode \
  braille-printer-app brltty brlapi python3-brlapi orca \
  nvidia-gpu-firmware intel-gmmlib intel-gpu-firmware intel-lpmd \
  intel-mediasdk intel-vaapi-driver intel-vpl-gpu-rt intel-vsc-firmware \
  libva-intel-media-driver firefox firefox-langpacks glibc-all-langpacks \
  default-fonts-cjk-mono default-fonts-cjk-serif \
  google-noto-sans-cjk-fonts google-noto-sans-mono-cjk-vf-fonts \
  google-noto-serif-cjk-vf-fonts \
  vim-enhanced vim-common vim-data vim-filesystem xxd nvtop htop mcelog \
  gpm-libs smartmontools smartmontools-selinux \
  sssd-client sssd-common sssd-kcm sssd-krb5-common sssd-nfs-idmap \
  realmd nfs-client-utils nfs-common-utils nfsv3-client-utils \
  nfsv4-client-utils nfs-utils libnfsidmap rpcbind gssproxy || true

systemctl enable plasmalogin.service
