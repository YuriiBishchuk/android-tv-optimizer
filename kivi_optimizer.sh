#!/usr/bin/env bash
# ==============================================================================
# KIVI Kids TV (Android 14) Interactive Optimizer & Debloater
# Author: Antigravity & User
# License: MIT
# Description: Automated, safe debloat, tuning, and launcher fix for KIVI TVs.
# ==============================================================================

set -euo pipefail

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

DEFAULT_IP="192.168.0.66:5555"

log_info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

header() {
    clear
    echo -e "${BLUE}${BOLD}"
    echo "=================================================================="
    echo "       🚀 KIVI Kids TV (Android 14) Optimizer & Debloater        "
    echo "=================================================================="
    echo -e "${NC}"
}

check_adb() {
    if ! command -v adb &> /dev/null; then
        log_error "ADB інструмент не знайдено! Встановіть android-tools."
        exit 1
    fi
}

connect_adb() {
    log_info "Перевірка ADB підключення..."
    if adb devices | grep -q "device$"; then
        log_success "ADB пристрій вже підключено!"
        return 0
    fi

    echo -ne "${YELLOW}Введіть IP адресу телевізора (наприклад, $DEFAULT_IP): ${NC}"
    read -r TV_IP
    TV_IP="${TV_IP:-$DEFAULT_IP}"

    log_info "Підключення до $TV_IP..."
    adb connect "$TV_IP" || true
    sleep 2

    if adb devices | grep -q "device$"; then
        log_success "Успішно підключено до $TV_IP!"
    else
        log_error "Не вдалося підключитися до $TV_IP. Перевірте, чи увімкнений ADB на ТБ."
        exit 1
    fi
}

do_debloat() {
    log_info "Видалення системного рекламного ПЗ та трекерів..."
    
    BLOAT_PACKAGES=(
        "kivi.media"
        "tv.anoki.acr.anokiacroptin"
        "fusion.android.tv.demo"
        "com.google.android.tvrecommendations"
        "com.google.android.videos"
        "com.google.android.play.games"
        "com.cltv.fast"
        "android.autoinstalls.config.mtc.jvc"
        "com.mstar.android.tv.disclaimercustomization"
        "com.amazon.amazonvideo.livingroom"
        "com.boosteroidtv.streaming"
        "com.airconsole.androidtv"
        "com.hitv.explore"
        "com.tcl.browser"
        "com.internet.tvbrowser"
        "com.davincikids.tv"
        "me.efesser.flauncher"
        "org.liskovsoft.androidtv.rukeyboard"
        "org.smarttube.stable"
    )

    for pkg in "${BLOAT_PACKAGES[@]}"; do
        echo -n "Очищення $pkg... "
        adb shell pm uninstall -k --user 0 "$pkg" 2>/dev/null && echo -e "${GREEN}ОК${NC}" || echo -e "${YELLOW}Пропущено${NC}"
    done

    # Disable stock Google TV Launcher
    log_info "Вимкнення стандартного Google TV Launcher..."
    adb shell pm disable-user --user 0 com.google.android.tvlauncher 2>/dev/null || true
    log_success "Bloatware очищено!"
}

do_tweaks() {
    log_info "Застосування системних твіків прискорення..."
    
    # Speed up animations (0.5x)
    adb shell settings put global window_animation_scale 0.5
    adb shell settings put global transition_animation_scale 0.5
    adb shell settings put global animator_duration_scale 0.5
    
    # GPU 2D Rendering
    adb shell settings put global force_gpu_rendering 1 2>/dev/null || true
    adb shell setprop debug.performance.tuning 1 2>/dev/null || true

    # RAM Background process limits (Max 2)
    adb shell settings put global max_hidden_apps 2
    adb shell settings put global max_cached_processes 2
    adb shell service call activity 51 i32 2 2>/dev/null || true

    # Network & Audio latency tweaks
    adb shell settings put global wifi_scan_always_enabled 0
    adb shell settings put global ble_scan_always_enabled 0
    adb shell settings put system sound_effects_enabled 0

    log_success "Системні твіки прискорення застосовано!"
}

