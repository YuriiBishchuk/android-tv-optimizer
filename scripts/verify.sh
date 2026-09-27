#!/usr/bin/env bash
# scripts/verify.sh — швидка перевірка стану: HOME / focused / disabled / RAM / телеметрія.
# Використання: TV_IP=192.168.0.103:5555 ./scripts/verify.sh
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
DEVICE_CONF="${DEVICE_CONF:-$REPO_DIR/devices/xiaomi_a_pro_2026.conf}"
# shellcheck disable=SC1090
source "$DEVICE_CONF" 2>/dev/null || PROJECTIVY_PKG="com.spocky.projengmenu"
A="${ADB:-adb}"
if [[ -n "${TV_IP:-}" ]]; then $A connect "$TV_IP" >/dev/null 2>&1 || true; fi
echo "== disabled ==";                      $A shell pm list packages -d
echo "== preferred ==";                     $A shell dumpsys package preferred 2>/dev/null | head -n 14
echo "== role HOME ==";                     $A shell cmd role get-role-holders android.app.role.HOME
echo "== default launcher ==";              $A shell cmd shortcut get-default-launcher 2>/dev/null || true
echo "== telemetry (порожньо = мертва) =="; $A shell pm list packages 2>/dev/null | grep -E 'miui.tv.analytics|mitv.tvhome.atv|tvmanager|statistic|milegal|webcontent|partnercustomizer' || echo "(none — telemetry gone)"
echo "== key apps ==";                      $A shell pm list packages 2>/dev/null | grep -E 'megogo|youtube|spocky|launcherx' || true
echo "== procs ==";                         $A shell "pidof $PROJECTIVY_PKG; pidof com.google.android.apps.tv.launcherx" 2>&1 || true
echo "== focused ==";                       $A shell dumpsys activity activities 2>/dev/null | grep -i -E 'topResumedActivity|mFocusedApp' | head -n 4
echo "== mem ==";                           $A shell free -m 2>/dev/null | head -n 5 || true
echo "== uptime ==";                        $A shell uptime
