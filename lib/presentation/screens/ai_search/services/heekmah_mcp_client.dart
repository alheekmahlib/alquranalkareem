part of '../ai_search.dart';

/// عميل MCP Streamable HTTP لخادم alheekmah-mcp (الأقسام الإسلامية).
///
/// يتواصل مع خادم الأقسام (الحديث، الفقه، العقيدة، السيرة) عبر JSON-RPC 2.0
/// فوق HTTP POST — نفس بروتوكول [TafsirMcpClient] لكنه يستهدف خادم الأقسام.
///
/// نقطة النهاية تُقرأ من ملف `.env` (المفتاح `HEEKMAH_MCP_ENDPOINT`) لإخفائها
/// عن المستودع العام. إن كان المفتاح فارغاً أو غائباً، يُعطّل العميل ويرمي
/// [McpException] عند المحاولة.
///
/// يعيد استخدام نماذج [McpTool] و [McpToolResult] و [McpException] المُعرَّفة
/// في `tafsir_mcp_client.dart` لأنها عامة (ليست خاصة بـ tafsir).
class HeekmahMcpClient {
  HeekmahMcpClient._();
  static final HeekmahMcpClient _instance = HeekmahMcpClient._();
  factory HeekmahMcpClient() => _instance;

  /// نقطة نهاية خادم alheekmah-mcp من `.env` (تُقرأ وقت التشغيل).
  /// فارغة إن لم يُضبط المفتاح — ويُعطّل العميل في هذه الحالة.
  static final String endpoint = dotenv.maybeGet('HEEKMAH_MCP_ENDPOINT') ?? '';

  /// هل الخادم مُهيّأ (يملك نقطة نهاية صالحة في `.env`)؟
  static bool get isConfigured => endpoint.isNotEmpty;

