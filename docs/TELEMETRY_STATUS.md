# Статус телеметрії / рекомендацій після деблоку (27.09.2026, 14:22, up 53 min)

## Мертве (в pm list їх нема — uninstall --user 0 тримається після ребута)

```
miui.tv.analytics, mitv.tvhome.atv (PatchWall), tvmanager,
xiaomi.statistic, milegal, webcontent, partnercustomizer,
mitvplus/michannel/oemtab, toolhouse, tvqs.overseas.y24, overseaservice,
feedbackconsent, google feedback, federatedcompute, ondevicepersonalization,
nearby.halfsheet, printspooler, play.games
```

Перевірка: `pm list packages | grep -E 'miui.tv.analytics|...'` → порожньо (`RC=1`).

## Лишилось свідомо (не чіпати)

- Відео-стек Xiaomi/MediaTek: `mitv.service, livetv(+ci, it), videoplayer,
  gallery, mediaexplorer, smartshare, setup, upgrader, updateservice,
  scenemode, mimusic2` — без них немає HDMI/Live/флешок.
- `tungsten.setupwraith` (pid живий) — системний сетап; вчора сипав
  `DeadSystemException` як жертва краша, але видаляти не можна (потрібен після резета).
- `dreamx` (скрінсейвер/бэкдроп) — живий, але не в фокусі.
- `launcherx` — `enabled` як fallback-HOME. `HomeActivity` висить як
  `Task type=home visible=false` (кеш), рекомендації не рендеряться поки дефолт Projectivy.

## Пам'ять (свіжі цифри)

```
free: total 1784MB, free ~84MB (+ swap 999MB, used 354MB)
projengmenu TOTAL PSS ~63MB (фокус був MEGOGO, тому вище за 33MB в простої)
topResumed = com.megogo.application MainActivity (запущений з Projectivy — як і хотілось)
disabled: isdbtuner, iwedia.tvinput, atsctuner, floatingframe (4 шт)
```

## Що НЕ оптимізовано (і не треба)

- `:coreservices` хвіст launcherx (шторка DashboardHandler) — потрібен системі, жре копійки.
- `setupwraith` — системний.
- Блим стоку 0.5с при буті — ціна fallback (див. `BOOT_FLASH.md`).

## Мінімальна розкладка Projectivy (MEGOGO перший, тільки MEGOGO + YouTube + HDMI)

Робиться **вручну пультом** (long-OK → Move/Hide), бо пакет не debuggable:
`run-as com.spocky.projengmenu` → `not debuggable`, префи/БД недоступні.
На 12:50 в `uiautomator` було: HDMI 1-3, Live TV, MEGOGO, Miracast, Play Маркет.
Приховати: Live TV, Miracast, Play Маркет + зайве; лишити MEGOGO, YouTube, HDMI 1-3.
