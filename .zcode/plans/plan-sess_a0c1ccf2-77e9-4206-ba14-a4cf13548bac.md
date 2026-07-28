# خطة إضافة ميزة البحث في قسم الأذكار

## ملخص
إضافة حقل بحث مدمج في أعلى شاشة قائمة الأقسام (`AdhkarList`). عند الكتابة، تختفي قائمة الأقسام وتظهر نتائج البحث (نص الذكر مظلّل + التصنيف). عند الضغط على نتيجة: الانتقال لشاشة القسم (`AdhkarItem`) مع **تمرير سلس** إلى الذكر المطلوب و**تمييز بصري مؤقت** (إطار ملوّن يختفي بعد ثوانٍ).

**نطاق البحث**: `zekr` (نص الذكر) + `description` (الوصف) + `category` (التصنيف).
**معالجة التشكيل**: البحث يتجاهل التشكيل ويساوي بين أ/إ/آ (إعادة استخدام `removeDiacriticsQuran`).

---

## التعديلات (6 خطوات)

### 1️⃣ `lib/presentation/screens/adhkar/controller/adhkar_state.dart` — إضافة حقول الحالة
إضافة الحقول التالية داخل `AdhkarState`:
```dart
final TextEditingController searchController = TextEditingController();   // حقل البحث
var searchQuery = ''.obs;                                                  // نص الاستعلام
var searchResults = <AdhkarData>[].obs;                                    // نتائج البحث
var targetZekrId = Rxn<int>();                                             // الذكر المستهدف للتمرير إليه
var highlightedZekrId = Rxn<int>();                                        // تمييز بصري مؤقت
Timer? _highlightTimer;                                                    // مؤقت إزالة التمييز (مع getter/setter)
final GlobalKey<ScrollableState>? Function(int id) targetKey; // اختياري - نستخدم نهج أبسط
```
في الواقع سأستخدم نهج أبسط: `Map<int, GlobalKey>` لتتبّع مفاتيح العناصر المرئية في `AdhkarItem`، مع `ScrollController` جديد للشاشة.

**الحقول الفعلية المراد إضافتها**:
- `TextEditingController searchController`
- `RxString searchQuery`
- `RxList<AdhkarData> searchResults`
- `RxnInt targetZekrId` (الذكر المستهدف للانتقال)
- `RxnInt highlightedZekrId` (للتمييز البصري)
- `ScrollController itemScrollController` (لتمرير `AdhkarItem`)
- `Map<int, GlobalKey> itemKeys` (لتتبّع مواقع العناصر)
- `Timer? highlightTimer`

### 2️⃣ `lib/presentation/screens/adhkar/controller/adhkar_controller.dart` — منطق البحث والتنقل
إضافة ثلاث دوال:

**`searchDhekr(String query)`**: يُستدعى عند `onChanged` في الحقل:
- يحفظ `searchQuery.value = query`
- إذا كان النص فارغاً بعد التنظيف → يمسح `searchResults`
- وإلا → يبحث في `allAdhkar` حيث يطابق (بعد `removeDiacriticsQuran`) أيٌّ من `zekr` / `description` / `category` النص المُدخَل
- يعيّن `searchResults.assignAll(نتائج)`

**`clearSearch()`**: يمسح `searchController` و`searchQuery` و`searchResults`.

**`navigateToZekr(AdhkarData zekr)`**: يُستدعى عند الضغط على نتيجة:
```dart
targetZekrId.value = zekr.id;           // علّمه كهدف للتمرير
filterByCategory(zekr.category);        // اعرض قسمه
Get.to(() => const AdhkarItem(), transition: Transition.downToUp);
```

**`scrollToTargetZekr()`**: يُستدعى من `AdhkarItem` بعد البناء (في `addPostFrameCallback`):
- يجد index العنصر ذي `id == targetZekrId.value` داخل `filteredDhekrList`
- يحسب الإزاحة التقريبية باستخدام `itemKeys[id]?.currentContext` و`Scrollable.ensureVisible` (موثوق مع الارتفاعات المتغيرة)
- يستدعي `Scrollable.ensureVisible(context, alignment: 0.3, duration: 500ms)`
- يشغّل `highlightZekr(id)`

**`highlightZekr(int id)`**: يضبط `highlightedZekrId.value = id` ويبدأ `highlightTimer` لمدة 3 ثوانٍ ثم يصفره (مع إلغاء أي timer سابق).

إضافة `@override void onClose()` لتنظيف `searchController` و`highlightTimer` و`itemScrollController`.