  static const String _protocolVersion = '2025-06-18';
  static const String _clientName = 'alquranalkareem';
  static const String _clientVersion = '1.0.0';

  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: endpoint,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      // لا نتحقق من status يدوياً — نقرأ ردود SSE يدوياً.
      validateStatus: (_) => true,
    ),
  );

  /// معرّف الجلسة إن أصدره الخادم (يجب إرفاقه في كل طلب لاحق).
  String? _sessionId;
  bool _initialized = false;

  /// قائمة الأدوات المخزّنة بعد أول `tools/list` (caching).
  List<McpTool> _cachedTools = const [];
  List<McpTool> get tools => _cachedTools;

  int _nextRequestId = 1;

  /// تهيئة الجلسة مع خادم MCP (initialize handshake).
  /// آمنة للتكرار — لا تعيد التهيئة إن تمت مسبقاً.
  Future<void> ensureInitialized() async {
    if (_initialized) return;
    if (!isConfigured) {
      throw const McpException(
        'HEEKMAH_MCP_ENDPOINT غير مُضبوط في ملف .env — خادم الأقسام غير مُهيّأ.',
      );
    }
    final initResp = await _sendRequest(
      method: 'initialize',
      params: {
        'protocolVersion': _protocolVersion,
        'capabilities': <String, dynamic>{},
        'clientInfo': {'name': _clientName, 'version': _clientVersion},
      },
    );
    // احفظ معرّف الجلسة إن أصدره الخادم.
    _sessionId = initResp?.headers.value('mcp-session-id');
    log('Heekmah MCP session-id: $_sessionId', name: 'HeekmahMcp');

    // إشعار بأن التهيئة تمّت (notification — لا نتوقع رداً).
    await _sendNotification(method: 'notifications/initialized');
    _initialized = true;

    // اجلب قائمة الأدوات فوراً للتخزين المؤقت.
    await _loadTools();
  }

  /// يجلب قائمة الأدوات من الخادم ويخزّنها. يُستدعى داخلياً بعد initialize.
  Future<List<McpTool>> _loadTools() async {
    if (!_initialized) await ensureInitialized();
    final resp = await _sendRequest(method: 'tools/list', params: {});
    final result = resp?.data?['result'] as Map<String, dynamic>?;
    final toolsList = (result?['tools'] as List?) ?? [];
    _cachedTools = toolsList
        .map((t) => McpTool.fromJson(t as Map<String, dynamic>))
        .toList(growable: false);
    log('Heekmah MCP tools loaded: ${_cachedTools.length}', name: 'HeekmahMcp');
    return _cachedTools;
  }

  /// يجلب قائمة الأدوات (نسخة جديدة). يستخدم التخزين المؤقت إن وُجد.
  Future<List<McpTool>> listTools() async {
    if (_cachedTools.isNotEmpty) return List.unmodifiable(_cachedTools);
    return _loadTools();
  }

  /// يستدعي أداة على الخادم ويرجع نتيجتها (محتوى نصي).
  ///
  /// [name] اسم الأداة مثل `search_hadith`.
  /// [arguments] وسائط الأداة كم Map (مثل `{query: "الصبر", topK: 5}`).
  Future<McpToolResult> callTool(
    String name,
    Map<String, dynamic> arguments,
  ) async {
    if (!_initialized) await ensureInitialized();
    final resp = await _sendRequest(
      method: 'tools/call',
      params: {'name': name, 'arguments': arguments},
    );
    final result = resp?.data?['result'] as Map<String, dynamic>?;
    return McpToolResult.fromJson(result ?? {});
  }

  // ─── طبقة JSON-RPC المنخفضة ─────────────────────────────────────

  Future<Response?> _sendRequest({
    required String method,
    Map<String, dynamic>? params,
  }) async {
    final id = _nextRequestId++;
    final payload = <String, dynamic>{
      'jsonrpc': '2.0',
      'id': id,
      'method': method,
    };
    if (params != null) payload['params'] = params;

    final response = await _dio.post(
      '',
      data: jsonEncode(payload),
      options: Options(
        headers: _buildHeaders(),
        responseType: ResponseType.json,
      ),
    );

    // تعامل مع SSE إن كان نوع المحتوى كذلك.
    final contentType = (response.headers.value('content-type') ?? '')
        .toLowerCase();
    if (contentType.contains('text/event-stream')) {
      final body = response.data is String
          ? response.data as String
          : response.data.toString();
      return _extractJsonFromSse(body, response);
    }

    // رد JSON عادي.
    if (response.statusCode != null && response.statusCode! >= 400) {
      throw McpException(
        'Heekmah MCP request "$method" failed: HTTP ${response.statusCode}',
      );
    }
    return response;
  }

  Future<void> _sendNotification({required String method}) async {
    final payload = <String, dynamic>{'jsonrpc': '2.0', 'method': method};
    // الـ notifications ليس لها id — نرسلها ونتجاهل الرد.
    try {
      await _dio.post(
        '',
        data: jsonEncode(payload),
        options: Options(
          headers: _buildHeaders(),
          responseType: ResponseType.json,
        ),
      );
    } catch (_) {
      // تجاهل أخطاء الـ notification — ليست حرجة.
    }
  }

  Map<String, String> _buildHeaders() {
    final h = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json, text/event-stream',
      'MCP-Protocol-Version': _protocolVersion,
    };
    if (_sessionId != null) h['Mcp-Session-Id'] = _sessionId!;
    return h;
  }

  /// يستخرج رسالة JSON-RPC الأولى من جسم SSE.
  Response<T> _extractJsonFromSse<T>(String sseBody, Response original) {
    final dataLines = StringBuffer();
    for (final line in sseBody.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.startsWith('data:')) {
        dataLines.writeln(trimmed.substring(5).trim());
      } else if (trimmed.isEmpty && dataLines.isNotEmpty) {
        break; // نهاية الحدث الأول.
      }
    }
    final jsonStr = dataLines.toString().trim();
    dynamic decoded;
    if (jsonStr.isNotEmpty) {
      try {
        decoded = jsonDecode(jsonStr);
      } catch (_) {
        decoded = null;
      }
    }
    return Response<T>(
      data: decoded as T?,
      statusCode: original.statusCode,
      requestOptions: original.requestOptions,
      headers: original.headers,
    );
  }

  /// يعيد ضبط العميل (يُستخدم عند فشل الجلسة لإعادة التهيئة).
  void reset() {
    _sessionId = null;
    _initialized = false;
    _cachedTools = const [];
  }
}
