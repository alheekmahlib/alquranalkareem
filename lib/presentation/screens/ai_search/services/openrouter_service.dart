part of '../ai_search.dart';

/// نموذج بيانات يمثل مزوّد LLM واحد (OpenAI-compatible).
///
/// كل المزودين (z.ai, Google, Groq, OpenRouter) يستخدمون نفس صيغة
/// `/chat/completions`، فلا حاجة لمنطق منفصل لكل مزود — يكفي تغيير
/// `baseUrl` و `apiKey` و `model`.
class LlmProvider {
  /// معرّف فريد (يُستخدم للحفظ في GetStorage).
  final String id;

  /// الاسم المعروض في القائمة المنسدلة.
  final String displayName;

  /// الرابط الأساسي للمزود (بدون /chat/completions).
  final String baseUrl;

  /// معرّف النموذج كما يتوقعه المزود.
  final String model;

  /// اسم متغيّر البيئة الذي يحوي مفتاح الـ API (في .env).
  final String envKeyName;

  /// هل النموذج مجاني وغير محدود؟ (يؤثر على أولوية الـ fallback).
  final bool isFreeUnlimited;

  /// هل النموذج يدعم function calling (tools) بشكل موثوق؟
  /// النماذج التي لا تدعم tools تُستبعد من fallback عند طلبات tool calling.
  final bool supportsTools;

  const LlmProvider({
    required this.id,
    required this.displayName,
    required this.baseUrl,
    required this.model,
    required this.envKeyName,
    this.isFreeUnlimited = false,
    this.supportsTools = true,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is LlmProvider && other.id == id);

  @override
  int get hashCode => id.hashCode;

  /// هل يوجد مفتاح لهذا المزود في .env؟
  bool get hasKey {
    final key = dotenv.maybeGet(envKeyName) ?? '';
    return key.isNotEmpty && !key.contains('YOUR_KEY');
  }
}

/// عميل LLM عام متعدد المزودين (جميعهم OpenAI-compatible).
///
/// يرسل طلبات `/chat/completions` مع دعم `tools` (function-calling) ومعالجة
/// `tool_calls` في الرد. يستخدم Dio مباشرة. يدعم التبديل بين المزودين
/// وfallback تلقائي عند فشل المزود المختار.
class LlmService {
  LlmService._();
  static final LlmService _instance = LlmService._();
  factory LlmService() => _instance;

  /// قائمة المزودين المدعومين (الترتيب = ترتيب الظهور في القائمة + fallback).
  ///
  /// Mistral Small أولاً (سريع جداً + أدوات ممتازة)، ثم z.ai كشبكة أمان
  /// غير محدودة عند نفاد سقف Mistral الشهري، ثم باقي الخيارات.
  /// ملاحظة: Groq محذوفة لأن حد TPM المنخفض (6000) يفشل مع system prompt الطويل
  /// وقائمة الأدوات الـ17.
  static const List<LlmProvider> providers = [
    // ── Mistral: الافتراضي — سريع جداً، فئة مجانية دائمة، يدعم tools ──
    LlmProvider(
      id: 'mistral-small',
      displayName: 'Mistral Small (Mistral AI)',
      baseUrl: 'https://api.mistral.ai/v1',
      model: 'mistral-small-latest',
      envKeyName: 'MISTRAL_API_KEY',
    ),
    // ── z.ai: شبكة أمان — مجاني تماماً وغير محدود ──
    LlmProvider(
      id: 'zai-glm-4-5-flash',
      displayName: 'GLM 4.5 Flash (z.ai)',
      baseUrl: 'https://api.z.ai/api/paas/v4',
      model: 'glm-4.5-flash',
      envKeyName: 'ZAI_API_KEY',
      isFreeUnlimited: true,
    ),
    LlmProvider(
      id: 'zai-glm-4-7-flash',
      displayName: 'GLM 4.7 Flash (z.ai)',
      baseUrl: 'https://api.z.ai/api/paas/v4',
      model: 'glm-4.7-flash',
      envKeyName: 'ZAI_API_KEY',
      isFreeUnlimited: true,
    ),
    // ─ـ خيارات إضافية ──
    LlmProvider(
      id: 'mistral-medium',
      displayName: 'Mistral Medium (Mistral AI)',
      baseUrl: 'https://api.mistral.ai/v1',
      model: 'mistral-medium-latest',
      envKeyName: 'MISTRAL_API_KEY',
    ),
    LlmProvider(
      id: 'nemotron',
      displayName: 'Nemotron Ultra 550B (OpenRouter)',
      baseUrl: 'https://openrouter.ai/api/v1',
      model: 'nvidia/nemotron-3-ultra-550b-a55b:free',
      envKeyName: 'OPENROUTER_API_KEY',
      // Nemotron لا يدعم function calling بشكل موثوق — يكتب tool_calls كنص خام.
      supportsTools: false,
    ),
  ];

