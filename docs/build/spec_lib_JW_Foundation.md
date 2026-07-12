# مواصفة استخراج مكتبة `JW_Foundation` (ط0 — leg + الموجة التاريخيّة)

> **الهدف:** فصل نواة ط0 النقيّة (هندسة الموجة من السعر) إلى مكتبة Pine v6 مستقلّة، بلا تغيير سلوك (تطابق بصريّ ١٠٠٪). النمط مُثبَت (JW_Elliott مُستورَدة أصلًا س2). المصدر: `J-Waves-M1.pine` س289-491.

## 1) مبدأ الفصل: نقيّ ⇄ مقترن بالشارت
| يُستخرَج للمكتبة (نقيّ/حالة) | يبقى في المؤشّر (عرض/مدخلات) |
|---|---|
| `waveLen` · `rangeHiLo` · `rangeDays` (دوالّ نقيّة) | كلّ `input.*` (waveMode·histBars·waveScaleDays·showHist·الألوان…) |
| `legInputs` (عتبة+اتجاه leg، ta.* كلّ بار) | كتلة الرسم (box/label الموجة+التواريخ، س420-491) |
| `type LegEngine` + `method step` (حالة المحرّك) | لوحة اختبار الموجة (table، س493+) |
| `waveLeft` (يسار الموجة من الحالة) | مبدّلات UI: `f_pos`·`f_dark`·`f_durTxt` (عرض بحت) |
| `buildSegments` (بناء segLefts/Rights/Px/Top) | استدعاء المحرّك + تمرير الحالة للطبقات الأعلى |

**السبب:** القاعدة الجوهريّة كور بلا input؛ الرسم واللوحة والمدخلات مقترنة بالشارت ⇒ تبقى. OHLC/time بإزاحة تاريخيّة **مسموحة في مكتبات v6** (لا تُمرَّر).

## 2) ⚠️ قيود Pine v6 الحرِجة (تُحكَم بها المواصفة)
1. **`ta.*` كلّ بار:** `ta.highest/lowest/highestbars/lowestbars` (س329-333) **يجب** أن تُقيَّم كلّ بار بلا شرط — لا داخل `if barstate.isconfirmed`. ⇒ تُجمَع في دالّة `legInputs` يستدعيها المؤشّر **بلا شرط** كلّ بار، ثمّ يُمرَّر ناتجها إلى `step` (الذي يُستدعى داخل isconfirmed).
2. **الحالة عبر UDT لا `var` عامّ:** حالة المحرّك (legBars/legDir0/legExtHi…) تُغلَّف في `type LegEngine`؛ `method step` يحدّثها. `var` **داخل الميثود** غير مطلوب (الحالة في كائن الـUDT الذي يحمله المؤشّر بـ`var`). يطابق نمط `DegreeLaws`/`BreakProc`.
3. **بلا `input`/`plot`/`table`/`box` في المكتبة:** الرسم يبقى في المؤشّر. المكتبة تُرجِع بيانات فقط.
4. **الإزاحة التاريخيّة:** `high[off]`/`low[off]`/`time[]` تعمل داخل دوالّ المكتبة (مسموح).

## 3) واجهة المكتبة (API) — التواقيع المقترَحة
```
// ── دوالّ نقيّة ──
export waveLen(int nBars) => int                                  // = f_waveLen (س298)
export rangeHiLo(int leftB, int rightB) => [float, float]         // = f_rangeHiLo (س305) بحارس buffer
export rangeDays(int leftB, int rightB) => float                  // = f_rangeDays (س317)

// ── مدخلات المحرّك (ta.* + هيستيريسيس bigDir — تُستدعى كلّ بار بلا شرط) ──
//   [نهائيّ] تأخذ المحرّك، تُحدِّث self.bigDir داخليًّا، وتُرجِع ما يحتاجه المؤشّر + step فقط.
//   (bigDir في الـUDT لا var داخل الدالّة — أأمن؛ ampBars/hbW/lbW داخليّة بلا مستهلك خارجيّ.)
export legInputs(LegEngine self, float waveScaleDays, float legMinRatio) => [float legTh, int bigDir]

// ── محرّك الـleg (حالة) ──
export type LegEngine
    int   dir0
    int   swC
    float extHi
    int   extHiBar
    float extLo
    int   extLoBar
    int   bigDir                    // هيستيريسيس الاتجاه (مطوّي هنا، س335-339)
    array<int>   bars               // = legBars (حدود الموجات)
    array<float> ps                 // = legPs
    array<bool>  tops               // = legTops (نوع الحدّ: قمّة/قاع)

export newLegEngine() => LegEngine  // باني بمصفوفات فارغة + أصفار

// يُستدعى داخل `if barstate.isconfirmed` فقط؛ يمرَّر ناتج legInputs + الثوابت
export method step(LegEngine self, float legTh, int rawDir, int hbW, int lbW, int ampBars, int bigMinSwings, int legCap) => void
    // نفس منطق س335-388 حرفيًّا: هيستيريسيس bigDir ⇒ تحديث الطرف ⇒ تثبيت الحدّ عند تجاوز legTh+swings ⇒ قصّ legCap

// ── يسار الموجة + المقاطع (نقيّة، من الحالة) ──
export waveLeft(LegEngine self, string waveMode, int histBars, int autoWaveLen) => int   // = f_waveLeft (س391)

// بناء مقاطع التحليل (بلا رسم): المقطع 0 = الموجة الحاليّة ثمّ التواريخ (سيقان leg خلف wL)
export buildSegments(LegEngine self, int wL, int wR, int histDepth) => [array<int> lefts, array<int> rights, array<float> leftPx, array<bool> leftTop]
    // نفس منطق س432-491 **منزوعَ الرسم** (يبني الأربع مصفوفات فقط + حارس buffer bar_index-legB<=4900)
```

