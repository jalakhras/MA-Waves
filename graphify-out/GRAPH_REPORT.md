# Graph Report - graphify-src  (2026-07-16)

## Corpus Check
- Corpus is ~45,648 words - fits in a single context window. You may not need a graph.

## Summary
- 157 nodes · 333 edges · 7 communities
- Extraction: 88% EXTRACTED · 12% INFERRED · 0% AMBIGUOUS · INFERRED: 39 edges (avg confidence: 0.82)
- Token cost: 119,200 input · 464,322 output

## Community Hubs (Navigation)
- الرسم والتغطية (المؤشّر)
- الدرجة الكبيرة ومحرّك النقاط
- المعماريّة والمواصفات الحاكمة
- الإشارات واللوحات وMTF
- مراحل داو وترقيم إليوت
- التقطيع وسلسلة الموجات (ط0)
- خطوط السيولة والمستويات (ط2)

## God Nodes (most connected - your core abstractions)
1. `Block: conclusions/decision panel + live signal (lesson09/10 + Atlas)` - 21 edges
2. `Block: large degree build + drawing + Elliott (two methods behind useBigBreak)` - 19 edges
3. `DegreeLaws (UDT: degree laws state — trendDir, pending pivot, lastEffTop/BottomPrice coverage refs, effective* output arrays, justActivated upward-feed signal)` - 15 edges
4. `Block: medium/small chain build + medium circles drawing (islast)` - 14 edges
5. `spec_ط0_reset.md — مواصفة إعادة تأسيس ط0 من المصدر` - 14 edges
6. `Block: historical per-degree signals + exit + funnel diag table (islast)` - 11 edges
7. `Block: wave test panel compute (degrees shown + impulse stats)` - 11 edges
8. `buildWave (batch: build one wave [segL..segR] — direction from extremes, then INLINE literal copy of small-scan loop body, then syncPending; thin backward-compat batch path)` - 11 edges
9. `MWaves_layer_map.md — خريطة الطبقات الحاكمة` - 11 edges
10. `mcBar/mcPrc/mcTop/mcEff/mcTm (unified medium chain across all waves)` - 10 edges

## Surprising Connections (you probably didn't know these)
- `f_degree4 (MTF 4th-degree two-candle confirmation engine)` --semantically_similar_to--> `SmallScan (UDT: streaming small-degree detector state — scD leg direction, running hi/lo extreme price/bar/time, ccD two-candle correction counter, cpHi/cpLo body locks)`  [INFERRED] [semantically similar]
  J-Waves-M1_indicator.pine.txt → JW_Degrees_library.pine.txt
- `drawElliott (internal: 6-point window numbering (1)-(5) + a-b-c + forming wave labels)` --semantically_similar_to--> `f_phaseAt (Dow phase machine at historical bar atBar)`  [INFERRED] [semantically similar]
  JW_Elliott_library.pine.txt → JW_Conclusions_library.pine.txt
- `Block: conclusions/decision panel + live signal (lesson09/10 + Atlas)` --calls--> `f_liqDir (liquidity direction = sign of the liquidity line slope; display/verification only)`  [EXTRACTED]
  J-Waves-M1_indicator.pine.txt → JW_Lines_library.pine.txt
- `DegreeLaws (UDT: degree laws state — trendDir, pending pivot, lastEffTop/BottomPrice coverage refs, effective* output arrays, justActivated upward-feed signal)` --shares_data_with--> `f_levelLine (trend level: horizontal line on the BODY of the last effective extreme of the basis type — down=last effective top/resistance, up=last effective bottom/support; extends levelExtend bars)`  [INFERRED]
  JW_Degrees_library.pine.txt → JW_Lines_library.pine.txt
