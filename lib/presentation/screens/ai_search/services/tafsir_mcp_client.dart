part of '../ai_search.dart';

/// عميل MCP Streamable HTTP لخادم tafsir-mcp.
///
/// يتواصل مع `https://mcp.tafsir.net/mcp` عبر JSON-RPC 2.0 فوق HTTP POST.
/// يدعم كلا حالتي الردّ: `application/json` و `text/event-stream` (SSE).
class TafsirMcpClient {
  TafsirMcpClient._();
  static final TafsirMcpClient _instance = TafsirMcpClient._();
  factory TafsirMcpClient() => _instance;

  static const String _endpoint = 'https://mcp.tafsir.net/mcp';
  static const String _protocolVersion = '2025-06-18';
  static const String _clientName = 'alquranalkareem';
  static const String _clientVersion = '1.0.0';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _endpoint,
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
  List<McpTool> get tools =>
      _cachedTools; // نسخة للقراءة فقط من جهة الـ orchestrator

  int _nextRequestId = 1;

  /// تهيئة الجلسة مع خادم MCP (initialize handshake).
  /// آمنة للتكرار — لا تعيد التهيئة إن تمت مسبقاً.
  Future<void> ensureInitialized() async {
    if (_initialized) return;
    final initResp = await _sendRequest(
      method: 'initialize',
      params: {
        'protocolVersion': _protocolVersion,
        'capabilities': <String, dynamic>{},
        'clientInfo': {
          'name': _clientName,
          'version': _clientVersion,
        },
      },
    );
    // احفظ معرّف الجلسة إن أصدره الخادم.
    _sessionId = initResp?.headers.value('mcp-session-id');
    log('MCP session-id: $_sessionId', name: 'TafsirMcp');

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
    log('MCP tools loaded: ${_cachedTools.length}', name: 'TafsirMcp');
    return _cachedTools;
  }

  /// يجلب قائمة الأدوات (نسخة جديدة). يستخدم التخزين المؤقت إن وُجد.
  Future<List<McpTool>> listTools() async {
    if (_cachedTools.isNotEmpty) return List.unmodifiable(_cachedTools);
    return _loadTools();
  }

  /// يستدعي أداة على الخادم ويرجع نتيجتها (محتوى نصي).
  ///
  /// [name] اسم الأداة مثل `fetch_ayah`.
  /// [arguments] وسائط الأداة كم Map (مثل `{surah: 1, ayah: 1}`).
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
    final contentType =
        (response.headers.value('content-type') ?? '').toLowerCase();
    if (contentType.contains('text/event-stream')) {
      final body = response.data is String
          ? response.data as String
          : response.data.toString();
      return _extractJsonFromSse(body, response);
    }

    // رد JSON عادي.
    if (response.statusCode != null && response.statusCode! >= 400) {
      throw McpException(
        'MCP request "$method" failed: HTTP ${response.statusCode}',
      );
    }
    return response;
  }

  Future<void> _sendNotification({required String method}) async {
    final payload = <String, dynamic>{
      'jsonrpc': '2.0',
      'method': method,
    };
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
  ///
  /// صيغة SSE: أسطر تبدأ بـ `data:` متبوعة بمحتوى JSON، مفصولة بأسطر فارغة.
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
    // أعِد بناء Response بنفس الأنواع الأصلية قدر الإمكان.
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

// ─── نماذج البيانات (Models) ─────────────────────────────────────────

/// وصف أداة MCP كما يرد من `tools/list`.
class McpTool {
  final String name;
  final String description;
  final Map<String, dynamic> inputSchema;

  const McpTool({
    required this.name,
    required this.description,
    required this.inputSchema,
  });

  factory McpTool.fromJson(Map<String, dynamic> json) {
    return McpTool(
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      inputSchema:
          (json['inputSchema'] as Map<String, dynamic>?) ?? const {},
    );
  }

  /// يحوّل الأداة إلى صيغة OpenAI function-calling لتمريرها للنموذج.
  Map<String, dynamic> toOpenAiFunction() {
    return {
      'type': 'function',
      'function': {
        'name': name,
        'description': description,
        'parameters': inputSchema,
      },
    };
  }
}

/// نتيجة استدعاء أداة MCP.
class McpToolResult {
  /// النص المجمع من كل عناصر `content` في النتيجة.
  final String text;

  /// هل حدث خطأ أثناء تنفيذ الأداة على الخادم.
  final bool isError;

  const McpToolResult({required this.text, this.isError = false});

  factory McpToolResult.fromJson(Map<String, dynamic> json) {
    final content = json['content'] as List? ?? [];
    final parts = <String>[];
    for (final item in content) {
      if (item is Map<String, dynamic>) {
        final type = item['type'];
        if (type == 'text') {
          parts.add(item['text']?.toString() ?? '');
        } else {
          // أنواع أخرى (image, resource...) — نحوّلها لـ JSON نصي.
          parts.add(jsonEncode(item));
        }
      }
    }
    return McpToolResult(
      text: parts.join('\n'),
      isError: json['isError'] == true,
    );
  }

  @override
  String toString() => isError ? 'Error: $text' : text;
}

/// استثناء خاص بأخطاء بروتوكول MCP.
class McpException implements Exception {
  final String message;
  const McpException(this.message);
  @override
  String toString() => 'McpException: $message';
}