## 4) تغييرات المؤشّر (المستهلِك) — استبدال لا إضافة
```
import <النشر>/JW_Foundation/1 as jwf
var jwf.LegEngine leg = jwf.newLegEngine()
[legTh, bigDir] = jwf.legInputs(leg, waveScaleDays, LEG_MIN_RATIO)   // كلّ بار بلا شرط (ta.*) · bigDir عالميّ لكلّ الطبقات
if barstate.isconfirmed
    jwf.legStep(leg, legTh, bigDir, bigMinSwings, 20)
// عند islast:
int wL = jwf.waveLeft(leg, waveMode, histBars, AUTO_WAVE_LEN)
[segLefts, segRights, segLeftPx, segLeftTop] = jwf.buildSegments(leg, wL, bar_index, histDepth, useHohN)
// … كتلة الرسم تبقى كما هي، تقرأ leg.bars/leg.ps/leg.tops + المصفوفات الأربع …
```
- تُحذف من المؤشّر: `f_waveLen`·`f_rangeHiLo`·`f_rangeDays`·كتلة المحرّك س321-388·`f_waveLeft`·منطق بناء المقاطع (يُستبدَل بالاستدعاء). **يبقى:** كلّ الرسم والمدخلات واللوحة.
- `LEG_MIN_RATIO`·`AUTO_WAVE_LEN`·`bigMinSwings`·`histDepth`·`waveScaleDays`·`histBars`·`waveMode`: تبقى مدخلات/ثوابت في المؤشّر وتُمرَّر وسائط.

## 5) ضمان التطابق (معيار القبول)
- **قبل النشر:** لا يمكن تصريف مكتبة تستورد؛ الاختبار البصريّ يقارن نسخة قبل/بعد على نفس الشارت (الذهب/US100 1H): **حدود الموجة + التواريخ + كلّ القمم/القيعان والخطوط المبنيّة فوقها متطابقة تمامًا**. أيّ اختلاف = خطأ نقل.
- **حارس الحالة:** `LegEngine` يحمل نفس الحقول بنفس الترتيب المنطقيّ؛ لا `var` مزدوج.
- **حارس ta.*:** `legInputs` تُستدعى بلا شرط (لو نُقلت داخل isconfirmed ⇒ فساد تاريخ ta ⇒ حدود leg خاطئة).

## 6) المخاطر
1. **ta.* داخل شرط** (الأعلى) — مُعالَج ببنية legInputs. 🔴 أخطر بند.
2. **ترتيب التنفيذ:** legInputs (كلّ بار) قبل step (isconfirmed) قبل islast — نفس ترتيب الأصل.
3. **إرجاع مصفوفات من المكتبة:** `buildSegments` يُرجِع مراجع مصفوفات جديدة كلّ islast (لا تسريب var). المؤشّر يستهلكها ثمّ يعيد الرسم.
4. **النشر:** المستخدم ينشر JW_Foundation على TradingView ويعطيني رقم الإصدار للاستيراد (كـ JW_Elliott/1).

## 7) خطوات التنفيذ (بعد اعتماد هذه المواصفة)
1. أكتب ملفّ `libraries/JW_Foundation.pine` (النواة أعلاه).
2. تنشره أنت ⇒ تعطيني `<user>/JW_Foundation/N`.
3. أستبدل الكود المضمَّن في المؤشّر بالاستيراد + الاستدعاءات (استبدال لا إضافة).
4. تختبر بصريًّا التطابق ⇒ إيداع ⇒ المكتبة التالية (JW_Degrees).
