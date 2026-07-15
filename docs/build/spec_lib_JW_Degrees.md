# مواصفة استخراج مكتبة `JW_Degrees` (ط1 — القمم/القيعان للدرجات الثلاث · دروس 05·06·07)

> **الأهمّ على الإطلاق** (أيّ خطأ يتضخّم فوقه). الهدف: فصل **محرّك الدرجات المعمّم** (النواة النقيّة) إلى مكتبة، بلا تغيير سلوك (تطابق بصريّ ١٠٠٪). يعتمد على `JW_Foundation` (يستهلك مقاطعها segL/segR). المصدر: `J-Waves-M1.pine` س425-855 (نواة) + مستهلك س857+.

> ## 🔴 تصحيح حاكم (المنشور `JW_Degrees/1` — يَنسخ بادئة `f_` أدناه)
> الكود المنشور يُصدّر **`feedMedium`** و**`buildWave`** (بلا بادئة `f_`)، لا `f_feedMedium`/`f_buildWave`. المؤشّر ينادي `jwd.buildWave`. المنشور /1 هو مصدر الحقيقة (لا يُعاد تسميته). حيثما وردت `f_feedMedium`/`f_buildWave` في هذه الوثيقة، اقرأها `feedMedium`/`buildWave`.

## 1) مبدأ الفصل: المحرّك المعمّم يُصدَّر · التنسيق والرسم يبقى
النواة **معمّمة على الدرجة** (نفس القوانين للصغيرة/المتوسطة/الكبيرة — [[reusable-degree-functions]]). لذا تُصدَّر **الأنواع + القوانين + المحرّك**، ويبقى في المؤشّر **تنسيق الدرجات الثلاث** (السلاسل الموحّدة، الحلقة على المقاطع، الرسم).

| ← يُصدَّر (JW_Degrees) | يبقى في المؤشّر |
|---|---|
| `type DegreeLaws` + `newDegreeLaws` + 5 ميثودات (sequenceLaw·isPendingConfirmed·activateLaw·feedPivot·appendEff) | سلاسل التوحيد `scBar/mcBar/lgBar…` + `f_pushChain/Med/Small` |
| `type BreakProc` + `newBreakProc` + `feedBreakDown/Up` | حلقة المقاطع (تُنشئ sd/md/me/mb لكلّ مقطع وتنادي buildWave) |
| `f_feedMedium` | تنسيق الكبيرة (useBigBreak/legLiveBreak — يستعمل نفس الأنواع) |
| `f_buildWave` (+ useValid·minCorr وسيطين) | كلّ الرسم (أسهم/دوائر) + التغطية + الطبقات الأعلى |

## 2) الاقتران الوحيد بالعوالم (يُحَلّ بالوسائط)
- `f_buildWave` يقرأ عالميًّا: **`useValid`** (س745: شرط النويز) و**`minCorr`** (785/822: عدد شمعتَي التصحيح). ⇒ يُمرَّران **وسيطين** (`bool useValid, int minCorr`).
- لا اقتران آخر: `high/low/open/close/time/bar_index` بالإزاحة **مسموحة في مكتبات v6**؛ الميثودات تقرأ `self` فقط؛ `f_feedMedium`/`feedPivot` مُصدَّرة داخل المكتبة.