  /// المزود الافتراضي: أول مزود له مفتاح (الأولوية لـ z.ai المجاني غير المحدود).
  static LlmProvider get defaultProvider {
    for (final p in providers) {
      if (p.hasKey) return p;
    }
    // لا مفاتيح على الإطلاق — نرجع z.ai ليُظهر رسالة خطأ واضحة عند الاستخدام.
    return providers.first;
  }

  /// المزودون الذين لهم مفاتيح في .env فقط (لعرضهم في القائمة المنسدلة).
  static List<LlmProvider> get availableProviders =>
      providers.where((p) => p.hasKey).toList();

  /// نص تعليمات النظام (System Prompt) الذي يوجّه النموذج.
  static const String _systemPrompt = '''أنت "المساعد الذكي" في تطبيق "القرآن الكريم - مكتبة الحكمة"، \
مساعدٌ متخصصٌ في القرآن الكريم وعلومه (التفسير، الإعراب، الصرف، أسباب النزول، القراءات، الإحصاءات).

## مهمتك
- أجب عن أسئلة المستخدم المتعلقة بالقرآن وعلومه بدقةٍ ومصادر موثوقة.
- **استخدم الأدوات المتاحة دائماً** للحصول على البيانات الصحيحة بدل الاعتماد على ذاكرتك وحدك. \
عند سؤال عن آيةٍ أو تفسيرٍ أو إعرابٍ أو إحصاء، نادِ الأداة المناسبة أولاً ثم اصيغ الإجابة من نتائجها.
- صُغ إجاباتك بلغة عربية فصيحة وواضحة، مع تنسيق Markdown عند الحاجة (عناوين، قوائم، اقتباسات).
- **استخدم صيغة Markdown القياسية فقط**: للقوائم المرقّمة استخدم `1.` `2.` `3.`، \
وللنقاط استخدم `-` أو `*`. **لا تستخدم رموزاً تعبيرية (emoji) أو أحرفاً خاصة** \
(مثل ① ② 🔹 ✅ ❌) بدل الترقيم أو النقاط.

## قواعد استخدام الأدوات
- لجلب نص آية: `fetch_ayah` (بالرقم: surah, ayah).
- لجلب التفسير: `fetch_tafsir` (surah, ayah).
- لإعراب كلمة وتحليلها الصرفي: `analyze_word` (surah, ayah, word_no).
- للبحث النصي في القرآن: `search_quran_text` (query).
- لمعلومات سورة أو إحصاءاتها: `fetch_surah_info` / `get_surah_statistics`.

## تنظيف مخرجات الأدوات (مهم جداً)
- الأدوات تُعيد أحياناً صيغاً تقنية خام يجب **عدم** عرضها للمستخدم. نظّفها دائماً:
  - القراءات بصيغة `@قارئ/قراءة@` (مثل `@نافع/وقف@`): حوّلها إلى نص مقروء، \
مثل: «قرأ نافع بالوقف». لا تعرض الرمز `@...@` أبداً.
  - علامات الإعراب الصرفية والرموز التقنية: اشرحها بالعربية المبسّطة.
- اعرض الآيات القرآنية **كاملةً** بإحاطتها بعلامات backtick مفردة، \
مثل: `بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ`. \
لكن **أعد صياغة** التفاسير وكلام العلماء بكلامك دون تحريف للمعنى.

## نسبة المصادر (مهم جداً)
- المصدر الفعلي للبيانات هو **«مركز تفسير» (tafsir.net)** عبر خادم tafsir-mcp، \
وليس «مكتبة الحكمة». التطبيق مجرد واجهة.
- عند ذكر المصدر، اكتب: «المصدر: قاعدة بيانات مركز تفسير (tafsir.net)». \
لا تنسب البيانات إلى «مكتبة الحكمة» أو إلى نفسك.

## السلوك العام
- إن لم يكن السؤال متعلقاً بالقرآن وعلومه، اعتذر بأدب ووضّح أن تخصصك القرآن وعلومه.
- كن مختصراً ما أمكن دون إخلالٍ بالفائدة.
- لا تخترع معلومات: إن لم تجد بيانات كافية من الأدوات، فاذكر ذلك بصراحة.''';

