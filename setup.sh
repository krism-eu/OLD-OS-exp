#!/bin/bash
set -e
echo "🦎 Inizializzazione microRaku..."
mkdir -p microraku/{dracut,lib,systemd,bin}

cat > LICENSE << 'EOF'
GNU GENERAL PUBLIC LICENSE
Version 3, 29 June 2007
Copyright (C) 2007 Free Software Foundation, Inc.
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
EOF

cat > SPEC.md << 'EOF'
# Persistent Overlay — Specifica Tecnica

## Principio
Su qualsiasi sistema immutabile dove `/usr` è read-only e `/var` è persistente,
montare un overlayfs su `/usr` permette di installare pacchetti nativi che
sopravvivono agli aggiornamenti della base.

## Requisiti
1. `/usr` read-only (base immutabile)
2. `/var` persistente e separato
3. Dracut / initramfs
4. OverlayFS nel kernel (Linux >= 3.18)
EOF

cat > .gitignore << 'EOF'
node_modules/
dist/
*.rpm
*.tar.gz
*.log
EOF

cat > microraku/dracut/module-setup.sh << 'EOF'
#!/bin/bash
check() {
    [[ -e /sys/module/overlay ]] && return 0
    modprobe overlay 2>/dev/null && return 0
    return 1
}
depends() { echo "bash"; return 0; }
install() {
    inst_simple "$moddir/mount-overlay.sh" "/usr/lib/microraku/mount-overlay.sh"
    chmod +x "${initdir}/usr/lib/microraku/mount-overlay.sh"
    inst_hook pre-pivot 50 "$moddir/mount-overlay.sh"
    hostonly="" instmods overlay
    inst_multiple mount findmnt mkdir rm date touch
}
installkernel() { instmods overlay; }
EOF

cat > microraku/dracut/mount-overlay.sh << 'EOF'
#!/bin/bash
set -euo pipefail
OVERLAY_BASE="/var/lib/microraku"
UPPER="${OVERLAY_BASE}/usr/upper"
WORK="${OVERLAY_BASE}/usr/work"
if [ -n "${NEWROOT:-}" ]; then
    LOWER="${NEWROOT}/usr"
    UPPER="${NEWROOT}${UPPER}"
    WORK="${NEWROOT}${WORK}"
    OVERLAY_BASE="${NEWROOT}${OVERLAY_BASE}"
else
    LOWER="/usr"
fi
info() { echo "[microraku] $*"; }
warn() { echo "[microraku] WARNING: $*" >&2; }
if command -v getargbool >/dev/null 2>&1; then
    if getargbool 0 microraku=0 || getargbool 0 nomicroraku; then
        info "disabled"; exit 0
    fi
fi
if ! findmnt -n -o TARGET "${NEWROOT:-}/var" >/dev/null 2>&1; then
    warn "/var not mounted"; exit 0
