#!/bin/bash

set -ouex pipefail

# Rename real dnf5 and dnf binaries
mv /usr/bin/dnf5 /usr/bin/dnf5.real
mv /usr/bin/dnf /usr/bin/dnf.real

# Mark all base image packages as dependency so PackageKit only manages overlay packages
dnf5.real mark dependency $(rpm -qa --qf '%{NAME} ') --skip-unavailable 

# Create dnf5 wrapper
cat > /usr/bin/dnf5 << 'WRAPPER'
#!/usr/bin/env bash
COMMAND="${1:-}"
case "$COMMAND" in
    install)
        shift
        exec rakuos install "$@"
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

# Create dnf wrapper
cat > /usr/bin/dnf << 'WRAPPER'
#!/usr/bin/env bash
exec /usr/bin/dnf5 "$@"
WRAPPER

# Make both executable
chmod +x /usr/bin/dnf5 /usr/bin/dnf

echo "RakuOS dnf/dnf5 wrappers installed successfully."