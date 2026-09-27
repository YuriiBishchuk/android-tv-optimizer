#!/usr/bin/env bash
# scripts/audit.sh — універсальний аудит "що можна почистити" (read-only за замовчуванням).
# Ідея з community: bloat.txt-патерн (tutyamxx) + tiers як в UAD (0x192) +
# safe/minimal списки (seun-novodev) + Xiaomi-список (danilenko-gist), див. docs/COMMUNITY_LISTS.md.
#
# Використання:
#   TV_IP=IP:PORT ./scripts/audit.sh                        # звіт: TIER_1/2/3 + PROTECTED
#   TV_IP=IP:PORT ./scripts/audit.sh --apply-tier1           # видалити ТІЛЬКИ tier1 що є на ТВ (з бекапом)
#   TV_IP=IP:PORT ./scripts/audit.sh --apply-bloat file.txt  # видалити пакети з файла (по одному на рядок, # коментар)
# Відкат: pm install-existing --user 0 <pkg>  (бекап-список друкується перед apply)
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
DEVICE_CONF="${DEVICE_CONF:-$REPO_DIR/devices/xiaomi_a_pro_2026.conf}"
# shellcheck disable=SC1090
source "$DEVICE_CONF" 2>/dev/null || true
A="${ADB:-adb}"
MODE="${1:-report}"
if [[ -n "${TV_IP:-}" ]]; then $A connect "$TV_IP" >/dev/null 2>&1 || true; fi
$A shell echo ok 2>/dev/null | grep -q ok || { echo "ERROR: ADB не підключено. Задай TV_IP=IP:PORT"; exit 1; }

# --- TIER_1: підтверджено безпечні на MiTV-MZTU0 (живий тест 27.09.2026, не воскресають) ---
TIER_1=(
  com.xiaomi.statistic com.xiaomo.tv.milegal com.xm.webcontent
  com.xiaomi.android.tvsetup.partnercustomizer
  com.mitv.tvhome.mitvplus com.mitv.tvhome.michannel com.mitv.tvhome.oemtab
  com.mitv.toolhouse com.xiaomi.tvqs.overseas.y24 com.mitv.overseaservice
  com.mitv.tvhome.atv com.miui.tv.analytics com.xiaomi.mitv.tvmanager
  com.android.tv.feedbackconsent com.google.android.feedback
  com.android.federatedcompute.services com.android.ondevicepersonalization.services
  com.android.nearby.halfsheet com.android.printspooler com.google.android.play.games
)
# --- TIER_2: community-safe (gist/UAD/toolkit), але на нашій прошивці: відсутні або OPTIONAL ---
TIER_2=(
  com.google.android.tvrecommendations com.google.android.leanbacklauncher.recommendations
  com.google.android.videos com.google.android.music
  com.android.providers.calendar com.android.providers.contacts
  com.google.android.syncadapters.calendar
  com.tcl.browser com.tcl.tv.appstore com.tcl.tv.cast com.tcl.usercenter
  com.tcl.tclaccount com.tcl.tv.tcloudaccount com.tcl.gallery com.tcl.mediacenter
  com.tcl.screenadservice com.tcl.screensaver com.tcl.eula
  com.amazon.amazonvideo.livingroom com.netflix.ninja com.netflix.tokenmanager com.iqiyi.i18n.tv
  com.google.android.youtube.tv com.google.android.youtube.tvmusic
  com.google.android.tts com.mitv.upgrader com.xiaomi.mitv.updateservice
  com.mitv.gallery com.mitv.videoplayer com.mitv.mediaexplorer com.xiaomi.mimusic2
  com.mitv.smartshare com.mitv.tvhome.scenemode
)
# shellcheck disable=SC2034
PROTECTED_LIST=(${PROTECTED[@]:-} android com.android.systemui com.android.vending
  com.google.android.gms com.google.android.apps.tv.launcherx mitv.service com.mitv.tvhome)

INSTALLED="$($A shell pm list packages 2>/dev/null | sed 's/^package://' | tr -d '\r' | sort)"
have() { echo "$INSTALLED" | grep -qx "$1"; }

echo "== audit report: $(echo "$INSTALLED" | wc -l) пакетів на ТВ =="
echo "--- TIER_1 present (безпечно чистити, перевірено на цьому ТВ) ---"
T1P=()
for p in "${TIER_1[@]}"; do have "$p" && { echo "  PRESENT  $p"; T1P+=("$p"); } || echo "  gone     $p"; done
echo "--- TIER_2 present (community-safe, але вирішуй сам / OPTIONAL) ---"
T2P=()
for p in "${TIER_2[@]}"; do have "$p" && { echo "  PRESENT  $p"; T2P+=("$p"); } || true; done
[[ ${#T2P[@]} -eq 0 ]] && echo "  (немає)"
echo "--- TIER_3 heuristic (keywords, РУЧНЕ підтвердження!) ---"
echo "$INSTALLED" | grep -i -E 'analytics|telemetry|tracker|acr|adservice|recommend|promo|demo|retail|partnercustomizer|printspooler|nearby.halfsheet|feedback|federated|personalization' || echo "  (немає збігів)"
echo "--- PROTECTED present (НЕ ЧІПАТИ) ---"
# NOTE: com.mitv.tvhome (базовий) в цій прошивці відсутній як пакет — є тільки
# mitv.service + livetv/setup. Тому MISSING по tvhome тут = норма, не тривога.
for p in mitv.service com.mitv.livetv com.mitv.setup com.mitv.videoplayer com.google.android.apps.tv.launcherx com.google.android.tungsten.setupwraith com.android.systemui android; do
  have "$p" && echo "  PROTECTED-OK $p" || echo "  MISSING?!    $p"
done

do_uninstall() {
  echo "--- backup removed list: $* ---"
  for p in "$@"; do
    skip=0
    for pr in "${PROTECTED_LIST[@]}"; do [[ "$p" == "$pr" ]] && { echo "SKIP protected $p"; skip=1; break; }; done
    [[ $skip -eq 1 ]] && continue
    [[ "$p" == "${STOCK_LAUNCHER:-com.google.android.apps.tv.launcherx}" ]] && { echo "SKIP stock launcher $p"; continue; }
    echo -n "uninstall $p ... "
    $A shell pm uninstall --user 0 "$p" 2>&1 | tr '\n' ' '; echo
  done
}

if [[ "$MODE" == "--apply-tier1" ]]; then
  if [[ ${#T1P[@]} -eq 0 ]]; then echo "TIER_1 вже чистий — нічого робити."; exit 0; fi
  echo "Видаляю TIER_1 (${#T1P[@]} шт). Відкат: pm install-existing --user 0 <pkg>"
  do_uninstall "${T1P[@]}"
elif [[ "$MODE" == "--apply-bloat" ]]; then
  F="${2:-}"; [[ -z "$F" || ! -f "$F" ]] && { echo "ERROR: вкажи файл: --apply-bloat bloat.txt"; exit 1; }
  mapfile -t WANT < <(grep -v -E '^\s*(#|$)' "$F" | tr -d '\r' | awk '{print $1}')
  echo "З файла $F: ${#WANT[@]} пакетів."
  TO_DO=(); for p in "${WANT[@]}"; do have "$p" && TO_DO+=("$p") || echo "  not installed: $p"; done
  [[ ${#TO_DO[@]} -eq 0 ]] && { echo "Нема чого видаляти."; exit 0; }
  do_uninstall "${TO_DO[@]}"
elif [[ "$MODE" != "report" ]]; then
  echo "Невідомий режим $MODE. report | --apply-tier1 | --apply-bloat <file>"
  exit 1
fi
echo "== done =="
