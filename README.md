# 🚀 KIVI Kids TV (Android 14) — Comprehensive Optimization & Debloat Guide

![Platform](https://img.shields.io/badge/Platform-Android%20TV%2014-blue)
![Device](https://img.shields.io/badge/Device-KIVI%20Kids%20TV-green)
![License](https://img.shields.io/badge/License-MIT-orange)
![Security](https://img.shields.io/badge/Security-0%25%20Russian%20Software-brightgreen)

Повний посібник та інтерактивний скрипт для очищення від рекламного софту (Debloat), зняття системних затримок, оптимізації оперативної пам'яті (RAM/zRAM) та встановлення надшвидкого **Projectivy Launcher** на телевізори **KIVI Kids TV / KIVI 2K Android TV**.

---

## 🌟 Основні можливості (Key Features)

- 🧹 **Очищення від Bloatware & Telemetry:** Видалено понад 15 рекламних та фонових додатків (`kivi.media`, `tv.anoki.acr.anokiacroptin`, демо-режими, промо-сервіси).
- 🏠 **Projectivy Launcher як Default:** Повна заміна важкого `com.google.android.tvlauncher` на легкий та чуйний Projectivy Launcher з фіксацією кнопки **Home**.
- ⚡ **Прискорення графічного інтерфейсу:** Шкалу анімації зменшено до `0.5x`, активовано `force_gpu_rendering=1` для 60 FPS рендерингу.
- 📉 **Оптимізація пам'яті (RAM & zRAM):** Встановлено ліміт фонових процесів (макс. 2 додатки в кеші). Звільнено **350+ МБ фізичної RAM** + ефективне стиснення zRAM (~10x).
- 🌐 **Безпечний Web-браузер:** Встановлено перевірений та легкий **BrowseHere (TCL Official)** з керуванням D-Pad пульта та споживанням всього 73 МБ RAM.
- 🛡️ **100% Безпека та Чистота:** Відсутність будь-яких російських додатків, сервісів чи клавіатур. Використовується лише офіційна клавіатура **Google Gboard**.

---

## 🚀 Швидкий запуск (Interactive Optimizer Script)

Для автоматичної чи покрокової оптимізації запустіть інтерактивний bash-скрипт:

```bash
chmod +x kivi_optimizer.sh
./kivi_optimizer.sh
```

### 📱 Скріншот інтерактивного меню:
```text
==================================================================
       🚀 KIVI Kids TV (Android 14) Optimizer & Debloater        
==================================================================

1) ⚡ Повна автоматична оптимізація (Debloat + Tweaks + Launcher)
2) 🧹 Очистити лише Bloatware та трекери
3) 🚀 Застосувати системні твіки прискорення (Анімації 0.5x, RAM limit)
4) 🏠 Налаштувати Projectivy Launcher за замовчуванням
5) 🌐 Встановити браузер BrowseHere (TCL Official)
6) 📊 Показати моніторинг системи (RAM, CPU, Температура)
7) 🔄 Відновити видалений пакет
8) 🚪 Вихід
```

---

## 📋 Аудит пакетів (Package Audit)

### ❌ Видалені / Знешкоджені пакети (Debloated):

| Пакет | Опис | Стан |
| :--- | :--- | :--- |
| `kivi.media` | Заводський промо-медіацентр KIVI | 🛑 Видалено (`user 0`) |
| `tv.anoki.acr.anokiacroptin` | Аналітичний трекер Anoki ACR | 🛑 Видалено |
| `fusion.android.tv.demo` | Демо-режим для магазинів | 🛑 Видалено |
| `com.google.android.tvlauncher` | Важкий системний лаунчер з рекламою | 🛑 Вимкнено (`disabled-user`) |
| `com.google.android.tvrecommendations` | Фонові рекомендації Google | 🛑 Видалено |
| `com.amazon.amazonvideo.livingroom` | Amazon Prime Video | 🛑 Видалено |
| `com.boosteroidtv.streaming` | Boosteroid Cloud Gaming | 🛑 Видалено |
| `com.airconsole.androidtv` | AirConsole Games | 🛑 Видалено |
| `com.hitv.explore` | HiTV | 🛑 Видалено |
| `com.davincikids.tv` | DaVinci Kids | 🛑 Видалено |
| `org.liskovsoft.androidtv.rukeyboard` | Фабрична клавіатура RuKeyboard | 🛑 Видалено |

---

## 📊 Порівняння продуктивності (Benchmark)

| Метрика | До оптимізації | Після оптимізації |
| :--- | :--- | :--- |
| **Вільна фізична RAM** | ~15 МБ *(ТБ постійно висів)* | **~302 МБ** |
| **Затримка анімації** | 1.5 секунди | **0.5 секунди (Миттєво)** |
| **Головний екран** | Google TV з рекламою | **Projectivy Launcher** |
| **Вільний zRAM** | 300 МБ | **378 МБ** *(з коефіцієнтом стиснення 10x)* |
| **Температура CPU** | 50°C (Норма) | **50°C (Оптимально)** |

---

## 🔄 Як відновити пакет (Rollback / Restore)

Якщо вам колись знадобиться відновити будь-який із вимкнених системних додатків, скористайтесь командою ADB:

```bash
adb shell pm install-existing --user 0 <назва_пакету>
# Наприклад:
adb shell pm install-existing --user 0 com.google.android.tvlauncher
```

---

## 📄 Ліцензія

Цей проєкт поширюється під вільною ліцензією **MIT**. Код є повністю відкритим та безпечним для використання.
