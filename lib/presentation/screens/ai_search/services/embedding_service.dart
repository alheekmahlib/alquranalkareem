part of '../ai_search.dart';

/// On-device embedding inference using ONNX Runtime + e5-small INT8 model
class EmbeddingService {
  static final EmbeddingService _instance = EmbeddingService._();
  factory EmbeddingService() => _instance;
  EmbeddingService._();

  static const int _maxSeqLength = 128;
  static const int _embeddingDim = 384;

  OrtSession? _session;
  OnnxRuntime? _ort;

  // Unigram tokenizer data
  _TrieNode? _trieRoot;
  List<_UnigramEntry> _entries = [];
  int _unkId = 3;
  bool _isReady = false;

  bool get isReady => _isReady;

  /// Initialize: load ONNX model + tokenizer vocab
  Future<void> init() async {
    if (_isReady) return;

    final dir = await _getSearchDataDir();

    // Load vocab from tokenizer.json (Unigram format)
    final tokenizerFile = File('${dir.path}/tokenizer.json');
    if (await tokenizerFile.exists()) {
      final jsonStr = await tokenizerFile.readAsString();
      final tokenizerData = json.decode(jsonStr);
      final model = tokenizerData['model'];
      if (model != null) {
        _unkId = model['unk_id'] ?? 3;
        final rawVocab = model['vocab'];
        if (rawVocab is List) {
          _entries = [];
          _trieRoot = _TrieNode();

          for (int i = 0; i < rawVocab.length; i++) {
            final entry = rawVocab[i];
            if (entry is List && entry.length >= 2) {
              final text = entry[0].toString();
              final score = (entry[1] as num).toDouble();
              _entries.add(_UnigramEntry(text, score, i));

              // Insert into trie (skip special tokens with score 0)
              if (score != 0.0 && text.isNotEmpty) {
                _insertTrie(_trieRoot!, text, i);
              }
            }
          }
        }
      }
    } else {
      throw Exception('Tokenizer not found');
    }

    // Load ONNX model
    final modelFile = File('${dir.path}/e5_small_int8.onnx');
    if (!await modelFile.exists()) {
      throw Exception('ONNX model not found');
    }

    _ort = OnnxRuntime();
    try {
      print('[AiSearch] Creating ONNX session from: ${modelFile.path} (${await modelFile.length()} bytes)');
      _session = await _ort!.createSession(modelFile.path);
      print('[AiSearch] ONNX session created successfully');
    } catch (e, stack) {
      print('[AiSearch] ONNX session creation failed: $e');
      print('[AiSearch] Stack: $stack');
      _isReady = false;
      return;
    }

    _isReady = true;
  }

  /// Generate embedding for a query
  Future<List<double>> embed(String text) async {
    if (!_isReady || _session == null) {
      throw Exception('Embedding service not initialized');
    }

    print('[AiSearch] Embedding: tokenizing...');

    // Tokenize with e5 prefix
    final prefixedText = 'query: $text';
    var tokens = _tokenize(prefixedText);

    // Pad/truncate to _maxSeqLength
    const padId = 1; // <pad>
    while (tokens.length < _maxSeqLength) {
      tokens.add(padId);
    }
    if (tokens.length > _maxSeqLength) {
      tokens = tokens.sublist(0, _maxSeqLength);
    }

    // Create attention mask (1 for real tokens, 0 for padding)
    final attentionMaskList = List<int>.generate(
      _maxSeqLength,
      (i) => tokens[i] != padId ? 1 : 0,
    );
    final tokenTypeIdsList = List.filled(_maxSeqLength, 0);

    // Create input tensors
    final inputIdsData = Int64List.fromList(tokens);
    final attentionMaskData = Int64List.fromList(attentionMaskList);
    final tokenTypeIdsData = Int64List.fromList(tokenTypeIdsList);

    final inputIdsTensor = await OrtValue.fromList(inputIdsData, [
      1,
      _maxSeqLength,
    ]);
    final attentionMaskTensor = await OrtValue.fromList(attentionMaskData, [
      1,
      _maxSeqLength,
    ]);
    final tokenTypeIdsTensor = await OrtValue.fromList(tokenTypeIdsData, [
      1,
      _maxSeqLength,
    ]);

    final inputs = <String, OrtValue>{
      'input_ids': inputIdsTensor,
      'attention_mask': attentionMaskTensor,
      'token_type_ids': tokenTypeIdsTensor,
    };

    final attentionMaskForPooling = attentionMaskData;

    print('[AiSearch] Embedding: running ONNX inference...');
    Map<String, OrtValue>? outputs;
    try {
      outputs = await _session!.run(inputs);
    } catch (e, stack) {
      print('[AiSearch] ONNX inference failed: $e');
      print('[AiSearch] Stack: $stack');
      // Cleanup inputs
      await inputIdsTensor.dispose();
      await attentionMaskTensor.dispose();
      await tokenTypeIdsTensor.dispose();
      rethrow;
    }
    print('[AiSearch] Embedding: inference done, extracting...');

    // Extract last_hidden_state: shape [1, 128, 384]
    final lastHiddenState = outputs['last_hidden_state'];
    if (lastHiddenState == null) {
      throw Exception('Model output missing');
    }

    // Use flattened list — much more memory-efficient than nested asList()
    final flatData = await lastHiddenState.asFlattenedList();

    // Mean pooling with attention mask
    // flatData is [1 * 128 * 384] flattened = index = seq * 384 + d
    final embedding = List.filled(_embeddingDim, 0.0);
    int validTokens = 0;

    for (int seq = 0; seq < _maxSeqLength; seq++) {
      if (attentionMaskForPooling[seq] == 1) {
        final seqOffset = seq * _embeddingDim;
        for (int d = 0; d < _embeddingDim; d++) {
          embedding[d] += (flatData[seqOffset + d] as num).toDouble();
        }
        validTokens++;
      }
    }

    if (validTokens > 0) {
      for (int d = 0; d < _embeddingDim; d++) {
        embedding[d] /= validTokens;
      }
    }

    // L2 normalize
    double norm = 0;
    for (final v in embedding) {
      norm += v * v;
    }
    norm = sqrt(norm);
    if (norm > 0) {
      for (int d = 0; d < _embeddingDim; d++) {
        embedding[d] /= norm;
      }
    }

    // Cleanup
    print('[AiSearch] Embedding: done, cleaning up...');
    await inputIdsTensor.dispose();
    await attentionMaskTensor.dispose();
    await tokenTypeIdsTensor.dispose();
    for (final v in outputs.values) {
      await v.dispose();
    }

    return embedding;
  }

