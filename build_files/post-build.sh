#!/usr/bin/env bash

set -euo pipefail

echo "[rakuos-custom] running post-build..."

if [[ ! -x /usr/bin/rakuos ]]; then
    echo "ERROR: /usr/bin/rakuos is missing" >&2
    exit 1
fi

echo "[rakuos-custom] post-build complete."