## 3) واجهة المكتبة (API)
```
// ── الأنواع + البناة (تُصدَّر كما هي) ──
export type DegreeLaws
    int trendDir=0 · int pendingType=0 · float pendingPrice=na · int pendingBar=na · int pendingTime=na
    float lastEffTopPrice=na · float lastEffBottomPrice=na
    array<int> effectiveBars · array<float> effectivePrices · array<bool> effectiveIsTop · array<int> effectiveTimes
    bool justActivated=false · bool justActTop=false · float justActPrice=na · int justActBar=na · int justActTime=na
export newDegreeLaws() => DegreeLaws            // بمصفوفات مُهيّأة

export type BreakProc
    bool started=false · float refTopPrice=na · float refBotPrice=na
    float minSincePrice=na · int minSinceBar=na · int minSinceTime=na
    float maxSincePrice=na · int maxSinceBar=na · int maxSinceTime=na
    bool inCorr=false · float breakPivotP=na
export newBreakProc() => BreakProc

// ── القوانين (ميثودات مُصدَّرة — تبقى صياغة self.method() في المستهلك بلا تغيير) ──
export method sequenceLaw(DegreeLaws self, bool isTop, float price, int bar, int tm)
export method isPendingConfirmed(DegreeLaws self, float incomingPrice) => bool
export method activateLaw(DegreeLaws self)
export method feedPivot(DegreeLaws self, bool isTop, float price, int bar, int tm, int waveDir)
export method appendEff(DegreeLaws self, bool isTop, float price, int bar, int tm)
export method feedBreakDown(BreakProc self, bool isTop, float price, int bar, int tm) => [int,bool,float,int,int,bool,float,int,int]
export method feedBreakUp(BreakProc self, bool isTop, float price, int bar, int tm) => [int,bool,float,int,int,bool,float,int,int]

// ── المحرّك ──
export f_feedMedium(DegreeLaws small, BreakProc bp, DegreeLaws med, DegreeLaws medEff, int wdir)
export f_buildWave(DegreeLaws sd, DegreeLaws md, DegreeLaws me, BreakProc mb, int segL, int segR, bool useValid, int minCorr) => int
```
🔴 **نقطة تحقّق تصريف #1:** `export method` واستدعاؤها بـ`obj.method()` على نوع مكتبة — إن رفضها المُصرِّف، البديل دوالّ مُصدَّرة `jwd.feedPivot(self, …)` (تُغيّر مواضع الاستدعاء في المستهلك). الأفضل الميثود (يُبقي المستهلك كما هو).

## 4) تغييرات المؤشّر (المستهلك) — استبدال لا إضافة
```
import Jassar_Mahmoud/JW_Degrees/1 as jwd
// كلّ إعلانات الأنواع تصير jwd.*:
var jwd.DegreeLaws smallDeg = jwd.newDegreeLaws()   // إلخ (صغيرة/متوسطة/كبيرة × خام/فعّال)
var jwd.BreakProc  medBreak = jwd.newBreakProc()
// النداءات كما هي (ميثودات): sd.feedPivot(...) · bp.feedBreakDown(...) · largeEffD.feedPivot(...)
// f_buildWave + f_feedMedium تصير jwd.* مع تمرير useValid/minCorr:
jwd.f_buildWave(sd, md, me, mb, segL, segR, useValid, minCorr)
```
- تُحذف من المؤشّر: تعريفات الأنواع/الميثودات/f_feedMedium/f_buildWave (س425-855). **يبقى:** السلاسل، الحلقة، الرسم، الكبيرة، التغطية.
- `useValid`/`minCorr`: يبقيان مدخلَين في المؤشّر، يُمرَّران لـf_buildWave.

## 5) ضمان التطابق (معيار القبول)
- الأنواع تحمل نفس الحقول بنفس الترتيب (بناء `.new` positional) · الميثودات منطقها حرفيّ · f_buildWave يطابق شمعةً بشمعة (القفل·التتابُع·الفعاليّة·الطورين).
- اختبار بصريّ: **كلّ القمم/القيعان (الدرجات الثلاث) + الدوائر + الأسهم متطابقة ١٠٠٪ قبل/بعد**. أيّ اختلاف = خطأ نقل.
- تعتمد على JW_Foundation مُختبَرةً أوّلًا (المقاطع الصحيحة شرط).

## 6) المخاطر
1. **`export method` على نوع مكتبة** (الأعلى) — نقطة تحقّق #1.
2. **تعدّد المخرجات 9-tuple** من feedBreakDown/Up — مسموح، تحقّق التصريف.
3. **ترتيب الاستدعاء:** f_buildWave يُنادى داخل حلقة المقاطع لكلّ مقطع (كما الأصل) — التنسيق يبقى في المؤشّر.
4. **الاعتماد على JW_Foundation:** المقاطع تُمرَّر segL/segR — لا اقتران مباشر بين المكتبتين (المؤشّر يوصّل).

## 7) خطوات التنفيذ (بعد اعتماد المواصفة **و** تأكيد تطابق JW_Foundation)
1. أكتب `libraries/JW_Degrees.pine` (النواة أعلاه).
2. تنشرها ⇒ `<user>/JW_Degrees/N`.
3. أستبدل تعريفات النواة في المؤشّر بالاستيراد (الأنواع jwd.* + تمرير useValid/minCorr) — استبدال لا إضافة.
4. اختبار بصريّ للتطابق ⇒ إيداع ⇒ JW_Lines (ط2).
