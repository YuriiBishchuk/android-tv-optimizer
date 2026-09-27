# Чому жодного разу не було вікна вибору лаунчера — це ОК

Спостереження: після встановлення Projectivy система жодного разу не показала
чойзер "виберіть основний лаунчер".

## Причина: дефолт вже зафіксований

```
cmd role get-role-holders android.app.role.HOME → com.spocky.projengmenu
cmd shortcut get-default-launcher → com.spocky.projengmenu/.ui.home.MainActivity
dumpsys package preferred User 0:
  ...MainActivity mMatch=0x100000 mAlways=true
    Selected from: launcherx, setupwraith Recovery, projengmenu, FallbackHome
```

`mAlways=true` = "користувач вже вибрав, більше не питати".

## Як воно так вийшло без вікна

1. Коли знесли/задисейблили `launcherx` + `mitv.tvhome.atv`, в системі лишився
   єдиний HOME-кандидат — Projectivy. Коли кандидат один, Android не показує
   чойзер, а авто-призначає його.
2. Projectivy при першому старті сам попросив `Role HOME` через `RoleManager`.
3. Після `pm enable launcherx` назад преференс лишився на Projectivy.

## Ручний вибір нічого не додає

Перевірено 27.09.2026 емуляцією чойзера через ADB:

```
cmd role remove-role-holder HOME projengmenu → holder відкотився на launcherx,
  preferred став launcherx mAlways=true (це і є "старий ланчер")
cmd role add-role-holder HOME projengmenu + pm set-home-activity projengmenu
  → holder + preferred + default-launcher знову projengmenu
```

Ті самі 2 записи, ніякої прихованої магії. `settings secure` нічого про
лаунчер не містить. Перезаписувати руками — просто перезаписати те саме тим самим.
