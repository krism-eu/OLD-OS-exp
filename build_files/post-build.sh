#!/bin/bash

set -ouex pipefail

# ─── Rinomina dnf ──────────────────────────────────────────────────────────────
mv /usr/bin/dnf5 /usr/bin/dnf5.real
mv /usr/bin/dnf /usr/bin/dnf.real

dnf5.real -y mark dependency $(rpm -qa --qf '%{NAME} ') --skip-unavailable

cat > /usr/bin/dnf5 << 'WRAPPER'
#!/usr/bin/env bash
COMMAND="${1:-}"
case "$COMMAND" in
    install)
        shift
        exec rakuos install "$@"
        ;;
    update)
        shift
        exec rakuos update "$@"
        ;;
    remove|erase)
        shift
        exec rakuos remove "$@"
        ;;
    *)
        exec /usr/bin/dnf5.real "$@"
        ;;
esac
WRAPPER

cat > /usr/bin/dnf << 'WRAPPER'
#!/usr/bin/env bash
exec /usr/bin/dnf5 "$@"
WRAPPER

chmod +x /usr/bin/dnf5 /usr/bin/dnf

# ─── RIMOZIONI PER CATEGORIA ──────────────────────────────────────────────────

echo "=== Rimozione pacchetti superflui (categorie) ==="

# 1. Langpacks (solo inglese)
dnf5 -y remove --no-autoremove glibc-all-langpacks || true

# 2. Scheduler (non servono)
dnf5 -y remove --no-autoremove scx-scheds scx-tools || true

# 3. Firmware (NVIDIA, WiFi, Atheros, Broadcom) - AMD non serve
dnf5 -y remove --no-autoremove \
  nvidia-gpu-firmware \
  iwlwifi-mvm-firmware iwlwifi-mld-firmware iwlwifi-dvm-firmware \
  atheros-firmware brcmfmac-firmware \
  || true

# 4. Python AWS (botocore, boto3, ecc.)
dnf5 -y remove --no-autoremove \
  python3-botocore python3-boto3 python3-s3transfer python3-jmespath \
  || true

# 5. CLDR / Emoji (dati Unicode extra)
dnf5 -y remove --no-autoremove \
  cldr-emoji-annotation cldr-emoji-annotation-dtd \
  || true

# 6. Input Method (IBUS e lingue asiatiche)
dnf5 -y remove --no-autoremove \
  ibus ibus-setup ibus-gtk3 ibus-gtk4 ibus-libs \
  ibus-anthy ibus-anthy-python ibus-libpinyin ibus-m17n ibus-chewing ibus-hangul ibus-typing-booster \
  anthy-unicode libpinyin libpinyin-data libchewing libhangul \
  m17n-lib m17n-db kasumi-unicode kasumi-common \
  || true

# 7. Font CJK e font extra
dnf5 -y remove --no-autoremove \
  google-noto-sans-cjk-vf-fonts google-noto-sans-mono-cjk-vf-fonts google-noto-serif-cjk-vf-fonts \
  default-fonts-cjk-sans default-fonts-cjk-serif default-fonts-cjk-mono \
  google-noto-sans-arabic-vf-fonts google-noto-sans-bengali-vf-fonts \
  google-noto-sans-canadian-aboriginal-vf-fonts google-noto-sans-cherokee-vf-fonts \
  google-noto-sans-devanagari-vf-fonts google-noto-sans-ethiopic-vf-fonts \
  google-noto-sans-georgian-vf-fonts google-noto-sans-gothic-fonts \
  google-noto-sans-gujarati-vf-fonts google-noto-sans-gurmukhi-vf-fonts \
  google-noto-sans-hebrew-vf-fonts google-noto-sans-khmer-vf-fonts \
  google-noto-sans-kannada-vf-fonts google-noto-sans-lao-vf-fonts \
  google-noto-sans-math-fonts google-noto-sans-meetei-mayek-vf-fonts \
  google-noto-sans-nko-fonts google-noto-sans-ol-chiki-vf-fonts \
  google-noto-sans-oriya-vf-fonts google-noto-sans-sinhala-vf-fonts \
  google-noto-sans-syriac-vf-fonts google-noto-sans-symbols-vf-fonts google-noto-sans-symbols-2-fonts \
  google-noto-sans-tamil-vf-fonts google-noto-sans-telugu-vf-fonts \
  google-noto-sans-thaana-vf-fonts google-noto-sans-thai-vf-fonts \
  google-noto-naskh-arabic-vf-fonts google-noto-color-emoji-fonts google-noto-emoji-fonts \
  google-noto-serif-bengali-vf-fonts google-noto-serif-devanagari-vf-fonts \
  google-noto-serif-ethiopic-vf-fonts google-noto-serif-georgian-vf-fonts \
  google-noto-serif-gujarati-vf-fonts google-noto-serif-gurmukhi-vf-fonts \
  google-noto-serif-hebrew-vf-fonts google-noto-serif-khmer-vf-fonts \
  google-noto-serif-kannada-vf-fonts google-noto-serif-lao-vf-fonts \
  google-noto-serif-oriya-vf-fonts google-noto-serif-sinhala-vf-fonts \
  google-noto-serif-tamil-vf-fonts google-noto-serif-telugu-vf-fonts \
  google-noto-serif-thai-vf-fonts google-noto-serif-armenian-vf-fonts \
  google-noto-sans-armenian-vf-fonts \
  madan-fonts rit-meera-new-fonts rit-rachana-fonts jomolhari-fonts \
  sil-padauk-fonts stix-fonts gdouros-symbola-fonts paktype-naskh-basic-fonts vazirmatn-vf-fonts \
  || true