### 3️⃣ `lib/presentation/screens/adhkar/widgets/adhkar_list.dart` — واجهة البحث (التعديل الرئيسي)
تحويل `AdhkarList` لـ `StatelessWidget` مع `Column`:
```dart
Column(children: [
  // 1) حقل البحث — نمط مشابه لـ TextFieldBarWidget لكن بأسلوب الأذكار
  _searchField(),                     // Directionality.rtl + TextField + أيقونة بحث + زر مسح
  // 2) محتوى يتبدّل حسب وجود استعلام بحث
  Expanded(child: Obx(() {
    if (searchQuery.isEmpty) return _categoriesListView();   // القائمة الحالية
    if (searchResults.isEmpty) return _emptyState();         // لا توجد نتائج
    return _searchResultsListView();                         // نتائج البحث
  })),
])
```
- **`_searchField`**: `TextField` بـ `onChanged: azkarCtrl.searchDhekr`، حقل RTL، أيقونة بحث يميناً (SVG موجود `SvgPath.svgHomeSearch`)، زر مسح (×) عند وجود نص. hintText = `'searchAzkar'.tr`.
- **`_searchResultsListView`**: `ListView.builder` على `searchResults`، كل عنصر `GestureDetector` → `onTap: navigateToZekr(zekr)`:
  - بطاقة تعرض نص الذكر (مع تظليل عبر `zekr.zekr.highlightLine(query)`) متبوعاً بشريط صغير يحوي اسم التصنيف (`zekr.category`) والتكرار.
  - `Directionality.rtl`، تصميم متناسق مع `TextWidget` الحالية (خلفية `primary.withValues(alpha:.1)` + حدود `primaryColorLight`).
- **`_emptyState`**: أيقونة Lottie أو نص `'noAzkarResults'.tr` وسط الشاشة.
- الإبقاء على الـ animation الموجود (`AnimationLimiter`) لقائمة الأقسام فقط.

### 4️⃣ `lib/presentation/screens/adhkar/screens/adhkar_item.dart` — التمرير + التمييز البصري
التعديلات على `AdhkarItem` (تحويلها لـ `StatefulWidget` لاستدعاء post-frame logic):
- ربط `ListView.builder` بـ `controller: azkarCtrl.state.itemScrollController`
- لكل عنصر: `GlobalKey` يُخزَّن في `azkarCtrl.state.itemKeys[zekr.id]` عبر `(key) => itemKeys[zekr.id] = key`
- إحاطة بطاقة العنصر بـ `Obx(() => Container(decoration: highlightedZekrId.value == zekr.id ? إطار_ملوّن : null, ...))`
- في `initState`: `WidgetsBinding.instance.addPostFrameCallback((_) => azkarCtrl.scrollToTargetZekr())`

### 5️⃣ `assets/locales/*.json` — الترجمات (11 لغة)
إضافة مفتاحين لكل لغة (ar, en, es, tr, bn, ur, so, id, ph, ku, ru) مع `@`-metadata كالنمط المتبع:
- **`searchAzkar`**: نص الـ hint (مثال عربي: "ابحث عن ذكر...")
- **`noAzkarResults`**: "لا توجد نتائج"

### 6️⃣ اختبار بصري يدوي
- تشغيل التطبيق، فتح قسم الأذكار، كتابة كلمة (مثلاً "اللهم")، التحقق من ظهور النتائج مظلّلة، الضغط على نتيجة، التحقق من:
  - الانتقال لشاشة القسم الصحيح
  - التمرير السلس إلى الذكر
  - ظهور التمييز البصري ثم اختفائه بعد ~3 ثوانٍ

---

## نقاط تصميمية مهمة
- **إعادة الاستخدام**: `highlightLine` من `highlight_extension.dart` (يُصدَّر من `text_span_extension.dart:592`)، `removeDiacriticsQuran`، نمط `TextFieldBarWidget`، و`Directionality.rtl`.
- **لماذا `Scrollable.ensureVisible` بدل `animateToWithOffset`**: لأن ارتفاعات الأذكار متفاوتة جداً (نصوص طويلة/قصيرة) فلا يمكن حساب offset بدقّة. `ensureVisible` يتعامل معها بشكل صحيح.
- **لماذا `targetZekrId` عبر state**: يتيح تمرير الهدف من حقل البحث إلى الشاشة الوجهة دون تغيير signature `AdhkarItem` (التي تُستدعى بدون معاملات في عدة أماكن: الإشعارات، قائمة الأقسام).
- **تنظيف الموارد**: `onClose` في الـ controller يلغي `highlightTimer` ويبدّد `searchController` و`itemScrollController`.
- **لا مسح للقائمة الأصلية**: `searchResults` منفصلة عن `filteredDhekrList` فلا تتعارض مع التصفية الحالية أو الإشعارات.

## الملفات المعدَّلة (ملخّص)
| الملف | نوع التغيير |
|---|---|
| `controller/adhkar_state.dart` | إضافة حقول |
| `controller/adhkar_controller.dart` | إضافة 4 دوال + `onClose` |
| `widgets/adhkar_list.dart` | إعادة هيكلة (حقل بحث + نتائج) |
| `screens/adhkar_item.dart` | StatefulWidget + ScrollController + تمييز |
| `assets/locales/*.json` (11 ملف) | مفتاحا ترجمة |

## الأخطار/المخاطر
- **`itemKeys` قد يتراكم** عند التنقل المتكرر بين الأقسام — الحل: مسح `itemKeys.clear()` عند الخروج من `AdhkarItem` (في `dispose` الـ stateful).
- **تداخل timer التمييز مع التنقل السريع** — معالَج بإلغاء الـ timer السابق في `highlightZekr` قبل بدء جديد.
- **الأداء**: 293 عنصراً في الذاكرة، البحث محلي بحت → فوري دون debounce.