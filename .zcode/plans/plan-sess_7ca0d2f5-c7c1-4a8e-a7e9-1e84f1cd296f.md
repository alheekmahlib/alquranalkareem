# خطة: اختيار النموذج (Multi-Provider) في المساعد الذكي

## الحقائق المؤكدة
كل المزودين **OpenAI-compatible** (نفس `/chat/completions` + `tools`):
- **z.ai GLM-4.7-Flash** (الافتراضي، مجاني غير محدود): `https://api.z.ai/api/paas/v4/`، model `glm-4.7-flash`، key `ZAI_API_KEY`
- **Google Gemini 2.5 Flash** (مجاني): `https://generativelanguage.googleapis.com/v1beta/openai/`، model `gemini-2.5-flash`، key `GEMINI_API_KEY`
- **Groq** (مجاني، سريع جداً): `https://api.groq.com/openai/v1`، models `llama-3.3-70b-versatile` / `gemma2-9b-it` / `mixtral-8x7b-32768`، key `GROQ_API_KEY`
- **OpenRouter** (احتياطي): `https://openrouter.ai/api/v1`، key `OPENROUTER_API_KEY`

---

## 1. تعميم `OpenRouterService` → `LlmService` متعدد المزودين

في `services/openrouter_service.dart` (نُعيد تسميتها منطقياً لـ LlmService):

### نموذج `LlmProvider` (نموذج بيانات ثابت):
```dart
class LlmProvider {
  final String id;              // 'zai'
  final String displayName;     // 'GLM 4.7 Flash (z.ai)'
  final String baseUrl;         // 'https://api.z.ai/api/paas/v4'
  final String model;           // 'glm-4.7-flash'
  final String envKeyName;      // 'ZAI_API_KEY'
  final bool isFreeUnlimited;   // true لـ z.ai
  const LlmProvider({...});
}
```

### قائمة المزودين الثابتة:
```dart
static const List<LlmProvider> providers = [
  LlmProvider(id: 'zai', displayName: 'GLM 4.7 Flash', baseUrl: 'https://api.z.ai/api/paas/v4', model: 'glm-4.7-flash', envKeyName: 'ZAI_API_KEY', isFreeUnlimited: true),
  LlmProvider(id: 'gemini', displayName: 'Gemini 2.5 Flash', baseUrl: 'https://generativelanguage.googleapis.com/v1beta/openai', model: 'gemini-2.5-flash', envKeyName: 'GEMINI_API_KEY'),
  LlmProvider(id: 'groq-llama', displayName: 'Llama 3.3 70B (Groq)', baseUrl: 'https://api.groq.com/openai/v1', model: 'llama-3.3-70b-versatile', envKeyName: 'GROQ_API_KEY'),
  LlmProvider(id: 'groq-gemma', displayName: 'Gemma 2 9B (Groq)', baseUrl: 'https://api.groq.com/openai/v1', model: 'gemma2-9b-it', envKeyName: 'GROQ_API_KEY'),
  LlmProvider(id: 'groq-mixtral', displayName: 'Mixtral 8x7B (Groq)', baseUrl: 'https://api.groq.com/openai/v1', model: 'mixtral-8x7b-32768', envKeyName: 'GROQ_API_KEY'),
  LlmProvider(id: 'nemotron', displayName: 'Nemotron Ultra 550B', baseUrl: 'https://openrouter.ai/api/v1', model: 'nvidia/nemotron-3-ultra-550b-a55b:free', envKeyName: 'OPENROUTER_API_KEY'),
];
```

### `chatCompletion` يصبح dynamic:
- يأخذ `provider` محدد (يحدّد baseUrl + model + apiKey).
- يبني `Dio` جديد لكل مزود (لأن baseUrl يختلف) بدل singleton بـ baseUrl ثابت.
- `apiKey` يُقرأ من `dotenv.get(provider.envKeyName)`.
- يحتفظ بـ fallback (للمزودين المجانيين فقط، عبر تبديل المزود لا النموذج).