  /// Unigram tokenization using Viterbi + Trie
  List<int> _tokenize(String text) {
    final normalized = _normalize(text);
    final metaspaced = '▁$normalized'.replaceAll(' ', '▁');
    final ids = _viterbiDecode(metaspaced);
    return [0, ...ids, 2]; // <s> ... </s>
  }

  /// Normalize: lowercase + strip diacritics
  String _normalize(String text) {
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final codeUnit = text.codeUnitAt(i);
      // Skip combining diacritical marks (U+0300-U+036F)
      if (codeUnit >= 0x0300 && codeUnit <= 0x036F) continue;
      // Skip Arabic tashkeel (U+064B-U+065F, U+0670)
      if ((codeUnit >= 0x064B && codeUnit <= 0x065F) || codeUnit == 0x0670)
        continue;
      // Lowercase ASCII
      if (codeUnit >= 65 && codeUnit <= 90) {
        buffer.writeCharCode(codeUnit + 32);
      } else {
        buffer.writeCharCode(codeUnit);
      }
    }
    return buffer.toString();
  }

  /// Viterbi with trie-based prefix lookup
  List<int> _viterbiDecode(String text) {
    final len = text.length;
    if (len == 0) return [];

    const double negInf = double.negativeInfinity;
    final bestScore = List<double>.filled(len + 1, negInf);
    final bestToken = List<int?>.filled(len + 1, null);
    final bestLen = List<int>.filled(len + 1, 0);

    bestScore[0] = 0.0;

    for (int start = 0; start < len; start++) {
      if (bestScore[start] == negInf) continue;

      // Walk trie to find all matching tokens at this position
      _TrieNode? node = _trieRoot;
      for (int end = start; end < len && node != null; end++) {
        node = node.children[text.codeUnitAt(end)];
        if (node != null && node.tokenId != null) {
          final score = bestScore[start] + _entries[node.tokenId!].score;
          if (score > bestScore[end + 1]) {
            bestScore[end + 1] = score;
            bestToken[end + 1] = node.tokenId;
            bestLen[end + 1] = end - start + 1;
          }
        }
      }

      // UNK fallback: consume one character
      final unkScore = bestScore[start] + -100.0;
      if (unkScore > bestScore[start + 1]) {
        bestScore[start + 1] = unkScore;
        bestToken[start + 1] = _unkId;
        bestLen[start + 1] = 1;
      }
    }

    // Backtrack
    final result = <int>[];
    int pos = len;
    while (pos > 0) {
      final tid = bestToken[pos];
      if (tid == null) {
        result.add(_unkId);
        pos--;
        continue;
      }
      result.add(tid);
      pos -= bestLen[pos];
    }

    return result.reversed.toList();
  }

  /// Insert token into trie
  void _insertTrie(_TrieNode root, String text, int tokenId) {
    _TrieNode node = root;
    for (int i = 0; i < text.length; i++) {
      final ch = text.codeUnitAt(i);
      node.children[ch] ??= _TrieNode();
      node = node.children[ch]!;
    }
    node.tokenId = tokenId;
  }

  static Future<Directory> _getSearchDataDir() async {
    final appDir = await getApplicationSupportDirectory();
    final dir = Directory('${appDir.path}/ai_search/shared');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }
}

/// Trie node for fast prefix matching
class _TrieNode {
  final Map<int, _TrieNode> children = {};
  int? tokenId;
}

/// Unigram vocab entry
class _UnigramEntry {
  final String text;
  final double score;
  final int id;
  const _UnigramEntry(this.text, this.score, this.id);
}
