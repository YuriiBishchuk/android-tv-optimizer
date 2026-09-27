# 📺 Android TV Optimizer (generic, no vendor lock-in)

Універсальний інструментарій для деблоку / тюнінгу Android TV / Google TV
з кастомним лаунчером (Projectivy) як HOME за замовчуванням.

> Попередня назва `kivi-tv-optimizer` була прив'язана до одного вендора.
> Цей репозиторій — **перестворений з нуля під generic-назвою**,
> конфіг під конкретний телевізор лежить в `devices/*.conf`,
> код вендор-нейтральний.

![Platform](https://img.shields.io/badge/Platform-Android_TV_14-blue)
![License](https://img.shields.io/badge/License-MIT-orange)

> Репозиторій перейменовано з `kivi-tv-optimizer` в `android-tv-optimizer`.
> Старі KIVI-скрипти лишились в історії git, новий код — `scripts/*` + `devices/*`.


## Структура

```
android-tv-optimizer/
├── README.md
├── devices/
│   ├── _template.conf          # шаблон для нового ТВ
│   └── xiaomi_a_pro_2026.conf  # Xiaomi TV A Pro 2026 (MiTV-MZTU0/river, MT9676, Android 14)
├── scripts/
│   ├── audit.sh                  # УНІВЕРСАЛЬНИЙ аудит tiers + --apply-tier1 / --apply-bloat
│   ├── debloat.sh              # safe uninstall --user 0 по списку з devices/*.conf
│   ├── set-home.sh             # призначення HOME (role + preferred, емуляція ручного вибору)
│   ├── verify.sh               # перевірка: HOME / focused / RAM / disabled
│   └── boot-diag.sh            # діагностика splash-loop (logcat crash/system/events + dumpsys)
├── tools/flows/
│   ├── home-check.yaml
│   └── boot-home-check.yaml
├── docs/
│   ├── BOOT_FLASH.md           # чому сток блимає 0.5с перед Projectivy — це ок
│   ├── HOME_CHOOSER.md         # чому немає вікна вибору лаунчера — це ок
│   ├── COMMUNITY_LISTS.md      # community-списки деблоку + мапінг на наш ТВ
│   ├── CRASH_2026-09-27.md     # system_server android.display Task.moveToBack — розбір
│   └── TELEMETRY_STATUS.md     # що мертве / що живе після деблоку
└── evidence/2026-09-27_xiaomi-a-pro/
    └── STATE.md                # сирі факти з ADB на момент 14:22 27.09.2026
```

## Швидкий старт

```bash
# 1. ADB
sudo apt install android-tools-adb
# На ТВ: Параметри розробника → USB/Wireless Debugging → ON, записати IP:порт

# 2. Підключення (порт динамічний для Wireless Debugging!)
adb connect 192.168.0.103:5555
adb devices -l
adb shell echo ok

# 2a. Аудит "що можна почистити" (read-only, tiers з community + живий тест)
TV_IP=192.168.0.103:5555 ./scripts/audit.sh
# ТІЛЬКИ tier1 (підтверджені): TV_IP=... ./scripts/audit.sh --apply-tier1
# Зі свого файла: TV_IP=... ./scripts/audit.sh --apply-bloat bloat.txt

# 3. Деблок (dry-run за замовчуванням нічого не видаляє без --apply)
DEVICE_CONF=devices/xiaomi_a_pro_2026.conf ./scripts/debloat.sh --apply

# 4. HOME = Projectivy (ідентично ручному вибору в чойзері)
DEVICE_CONF=devices/xiaomi_a_pro_2026.conf ./scripts/set-home.sh

# 5. Перевірка
TV_IP=192.168.0.103:5555 ./scripts/verify.sh
TV_IP=192.168.0.103:5555 ./scripts/boot-diag.sh
```

## Правила безпеки

1. **Ніколи не `disable` останній fallback-HOME.** Стоковий `launcherx` лишається `enabled`
   як запасний, дефолт — Projectivy (`mAlways=true` + `Role HOME`).
2. **Не чіпати відео-стек** (`mitv.service`, `livetv`, `videoplayer`, `setup`) — без них немає HDMI/Live.
3. **Не чіпати `setupwraith`** — системний сетап-трекер, потрібен після резета.
4. Projectivy-розкладка (MEGOGO перший, тільки MEGOGO + YouTube + HDMI) — **вручну пультом**
   (long-OK → Move/Hide), бо пакет не debuggable (`run-as` не працює). ADB це не пропише.
5. Не заходити без потреби в `Projectivy → Android Settings` — саме там ловився
   `FATAL android.display positionChildAt` 27.09.2026 (див. `docs/CRASH_2026-09-27.md`).

## Протестовані пристрої

| Дата | Пристрій | SoC / OS | Результат |
|------|----------|----------|-----------|
| 2026-05 | KIVI Kids TV (KIVI 2K Android TV, MSD9216PA) | Android TV 14 | RAM ~15МБ → ~302МБ, Projectivy default |
| 2026-09-27 | Xiaomi TV A Pro 2026 (MiTV-MZTU0/river) | MT9676, Android TV 14 SDK34 | telemetry мертва, Projectivy default, блим стоку 0.5с = ок |

## Legacy (KIVI)

Старі скрипти (`kivi_optimizer.sh`, `debloat.sh`, `packages.txt`, APK) лишаються
в історії git до перейменування. Новий код — `scripts/*` + `devices/*`.

## 📄 Ліцензія

[MIT](LICENSE) — вільне використання та поширення.