  /// التعليمات الافتراضية للنظام — جاهزة لإرفاقها كأول رسالة.
  static Map<String, dynamic> get systemMessage =>
      {'role': 'system', 'content': _systemPrompt};

  /// يرسل طلب إكمال محادثة مع fallback تلقائي بين المزودين المتاحين.
  ///
  /// يبدأ بـ [provider] المختار، وإن فشل (429/401/404/503/400) يجرّب بقية
  /// المزودين الذين لهم مفاتيح حتى ينجح أحدهم.
  ///
  /// [onFallback] يُستدعى (مع المزود الناجح) عند نجاح fallback — يُستخدم
  /// لتحديث القائمة وإظهار تنبيه للمستخدم.
  Future<LlmResponse> chatCompletion({
    required List<Map<String, dynamic>> messages,
    List<Map<String, dynamic>> tools = const [],
    required LlmProvider provider,
    void Function(LlmProvider fallbackProvider)? onFallback,
  }) async {
    // ابنِ قائمة المحاولة: المختار أولاً، ثم بقية المزودين المتاحين.
    // عند طلب tool calling، استبعد النماذج التي لا تدعم tools (تكتبها كنص خام).
    final wantsTools = tools.isNotEmpty;
    final candidates = <LlmProvider>[provider];
    for (final p in availableProviders) {
      if (candidates.contains(p)) continue;
      if (wantsTools && !p.supportsTools) continue;
      candidates.add(p);
    }

    Object? lastError;
    for (final candidate in candidates) {
      try {
        final response = await _callOnce(
          provider: candidate,
          messages: messages,
          tools: tools,
        );
        // لو نجح نموذج غير المختار → أبلغ عن الـ fallback.
        if (candidate.id != provider.id) {
          onFallback?.call(candidate);
        }
        return response;
      } on _RetryableLlmError catch (e) {
        log('Provider ${candidate.id} unavailable (${e.code}), trying next…',
            name: 'LlmService');
        lastError = e;
        continue;
      }
    }
    if (lastError is LlmException) throw lastError;
    throw const LlmException('تعذّر الوصول لأي نموذج متاح. تحقق من مفاتيح API في .env');
  }

  /// ينفّذ طلباً واحداً لمزود محدد.
  Future<LlmResponse> _callOnce({
    required LlmProvider provider,
    required List<Map<String, dynamic>> messages,
    required List<Map<String, dynamic>> tools,
  }) async {
    final apiKey = _getKey(provider);
    final body = <String, dynamic>{
      'model': provider.model,
      'messages': messages,
      // temperature=0 يجعل النموذج حتمياً (deterministic) وأكثر التزاماً باستدعاء
      // الأدوات دائماً بدل التخمين/الهلوسة. القيمة الافتراضية (1.0) تسبب عشوائية
      // فيتجاهل النموذج الأدوات أحياناً ويعطي إجابات وهمية.
      'temperature': 0,
    };
    if (tools.isNotEmpty) {
      body['tools'] = tools;
      body['tool_choice'] = 'auto';
    }
    // عطّل «التفكير الداخلي» (reasoning) لمزودي z.ai لأنه يسبب تأخيراً كبيراً
    // (دقائق) مع حلقة الأدوات. الاختبار أظهر تسريعاً 10×+ مع تعطيله.
    if (provider.baseUrl.contains('z.ai')) {
      body['thinking'] = {'type': 'disabled'};
    }

    final dio = Dio(BaseOptions(
      baseUrl: provider.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 120),
      validateStatus: (_) => true,
    ));

    final response = await dio.post(
      '/chat/completions',
      data: jsonEncode(body),
      options: Options(
        headers: _buildHeaders(provider, apiKey),
        responseType: ResponseType.json,
      ),
    );

    final status = response.statusCode ?? 0;
    // أخطاء "جرّب مزوّداً آخر" (بما فيها 400 للنماذج المستغنى عنها).
    if (status == 400 || status == 404 || status == 429 ||
        status == 503 || status == 402) {
      throw _RetryableLlmError(
        code: status,
        message: _extractErrorMessage(response.data),
      );
    }
    if (status >= 400) {
      throw LlmException(
        '${provider.displayName} error $status: ${_extractErrorMessage(response.data)}',
      );
    }

