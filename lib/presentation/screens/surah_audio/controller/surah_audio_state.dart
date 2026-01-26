part of '../surah_audio.dart';

class SurahAudioState {
  // Singleton pattern
  static final SurahAudioState _instance = SurahAudioState._internal();
  factory SurahAudioState() => _instance;
  SurahAudioState._internal();

  /// -------- [Variables] ----------
  ArabicNumbers arabicNumber = ArabicNumbers();

  TextEditingController srchTxtCntroler = TextEditingController();
  late ItemScrollController surahsScrollController = ItemScrollController();
  // final SlidingPanelController boxController = SlidingPanelController();
  final box = GetStorage();

  // للتحكم في عرض الصفحة بنجاح بعد تحميل التطبيق
  // For controlling successful page display after app loading
  RxBool surahReadersLoaded = false.obs;
  RxBool isPlayExpanded = false.obs;

  TextEditingController textController = TextEditingController();
}