- `DegreeLaws (UDT: degree laws state — trendDir, pending pivot, lastEffTop/BottomPrice coverage refs, effective* output arrays, justActivated upward-feed signal)` --shares_data_with--> `f_liqPairAt (liquidity pair at atBar: strictly the two most recent adjacent effective extremes (<= atBar) consistent with direction — rising bottoms up / falling tops down; inconsistent => [-1,-1] = no line = ranging; no jump to older pair, no fallback)`  [INFERRED]
  JW_Degrees_library.pine.txt → JW_Lines_library.pine.txt

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Splitting loop -> curSub chain -> segLefts chain -> downstream consumers (surgery map)** — graphify_src_j_waves_m1_indicator_pine_for_gi_loop, graphify_src_j_waves_m1_indicator_pine_var_cursub_chain, graphify_src_j_waves_m1_indicator_pine_block_chain_build, graphify_src_j_waves_m1_indicator_pine_var_seg_chain, graphify_src_j_waves_m1_indicator_pine_block_wavebox_draw, graphify_src_j_waves_m1_indicator_pine_block_medium_chain_build, graphify_src_j_waves_m1_indicator_pine_block_large_degree, graphify_src_j_waves_m1_indicator_pine_block_zones, graphify_src_j_waves_m1_indicator_pine_block_deg_signals, graphify_src_j_waves_m1_indicator_pine_block_wave_panel [EXTRACTED 1.00]
- **Degree chains (sc/mc/lg) feed activeDir cache, lines, conclusions and signals** — graphify_src_j_waves_m1_indicator_pine_var_sc_chain, graphify_src_j_waves_m1_indicator_pine_var_mc_chain, graphify_src_j_waves_m1_indicator_pine_var_lg_chain, graphify_src_j_waves_m1_indicator_pine_block_activedir_cache, graphify_src_j_waves_m1_indicator_pine_block_level_lines, graphify_src_j_waves_m1_indicator_pine_block_liq_lines, graphify_src_j_waves_m1_indicator_pine_block_conclusions, graphify_src_j_waves_m1_indicator_pine_block_deg_signals [EXTRACTED 1.00]
- **Zones -> zone bounds -> live decision + historical/exit signal emission** — graphify_src_j_waves_m1_indicator_pine_block_zones, graphify_src_j_waves_m1_indicator_pine_var_zone_bounds, graphify_src_j_waves_m1_indicator_pine_block_conclusions, graphify_src_j_waves_m1_indicator_pine_f_emitdegsignals, graphify_src_j_waves_m1_indicator_pine_f_emitexit [EXTRACTED 1.00]
- **Streaming small-to-medium degree pipeline: feedBar steps SmallScan per bar, emits small pivots into DegreeLaws.feedPivot, feedMedium routes activated small pivots through BreakProc into medium raw + effective series, syncPending keeps the live medium pending extreme in sync** — graphify_src_jw_degrees_library_pine_feedbar, graphify_src_jw_degrees_library_pine_smallscan, graphify_src_jw_degrees_library_pine_feedpivot, graphify_src_jw_degrees_library_pine_feedmedium, graphify_src_jw_degrees_library_pine_breakproc, graphify_src_jw_degrees_library_pine_syncpending [EXTRACTED 1.00]
- **Batch/stream duality: buildWave is the batch path holding a literal inline copy of feedBar's scan-loop body (deliberate, measured duplication forced by TradingView compiler miscompilation of the SmallScan-wrapper pattern; buildWave slated for deletion after move 2)** — graphify_src_jw_degrees_library_pine_buildwave, graphify_src_jw_degrees_library_pine_feedbar, graphify_src_jw_degrees_library_pine_syncpending, graphify_src_jw_degrees_library_pine_tv_miscompile_rationale [EXTRACTED 1.00]
- **Liquidity line flow (lesson 08): f_liqPairAt selects the pair of effective extremes, f_liqPair wraps it at current bar, f_liqLine draws the sloped wick line through the pair, f_liqDir reports its slope sign; f_liqPairPhaseAt is the divergent phase-machine variant (older consistent pair + fallback, strict < atBar)** — graphify_src_jw_lines_library_pine_f_liqpairat, graphify_src_jw_lines_library_pine_f_liqpair, graphify_src_jw_lines_library_pine_f_liqline, graphify_src_jw_lines_library_pine_f_liqdir, graphify_src_jw_lines_library_pine_f_liqpairphaseat [EXTRACTED 1.00]
- **Dow phase pipeline: JW_Lines liquidity pair feeds f_phaseAt which f_phase wraps to realize the five-phase machine** — graphify_src_jw_lines_library_pine_f_liqpairphaseat, graphify_src_jw_conclusions_library_pine_f_phaseat, graphify_src_jw_conclusions_library_pine_f_phase, graphify_src_jw_conclusions_library_pine_dow_abc_phases [EXTRACTED 1.00]
- **Elliott numbering flow: ewRun alternation-cleans pivots, drawElliott applies the three rules and the a-b-c Dow correction** — graphify_src_jw_elliott_library_pine_ewrun, graphify_src_jw_elliott_library_pine_drawelliott, graphify_src_jw_elliott_library_pine_elliott_three_rules, graphify_src_jw_elliott_library_pine_abc_dow_correction [EXTRACTED 1.00]
- **Zone pairing law: f_pairZones combines price adjacency, direct-correction exception, and no-zone-in-zone containment** — graphify_src_jw_zones_library_pine_f_pairzones, graphify_src_jw_zones_library_pine_price_adjacency, graphify_src_jw_zones_library_pine_direct_correction_exception, graphify_src_jw_zones_library_pine_no_zone_in_zone [EXTRACTED 1.00]
- **تدفّق المحرّك الأماميّ: ط1 (درجات) → ط2 (كشف كسر المستوى) → trigger الانقلاب → ط0 (تحديث الموجة الفعّالة)** — graphify_src_mwaves_layer_map_layer1, graphify_src_mwaves_layer_map_layer2, graphify_src_spec_p0_reset_reversal_trigger, graphify_src_mwaves_layer_map_layer0, graphify_src_spec_p0_reset_forward_engine [EXTRACTED 1.00]
- **سلسلة التبعيّة الأحاديّة: السعر → ط0 → ط1 → ط2 → ط3 → ط4، كلّ سهم لأعلى فقط (لا دائرة)** — graphify_src_mwaves_layer_map_layer0, graphify_src_mwaves_layer_map_layer1, graphify_src_mwaves_layer_map_layer2, graphify_src_mwaves_layer_map_layer3, graphify_src_mwaves_layer_map_layer4, graphify_src_mwaves_layer_map_no_circle [EXTRACTED 1.00]
- **التقطيع بالتمريرتين: حدّ الموجة البنيويّ (ت1 مُثبَّت) ثمّ التقطيع بكسور مستوى المتوسط المُجمَّد (ت2)** — graphify_src_spec_p0_reset_two_pass, graphify_src_spec_p0_reset_wave_boundary, graphify_src_spec_p0_reset_break_of_medium_level [EXTRACTED 1.00]

