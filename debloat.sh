#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TV_IP="192.168.0.66:5555"

echo "=================================================="
echo "  KIVI Kids TV Debloat & Maximum Acceleration"
echo "=================================================="

echo "[1/6] Підключення до ADB ($TV_IP)..."
adb connect "$TV_IP"
adb devices

echo "[2/6] Встановлення офіційного Projectivy Launcher v4.71..."
if [ -f "$SCRIPT_DIR/ProjectivyLauncher.apk" ]; then
    adb install -r "$SCRIPT_DIR/ProjectivyLauncher.apk"
    echo " -> Projectivy Launcher успішно встановлено!"
else
    echo " -> [!] Помилка: APK не знайдено в $SCRIPT_DIR"
fi

# 1. Safe Bloatware & Telemetry Packages
SAFE_BLOATWARE=(
    "kivi.media"                                            # Kivi Media Hub
    "tv.anoki.acr.anokiacroptin"                           # Anoki ACR (Телеметрія/трекінг)
    "fusion.android.tv.demo"                               # Демо-режим магазину (MtcRetailDisplay)
    "com.google.android.tvrecommendations"                # Рекламні рекомендації Google
    "com.google.android.videos"                           # Google Play Фільми
    "com.google.android.play.games"                        # Google Play Ігри
    "com.google.android.syncadapters.calendar"            # Календар Синхронізація
    "com.mediatek.android.leanbacklauncher.partnercustomizer" # Партнерські промо
    "com.cltv.fast"                                        # CLTV FAST рекламні канали
    "android.autoinstalls.config.mtc.jvc"                 # Auto-installs stub
    "com.mstar.android.tv.disclaimercustomization"         # Vendor Disclaimer
)

echo "[3/6] Безпечне очищення рекламного ПЗ та трекерів..."
for pkg in "${SAFE_BLOATWARE[@]}"; do
    echo " -> Видалення $pkg..."
    adb shell pm uninstall -k --user 0 "$pkg" 2>/dev/null || echo "    [i] Пакет $pkg вже відсутній або видалений."
done

echo "[4/6] Прискорення графічного інтерфейсу (Твік анімацій)..."
# Зменшуємо анімації з 1.0x до 0.5x для миттєвого відгуку на пульт
adb shell settings put global window_animation_scale 0.5
adb shell settings put global transition_animation_scale 0.5
adb shell settings put global animator_duration_scale 0.5
echo " -> Шкалу анімацій встановлено на 0.5x (миттєвий відгук вікон)."

echo "[5/6] Призначення Projectivy Launcher..."
adb shell cmd package set-home-activity com.spocky.projlauncher/.ui.main.MainActivity 2>/dev/null || true

echo "=================================================="
echo "  [✅] МАКСИМАЛЬНЕ ПРИСКОРЕННЯ ЗАВЕРШЕНО!"
echo "=================================================="
echo "Для відновлення будь-якого видаленого пакету:"
echo "  adb shell pm install-existing --user 0 <пакет>"