# 8. Geolocalizzazione (Geolite2)
dnf5 -y remove --no-autoremove geolite2-city geolite2-country || true

# 9. Sviluppo (compilatori, header, debug)
dnf5 -y remove --no-autoremove \
  gcc cpp gdb-minimal binutils make flex bison m4 \
  gcc-plugin-annobin annobin-plugin-gcc annobin-docs \
  glibc-devel elfutils-devel elfutils-libelf-devel kernel-headers \
  rpm-build rpm-build-libs rpmdevtools debugedit dwz patch openssl-devel \
  || true

# 10. Samba e CIFS (condivisione Windows)
dnf5 -y remove --no-autoremove \
  samba-client samba-client-libs samba-common samba-common-libs \
  cifs-utils cifs-utils-info \
  || true

# 11. Driver e firmware Intel (media, GPU, audio)
dnf5 -y remove --no-autoremove \
  intel-mediasdk intel-vpl-gpu-rt \
  intel-gpu-firmware intel-vsc-firmware intel-audio-firmware \
  libva-intel-media-driver intel-gmmlib \
  || true

# 12. Fotocamere digitali
dnf5 -y remove --no-autoremove libgphoto2 || true

# 13. Adobe mappings (PDF, font)
dnf5 -y remove --no-autoremove \
  adobe-mappings-cmap adobe-mappings-cmap-deprecated adobe-mappings-pdf \
  || true

# 14. Unicode UCD
dnf5 -y remove --no-autoremove unicode-ucd || true

# 15. Driver DKMS (non servono, kernel standard)
dnf5 -y remove --no-autoremove dkms akmods || true

echo "=== Rimozioni completate ==="

# ─── protected-packages.txt ──────────────────────────────────────────────────
PROTECTED_FILE="/usr/share/rakuos/protected-packages.txt"
mkdir -p /usr/share/rakuos

if [[ -f "$PROTECTED_FILE" ]]; then
    echo "nvidia build detected — appending base packages to existing protected-packages.txt..."
else
    echo "Normal build — creating protected-packages.txt with base packages..."
    > "$PROTECTED_FILE"
fi

cat >> "$PROTECTED_FILE" << 'EOF'

# Base image packages (from rakuos-base/build_files/build.sh)
dnf5-plugins
dnf-plugins-core
git
flatpak
podman
distrobox
podman-compose
lm_sensors
mesa-dri-drivers.i686
mesa-va-drivers.i686
mesa-vulkan-drivers.i686
mesa-libEGL.i686
mesa-libGL.i686
libxcrypt-compat
rsync
fuse
squashfuse
sqlite3
openssl
libnotify
inotify-tools
unzip
ffmpeg
fedora-logos
EOF

echo "protected-packages.txt ready ($(grep -c '^[^#]' "$PROTECTED_FILE") packages)."

echo "Generating base file manifest..."
/usr/libexec/rakuos/generate-base-manifest
