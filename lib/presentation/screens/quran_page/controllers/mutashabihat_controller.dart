import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quran_library/quran.dart';

import '../../../../core/utils/constants/api_constants.dart';
import '../data/models/mutashabihat_model.dart';
import '../data/repository/mutashabihat_repository.dart';

/// Controller for managing mutashabihat (similar verses) functionality
class MutashabihatController extends GetxController {
  static MutashabihatController get instance =>
      GetInstance().putOrFind(() => MutashabihatController());

  final MutashabihatRepository _repository = MutashabihatRepository.instance;

  final Rx<MutashabihatResult?> currentResult = Rx<MutashabihatResult?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isInitialized = false.obs;
  final RxInt currentSurahNumber = 0.obs;
  final RxInt currentAyahNumber = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  /// Initialize the mutashabihat data
  Future<void> _initializeData() async {
    isLoading.value = true;
    try {
      await _repository.loadData();
      isInitialized.value = true;
    } catch (e) {
      // Handle error
    } finally {
      isLoading.value = false;
    }
  }

  /// Load mutashabihat for a specific verse
  Future<void> loadMutashabihat(int surahNumber, int ayahNumber) async {
    isLoading.value = true;
    currentSurahNumber.value = surahNumber;
    currentAyahNumber.value = ayahNumber;

    try {
      if (!isInitialized.value) {
        await _repository.loadData();
        isInitialized.value = true;
      }

      final result = _repository.getMutashabihatForVerse(
        surahNumber,
        ayahNumber,
      );
      currentResult.value = result;
    } catch (e) {
      currentResult.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Check if a verse has similar verses
  bool hasMutashabihat(int surahNumber, int ayahNumber) {
    if (!isInitialized.value) return false;
    return _repository.hasMutashabihat(surahNumber, ayahNumber);
  }

  /// Get the verse key for the current verse
  String get currentVerseKey =>
      '${currentSurahNumber.value}:${currentAyahNumber.value}';

  /// Get phrases count
  int get phrasesCount => currentResult.value?.phrases.length ?? 0;

  /// Get phrases count for a specific verse (for badge)
  int getPhrasesCountForVerse(int surahNumber, int ayahNumber) {
    if (!isInitialized.value) return 0;
    return _repository.getPhrasesCount(surahNumber, ayahNumber);
  }

  // ─── Navigation ───

  /// All verse keys in current surah that have mutashabihat
  List<String> get _surahVerseKeys =>
      _repository.getVerseKeysInSurah(currentSurahNumber.value)..sort((a, b) {
        final aNum = int.tryParse(a.split(':').last) ?? 0;
        final bNum = int.tryParse(b.split(':').last) ?? 0;
        return aNum.compareTo(bNum);
      });

  bool get hasNext {
    final keys = _surahVerseKeys;
    final idx = keys.indexOf(currentVerseKey);
    return idx >= 0 && idx < keys.length - 1;
  }

  bool get hasPrevious {
    final keys = _surahVerseKeys;
    final idx = keys.indexOf(currentVerseKey);
    return idx > 0;
  }

  void navigateToNext() {
    final keys = _surahVerseKeys;
    final idx = keys.indexOf(currentVerseKey);
    if (idx >= 0 && idx < keys.length - 1) {
      final next = keys[idx + 1];
      final parts = next.split(':');
      loadMutashabihat(int.parse(parts[0]), int.parse(parts[1]));
    }
  }

  void navigateToPrevious() {
    final keys = _surahVerseKeys;
    final idx = keys.indexOf(currentVerseKey);
    if (idx > 0) {
      final prev = keys[idx - 1];
      final parts = prev.split(':');
      loadMutashabihat(int.parse(parts[0]), int.parse(parts[1]));
    }
  }

  // ─── Browse ───

  /// Get all verse keys grouped by surah
  Map<int, List<String>> getAllGroupedBySurah() =>
      _repository.getAllVerseKeysGroupedBySurah();

  // ─── Copy / Share ───

  String buildPhraseShareText(
    MutashabihatPhraseResult phraseResult,
    String phraseText,
  ) {
    final source = phraseResult.phrase.source;
    final surah = QuranCtrl.instance.surahs.firstWhereOrNull(
      (s) => s.surahNumber == int.tryParse(source.key.split(':').first),
    );
    final surahName = surah?.arabicName.replaceAll('سُورَةُ ', '') ?? '';

    final buffer = StringBuffer()
      ..writeln('العبارة المتشابهة: $phraseText')
      ..writeln('المصدر: سورة $surahName - آية ${source.key.split(':').last}')
      ..writeln(
        'تتكرر ${phraseResult.phrase.count} مرات في ${phraseResult.phrase.ayahsCount} آيات في ${phraseResult.phrase.surahsCount} سور',
      )
      ..writeln()
      ..writeln('الآيات المتشابهة:');

    for (final v in phraseResult.similarVerses) {
      final vSurah = QuranCtrl.instance.surahs.firstWhereOrNull(
        (s) => s.surahNumber == v.surahNumber,
      );
      final vName = vSurah?.arabicName.replaceAll('سُورَةُ ', '') ?? '';
      buffer.writeln('- سورة $vName: آية ${v.ayahNumber}');
    }

    buffer.writeln('\n${'appName'.tr}');
    return buffer.toString();
  }

  Future<void> copyPhraseToClipboard(
    MutashabihatPhraseResult phraseResult,
    String phraseText,
  ) async {
    final text = buildPhraseShareText(phraseResult, phraseText);
    await Clipboard.setData(
      ClipboardData(text: '$text\n\nللتحميل:\n${ApiConstants.appUrl}'),
    );
  }

  /// Clear current result
  void clearResult() {
    currentResult.value = null;
  }

  /// Get all phrases for the current result
  List<MutashabihatPhraseResult> get phrases =>
      currentResult.value?.phrases ?? [];
}
