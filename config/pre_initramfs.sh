#!/usr/bin/env bash
set -euo pipefail
FEDORA_VERSION=$(rpm -E %fedora)

echo "Preparing initramfs for RakuOS Linux Live Isos"