    final data = response.data as Map<String, dynamic>;
    return LlmResponse.fromJson(data);
  }

  /// يبني الترويسات المناسبة لكل مزود (كلهم OpenAI-compatible لكن مع اختلافات).
  Map<String, String> _buildHeaders(LlmProvider provider, String apiKey) {
    final headers = <String, String>{
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };
    // OpenRouter يتطلب ترويسات إضافية.
    if (provider.id == 'nemotron') {
      headers['HTTP-Referer'] = 'https://alheekmahlib.com';
      headers['X-Title'] = 'AlQuran AlKareem';
    }
    return headers;
  }

  /// يجلب مفتاح الـ API للمزود من .env.
  String _getKey(LlmProvider provider) {
    final key = dotenv.maybeGet(provider.envKeyName) ?? '';
    if (key.isEmpty || key.contains('YOUR_KEY')) {
      throw LlmException(
        'لا يوجد مفتاح API لـ ${provider.displayName}. '
        'أضف ${provider.envKeyName} إلى assets/.env',
      );
    }
    return key;
  }

  /// يستخرج نص رسالة الخطأ من جسم ردّ المزود.
  String _extractErrorMessage(dynamic errBody) {
    if (errBody is Map) {
      final err = errBody['error'];
      if (err is Map) return err['message']?.toString() ?? '';
      return err.toString();
    }
    return errBody?.toString() ?? '';
  }
}

// ─── نماذج بيانات الاستجابة (مطابقة لصيغة OpenAI) ────────────────────

/// نتيجة طلب chat/completion، تحوي الردّ النصي و/أو طلبات الأدوات.
class LlmResponse {
  final String content;
  final List<LlmToolCall> toolCalls;
  final String model;

  const LlmResponse({
    required this.content,
    required this.toolCalls,
    required this.model,
  });

  factory LlmResponse.fromJson(Map<String, dynamic> json) {
    final choices = (json['choices'] as List?) ?? [];
    if (choices.isEmpty) {
      return const LlmResponse(content: '', toolCalls: [], model: '');
    }
    final firstChoice = choices.first as Map<String, dynamic>;
    final message = (firstChoice['message'] as Map<String, dynamic>?) ?? {};
    final content = message['content']?.toString() ?? '';

    final rawToolCalls = message['tool_calls'] as List? ?? [];
    final toolCalls = rawToolCalls
        .map((t) => LlmToolCall.fromJson(t as Map<String, dynamic>))
        .toList();

    return LlmResponse(
      content: content,
      toolCalls: toolCalls,
      model: json['model']?.toString() ?? '',
    );
  }

  bool get hasToolCalls => toolCalls.isNotEmpty;
}

/// طلب استدعاء أداة واحد من جانب النموذج.
class LlmToolCall {
  final String id;
  final String name;
  final Map<String, dynamic> arguments;

  const LlmToolCall({
    required this.id,
    required this.name,
    required this.arguments,
  });

  factory LlmToolCall.fromJson(Map<String, dynamic> json) {
    final function = (json['function'] as Map<String, dynamic>?) ?? {};
    final rawArgs = function['arguments'];
    Map<String, dynamic> args;
    if (rawArgs is String) {
      try {
        final decoded = jsonDecode(rawArgs);
        args = decoded is Map<String, dynamic>
            ? decoded
            : Map<String, dynamic>.from(decoded as Map);
      } catch (_) {
        args = {};
      }
    } else if (rawArgs is Map) {
      args = Map<String, dynamic>.from(rawArgs);
    } else {
      args = {};
    }
    return LlmToolCall(
      id: json['id']?.toString() ?? '',
      name: function['name']?.toString() ?? '',
      arguments: args,
    );
  }
}

/// استثناء خاص بأخطاء LLM.
class LlmException implements Exception {
  final String message;
  const LlmException(this.message);
  @override
  String toString() => 'LlmException: $message';
}

/// خطأ قابل لإعادة المحاولة بمزوّد آخر (429، 503، 404، 402).
class _RetryableLlmError extends LlmException {
  final int code;
  const _RetryableLlmError({
    required this.code,
    required String message,
  }) : super('LLM error $code: $message');
}
