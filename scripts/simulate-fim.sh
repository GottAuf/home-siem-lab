#!/usr/bin/env bash

# =====================================================
# SOCForge - File Integrity Monitoring Simulation
# =====================================================

set -euo pipefail

LAB_DIR="/opt/socforge/fim"
TEST_FILE="${LAB_DIR}/socforge_test.txt"

echo "[*] Starting File Integrity Monitoring simulation..."

mkdir -p "${LAB_DIR}"

echo "[1/4] Creating test file..."
echo "SOCForge FIM Test" > "${TEST_FILE}"

sleep 5

echo "[2/4] Modifying file..."
echo "Modification at $(date)" >> "${TEST_FILE}"

sleep 5

echo "[3/4] Changing permissions..."
chmod 777 "${TEST_FILE}"

sleep 5

echo "[4/4] Deleting file..."
rm -f "${TEST_FILE}"

echo
echo "[✓] Simulation complete."
echo "Check the Wazuh Dashboard for FIM alerts."
