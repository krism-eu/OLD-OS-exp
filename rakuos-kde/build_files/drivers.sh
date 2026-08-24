#!/usr/bin/env bash

set -euo pipefail

echo "[rakuos-kde] driver configuration handled by the base package set."

if rpm -q amd-gpu-firmware >/dev/null 2>&1; then
    echo "[rakuos-kde] AMD GPU firmware is installed."
fi

if rpm -q mesa-vulkan-drivers mesa-va-drivers >/dev/null 2>&1; then
    echo "[rakuos-kde] Mesa graphics drivers are installed."
fi
