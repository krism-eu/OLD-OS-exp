#!/usr/bin/env bash

set -euo pipefail

REQUIRED_FILES=(
  /usr/bin/rakuos
  /usr/libexec/rakuos/rakuos-install
  /usr/libexec/rakuos/rakuos-remove
  /usr/libexec/rakuos/rakuos-update
  /usr/libexec/rakuos/rakuos-overlay-mount
  /usr/libexec/rakuos/rakuos-overlay-sync
  /usr/libexec/rakuos/rakuos-overlay-services
  /usr/libexec/rakuos/generate-base-manifest
)

for file in "${REQUIRED_FILES[@]}"; do
  if [[ ! -e "$file" ]]; then
    echo "ERROR: missing required RakuOS file: $file" >&2
    exit 1
  fi

  if [[ ! -x "$file" ]]; then
    echo "ERROR: RakuOS file is not executable: $file" >&2
    exit 1
  fi
done

for unit in \
  rakuos-overlay-mount.service \
  rakuos-overlay-sync.service \
  rakuos-overlay-services.service
do
  if [[ ! -e "/usr/lib/systemd/system/$unit" ]]; then
    echo "ERROR: missing RakuOS systemd unit: $unit" >&2
    exit 1
  fi
done

echo "RakuOS base validation successful."