## Communities (7 total, 0 thin omitted)

### Community 0 - "الرسم والتغطية (المؤشّر)"
Cohesion: 0.12
Nodes (32): Block: activeDir cache compute (islast, 3 degrees), Block: coverage cache compute (f_covLater x3), Block: historical per-degree signals + exit + funnel diag table (islast), Block: trend level lines (horizontal on bodies, 3 degrees), Block: liquidity lines (sloped on tails, 3 degrees, broken => dashed), Block: medium/small chain build + medium circles drawing (islast), Block: small degree drawing from scBar (last 90, arrows + links), Block: wave test panel compute (degrees shown + impulse stats) (+24 more)

### Community 1 - "الدرجة الكبيرة ومحرّك النقاط"
Cohesion: 0.14
Nodes (27): Block: large degree build + drawing + Elliott (two methods behind useBigBreak), Block: leg engine setup (jwf.newLegEngine + legInputs => bigDir), f_drawMedCircle (two stacked circle labels), f_lblSize (label size mapper), f_lblSizeIn (inner label size mapper), Input group: Elliott descriptive (showEW, ewStrict, ewOffset), Input group: L1 Large degree (useBigBreak, legLiveBreak), largeDeg/largeRaw/largeEffD/largeBreak (large-degree state objects) (+19 more)

