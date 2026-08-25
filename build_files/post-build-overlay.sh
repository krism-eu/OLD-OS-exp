#!/usr/bin/env bash
set -euo pipefail

DEFAULT_PACKAGES_LIST="/usr/share/rakuos/packages.list"
PACKAGES_LIST="/var/lib/rakuos/packages.list"
UPPER_DIR="/var/lib/rakuos/overlay/upper"
WORK_DIR="/var/lib/rakuos/overlay/work"
STATE_FILE="/var/lib/rakuos/overlay.state"
DIRTY_FILE="/var/lib/rakuos/overlay.dirty"

mkdir -p /usr/share/rakuos /var/lib/rakuos "$UPPER_DIR" "$WORK_DIR"

# ─── packages.list ──────────────────────────────────────────────────────────
# Lasciato vuoto: tutti i pacchetti sono già nell'immagine base.
# Se vuoi installare pacchetti al primo avvio (es. rclone, btop),
# decommenta le righe qui sotto.
cat > "$DEFAULT_PACKAGES_LIST" <<'EOF'
# Pacchetti opzionali da installare al primo avvio (NON nell'immagine base)
# rclone
# btop
# fastfetch
# openssh-server
# hunspell-it
# unrar-free
# fzf
# bash-completion
EOF

cp "$DEFAULT_PACKAGES_LIST" "$PACKAGES_LIST"
rm -f "$STATE_FILE" "$DIRTY_FILE"

# ─── protected-packages.txt ──────────────────────────────────────────────────
# Non toccare: viene gestito dalla base RakuOS (ereditato).
echo "post-build-overlay.sh: protected-packages.txt lasciato invariato."

# ─── Genera manifest ────────────────────────────────────────────────────────
if [ -x /usr/libexec/rakuos/generate-base-manifest ]; then
    /usr/libexec/rakuos/generate-base-manifest
else
    echo "WARNING: generate-base-manifest non trovato – saltato."
fi

echo "post-build-overlay.sh completato."
