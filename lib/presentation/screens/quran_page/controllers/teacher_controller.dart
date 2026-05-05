import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran_library/quran_library.dart';

class TeacherController extends GetxController {
  static TeacherController get instance => Get.find<TeacherController>();

  final _box = GetStorage();

  // ─── State ───
  final RxBool isTeacherModeEnabled = false.obs;
  final RxInt repeatCount = 3.obs;
  final RxDouble delayBetweenWords = 1.0.obs;
  final RxInt startAyahUQNumber = 1.obs;
  final RxInt endAyahUQNumber = 1.obs;

  // Playback state
  final RxBool isPlaying = false.obs;
  final RxBool isPaused = false.obs;
  final Rx<WordRef?> currentWordRef = Rx<WordRef?>(null);
  final RxInt currentRepeatIndex = 0.obs;
  final RxInt currentWordIndex = 0.obs;
  final RxInt totalWords = 0.obs;

  final RxBool isLoading = false.obs;

  // Injected data from the app layer
  List<AyahModel> Function()? getAllAyahs;
  void Function(WordRef)? onWordChanged;

  StreamSubscription<PlayerState>? _playerStateSubscription;
  Timer? _delayTimer;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  void _loadSettings() {
    isTeacherModeEnabled.value = _box.read('teacherMode') ?? false;
    repeatCount.value = _box.read('teacherRepeatCount') ?? 3;
    delayBetweenWords.value = _box.read('teacherDelay') ?? 1.0;
  }

  void toggleTeacherMode() {
    isTeacherModeEnabled.value = !isTeacherModeEnabled.value;
    _box.write('teacherMode', isTeacherModeEnabled.value);
    if (!isTeacherModeEnabled.value) {
      stop();
    }
    update(['teacher_mode']);
  }

  void setRepeatCount(int value) {
    repeatCount.value = value;
    _box.write('teacherRepeatCount', value);
  }

  void setDelay(double value) {
    delayBetweenWords.value = value;
    _box.write('teacherDelay', value);
  }

  void setAyahRange(int startUQ, int endUQ) {
    startAyahUQNumber.value = startUQ;
    endAyahUQNumber.value = endUQ;
  }

  /// Get all words for current ayah range
  List<WordRef> _buildWordList() {
    final words = <WordRef>[];
    final allAyahs = getAllAyahs?.call() ?? [];
    final svc = WordAudioService.instance;
    for (int uq = startAyahUQNumber.value;
        uq <= endAyahUQNumber.value;
        uq++) {
      if (uq < 1 || uq > allAyahs.length) continue;
      final ayah = allAyahs[uq - 1];
      final wordCount = svc.getAyahWordCount(
        ayah.surahNumber ?? 0,
        ayah.ayahNumber,
      );
      for (int w = 1; w <= wordCount; w++) {
        words.add(WordRef(
          surahNumber: ayah.surahNumber ?? 0,
          ayahNumber: ayah.ayahNumber,
          wordNumber: w,
        ));
      }
    }
    return words;
  }

  /// Start playing word by word with repetition
  Future<void> play() async {
    if (isPaused.value) {
      isPaused.value = false;
      isPlaying.value = true;
      _playNextRepeat();
      return;
    }

    final words = _buildWordList();
    if (words.isEmpty) return;

    totalWords.value = words.length;
    isPlaying.value = true;
    isPaused.value = false;
    currentWordIndex.value = 0;
    currentRepeatIndex.value = 0;

    await _playWordWithRepeat(words);
  }

  Future<void> _playWordWithRepeat(List<WordRef> words) async {
    if (!isPlaying.value || currentWordIndex.value >= words.length) {
      _onComplete();
      return;
    }

    final ref = words[currentWordIndex.value];
    currentWordRef.value = ref;

    // Notify app layer for word highlighting
    onWordChanged?.call(ref);
    update(['teacher_mode']);

    await _playSingleWord(ref);
  }

  Future<void> _playSingleWord(WordRef ref) async {
    final svc = WordAudioService.instance;
    final wordCtrl = WordInfoCtrl.instance;

    // Listen for word completion
    _playerStateSubscription?.cancel();
    _playerStateSubscription = svc.player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _onWordComplete();
      }
    });

    isLoading.value = true;
    await wordCtrl.playWordAudio(ref);
    isLoading.value = false;
  }

  void _onWordComplete() {
    _playerStateSubscription?.cancel();
    _playerStateSubscription = null;

    final words = _buildWordList();
    if (!isPlaying.value || currentWordIndex.value >= words.length) {
      _onComplete();
      return;
    }

    currentRepeatIndex.value++;

    if (currentRepeatIndex.value < repeatCount.value) {
      // Repeat same word after delay
      _scheduleDelay(() => _playSingleWord(currentWordRef.value!));
    } else {
      // Move to next word
      currentRepeatIndex.value = 0;
      currentWordIndex.value++;
      _scheduleDelay(() => _playWordWithRepeat(words));
    }
  }

  void _scheduleDelay(VoidCallback callback) {
    final delayMs = (delayBetweenWords.value * 1000).round();
    _delayTimer?.cancel();
    _delayTimer = Timer(Duration(milliseconds: delayMs), callback);
  }

  void _playNextRepeat() {
    final words = _buildWordList();
    if (words.isEmpty || currentWordIndex.value >= words.length) {
      _onComplete();
      return;
    }
    _playWordWithRepeat(words);
  }

  void pause() {
    isPaused.value = true;
    isPlaying.value = false;
    _delayTimer?.cancel();
    WordAudioService.instance.stop();
  }

  void stop() {
    isPlaying.value = false;
    isPaused.value = false;
    currentWordRef.value = null;
    currentRepeatIndex.value = 0;
    currentWordIndex.value = 0;
    totalWords.value = 0;
    isLoading.value = false;
    _delayTimer?.cancel();
    _playerStateSubscription?.cancel();
    _playerStateSubscription = null;
    WordAudioService.instance.stop();
    update(['teacher_mode']);
  }

  void skipNext() {
    if (!isPlaying.value) return;
    _delayTimer?.cancel();
    _playerStateSubscription?.cancel();
    WordAudioService.instance.stop();

    final words = _buildWordList();
    currentRepeatIndex.value = 0;
    currentWordIndex.value++;
    if (currentWordIndex.value >= words.length) {
      _onComplete();
    } else {
      _playWordWithRepeat(words);
    }
  }

  void replayWord() {
    if (!isPlaying.value) return;
    _delayTimer?.cancel();
    _playerStateSubscription?.cancel();
    WordAudioService.instance.stop();

    currentRepeatIndex.value = 0;
    _playSingleWord(currentWordRef.value!);
  }

  void _onComplete() {
    isPlaying.value = false;
    isPaused.value = false;
    currentWordRef.value = null;
    update(['teacher_mode']);
  }

  @override
  void onClose() {
    _delayTimer?.cancel();
    _playerStateSubscription?.cancel();
    super.onClose();
  }
}
