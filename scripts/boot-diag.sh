#!/usr/bin/env bash
# scripts/boot-diag.sh — діагностика зависання на splash / чорному екрані.
# Збирає те саме що врятувало 27.09.2026: crash + focused + home task.
# Використання: TV_IP=192.168.0.103:5555 ./scripts/boot-diag.sh
set -euo pipefail
A="${ADB:-adb}"
if [[ -n "${TV_IP:-}" ]]; then $A connect "$TV_IP" >/dev/null 2>&1 || true; fi
echo "== uptime ==";            $A shell uptime
echo "== crash (android.display positionChildAt?) =="; $A shell logcat -b crash -t 100 2>/dev/null | tail -n 40
echo "== system warnings ==";   $A shell logcat -b system '*:W' -t 200 2>/dev/null | tail -n 30 || $A shell logcat -b system -t 200 2>/dev/null | tail -n 30
echo "== focused/home tasks =="; $A shell dumpsys activity activities 2>/dev/null | grep -i -E 'mFocusedApp|topResumed|type=home|projengmenu|launcherx|FallbackHome' | head -n 25
echo "== home role/preferred =="; $A shell cmd role get-role-holders android.app.role.HOME; $A shell dumpsys package preferred 2>/dev/null | head -n 14
echo "== procs ==";             $A shell "pidof com.spocky.projengmenu; pidof com.google.android.apps.tv.launcherx; pidof system_server" 2>&1 || true
