#!/usr/bin/env bash
# scripts/debloat.sh — safe uninstall --user 0 по SAFE_REMOVE з devices/*.conf
# Використання:
#   DEVICE_CONF=devices/xiaomi_a_pro_2026.conf ./scripts/debloat.sh            # dry-run
#   DEVICE_CONF=devices/xiaomi_a_pro_2026.conf ./scripts/debloat.sh --apply    # реально видалити
#   TV_IP=192.168.0.103:5555 DEVICE_CONF=devices/xiaomi_a_pro_2026.conf ./scripts/debloat.sh --apply
# Відкат одного пакета: adb shell pm install-existing --user 0 <pkg>
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
DEVICE_CONF="${DEVICE_CONF:-$REPO_DIR/devices/xiaomi_a_pro_2026.conf}"
APPLY=0; [[ "${1:-}" == "--apply" ]] && APPLY=1
# shellcheck disable=SC1090
source "$DEVICE_CONF"
A="${ADB:-adb}"
if [[ -n "${TV_IP:-}" ]]; then $A connect "$TV_IP" >/dev/null 2>&1 || true; fi
$A shell echo ok 2>/dev/null | grep -q ok || { echo "ERROR: ADB не підключено. Задай TV_IP=IP:PORT"; exit 1; }

echo "== debloat (device: $DEVICE_MODEL) apply=$APPLY =="
echo "-- protected guard: ці пакети НЕ будуть чіпатись навіть якщо потраплять у список:"
printf '   %s\n' "${PROTECTED[@]:-}"
for pkg in "${SAFE_REMOVE[@]}"; do
  for p in "${PROTECTED[@]:-}"; do
    if [[ "$pkg" == "$p" ]]; then echo "SKIP protected $pkg"; continue 2; fi
  done
  if [[ "$pkg" == "$STOCK_LAUNCHER" ]]; then echo "SKIP stock launcher $pkg (fallback!)"; continue; fi
  if [[ $APPLY -eq 1 ]]; then
    echo -n "uninstall $pkg ... "
    $A shell pm uninstall --user 0 "$pkg" 2>&1 | tr '\n' ' '; echo
  else
    echo "would uninstall $pkg"
  fi
done
if [[ "${DISABLE_ONLY:-}" ]]; then
  for pkg in "${DISABLE_ONLY[@]}"; do
    if [[ $APPLY -eq 1 ]]; then
      echo -n "disable $pkg ... "
      $A shell pm disable-user --user 0 "$pkg" 2>&1 | tr '\n' ' '; echo
    else
      echo "would disable $pkg"
    fi
  done
fi
echo "== done. Відкат: adb shell pm install-existing --user 0 <pkg> =="
