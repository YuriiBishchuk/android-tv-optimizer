# План максимального прискорення KIVI Kids TV

Окрім деблоату та заміни лаунчера, ми застосовуємо **системні твіки прискорення інтерфейсу** через ADB.

---

## ⚡ Комплекс дій для МАКСИМАЛЬНОГО прискорення:

### 1. Заміна лаунчера на Projectivy Launcher v4.71
* Виключає фонову рекламу, легке споживання RAM (~35-50 МБ замість ~250 МБ).

### 2. Видалення фонових сервісів та трекерів (Bloatware)
* Видаляємо `kivi.media`, `tv.anoki.acr`, `fusion.android.tv.demo`, `com.google.android.tvrecommendations`, `com.cltv.fast` тощо.
* Це звільняє оперативну пам'ять (RAM) та зменшує навантаження на слабкий процесор MediaTek.

### 3. Твік системних анімацій (System Animation Scaling)
* За замовчуванням Android TV витрачає 1-2 секунди на "плавне" відкриття кожного вікна та меню (`scale: 1.0`).
* Ми зменшуємо шкалу анімації у 2 рази (`0.5x`):
  ```bash
  adb shell settings put global window_animation_scale 0.5
  adb shell settings put global transition_animation_scale 0.5
  adb shell settings put global animator_duration_scale 0.5
  ```
* **Результат:** Меню, додатки та налаштування відкриваються **миттєво при натисканні на пульті**.

### 4. Опціонально: Видалення невикористовуваних важких додатків
Якщо ви не користуєтеся ними, додатково можна видалити:
* `com.amazon.amazonvideo.livingroom` (Prime Video)
* `com.megogo.application` (Megogo)
* `tv.sweet.tvplayer` (Sweet.tv)
* `com.davincikids.tv` (DaVinci Kids)
* `com.boosteroidtv.streaming` (Boosteroid)
* `com.tcl.browser` (Браузер)
