# Community debloat knowledge base (Xiaomi / Google TV / TCL)

Зібрано 27.09.2026 з відкритих джерел. Використовується як `TIER_1/2/3`
в `scripts/audit.sh`. Позначки: ✅ підтверджено на нашому ТВ, 🌐 з community.

## Джерела

1. **seun-novodev/android-tv-debloat-toolkit** (658 ⭐, TCL/Google TV, Python+ADB)
   - `scripts/debloat_safe.sh`: `com.tcl.browser, tv.appstore, tv.cast,
     usercenter, tclaccount, tv.tcloudaccount, gallery, mediacenter,
     screenadservice, screensaver, eula` + `com.google.android.tvrecommendations`
   - `scripts/debloat_minimal.sh`: тільки `com.google.android.tvrecommendations`
   - Фішка: Pair & Connect (Android 11+ Wireless Debugging), "Disable Google
     Launcher safely (after installing a custom launcher)", reboot remotely.
2. **tutyamxx/androidtv-debloat-script** — патерн `bloat.txt` (по одному пакету
   на рядок) + `uninstall-bloat.sh` читає файл. Philips/Freeview списки
   (`org.droidtv.*`, `uk.co.freeview.*`) — для нас не релевантні, але патерн
   взяли в `scripts/audit.sh --apply-bloat <file>`.
3. **alexander-danilenko gist — Debloat Xiaomi Smart TV Box S (2nd Gen)** —
   найближчий до нашого ТВ список (перевірено на Xiaomi):
   `air.com.vudu.air.DownloaderTablet, amazonvideo.livingroom, cts.priv.ctsshim,
   printspooler, providers.calendar, providers.contacts, cbs.ott,
   hindi/zhuyin/japanese/korean/pinyin IME, feedback, leanbacklauncher.recommendations,
   music, partnersetup, play.games, syncadapters.calendar, tts, tv, videos,
   youtube.tvmusic, hulu, mitv.dream, mitv.tvhome.atv, michannel, mitvplus,
   mitv.videoplayer(!), miui.tv.analytics, netflix, rbtv, pandora, showtime,
   sling, tvsetup.partnercustomizer, mitv.updateservice`
4. **0x192/universal-android-debloater** (20k ⭐, Rust, UAD lists: GFAM/AOSP/OEM/
   Carrier/Qualcomm/Mediatek) — головний референс таксономії
   (Recommended/Advanced/Expert/Unsafe) + правило "китайські вендори маскують
   свої пакети під AOSP-імена — видаляти обережно". TV-специфічних списків там
   нема, але таксономію tiers взяли.

## Мапінг на наш ТВ (MiTV-MZTU0, Android 14)

| Community-пакет | Наш статус 27.09.2026 |
|---|---|
| `com.google.android.tvrecommendations` | нема в прошивці (поглинутий launcherx/dreamx) — чистити нічого |
| `com.google.android.leanbacklauncher.recommendations` | нема, те саме |
| `com.mitv.tvhome.atv / michannel / mitvplus` | ✅ видалені (TIER_1) |
| `com.miui.tv.analytics` | ✅ видалений (TIER_1) |
| `com.xiaomi.android.tvsetup.partnercustomizer` | ✅ видалений (TIER_1) |
| `com.google.android.feedback` | ✅ видалений (TIER_1) |
| `com.android.printspooler / providers.calendar` | ✅ видалені (TIER_1) |
| `com.google.android.play.games` | ✅ видалений (TIER_1) |
| `com.google.android.tts` | лишився свідомо (OPTIONAL — 74МБ, але потрібен для accessibility/voice) |
| `com.mitv.videoplayer / gallery / mediaexplorer` | PROTECTED (відео-стек флешок/HDMI) — gist радить зносити, ми НІ |
| `com.mitv.dream` | нема в нашій прошивці (є `dreamx` — скрінсейвер, лишаємо) |
| `com.xiaomi.mitv.updateservice / mitv.upgrader` | OPTIONAL (мінус — без OTA) |
| `com.tcl.*` | нема (не TCL), ігнор |
| `org.droidtv.* / uk.co.freeview.*` | нема (не Philips), ігнор |
| `com.android.cts.*shim` | лишаємо (CTS-стаби, нуль RAM) |
| IME `hindi/zhuyin/japanese/korean/pinyin` | нема в прошивці (тільки latin) |
| `amazonvideo/netflix/iqiyi` | OPTIONAL_STREAMING (за вибором власника) |

## Висновок для audit.sh

TIER_1 = перетин community-списків + підтверджено безпечно на MiTV-MZTU0.
TIER_2 = community-safe, але на нашій прошивці або відсутні, або OPTIONAL.
TIER_3 = евристика (keywords), завжди ручне підтвердження.
Нічого з community не додаємо в авто-видалення без живого тесту на нашому ТВ.
