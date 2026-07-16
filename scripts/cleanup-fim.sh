#!/usr/bin/env bash

set -euo pipefail

LAB_DIR="/opt/socforge/fim"

echo "[*] Cleaning FIM lab..."

rm -f "${LAB_DIR}"/*

echo "[✓] Cleanup complete."
