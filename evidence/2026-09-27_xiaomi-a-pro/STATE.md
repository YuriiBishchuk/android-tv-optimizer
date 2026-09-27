# Evidence 2026-09-27 — Xiaomi TV A Pro 2026 (MiTV-MZTU0/river), 14:22 local, up 53 min

Сирі факти з ADB (`192.168.0.103:5555`), без інтерпретацій — інтерпретації в `docs/`.

```
===DISABLED===
package:com.mediatek.dtv.tvinput.isdbtuner
package:com.iwedia.tvinput
package:com.mediatek.dtv.tvinput.atsctuner
package:com.xiaomi.floatingframe

===HOME_PREFERRED===
Preferred Activities User 0:
  Non-Data Actions:
      android.intent.action.MAIN:
        fe9bddf com.spocky.projengmenu/.ui.home.MainActivity
         mMatch=0x100000 mAlways=true
          Selected from:
            com.google.android.apps.tv.launcherx/.home.HomeActivity
            com.google.android.tungsten.setupwraith/.RecoveryActivity
            com.spocky.projengmenu/.ui.home.MainActivity
            com.android.tv.settings/.system.FallbackHome

===ROLE=== com.spocky.projengmenu
===DEFAULT_LAUNCHER=== com.spocky.projengmenu/.ui.home.MainActivity

===TELEMETRY_CHECK=== (grep miui.tv.analytics|mitv.tvhome.atv|tvmanager|statistic|milegal|webcontent|partnercustomizer) → порожньо
===STOCK_LAUNCHER=== package:com.google.android.apps.tv.launcherx (enabled)
===KEY_APPS=== megogo, spocky.projengmenu, youtube.tv, youtube.tvmusic — present

===PROCS=== pid projengmenu=1730, pid launcherx=1142
===FOCUSED=== topResumed=mFocusedApp=com.megogo.application/net.megogo.tv.main.MainActivity
===MEMINFO_PROJ=== TOTAL 63520 ... PSS 63520 / RSS 126108 / SWAP PSS 24345
===MEM=== total 1784 / free ~84 / swap 999 (used 354)
===UPTIME=== up 53 min, load ~22.5
```

Краш того ж дня (12:46/12:47, до ребута): `FATAL android.display
positionChildAt: container=Task is not a child ... at Task.moveToBack`,
жертви `DeadSystemException: setupwraith, mediatek.tv.agent, gms`.
Вихід: Back → `wm_finish_activity SettingsActivity` →
`wm_set_resumed_activity projengmenu MainActivity`.
