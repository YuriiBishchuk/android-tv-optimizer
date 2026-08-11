# 🚀 KIVI Kids TV (Android 14) — Optimization & Debloat Guide

![Platform](https://img.shields.io/badge/Platform-Android%20TV%2014-blue)
![Device](https://img.shields.io/badge/Device-KIVI%20Kids%20TV-green)
![License](https://img.shields.io/badge/License-MIT-orange)
![Security](https://img.shields.io/badge/Security-0%25%20Russian%20Software-brightgreen)

Повний посібник та інтерактивний скрипт для очищення від рекламного ПЗ (Debloat), зняття системних затримок, оптимізації RAM/zRAM та встановлення надшвидкого **Projectivy Launcher** на телевізори **KIVI Kids TV / KIVI 2K Android TV**.

---

## 📺 Протестований пристрій

| Параметр | Значення |
| :--- | :--- |
| **Модель** | KIVI Kids TV (`KIVI 2K Android TV`) |
| **Чипсет** | MediaTek MSD9216PA |
| **Android OS** | Android TV 14 (Збірка `UKNV.260512.001`, Патч безпеки: Червень 2026) |
| **RAM** | 1 ГБ DDR3 + 700 МБ zRAM (стиснення ~10x) |
| **Роздільна здатність** | Full HD 1920×1080 @ 60 Hz |

---

## 🌟 Що робить скрипт

- 🧹 **Debloat** — видалення 15+ рекламних та шпигунських пакетів (`kivi.media`, `tv.anoki.acr.anokiacroptin`, демо-режими тощо)
- 🏠 **Projectivy Launcher** — повна заміна важкого `com.google.android.tvlauncher`, фіксація кнопки **Home**
- ⚡ **Прискорення UI** — анімації `0.5x`, примусовий GPU 2D рендеринг
- 📉 **Оптимізація RAM** — ліміт кешованих процесів (макс. 2), звільнення 350+ МБ фізичної пам'яті
- 🌐 **Браузер** — встановлення **BrowseHere (TCL Official)**, легкий (73 МБ RAM), керування D-Pad пультом
- 🛡️ **Безпека** — нуль російського ПЗ, офіційна клавіатура Google Gboard

---

## ⚙️ Передумови

### На комп'ютері (Linux / macOS / Windows):
```bash
# Ubuntu / Debian
sudo apt install android-tools-adb

# Arch / Manjaro
sudo pacman -S android-tools

# macOS (Homebrew)
brew install android-platform-tools
```

### На телевізорі KIVI:
1. **Налаштування → Про телевізор → Збірка** — натисніть **7 разів** для увімкнення режиму розробника.
2. **Налаштування → Параметри розробника → Налагодження через USB** — **Увімкнути**.
3. **Налаштування → Параметри розробника → Налагодження через мережу** — **Увімкнути**, записати IP-адресу ТВ.

---

## 🚀 Запуск

```bash
git clone https://github.com/YuriiBishchuk/kivi-tv-optimizer.git
cd kivi-tv-optimizer
chmod +x kivi_optimizer.sh
./kivi_optimizer.sh
```

### Інтерактивне меню:
```
==================================================================
       🚀 KIVI Kids TV (Android 14) Optimizer & Debloater
==================================================================

1) ⚡ Повна автоматична оптимізація (Debloat + Tweaks + Launcher)
2) 🧹 Очистити лише Bloatware та трекери
3) 🚀 Застосувати системні твіки прискорення
4) 🏠 Налаштувати Projectivy Launcher за замовчуванням
5) 🌐 Встановити браузер BrowseHere (TCL Official)
6) 📊 Моніторинг системи (RAM, CPU, Температура)
7) 🔄 Відновити видалений пакет
8) 🚪 Вихід
```

---

## 📋 Видалені пакети (Debloat List)

| Пакет | Опис | Стан |
| :--- | :--- | :--- |
| `kivi.media` | Промо-медіацентр KIVI | 🛑 Видалено |
| `tv.anoki.acr.anokiacroptin` | Трекер Anoki ACR | 🛑 Видалено |
| `fusion.android.tv.demo` | Демо-режим для магазинів | 🛑 Видалено |
| `com.google.android.tvlauncher` | Системний лаунчер Google TV | 🛑 Вимкнено |
| `com.google.android.tvrecommendations` | Фонові рекомендації Google | 🛑 Видалено |
| `com.amazon.amazonvideo.livingroom` | Amazon Prime Video | 🛑 Видалено |
| `com.boosteroidtv.streaming` | Boosteroid Cloud Gaming | 🛑 Видалено |
| `com.airconsole.androidtv` | AirConsole Games | 🛑 Видалено |
| `com.hitv.explore` | HiTV | 🛑 Видалено |
| `com.davincikids.tv` | DaVinci Kids | 🛑 Видалено |
| `org.liskovsoft.androidtv.rukeyboard` | Клавіатура RuKeyboard | 🛑 Видалено |

---

## 📊 Результати оптимізації

| Метрика | До | Після |
| :--- | :--- | :--- |
| **Вільна фізична RAM** | ~15 МБ | **~302 МБ** |
| **Затримка анімації** | ~1.5 с | **~0.3 с** |
| **Головний екран** | Google TV + реклама | **Projectivy Launcher** |
| **Вільний zRAM** | ~300 МБ | **~378 МБ** |

---

## 🔄 Відновлення пакету

```bash
adb connect <IP_телевізора>:5555
adb shell pm install-existing --user 0 com.google.android.tvlauncher
```

---

## 📄 Ліцензія

[MIT](LICENSE) — вільне використання та поширення.
