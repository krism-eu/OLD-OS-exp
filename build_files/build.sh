# ------------------------------------------------------------
# 5. kde/build_files/build.sh (REV 2)
# ------------------------------------------------------------
cat > rakufinal/kde/build_files/build.sh << 'EOF'
#!/bin/bash
set -ouex pipefail
FEDORA_VERSION=$(rpm -E %fedora)

# ─── Lingue minime ─────────────────────────────────────────
dnf5.real -y install glibc-langpack-en glibc-langpack-it

# ─── Storage e sistema ─────────────────────────────────────
dnf5.real -y install \
  snapper \
  btrfs-assistant \
  btrfsmaintenance \
  rclone

# ─── Audio: PipeWire + WirePlumber ─────────────────────────
dnf5.real -y install \
  pipewire \
  pipewire-alsa \
  pipewire-pulseaudio \
  wireplumber

# ─── Firmware e driver video ───────────────────────────────
dnf5.real -y install \
  mt7xxx-firmware \
  mesa-vulkan-drivers \
  mesa-va-drivers

# ─── Font base ─────────────────────────────────────────────
dnf5.real -y install google-noto-fonts liberation-fonts

# ─── KDE / Plasma ──────────────────────────────────────────
dnf5.real -y install \
  plasma-desktop \
  plasma-workspace \
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
  kcalc \
  skanpage \
  kompare

# ─── Plasma Login Manager ──────────────────────────────────
dnf5.real -y install \
  plasma-login-manager \
  kcm-plasmalogin \
  kde-settings-plasmalogin

# ─── Portali e compatibilità X11 ───────────────────────────
dnf5.real -y install \
  xdg-desktop-portal-kde \
  xorg-x11-server-Xwayland

# ─── Applicazioni KDE ──────────────────────────────────────
dnf5.real -y install \
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
  kf6-sonnet-hunspell

# ─── Strumenti CLI ─────────────────────────────────────────
dnf5.real -y install \
  btop \
  fastfetch \
  openssh-server \
  hunspell-it \
  unrar-free \
  system-config-printer \
  fzf \
  bash-completion \
  grsync

# ─── Sfondi ────────────────────────────────────────────────
dnf5.real -y install \
  f44-backgrounds-base \
  f44-backgrounds-kde

# ─── Rimuovi SOLO cose non volute (NON toccare il desktop) ──
dnf5.real -y remove \
  rakuos-welcome-qt \
  rakuos-software-qt \
  plasma-welcome \
  plasma-welcome-fedora \
  || true

# ─── Rimuovi look&feel Fedora (mantieni sfondi F44) ─────────
rm -rf /usr/share/plasma/look-and-feel/org.fedoraproject.fedora.desktop
rm -rf /usr/share/plasma/look-and-feel/org.fedoraproject.fedoradark.desktop
rm -rf /usr/share/plasma/look-and-feel/org.fedoraproject.fedoralight.desktop
rm -rf /usr/share/wallpapers/Fedora

# ─── KDE customizations ────────────────────────────────────
sed -i '$r /usr/share/plasma/shells/org.kde.plasma.desktop/contents/updates/rakuos-pins.js' \
  /usr/share/plasma/layout-templates/org.kde.plasma.desktop.defaultPanel/contents/layout.js

# ─── Servizi ───────────────────────────────────────────────
systemctl enable plasmalogin.service
systemctl enable sshd.service
systemctl enable snapper-timeline.timer
systemctl enable snapper-cleanup.timer
EOF
