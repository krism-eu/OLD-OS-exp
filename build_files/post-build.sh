#!/usr/bin/env bash
set -euo pipefail

# RakuOS base post-build integration.
# The canonical implementation must remain aligned with RakuOS/rakuos-base.
# This stage is intentionally kept separate from the KDE package payload.

if [[ ! -x /usr/libexec/rakuos/generate-base-manifest ]]; then
    echo "ERROR: missing RakuOS base manifest generator" >&2
    exit 1
fi

mkdir -p /usr/share/rakuos

if [[ -f /usr/share/rakuos/protected-packages.txt ]]; then
    echo "Using existing RakuOS protected package manifest"
else
    : > /usr/share/rakuos/protected-packages.txt
fi

echo "Marking installed image packages as dependencies"
dnf5.real -y mark dependency $(rpm -qa --qf '%{NAME} ') --skip-unavailable

echo "Generating base file manifest"
/usr/libexec/rakuos/generate-base-manifest

mv /usr/bin/dnf5 /usr/bin/dnf5.real 2>/dev/null || true
mv /usr/bin/dnf /usr/bin/dnf.real 2>/dev/null || true

if [[ -x /usr/libexec/rakuos/rakuos-install ]]; then
    ln -sf /usr/libexec/rakuos/rakuos-install /usr/bin/dnf5
    ln -sf /usr/libexec/rakuos/rakuos-install /usr/bin/dnf
fi
