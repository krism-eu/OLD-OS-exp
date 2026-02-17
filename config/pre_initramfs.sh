#!/usr/bin/env bash
set -euo pipefail

echo "🔧 Preparing initramfs for CachyOS kernel..."

# Detect installed CachyOS kernel
QUALIFIED_KERNEL=$(rpm -q --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}\n' kernel-cachyos)

if [ -z "$QUALIFIED_KERNEL" ]; then
    echo "❌ kernel-cachyos not found!"
    exit 1
fi

echo "✔ Found kernel: $QUALIFIED_KERNEL"

# Ensure modules dependency file exists
depmod "$QUALIFIED_KERNEL"

# Optional: enforce reproducible + zstd compression
cat > /etc/dracut.conf.d/99-rakuos-cachyos.conf <<EOF
hostonly=no
compress="zstd"
reproducible=yes
EOF

echo "✔ Dracut configured for CachyOS kernel"