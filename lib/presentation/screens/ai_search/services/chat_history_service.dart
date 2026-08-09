part of '../ai_search.dart';

/// Lightweight serializable version of SearchResult
class SerializableSearchResult {
  final double score;
  final String sectionId;
  final int metadataId;
  final String preview;
  final String source;
  final String author;
  final String type;
  final String reference;
  final Map<String, dynamic> details;

  const SerializableSearchResult({
    required this.score,
    required this.sectionId,
    required this.metadataId,
    required this.preview,
    required this.source,
    this.author = '',
    required this.type,
    required this.reference,
    this.details = const {},
  });

  factory SerializableSearchResult.fromSearchResult(SearchResult r) {
    return SerializableSearchResult(
      score: r.score,
      sectionId: r.sectionId,
      metadataId: r.metadata.id,
      preview: r.metadata.preview,
      source: r.metadata.source,
      author: r.metadata.author,
      type: r.metadata.type,
      reference: r.metadata.reference,
      details: r.metadata.details,
    );
  }

  factory SerializableSearchResult.fromJson(Map<String, dynamic> json) {
    return SerializableSearchResult(
      score: (json['s'] as num).toDouble(),
      sectionId: json['sid'] as String,
      metadataId: json['i'] as int,
      preview: json['p'] as String,
      source: json['src'] as String,
      author: json['a'] as String? ?? '',
      type: json['t'] as String,
      reference: json['r'] as String? ?? '',
      details: json['d'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() => {
        's': score,
        'sid': sectionId,
        'i': metadataId,
        'p': preview,
        'src': source,
        'a': author,
        't': type,
        'r': reference,
        'd': details,
      };

  SearchResult toSearchResult() {
    return SearchResult(
      score: score,
      sectionId: sectionId,
      metadata: SearchMetadata(
        id: metadataId,
        preview: preview,
        source: source,
        author: author,
        type: type,
        reference: reference,
        details: details,
      ),
    );
  }
}

/// نوع السجل: بحث دلالي أحادي الدور، أو محادثة مساعد موحَّدة متعددة الأدوار.
enum ChatHistoryType { semanticSearch, assistant }

/// A single chat history entry — supports both semantic-search results and
/// multi-turn assistant conversations.
class ChatHistoryEntry {
  final String id;

  /// العنوان المعروض في السجل (أول استفسار للمستخدم).
  final String query;
  final DateTime date;
  final ChatHistoryType type;

  /// نتائج البحث الدلالي (للنوع semanticSearch فقط).
  final Map<String, List<SerializableSearchResult>> sectionResults;

  /// رسائل محادثة المساعد (للنوع assistant فقط).
  final List<ChatMessage> messages;

  const ChatHistoryEntry({
    required this.id,
    required this.query,
    required this.date,
    this.type = ChatHistoryType.semanticSearch,
    this.sectionResults = const {},
    this.messages = const [],
  });

  /// Total results across all sections (semantic search only).
  int get totalResults =>
      sectionResults.values.fold(0, (sum, list) => sum + list.length);

  /// عدد رسائل المستخدم في محادثة المساعد (للعرض في السجل).
  int get userMessageCount =>
      messages.where((m) => m.isUser).length;

  factory ChatHistoryEntry.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String? ?? 'semanticSearch';
    final type = typeStr == 'assistant'
        ? ChatHistoryType.assistant
        : ChatHistoryType.semanticSearch;

    // نتائج البحث الدلالي.
    final results = <String, List<SerializableSearchResult>>{};
    final raw = json['results'] as Map<String, dynamic>? ?? {};
    for (final entry in raw.entries) {
      results[entry.key] = (entry.value as List)
          .map((e) => SerializableSearchResult.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    // رسائل المساعد.
    final msgs = <ChatMessage>[];
    final rawMsgs = json['msgs'] as List? ?? [];
    for (final m in rawMsgs) {
      msgs.add(ChatMessage.fromJson(m as Map<String, dynamic>));
    }

    return ChatHistoryEntry(
      id: json['id'] as String,
      query: json['q'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(json['d'] as int),
      type: type,
      sectionResults: results,
      messages: msgs,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id': id,
      'q': query,
      'd': date.millisecondsSinceEpoch,
      'type': type.name,
    };
    if (type == ChatHistoryType.semanticSearch) {
      json['results'] = sectionResults.map(
        (k, v) => MapEntry(k, v.map((r) => r.toJson()).toList()),
      );
    } else {
      json['msgs'] = messages.map((m) => m.toJson()).toList();
    }
    return json;
  }
}

/// Service for persisting chat history to disk
class ChatHistoryService {
  static const _historyDirName = 'history';

  Future<Directory> _getHistoryDir() async {
    final appDir = await getApplicationSupportDirectory();
    final dir = Directory('${appDir.path}/ai_search/$_historyDirName');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Get all history entries sorted by date (newest first)
  Future<List<ChatHistoryEntry>> getEntries() async {
    final dir = await _getHistoryDir();
    if (!await dir.exists()) return [];

    final entries = <ChatHistoryEntry>[];
    await for (final entity in dir.list()) {
      if (entity is File && entity.path.endsWith('.json')) {
        try {
          final json = jsonDecode(await entity.readAsString());
          entries.add(ChatHistoryEntry.fromJson(json as Map<String, dynamic>));
        } catch (e) {
          print('[ChatHistory] Failed to parse ${entity.path}: $e');
        }
      }
    }

    entries.sort((a, b) => b.date.compareTo(a.date));
    return entries;
  }

  /// Save a new entry to disk
  Future<void> saveEntry(ChatHistoryEntry entry) async {
    final dir = await _getHistoryDir();
    final file = File('${dir.path}/${entry.id}.json');
    await file.writeAsString(jsonEncode(entry.toJson()));
  }

  /// Delete a single entry
  Future<void> deleteEntry(String id) async {
    final dir = await _getHistoryDir();
    final file = File('${dir.path}/$id.json');
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Delete all history entries
  Future<void> deleteAll() async {
    final dir = await _getHistoryDir();
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }
}