fi
mkdir -p "$UPPER" "$WORK"
if command -v getargbool >/dev/null 2>&1; then
    if getargbool 0 microraku.reset; then
        info "RESETTING overlay"; rm -rf "${UPPER:?}"/* "${WORK:?}"/*
    fi
fi
info "mounting overlayfs on ${LOWER}"
if mount -t overlay overlay -o "lowerdir=${LOWER},upperdir=${UPPER},workdir=${WORK},index=on,metacopy=on" "${LOWER}"; then
    info "overlay mounted successfully"
    mkdir -p "${OVERLAY_BASE}/state"
    date -Iseconds > "${OVERLAY_BASE}/state/last-mount"
else
    warn "FAILED to mount overlay"
    touch "${OVERLAY_BASE}/.corrupted"
    info "continuing without overlay"
    exit 0
fi
EOF

cat > microraku/lib/sync.sh << 'EOF'
#!/bin/bash
set -euo pipefail
OVERLAY_BASE="/var/lib/microraku"
MANIFEST="${OVERLAY_BASE}/packages.toml"
INSTALL_CMD="zypper --non-interactive install"
REMOVE_CMD="zypper --non-interactive remove"
QUERY_CMD="rpm -q"
log() { echo "[microraku-sync] $*"; }
if ! findmnt -n -o FSTYPE /usr | grep -q overlay; then
    log "ERROR: /usr not overlay"; exit 1
fi
[ ! -f "$MANIFEST" ] && { log "No manifest"; exit 0; }
log "Starting sync..."
PACKAGES=()
while IFS= read -r line; do
    pkg=$(echo "$line" | grep '^name = ' | sed 's/name = "//;s/"$//')
    [ -n "$pkg" ] && PACKAGES+=("$pkg")
done < "$MANIFEST"
log "Found ${#PACKAGES[@]} packages"
TO_REINSTALL=()
for pkg in "${PACKAGES[@]}"; do
    if $QUERY_CMD "$pkg" >/dev/null 2>&1; then
        log "  $pkg: in base, removing"; $REMOVE_CMD "$pkg" 2>/dev/null || true
    else
        log "  $pkg: keeping"; TO_REINSTALL+=("$pkg")
    fi
done
if [ ${#TO_REINSTALL[@]} -gt 0 ]; then
    log "Reinstalling ${#TO_REINSTALL[@]}..."
    $INSTALL_CMD "${TO_REINSTALL[@]}" || for pkg in "${TO_REINSTALL[@]}"; do
        $INSTALL_CMD "$pkg" 2>/dev/null || log "  FAILED: $pkg"
    done
fi
command -v rpm >/dev/null 2>&1 && rpm --rebuilddb 2>/dev/null || true
mkdir -p "${OVERLAY_BASE}/state"
date -Iseconds > "${OVERLAY_BASE}/state/last-sync"
log "Sync complete. ${#TO_REINSTALL[@]} packages in overlay."
EOF

cat > microraku/systemd/microraku-sync.service << 'EOF'
[Unit]
Description=microRaku Sync
After=local-fs.target var.mount network-online.target
Wants=network-online.target
ConditionPathExists=/var/lib/microraku/packages.toml
ConditionPathIsMountPoint=/usr

[Service]
Type=oneshot
ExecStart=/usr/libexec/microraku/sync.sh
RemainAfterExit=yes
TimeoutStartSec=600

[Install]
WantedBy=multi-user.target
EOF

cat > microraku/bin/microraku-install << 'EOF'
#!/bin/bash
set -euo pipefail
OVERLAY_BASE="/var/lib/microraku"
MANIFEST="${OVERLAY_BASE}/packages.toml"
INSTALL_CMD="zypper --non-interactive install"
QUERY_CMD="rpm -q"
if ! findmnt -n -o FSTYPE /usr | grep -q overlay; then
    echo "ERROR: /usr not overlay" >&2; exit 1
fi
PACKAGES=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        -y) INSTALL_CMD="$INSTALL_CMD --no-confirm"; shift ;;
        -h|--help) echo "Usage: microraku-install <pkg>..."; exit 0 ;;
        *) PACKAGES+=("$1"); shift ;;
    esac
done
[ ${#PACKAGES[@]} -eq 0 ] && { echo "No packages" >&2; exit 1; }
echo "🦎 Installing: ${PACKAGES[*]}"
$INSTALL_CMD "${PACKAGES[@]}"
mkdir -p "$(dirname "$MANIFEST")"
for pkg in "${PACKAGES[@]}"; do
    [ -f "$MANIFEST" ] && sed -i "/^name = \"$pkg\"$/,/^$/d" "$MANIFEST"
    VER=$($QUERY_CMD --qf '%{VERSION}' "$pkg" 2>/dev/null || echo "latest")
    cat >> "$MANIFEST" << EOT

[[package]]
name = "$pkg"
version = "$VER"
installed = "$(date -Iseconds)"
EOT
    echo "  ✓ $pkg ($VER)"
done
echo "✅ Done!"
EOF

cat > microraku/bin/microraku-list << 'EOF'
#!/bin/bash
MANIFEST="/var/lib/microraku/packages.toml"
[ ! -f "$MANIFEST" ] && { echo " lizard No packages"; exit 0; }
echo " lizard microRaku — Packages:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
name=""; ver=""; inst=""
while IFS= read -r line; do
    [[ "$line" =~ ^name\ =\ \"(.+)\"$ ]] && name="${BASH_REMATCH[1]}"
    [[ "$line" =~ ^version\ =\ \"(.+)\"$ ]] && ver="${BASH_REMATCH[1]}"
    [[ "$line" =~ ^installed\ =\ \"(.+)\"$ ]] && {
        inst="${BASH_REMATCH[1]}"
        [ -n "$name" ] && printf "  %-25s %s\n" "$name" "$ver"
        name=""; ver=""; inst=""
    }
done < "$MANIFEST"
EOF

cat > microraku/bin/microraku-remove << 'EOF'
#!/bin/bash
set -euo pipefail
MANIFEST="/var/lib/microraku/packages.toml"
[ $# -eq 0 ] && { echo "Usage: microraku-remove <pkg>..."; exit 1; }
echo " lizard Removing: $*"
zypper --non-interactive remove "$@"
for pkg in "$@"; do
    [ -f "$MANIFEST" ] && sed -i "/^name = \"$pkg\"$/,/^$/d" "$MANIFEST"
done
echo "✅ Done!"
EOF

cat > microraku/bin/microraku-reset << 'EOF'
#!/bin/bash
set -euo pipefail
BASE="/var/lib/microraku"
echo " lizard Reset overlay?"
read -p "Are you sure? (yes/no): " c
[ "$c" != "yes" ] && { echo "Aborted"; exit 0; }
[ -d "$BASE/usr/upper" ] && rm -rf "${BASE}/usr/upper"/*
[ -d "$BASE/usr/work" ] && rm -rf "${BASE}/usr/work"/*
echo "✅ Reset! Reboot required."
EOF

cat > microraku/install.sh << 'EOF'
#!/bin/bash
set -euo pipefail
[ "$EUID" -ne 0 ] && { echo "Run as root" >&2; exit 1; }
echo " lizard microRaku Installer"
mkdir -p /var/lib/microraku/{usr/upper,usr/work,cache,state,rpmdb}
[ ! -f /var/lib/microraku/packages.toml ] && echo "# microRaku manifest" > /var/lib/microraku/packages.toml
echo "==> Installing dracut module..."
mkdir -p /usr/lib/dracut/modules.d/90microraku
cp dracut/*.sh /usr/lib/dracut/modules.d/90microraku/
chmod +x /usr/lib/dracut/modules.d/90microraku/*.sh
echo "==> Installing sync service..."
mkdir -p /usr/libexec/microraku
cp lib/sync.sh /usr/libexec/microraku/
chmod +x /usr/libexec/microraku/sync.sh
cp systemd/microraku-sync.service /usr/lib/systemd/system/
systemctl daemon-reload && systemctl enable microraku-sync.service
echo "==> Installing CLI tools..."
cp bin/microraku-* /usr/bin/
chmod +x /usr/bin/microraku-*
echo "==> Rebuilding initrd..."
command -v dracut >/dev/null 2>&1 && dracut --force || echo "⚠ dracut not found"
echo ""
echo "✅ Done! Reboot and test:"
echo "  sudo reboot"
echo "  sudo microraku-install htop"
echo "  microraku-list"
EOF

cat > microraku/GUIDE.md << 'EOF'
# Guida microRaku

## Installazione
```bash
cd microraku && sudo ./install.sh && sudo reboot
