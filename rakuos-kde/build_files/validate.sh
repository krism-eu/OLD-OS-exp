#!/usr/bin/env bash

set -euo pipefail

echo "[rakuos-kde] validating KDE image..."

REQUIRED_EXECUTABLES=(
    /usr/bin/dnf5.real
    /usr/bin/dnf5
    /usr/bin/dnf
    /usr/bin/rakuos
    /usr/bin/rum
    /usr/libexec/rakuos/rakuos-install
    /usr/libexec/rakuos/rakuos-remove
    /usr/libexec/rakuos/rakuos-update
    /usr/libexec/rakuos/rakuos-overlay-mount
    /usr/libexec/rakuos/rakuos-overlay-sync
    /usr/libexec/rakuos/rakuos-overlay-services
    /usr/libexec/rakuos/generate-base-manifest
)

for file in "${REQUIRED_EXECUTABLES[@]}"; do
    if [[ ! -x "$file" ]]; then
        echo "ERROR: missing or non-executable file: $file" >&2
        exit 1
    fi
done

REQUIRED_FILES=(
    /usr/share/rakuos/dnf.conf
    /usr/share/rakuos/protected-packages.txt
)

for file in "${REQUIRED_FILES[@]}"; do
    if [[ ! -f "$file" ]]; then
        echo "ERROR: missing required file: $file" >&2
        exit 1
    fi
done

REQUIRED_PACKAGES=(
    rakuos-rum
    rum-dnf-shim
    plasma-desktop
    plasma-workspace
    plasma-login-manager
    kcm-plasmalogin
    kde-settings
    kscreen
    powerdevil
    plasma-nm
    plasma-pa
    kde-gtk-config
    bluedevil
    kwalletmanager5
    dolphin
    konsole
    xdg-desktop-portal-kde
    rakuos-welcome-qt
    rakuos-software-qt
)

for package in "${REQUIRED_PACKAGES[@]}"; do
    if ! rpm -q "$package" >/dev/null 2>&1; then
        echo "ERROR: missing required package: $package" >&2
        exit 1
    fi
done

REQUIRED_UNITS=(
    rakuos-overlay-mount.service
    rakuos-overlay-services.service
    rakuos-overlay-sync.service
    plasmalogin.service
)

for unit in "${REQUIRED_UNITS[@]}"; do
    if [[ ! -f "/usr/lib/systemd/system/$unit" ]]; then
        echo "ERROR: missing required systemd unit: $unit" >&2
        exit 1
    fi
done

if ! grep -q '^plasma-desktop$' \
    /usr/share/rakuos/protected-packages.txt; then
    echo "ERROR: plasma-desktop is not protected" >&2
    exit 1
fi

if ! grep -q '^rakuos-software-qt$' \
    /usr/share/rakuos/protected-packages.txt; then
    echo "ERROR: rakuos-software-qt is not protected" >&2
    exit 1
fi

if rpm -q plasma-discover >/dev/null 2>&1; then
    echo "ERROR: plasma-discover must not be installed" >&2
    exit 1
fi

if rpm -q plasma-welcome >/dev/null 2>&1; then
    echo "ERROR: plasma-welcome must not be installed" >&2
    exit 1
fi

if ! systemctl is-enabled plasmalogin.service >/dev/null 2>&1; then
    echo "ERROR: plasmalogin.service is not enabled" >&2
    exit 1
fi

echo "[rakuos-kde] KDE image validation successful."
