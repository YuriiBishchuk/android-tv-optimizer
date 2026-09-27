#!/usr/bin/env bash
# scripts/set-home.sh — призначити Projectivy дефолтним HOME.
# Еквівалент ручного вибору в чойзері (mAlways=true + Role HOME), плюс страховка fallback.
# Використання:
#   DEVICE_CONF=devices/xiaomi_a_pro_2026.conf ./scripts/set-home.sh
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
DEVICE_CONF="${DEVICE_CONF:-$REPO_DIR/devices/xiaomi_a_pro_2026.conf}"
# shellcheck disable=SC1090
source "$DEVICE_CONF"
A="${ADB:-adb}"
if [[ -n "${TV_IP:-}" ]]; then $A connect "$TV_IP" >/dev/null 2>&1 || true; fi
$A shell echo ok 2>/dev/null | grep -q ok || { echo "ERROR: ADB не підключено. Задай TV_IP=IP:PORT"; exit 1; }

echo "== set-home -> $PROJECTIVY_PKG =="
$A shell pm enable "$STOCK_LAUNCHER" 2>&1 | tr '\n' ' '; echo " (fallback enabled, це навмисно)"
$A shell cmd role add-role-holder --user 0 android.app.role.HOME "$PROJECTIVY_PKG" 2>&1 | tr '\n' ' '; echo
$A shell pm set-home-activity --user 0 "$PROJECTIVY_PKG" 2>&1 | tr '\n' ' '; echo
echo "--- перевірка ---"
$A shell cmd role get-role-holders android.app.role.HOME
$A shell cmd shortcut get-default-launcher 2>/dev/null || true
$A shell dumpsys package preferred 2>/dev/null | head -n 14
echo "== done. Очікувано: role + preferred + default-launcher = $PROJECTIVY_PKG =="
