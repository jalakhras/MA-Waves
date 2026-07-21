# مواصفة استخراج مكتبة الإشارات — `spec_lib_JW_Signals.md`

**الحالة:** تخطيط (2026-07-20، طلب المالك «فصل طبقة الإشارات في مكتبة لوحدها»). 🔴 لا كود مكتبة قبل موافقة المالك على هذه المواصفة.
**يسبقها:** تنظيف v2.66.0 (حُذِف كلّ ما خارج النواة: التشخيص + التدقيق + المؤشّرات الأجنبيّة).
**المرجع الحاكم:** دستور الكود + [[pine-compiler-pitfalls]] + بروتوكول النشر الآمن + نمط الاستخراجات السابقة (JW_Zones/JW_Lines/JW_Conclusions).

---

## 0) الهدف والخطّ الأحمر
- **الهدف:** نقل طبقة إصدار الإشارات إلى مكتبة `JW_Signals` (كـJW_Zones) — الرسم يبقى في المكتبة (النمط المعتمَد: f_levelLine/f_liqLine/f_pairZones ترسم/تُرجِع)، والحالة والمدخلات تُمرَّر **وسائط** من المؤشّر.
- 🔴 **تكافؤ سلوكيّ صارم:** الاستخراج **لا يغيّر أيّ إشارة** — A/B قبل/بعد يجب أن يكون مطابقًا (نفس الوسوم، نفس المواضع). أيّ اختلاف = عطب.

## 1) ما يُنقَل (3 دوالّ)
| الدالّة | الدور | الرسم |
|---|---|---|
| `f_emitDegSignals` | إشارات الدرجات (تطرّف داخل منطقة + تأكيد كسر N+1 + بوّابة المرحلة) ⇒ ✦/⚠ + RR | يدفع لـ`sigLabels` (وسيط) |
| `f_emitExit` | إشارة الخروج (كسر+إعادة اختبار+ارتداد) ⇒ ✦ | يدفع لـ`sigLabels` (وسيط) |
| `f_sigLvl` | شبكة الوقف/الأهداف الحيّة (خطّ متقطّع + وسم مسعّر) | يدفع لـ`lns/mks` (وسيطان) |

**لا يُنقَل (يبقى في المؤشّر):** الصفقة الحيّة (`liveActive/liveB/E/Dir/Stp/Tps`) — مدمجة مع كتلة اللوحة والقرار (`decK/entry/inZone`)، فصلها يستلزم نقل نصف اللوحة. تبقى في المؤشّر وتُغذّي `f_sigLvl` بالوسائط.

## 2) الاعتماديّات ⇒ تصير وسائط
`f_emitDegSignals` اليوم تقرأ عالميًّا: `zTop/zBot` · `sigLabels` · `confWin` · `minRR` · `maxTradesL2` · `useDistrib` · `f_t` (اللغة) · `jwc.f_phaseAt` · `f_coveredAt`.
- **مصفوفات المناطق** `zTop/zBot` ⇒ وسيطان.
- **مخرَج** `sigLabels` ⇒ وسيط (المكتبة تدفع فيه).
- **قيَم** `confWin/minRR/maxTradesL2` + `isAR` (بدل f_t) + `useDistrib` ⇒ وسائط.
- **`jwc.f_phaseAt`:** المكتبة تستورد `JW_Conclusions` (مكتبة تستورد مكتبة — مسموح). أو يُمرَّر ناتج المرحلة مسبقًا (أنظف لكن يغيّر البنية). **القرار المقترَح: استيراد jwc داخل JW_Signals** (أقلّ تغييرًا).
- **`f_coveredAt`:** دالّة محلّيّة في المؤشّر تقرأ `covCur/covHist/covHoH` (مدخلات) ⇒ تُنقَل هي أيضًا للمكتبة بوسائط التغطية، أو يُمرَّر `covLater` مُحسَبًا (كما يجري الآن جزئيًّا). **مقترَح: تمرير `covLater` + حدود الطبقات** (المؤشّر يحسبها كما اليوم).

## 3) فخاخ Pine (من الذاكرة — تُفحَص صراحةً)
- 🔴 **«كائن UDT محلّيّ + نداء method» يُترجَم معطوبًا** في المكتبات: هذه الدوالّ **لا تستعمل** هذا النمط (مصفوفات + نداء jwc خارجيّ) ⇒ **آمنة مبدئيًّا**، لكن يُفحَص تحذير CE10237 بعد النشر ولا يُسكت.
- `pine_check` أعمى عن أرقام إصدارات المكتبات ⇒ **بروتوكول النشر الآمن إلزاميّ:** انشر من القرص + راقب كونسول الحفظ + A/B فوريّ بعد النشر.
- `request.security` (تأكيد الرابعة) يبقى في المؤشّر (يقرأ tickerid) — لا يُنقَل.

## 4) خطّة التنفيذ (تدريجيّة، كلّ خطوة قابلة للاختبار)
1. أنشئ `libraries/JW_Signals.pine` بالدوالّ الثلاث مُعمَّمة (وسائط) — **بلا نشر بعد**.
2. `pine_check` على المكتبة وحدها (بيانات وهميّة) للتحقّق النحويّ.
3. انشرها (v1) ببروتوكول النشر الآمن.
4. في المؤشّر: استبدل النداءات المحلّيّة بـ`jws.f_*` (استيراد `JW_Signals/1`)، واحذف الأجسام المحلّيّة.
5. **A/B صارم:** نفس الأداة/الفريم قبل/بعد ⇒ لقطة + مقارنة وسوم (`data_get_pine_labels`) — يجب أن تتطابق.
6. مسح تحقّق (أدوات/فريمات) كالمعتاد.