### إزالة المنطك القديم:
- حذف `_freeModels`, `_modelsToTry`, `_defaultModel`, `OPENROUTER_MODEL` (لم نعد نحتاجه — الاختيار صريح الآن).

---

## 2. حالة المزود المختار في `AiSearchState`

أضيف:
```dart
/// المزود المختار حالياً (يُحفظ في GetStorage).
final Rx<LlmProvider> selectedProvider = LlmService.defaultProvider.obs;
```
- `defaultProvider` = مزود z.ai glm-4.7-flash (طالما مفتاحه موجود، وإلا أول مزود له مفتاح).
- الاختيار يُحفظ في GetStorage (مفتاح `ai_search_selected_provider`).
- عند الإقلاع: اقرأ المحفوظ، وتحقق أن مفتاحه موجود، وإلا ارجع للـ default.

---

## 3. `AssistantOrchestrator` يستخدم المزود المختار

`chatCompletion` يُمرَّر له `provider: state.selectedProvider.value`.
- الـ fallback: إن فشل المزود المختار (429/401)، جرّب بقية المزودين الذين لهم مفاتيح.

---

## 4. Dropdown النماذج في `InputBarWidget` (وضع المساعد)

widget جديد `ModelSelectorWidget` (StatelessWidget، `part of`) بنمط `SectionFilterWidget`:
- `DropdownButton2<LlmProvider>` مع `customButton` على شكل pill (أيقونة `Icons.psychology`/`model_training` + اسم النموذج المختار).
- يعرض فقط المزودين الذين **لهم مفاتيح** في `.env` (يتحقّص `_availableProviders()`).
- عند الاختيار: `ctrl.selectProvider(provider)`.
- في `InputBarWidget`، الصف السفلي في وضع المساعد يصبح:
  ```
  [زر الإرسال] [ModelSelectorWidget أو ToolCallIndicator]
  ```
  إن كانت أداة جارية → `ToolCallIndicator`؛ وإلا → `ModelSelectorWidget`.

---

## 5. التحكم في `AiSearchController`

أضيف طرقاً:
- `List<LlmProvider> get availableProviders` — المزودون الذين لهم مفاتيح.
- `void selectProvider(LlmProvider p)` — يضبط `state.selectedProvider` ويحفظه في GetStorage.
- في `sendAssistantMessage`: يمرّر `state.selectedProvider.value` للـ orchestrator.

---

## 6. تحديث `.env` و `.env.example`

أضيف مفاتيح كل المزودين (بقيم placeholder):
```
ZAI_API_KEY=
GEMINI_API_KEY=
GROQ_API_KEY=
OPENROUTER_API_KEY=...  # موجود مسبقاً
```

---

## 7. التوطين
مفاتيح جديدة لـ 11 لغة:
- `selectModel` (اختر النموذج)
- `noApiKey` (لا يوجد مفتاح لهذا النموذج في .env)
- أسماء المزودين تُعرض كما هي (نصوص مباشرة، لا توطين).

---

## 8. الترتيب
1. تحديث `.env` و `.env.example` بالمفاتيح الجديدة.
2. تعميم `OpenRouterService` → `LlmService` + `LlmProvider` model.
3. إضافة `selectedProvider` لـ `AiSearchState` + الحفظ/الاستعادة.
4. تحديث `AssistantOrchestrator` لتمرير المزود.
5. إضافة `ModelSelectorWidget`.
6. دمج `ModelSelectorWidget` في `InputBarWidget` (وضع المساعد).
7. طرق التحكم في `AiSearchController` (availableProviders, selectProvider).
8. التوطين.
9. `flutter analyze`.

## القيود
- ✅ لا StatefulWidget، لا تكرار كود، فصل اللوجيك عن الـ UI.
- ✅ إعادة استخدام DropdownButton2 و نمط SectionFilterWidget.
- ✅ كل المزودين عبر service واحد (OpenAI-compatible).
- ✅ الاختيار محفوظ في GetStorage، والنماذج بلا مفتاح تُخفى.