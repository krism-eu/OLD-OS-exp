#!/usr/bin/env bash

set -euo pipefail

echo "[rakuos-custom] updating overlay metadata..."

PROTECTED_FILE="/usr/share/rakuos/protected-packages.txt"
PACKAGES_LIST="/var/lib/rakuos/packages.list"

mkdir -p \
    /usr/share/rakuos \
    /var/lib/rakuos

touch "$PROTECTED_FILE"
touch "$PACKAGES_LIST"

# Pacchetti aggiunti dal custom e da proteggere.
CUSTOM_PACKAGES=(
    rakuos-welcome-qt
    rakuos-software-qt
)

for package in "${CUSTOM_PACKAGES[@]}"; do
    if rpm -q "$package" >/dev/null 2>&1; then
        if ! grep -Fxq "$package" "$PROTECTED_FILE"; then
            printf '%s\n' "$package" >> "$PROTECTED_FILE"
        fi
    fi
done

# Aggiorna la lista dei pacchetti presenti nell'immagine, se il tool è disponibile.
if [[ -x /usr/libexec/rakuos/generate-base-manifest ]]; then
    /usr/libexec/rakuos/generate-base-manifest
fi

echo "[rakuos-custom] overlay metadata updated."
