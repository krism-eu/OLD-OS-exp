#!/usr/bin/env bash
set -euo pipefail

DNF="$(command -v dnf5.real 2>/dev/null || command -v dnf5)"

echo "==> Marcatura dei pacchetti come dipendenze..."
"$DNF" -y mark dependency $(rpm -qa --qf '%{NAME} ') --skip-unavailable

PROTECTED_FILE="/usr/share/rakuos/protected-packages.txt"
mkdir -p "$(dirname "$PROTECTED_FILE")"

if [ -f /ctx/protected-packages.txt ]; then
    cp /ctx/protected-packages.txt "$PROTECTED_FILE"
else
    echo "ERRORE: /ctx/protected-packages.txt non trovato" >&2
    exit 1
fi

echo "==> Generazione manifest..."
if [ -x /usr/libexec/rakuos/generate-base-manifest ]; then
    /usr/libexec/rakuos/generate-base-manifest
else
    echo "ERRORE: generate-base-manifest non trovato" >&2
    exit 1
fi

echo "post-build.sh completato."