### Community 2 - "المعماريّة والمواصفات الحاكمة"
Cohesion: 0.16
Nodes (26): JW_Degrees Library (Degree Pivot Engine, Layer 1), JW_Foundation Library (Layer 0: leg engine + historical wave core, pure — no input/drawing), MWaves_layer_map.md — خريطة الطبقات الحاكمة, السلّم مفتوح — N درجات لا ثلاث مثبَّتة, الدرجة الرابعة (الأكبر من الزرقاء) — نقطة الاستئناف, ط0 — الأساس (leg + الموجة التاريخية) · JW_Foundation/3, ط1 — القمم والقيعان (المحرّك الفراكتاليّ) · JW_Degrees/1, ط2 — الخطوط والتجدّد · JW_Lines/4 (+18 more)

### Community 3 - "الإشارات واللوحات وMTF"
Cohesion: 0.12
Nodes (24): Block: conclusions/decision panel + live signal (lesson09/10 + Atlas), Block: MTF confirmation (request.security f_degree4 on smaller TF), f_atlasDecision (FSM decision table from full state), f_degree4 (MTF 4th-degree two-candle confirmation engine), f_drawWavePanel (wave test panel), f_durTxt (duration to text), f_emitDegSignals (per-degree historical entry signals with gate+confirm+RR), f_emitExit (exit signals: zone break + retest + rejection) (+16 more)

### Community 4 - "مراحل داو وترقيم إليوت"
Cohesion: 0.14
Nodes (20): J-Waves M2 Indicator (root), JW_Conclusions Library (Layer 3: Conclusions & Market Phases), Despair trend break gate (despair to accumulation via break of last-two-opposite-rebounds trendline, extrapolation guard), Dow/Elliott ABC five-phase machine (participation/panic/despair/accumulation/distribution, Lesson 11), f_liqStrength (liquidity strength: overlap of extreme vs 2nd opposite extreme back), f_phase (thin wrapper: phase at current bar), f_phaseAt (Dow phase machine at historical bar atBar), Half-body break threshold (phase trigger = candle body midpoint crosses line, not wick touch) (+12 more)

### Community 5 - "التقطيع وسلسلة الموجات (ط0)"
Cohesion: 0.16
Nodes (18): Block: chain build (curSub* => segLefts, main degrees rebuild, anchor), Block: wave splitting islast (v0.23.0 wave-bounded build), Block: wave anchor islast (jwf.waveLeftStruct => wL0), Block: current-wave box + history boxes drawing, f_dark (darker border color), for gi splitting loop (recursive renewal: cut at every reversal), Input group: L0 Wave & Frame (waveMode, histBars, waveScaleDays, renewFwd, histDepth, show boxes), curSubL/curSubPx/curSubTop (reversal-boundary chain arrays) (+10 more)

### Community 6 - "خطوط السيولة والمستويات (ط2)"
Cohesion: 0.22
Nodes (10): f_liqBroken (sloped liquidity-line break detector, 2 closes), JW_Lines Library (Layer 2: liquidity lines + trend levels, lesson 08 — pure generalized drawing), Concept: break detection (L09), f_activeDir (effective direction), phases (Layer 3) and styling deliberately stay in the consumer indicator — NOT moved into JW_Lines (per library header), f_levelLine (trend level: horizontal line on the BODY of the last effective extreme of the basis type — down=last effective top/resistance, up=last effective bottom/support; extends levelExtend bars), f_liqDir (liquidity direction = sign of the liquidity line slope; display/verification only), f_liqLine (liquidity line: sloped through the WICKS of both pair extremes exactly, slope per candle (bar space, not time — gap instruments), extends liqExtend bars right), f_liqPair (thin wrapper: f_liqPairAt evaluated at current bar_index), f_liqPairAt (liquidity pair at atBar: strictly the two most recent adjacent effective extremes (<= atBar) consistent with direction — rising bottoms up / falling tops down; inconsistent => [-1,-1] = no line = ranging; no jump to older pair, no fallback) (+2 more)

