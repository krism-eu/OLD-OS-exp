#!/usr/bin/env bash
set -euo pipefail

echo "=== RakuOS base validation ==="

echo "=== Required bootc components ==="
test -x /usr/bin/bootc
test -x /usr/lib/systemd/systemd

echo "=== Required packages ==="
rpm -q \
  pipewire \
  pipewire-pulseaudio \
  wireplumber \
  mesa-vulkan-drivers \
  podman

echo "=== Forbidden packages ==="
if rpm -qa | grep -E \
  '(\.i686$|^kernel-cachyos|^nvidia|^gamemode|^steam|^lutris)'; then
  echo "ERROR: forbidden package found"
  exit 1
fi

echo "=== Unwanted hardware packages ==="
rpm -qa | grep -Ei \
  '(^|[-])(intel-lpmd|intel-gmmlib|intel-mediasdk|intel-vaapi-driver)|virtualbox|vmware|spice-vdagent|qemu-guest-agent|mcelog' \
  || true

echo "=== Package count ==="
rpm -qa | wc -l

echo "=== Validation passed ==="
