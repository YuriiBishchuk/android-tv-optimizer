# Чому при старті блимає стоковий лаунчер ~0.5с перед Projectivy — це ОК

Спостереження (Xiaomi A Pro 2026, 27.09.2026): при холодному старті спочатку
на пів секунди видно старий (стоковий Google TV) лаунчер, потім вмикається Projectivy.

## Це штатний boot-race, а не "два лаунчери паралельно"

1. `system_server` стартує і першим піднімає вшитий
   `launcherx/.dashboard.DashboardHandler` — він частина прошивки.
2. Тільки коли `PackageManager` дочитає `preferred-activities User 0`,
   він кидає `HOME intent`, бачить `mAlways=true Projectivy` і переключає.

Факт з `logcat -b events` того дня:

```
wm_set_resumed_activity: launcherx/.dashboard.DashboardHandler
input_focus entering launcherx DashboardHandler
... ~4с ...
wm_finish_activity launcherx DashboardHandler
wm_destroy_activity launcherx DashboardHandler
am_kill launcherx excessive binder traffic during cached
am_proc_died launcherx
```

3. `dumpsys activity` в нормі показує:
```
Task type=home launcherx/.home.HomeActivity visible=false   # кеш, не екран
Task projengmenu/.ui.home.MainActivity visible=true         # дефолт, екран
```

## Чому не "пофіксити" через disable

`pm disable launcherx` прибере блим, але при наступному падінні
`system_server` (а воно було — див. `CRASH_2026-09-27.md`) не буде fallback-HOME
і буде вічний Google TV splash. Тому `launcherx` лишається `enabled`,
дефолт — Projectivy. Ціна = 0.5с блим. Це правильний трейд-оф.

Підтвердження з інтернету: GitHub `spocky/miproja1` #415 (TCL Android 14 —
сток стартує першим, Projectivy другим по HOME), #354 (після standby
прокидається сток, треба HOME), XDA 19.09.2026 (альтернативний лаунчер як
default, сток лишається fallback).
