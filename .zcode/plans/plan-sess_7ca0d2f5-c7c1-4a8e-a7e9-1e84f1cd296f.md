# خطة: دمج المساعد الذكي في بحث القرآن (زر AI بدل زر Home)

## الفكرة المحورية (من اقتراح المستخدم)
زر `HomeChild` في `TopBarWidget` (الأسطر 127-180 من `tab_bar_widget.dart`) يتبدّل بـ **زر AI** فقط عندما يكون `topBarType == search` و `isHomeChild == true` (بحث القرآن). عند الإغلاق أو التبديل لقسم آخر → يعود زر Home الأصلي. هكذا تستغل المساحة ولا تتأثر بقية استخدامات `TopBarWidget` (التقويم، الأذكار، الكتب — 8 أماكن).

## تجنّب تعارض المكتبات
`QuranSearch` هو `part of quran.dart`، و `AssistantView/ModelSelectorWidget` هما `part of ai_search.dart`. دمج الاستيرادين يُخاطر بتعارضات (`Response`, أسماء كلاسات). **الحل**: أعرض widgets الـ AI عبر `bodyChild` parameter في `TopBarWidget` (الموجود فعلاً في السطر 232: `bodyChild ?? QuranSearch()`). هكذا أبني الـ widget في `quran_home.dart` (الذي يمكنه استيراد ai_search بأمان) وأمرّره كـ `bodyChild`، بدل دمج المكتبتين.

---

## 1. حالة التبديل في `SearchState`
في `search_state.dart`، أضيف:
```dart
final RxBool isAiMode = false.obs;
```

---

## 2. زر التبديل في `TopBarWidget` (tab_bar_widget.dart)
داخل فرع `isHomeChild == true` (السطر 129)، ألفّه بـ `Obx`:
```dart
isHomeChild
  ? Obx(() {
      // فقط في وضع بحث القرآن: اعرض زر AI بدل زر Home.
      if (quranCtrl.getTopBarType(TopBarType.search)) {
        return _buildAiToggleButton(context);  // زر ✨ للتبديل
      }
      // وإلا: زر Home الأصلي كما هو (الكود الحالي).
      return ContainerButton(/* ... زر home الحالي ... */);
    })
  : ...
```
- `_buildAiToggleButton`: `ContainerButton` بأيقونة `SvgPath.svgHomeAiMcp` (أو Icons.auto_awesome). عند الضغط: يقلب `searchCtrl.state.isAiMode.value` ويضبط `AiSearchController.instance.state.midasMode = MidasMode.assistant`.
- **لا يتأثر أي استخدام آخر** لـ TopBarWidget لأن الشرط يتطلب `topBarType == search`.

---

## 3. تعديل ربط `TextFieldBarWidget` في `quran_home.dart`
أعدّل callbacks الحالية:
- **`onChanged`**: في وضع AI (`searchCtrl.state.isAiMode.value == true`)، لا تفعل شيئاً (لا search ولا surahSearchMethod). في الوضع العادي، الكود الحالي.
- **`onSubmitted`**: في وضع AI، يستدعي `AiSearchController.instance.sendAssistantMessage(query)` ويمسح حقل quran_search. في الوضع العادي، `searchCtrl.addSearchItem(query)`.
- **`onButtonPressed` (زر X)**: في وضع AI، يمسح محادثة المساعد أيضاً.

---

## 4. عرض `AssistantView` عبر `bodyChild`
في `quran_home.dart`، ألفّ الـ `bodyChild` بـ `Obx`:
- **`isAiMode == true`**: أمرّر widget جديد أبنيه هنا يستدعي `AssistantView()` (من ai_search) + شريط `ModelSelectorWidget` أسفله (أو فوقه). هذا الـ widget يُمرَّر كـ `bodyChild` لـ `TopBarWidget`، فيُعرض بدل `QuranSearch()` عند تفعيل AI.
- **`isAiMode == false`**: `bodyChild: null` → يُعرض `QuranSearch()` الافتراضي.

---

## 5. إعادة الضبط عند الإغلاق
في `tab_bar_widget.dart` السطر 67-73 (`onStateChanged`)، عند `!isOpen`:
- أضيف `searchCtrl.state.isAiMode.value = false;`.
- وأيضاً `AiSearchController.instance.clearAssistantConversation();` لمسح المحادثة.

ملاحظة: `QuranSearchController` و `AiSearchController` كلاهما singleton متاح عبر `Get.find`، فالوصول آمن من `TopBarWidget`.

---

## 6. السلوك النهائي
1. المستخدم يفتح بحث القرآن → `topBarType = search` → زر Home يتبدّل بزر ✨ AI.
2. يضغط ✨ → يدخل وضع AI → يظهر `ModelSelectorWidget` + `AssistantView`.
3. يكتب سؤالاً → عند Enter → `sendAssistantMessage` → إجابة streaming.
4. يضغط ✨ مرة أخرى → يعود البحث العادي (آيات/سور).
5. يغلق `TopBarWidget` → كل شيء يُعاد ضبطه (isAiMode = false، محادثة ممسوحة).

---

## 7. الترتيب
1. إضافة `isAiMode` لـ `SearchState`.
2. تعديل `tab_bar_widget.dart`: زر AI بدل Home في وضع search + إعادة ضبط عند الإغلاق.
3. تعديل `quran_home.dart`: callbacks (onChanged/onSubmitted) + `bodyChild` يعرض AssistantView.
4. `flutter analyze`.

## القيود
- ✅ لا StatefulWidget، لا تكرار كود (AssistantView/ModelSelectorWidget/AiSearchController جاهزة).
- ✅ إرسال عند Enter فقط في وضع AI.
- ✅ لا يتأثر أي استخدام آخر لـ TopBarWidget.
- ✅ بدون ChatHistorySheet.
- ✅ إعادة ضبط كاملة عند الإغلاق/التبديل.