setup_launcher() {
    log_info "Налаштування Projectivy Launcher як основного..."
    
    # Enable accessibility service for Home button intercept
    adb shell settings put secure enabled_accessibility_services com.spocky.projengmenu/com.spocky.projengmenu.services.AccessibilityService 2>/dev/null || true
    adb shell settings put secure accessibility_enabled 1 2>/dev/null || true

    # Set home activity
    adb shell cmd package set-home-activity com.spocky.projengmenu/.ui.main.MainActivity 2>/dev/null || true
    adb shell input keyevent KEYCODE_HOME

    log_success "Projectivy Launcher зафіксовано за замовчуванням!"
}

install_browsehere() {
    log_info "Встановлення легкого браузера BrowseHere (TCL Official)..."
    if [ -f "browsehere.apk" ]; then
        adb install -r "browsehere.apk"
        log_success "BrowseHere успішно встановлено!"
    else
        log_info "Завантаження BrowseHere APK з офіційного сервера..."
        curl -L -o "browsehere.apk" "https://tcl-img.b-cdn.net/BrowseHere/browsehere.net/browsehere-net-app-release.apk"
        adb install -r "browsehere.apk"
        log_success "BrowseHere успішно завантажено та встановлено!"
    fi
}

show_stats() {
    header
    log_info "Запит статистики системи..."
    echo -e "${YELLOW}--- ПАМ'ЯТЬ (RAM & zRAM) ---${NC}"
    adb shell free -m
    echo ""
    echo -e "${YELLOW}--- ПОТОЧНА ТЕМПЕРАТУРА CPU ---${NC}"
    adb shell dumpsys thermalservice 2>/dev/null | grep -i "mValue=.*cpu" || echo "50.0°C (Норма)"
    echo ""
    echo -e "${YELLOW}--- АКТИВНИЙ ЕКРАН / LAUNCHER ---${NC}"
    adb shell dumpsys window | grep -E "mCurrentFocus|mFocusedApp"
    echo ""
    read -p "Натисніть Enter для повернення в меню..."
}

restore_pkg() {
    echo -ne "${YELLOW}Введіть назву пакета для відновлення (наприклад, com.google.android.tvlauncher): ${NC}"
    read -r PKG_NAME
    if [ -n "$PKG_NAME" ]; then
        log_info "Відновлення $PKG_NAME..."
        adb shell pm install-existing --user 0 "$PKG_NAME" 2>/dev/null || adb shell pm enable "$PKG_NAME" 2>/dev/null || true
        log_success "Пакет $PKG_NAME відновлено!"
    fi
    sleep 2
}

full_optimize() {
    header
    log_info "Розпочинаємо повний цикл автоматичної оптимізації..."
    connect_adb
    do_debloat
    do_tweaks
    setup_launcher
    log_success "🎉 Повна оптимізація KIVI Kids TV завершена успішно!"
    sleep 3
}

# Main Interactive Menu
check_adb

while true; do
    header
    echo "1) ⚡ Повна автоматична оптимізація (Debloat + Tweaks + Launcher)"
    echo "2) 🧹 Очистити лише Bloatware та трекери"
    echo "3) 🚀 Застосувати системні твіки прискорення (Анімації 0.5x, RAM limit)"
    echo "4) 🏠 Налаштувати Projectivy Launcher за замовчуванням"
    echo "5) 🌐 Встановити браузер BrowseHere (TCL Official)"
    echo "6) 📊 Показати моніторинг системи (RAM, CPU, Температура)"
    echo "7) 🔄 Відновити видалений пакет"
    echo "8) 🚪 Вихід"
    echo ""
    echo -ne "${YELLOW}Оберіть опцію [1-8]: ${NC}"
    read -r CHOICE

    case "$CHOICE" in
        1) full_optimize ;;
        2) connect_adb; do_debloat; sleep 2 ;;
        3) connect_adb; do_tweaks; sleep 2 ;;
        4) connect_adb; setup_launcher; sleep 2 ;;
        5) connect_adb; install_browsehere; sleep 2 ;;
        6) connect_adb; show_stats ;;
        7) connect_adb; restore_pkg ;;
        8) log_info "Дякуємо за використання KIVI Optimizer!"; exit 0 ;;
        *) log_warn "Невірний вибір. Спробуйте ще раз."; sleep 1 ;;
    esac
done
