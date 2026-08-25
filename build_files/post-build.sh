#!/usr/bin/env bash
set -ouex pipefail

mv /usr/bin/dnf5 /usr/bin/dnf5.real
mv /usr/bin/dnf /usr/bin/dnf.real

dnf5.real -y mark dependency $(rpm -qa --qf '%{NAME} ') --skip-unavailable

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

cat > /usr/bin/dnf << 'WRAPPER'
#!/usr/bin/env bash
exec /usr/bin/dnf5 "$@"
WRAPPER

chmod +x /usr/bin/dnf5 /usr/bin/dnf

PROTECTED_FILE="/usr/share/rakuos/protected-packages.txt"
mkdir -p /usr/share/rakuos
: > "$PROTECTED_FILE"

cat >> "$PROTECTED_FILE" <<'EOF'

# myrakuOS base packages
flatpak
podman
distrobox
podman-compose
libxcrypt-compat
rsync
fuse
squashfuse
sqlite3
openssl
libnotify
inotify-tools
unzip
appstream
appstream-data
fwupd
fedora-logos
EOF

/usr/libexec/rakuos/generate-base-manifest
