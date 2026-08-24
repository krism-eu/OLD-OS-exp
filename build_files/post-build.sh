#!/bin/bash

set -ouex pipefail

# Rename real dnf5 and dnf binaries
mv /usr/bin/dnf5 /usr/bin/dnf5.real
mv /usr/bin/dnf /usr/bin/dnf.real

# Mark all base image packages as dependency so PackageKit only manages overlay packages
dnf5.real -y mark dependency $(rpm -qa --qf '%{NAME} ') --skip-unavailable

# Create dnf5 wrapper
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

# Create dnf wrapper
cat > /usr/bin/dnf << 'WRAPPER'
#!/usr/bin/env bash
exec /usr/bin/dnf5 "$@"
WRAPPER

# Make all wrappers executable
chmod +x /usr/bin/dnf5 /usr/bin/dnf

# Remove ostree boot condition from PackageKit so it starts on RakuOS
# sed -i '/ConditionPathExists=!\/run\/ostree-booted/d' \
#     /usr/lib/systemd/system/packagekit.service

echo "RakuOS post-build complete."

# ── Build protected-packages.txt ──────────────────────────────────────────────
# The KDE layer will append the KDE packages and generate the final manifest.
PROTECTED_FILE="/usr/share/rakuos/protected-packages.txt"
mkdir -p /usr/share/rakuos

cat > "$PROTECTED_FILE" << 'EOF'

# Base image packages from the custom Fedora 44 minimal base
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
EOF

echo "protected-packages.txt ready ($(grep -c '^[^#]' "$PROTECTED_FILE") packages)."
