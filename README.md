# Islami — Flutter Assignment

## التشغيل (من VS Code)

افتح الفولدر في VS Code، وبعدين اكتب في الـ Terminal:

```bash
flutter create . --project-name islami --platforms android,ios,web
flutter pub get
flutter run
```

أمر `flutter create .` بيضيف فولدرات android و ios و web بس، ومش بيلمس `lib` ولا `assets`.

## الشاشات

| الشاشة | الملف |
|---|---|
| Splash | `lib/screens/splash_screen.dart` |
| Onboarding (5 صفحات، وبتظهر أول مرة بس) | `lib/screens/onboarding_screen.dart` |
| Home + Bottom Navigation | `lib/screens/home_screen.dart` |
| تاب القرآن (بحث + Most Recently + قائمة السور الـ 114) | `lib/tabs/quran_tab.dart` |
| تفاصيل السورة | `lib/screens/sura_details_screen.dart` |
| تاب الأحاديث (Carousel) + التفاصيل | `lib/tabs/hadith_tab.dart` و `lib/screens/hadith_details_screen.dart` |
| السبحة (بتلف مع كل ضغطة، وبتغيّر الذكر كل 33) | `lib/tabs/sebha_tab.dart` |
| الراديو (UI) | `lib/tabs/radio_tab.dart` |
| مواقيت الصلاة + الأذكار (UI) | `lib/tabs/time_tab.dart` |

## ملفات القرآن والأحاديث

- **السور:** `assets/suras/1.txt` لحد `114.txt`، وكل آية في سطر. الفاتحة موجودة. باقي الملفات حطها من ملفات الكورس، وغيّر أسماءها لرقم السورة لو لزم.
- **الأحاديث:** `assets/hadith/h1.txt` لحد `h50.txt`. أول سطر هو العنوان (مثلاً «الحديث الأول»)، والباقي نص الحديث. الحديث الأول موجود.

أي ملف مش موجود التطبيق بيتخطاه أو بيعرض رسالة، من غير ما يقع.

## ملاحظات

- مواقيت الصلاة أرقام ثابتة زي التصميم. التاريخ الميلادي والهجري والعد التنازلي للصلاة الجاية حقيقيين.
- الراديو واجهة بس. لو عايز صوت فعلي، ضيف باكدج `just_audio` وشغّل اللينك جوه `_togglePlay`.
- صور الأذكار (الهلال والمسجد 3D) مكانتش في ملف التصدير، فحطيت مكانها أيقونات مؤقتة.
