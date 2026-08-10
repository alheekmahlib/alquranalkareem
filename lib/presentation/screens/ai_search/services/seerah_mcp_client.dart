part of '../ai_search.dart';

/// عميل MCP لخادم السيرة والتاريخ (alheekmah-seerah-mcp).
///
/// يستهدف Worker منفصل على حساب Cloudflare مختلف (haozo89) لأن حجم قسم
/// السيرة (128K قطعة) يتجاوز حد D1 المجاني في حساب Ahmedlabtop4.
///
/// نقطة النهاية تُقرأ من ملف `.env` (المفتاح `SEERAH_MCP_ENDPOINT`).
/// يعيد استخدام نماذج [McpTool] و [McpToolResult] و [McpException].
class SeerahMcpClient {
  SeerahMcpClient._();
  static final SeerahMcpClient _instance = SeerahMcpClient._();
  factory SeerahMcpClient() => _instance;

  /// نقطة نهاية خادم السيرة من `.env`.
  static final String endpoint = dotenv.maybeGet('SEERAH_MCP_ENDPOINT') ?? '';

  /// هل الخادم مُهيّأ؟
  static bool get isConfigured => endpoint.isNotEmpty;

  static const String _protocolVersion = '2025-06-18';
  static const String _clientName = 'alquranalkareem';
  static const String _clientVersion = '1.0.0';

  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: endpoint,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      validateStatus: (_) => true,
    ),
  );

  String? _sessionId;
  bool _initialized = false;
  List<McpTool> _cachedTools = const [];
  List<McpTool> get tools => _cachedTools;
  int _nextRequestId = 1;

  Future<void> ensureInitialized() async {
    if (_initialized) return;
    if (!isConfigured) {
      throw const McpException(
        'SEERAH_MCP_ENDPOINT غير مُضبوط في ملف .env — خادم السيرة غير مُهيّأ.',
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
    _sessionId = initResp?.headers.value('mcp-session-id');
    await _sendNotification(method: 'notifications/initialized');
    _initialized = true;
    await _loadTools();
  }

  Future<List<McpTool>> _loadTools() async {
    if (!_initialized) await ensureInitialized();
    final resp = await _sendRequest(method: 'tools/list', params: {});
    final result = resp?.data?['result'] as Map<String, dynamic>?;
    final toolsList = (result?['tools'] as List?) ?? [];
    _cachedTools = toolsList
        .map((t) => McpTool.fromJson(t as Map<String, dynamic>))
        .toList(growable: false);
    log('Seerah MCP tools loaded: ${_cachedTools.length}', name: 'SeerahMcp');
    return _cachedTools;
  }

  Future<List<McpTool>> listTools() async {
    if (_cachedTools.isNotEmpty) return List.unmodifiable(_cachedTools);
    return _loadTools();
  }

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

    final contentType = (response.headers.value('content-type') ?? '')
        .toLowerCase();
    if (contentType.contains('text/event-stream')) {
      final body = response.data is String
          ? response.data as String
          : response.data.toString();
      return _extractJsonFromSse(body, response);
    }

    if (response.statusCode != null && response.statusCode! >= 400) {
      throw McpException(
        'Seerah MCP request "$method" failed: HTTP ${response.statusCode}',
      );
    }
    return response;
  }

  Future<void> _sendNotification({required String method}) async {
    try {
      await _dio.post(
        '',
        data: jsonEncode({'jsonrpc': '2.0', 'method': method}),
        options: Options(
          headers: _buildHeaders(),
          responseType: ResponseType.json,
        ),
      );
    } catch (_) {}
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

  Response<T> _extractJsonFromSse<T>(String sseBody, Response original) {
    final dataLines = StringBuffer();
    for (final line in sseBody.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.startsWith('data:')) {
        dataLines.writeln(trimmed.substring(5).trim());
      } else if (trimmed.isEmpty && dataLines.isNotEmpty) {
        break;
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

  void reset() {
    _sessionId = null;
    _initialized = false;
    _cachedTools = const [];
  }
}