## Ambiguous Edges - Review These
- `MTF «تثبيت التحليل» — كلّ موجة لها فريمها` → `الدرجة الرابعة (الأكبر من الزرقاء) — نقطة الاستئناف`  [AMBIGUOUS]
  MWaves_layer_map.md · relation: conceptually_related_to

## Knowledge Gaps
- **26 isolated node(s):** `f_dark (darker border color)`, `f_degVis (degree visible-structure judge: effective top AND bottom in window)`, `f_impulseIn (impulse medium legs count + durations in range)`, `f_drawArrow (7-point filled arrow polyline)`, `f_lblSize (label size mapper)` (+21 more)
  These have ≤1 connection - possible missing edges or undocumented components.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **What is the exact relationship between `MTF «تثبيت التحليل» — كلّ موجة لها فريمها` and `الدرجة الرابعة (الأكبر من الزرقاء) — نقطة الاستئناف`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **Why does `Block: conclusions/decision panel + live signal (lesson09/10 + Atlas)` connect `الإشارات واللوحات وMTF` to `الرسم والتغطية (المؤشّر)`, `الدرجة الكبيرة ومحرّك النقاط`, `مراحل داو وترقيم إليوت`, `خطوط السيولة والمستويات (ط2)`?**
  _High betweenness centrality (0.191) - this node is a cross-community bridge._
- **Why does `Block: large degree build + drawing + Elliott (two methods behind useBigBreak)` connect `الدرجة الكبيرة ومحرّك النقاط` to `الرسم والتغطية (المؤشّر)`, `مراحل داو وترقيم إليوت`, `التقطيع وسلسلة الموجات (ط0)`?**
  _High betweenness centrality (0.146) - this node is a cross-community bridge._
- **Why does `buildWave (batch: build one wave [segL..segR] — direction from extremes, then INLINE literal copy of small-scan loop body, then syncPending; thin backward-compat batch path)` connect `الدرجة الكبيرة ومحرّك النقاط` to `الرسم والتغطية (المؤشّر)`, `المعماريّة والمواصفات الحاكمة`, `التقطيع وسلسلة الموجات (ط0)`?**
  _High betweenness centrality (0.130) - this node is a cross-community bridge._
- **Are the 4 inferred relationships involving `Block: conclusions/decision panel + live signal (lesson09/10 + Atlas)` (e.g. with `Input group: Panels (positions, showConc, showFrameHelper)` and `Input group: L3 Phases (useDistrib, showPhaseLbl)`) actually correct?**
  _`Block: conclusions/decision panel + live signal (lesson09/10 + Atlas)` has 4 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `Block: large degree build + drawing + Elliott (two methods behind useBigBreak)` (e.g. with `Input group: Elliott descriptive (showEW, ewStrict, ewOffset)` and `Input group: L1 Large degree (useBigBreak, legLiveBreak)`) actually correct?**
  _`Block: large degree build + drawing + Elliott (two methods behind useBigBreak)` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `DegreeLaws (UDT: degree laws state — trendDir, pending pivot, lastEffTop/BottomPrice coverage refs, effective* output arrays, justActivated upward-feed signal)` (e.g. with `f_levelLine (trend level: horizontal line on the BODY of the last effective extreme of the basis type — down=last effective top/resistance, up=last effective bottom/support; extends levelExtend bars)` and `f_liqPairAt (liquidity pair at atBar: strictly the two most recent adjacent effective extremes (<= atBar) consistent with direction — rising bottoms up / falling tops down; inconsistent => [-1,-1] = no line = ranging; no jump to older pair, no fallback)`) actually correct?**
  _`DegreeLaws (UDT: degree laws state — trendDir, pending pivot, lastEffTop/BottomPrice coverage refs, effective* output arrays, justActivated upward-feed signal)` has 3 INFERRED edges - model-reasoned connections that need verification._