#!/usr/bin/env bash
set -eoux pipefail

# Install a different kernel
dnf -y copr enable bieszczaders/kernel-cachyos
dnf swap -y kernel kernel-cachyos-core