## 5) معايير القبول
- صفر تغيير في الإشارات (A/B مطابق على ≥3 أدوات/فريمات).
- المؤشّر أنحف (−3 دوالّ)، المكتبة مستقلّة قابلة لإعادة الاستعمال (لطبقة الاستراتيجية م-إش-3 لاحقًا).
- لا تحذير CE10237 غير مُبرَّر.

## 6.5) لصقة تعديل المؤشّر (تُطبَّق **بعد** نشر `JW_Signals/1` — الآن المكتبة على القرص فقط)
> الحالة: `libraries/JW_Signals.pine` كُتِبت (2026-07-20). المؤشّر **لم يُمَسّ** (يبقى v2.66.0 قابلًا للترجمة والتحقّق مستقلًّا). عند عودة الـMCP: (1) تحقّق v2.66.0 بصريًّا · (2) انشر JW_Signals · (3) طبّق هذه اللصقة · (4) A/B.

1. **الاستيراد** (بعد سطر `import ... JW_Zones/6 as jwz`):
   `import Jassar_Mahmoud/JW_Signals/1 as jws`
2. **احذف الأجسام المحلّيّة الثلاث** من المؤشّر: `f_sigLvl` · `f_emitDegSignals` · `f_emitExit` (تبقى تعليقاتها التعريفيّة اختياريًّا).
3. **مساعد التغطية** (يبقى في المؤشّر — يحوّل f_coveredAt لكلّ نقطة إلى قناع `aCov`): أضِف قبل كتلة الإشارات:
   ```
   f_covArr(array<int> aBar, array<bool> aTop, array<float> aPrc, int hL1, int hL2, float wHi, float wLo, array<bool> covLater) =>
       array<bool> out = array.new<bool>()
       int n = array.size(aBar)
       for i = 0 to (n > 0 ? n - 1 : 0)
           if n > 0
               array.push(out, f_coveredAt(aBar, aTop, aPrc, i, hL1, hL2, wHi, wLo, covLater))
       out
   ```
4. **نداءات الإشارات** (داخل `if showSignals and showSigSub ...`):
   - قبل النداءات: `array<bool> scCovArr = f_covArr(scBar, scTop, scPrc, histLs, hL2s, wHiS, wLoS, scCovLg)` و`mcCovArr` نظيرها بـmc.
   - الصغيرة: `[slb, sle, slzt, slzb, slup] = jws.f_emitDegSignals(scBar, scTop, scPrc, scEff, scCovArr, sigDir, histLs, f_t("صغيرة","Small"), sActVg, mcBar, mcTop, mcPrc, mcEff, zTop, zBot, sigLabels, confWin, minRR, maxTradesL2, useDistrib, uiLang == "AR / عربيّة")`
   - المتوسطة: `[mlb, mle, mlzt, mlzb, mlup] = jws.f_emitDegSignals(mcBar, mcTop, mcPrc, mcEff, mcCovArr, sigDir, histLs, f_t("متوسطة","Medium"), mActVg, lgBar, lgTop, lgPrc, lgEff, zTop, zBot, sigLabels, confWin, minRR, maxTradesL2, useDistrib, uiLang == "AR / عربيّة")`
   - الخروج: `jws.f_emitExit(sigDir, math.max(histLs, bar_index - 500), zTop, zBot, sigLabels, minRR, uiLang == "AR / عربيّة")`
5. **شبكة الحيّة** (استبدل نداءات `f_sigLvl` بـ`jws.f_sigLvl(..., sigLvlExt)`): مثال `jws.f_sigLvl(sigLvLines, sigLvMarks, liveB, liveStp, "✕", "SL", #F23645, sigLvlExt)` (وEntry/TP كذلك بإضافة `sigLvlExt` وسيطًا أخيرًا).
6. **رقم الإصدار:** v2.67.0 «فصل طبقة الإشارات ⇒ JW_Signals/1».

**تغيير التوقيع عن النسخة المحلّيّة:** حُذِف من `f_emitDegSignals` وسائط `hL2/wHi/wLo/covLater` (استُبدِلت بـ`aCov` المُحسَبة) ⇒ **تكافؤ مضمون** (aCov = نفس f_coveredAt لكلّ نقطة). ⚠️ عند الترجمة: راقب أنّ `close[ok]` داخل المكتبة لا يطلب `max_bars_back` إضافيًّا (المؤشّر يضبط 5000 — يُفترَض أن يكفي؛ إن شكا، أضِف `max_bars_back(close, 500)` بالمؤشّر).

## 6) بعد هذه المرحلة (طلب المالك)
> «سنبدأ بعد هذه المرحلة بإضافة المؤشّرات وتقييم الإشارات التي اتفقنا عليها مسبقًا» — أي **طبقة التلاقي** (`spec_confluence_sma_ema_rsi.md`) + التقييم الكمّيّ (`strategy()`)، فوق مكتبة الإشارات النظيفة.
