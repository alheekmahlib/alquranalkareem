part of '../quran.dart';

class PlayListController extends GetxController {
  static PlayListController get instance =>
      GetInstance().putOrFind(() => PlayListController());

  // ━━━━━━━━━━━━━━ المتحكمات ━━━━━━━━━━━━━━
  final audioCtrl = AudioCtrl.instance;
  final quranCtrl = QuranController.instance;
  final generalCtrl = GeneralController.instance;

  // ━━━━━━━━━━━━━━ الصوت ━━━━━━━━━━━━━━
  final AudioPlayer playlistAudioPlayer = AudioPlayer();
  final RxList<AudioSource> ayahsPlayList = <AudioSource>[].obs;

  /// خريطة ربط index الصوت مع ayahUQNumber (لتتبع الآية الحالية)
  final RxList<int> audioIndexToAyahUQ = <int>[].obs;

  // ━━━━━━━━━━━━━━ القوائم المحفوظة ━━━━━━━━━━━━━━
  RxList<PlayListModel> playLists = RxList<PlayListModel>();
  final GlobalKey<ExpansionTileCardState> saveCard = GlobalKey();

  // ━━━━━━━━━━━━━━ اختيار السورة والآيات ━━━━━━━━━━━━━━
  RxInt fromSurahIndex = 0.obs;
  RxInt toSurahIndex = 0.obs;
  RxInt startAyah = 1.obs;
  RxInt endAyah = 1.obs;
  RxInt startAyahUQ = 1.obs;
  RxInt endAyahUQ = 1.obs;
  final ScrollController scrollController = ScrollController();
  final ScrollController surahScrollController = ScrollController();
  double ayahItemHeight = 80.0;

  // ━━━━━━━━━━━━━━ التحميل ━━━━━━━━━━━━━━
  RxBool downloading = false.obs;
  RxBool onDownloading = false.obs;
  RxString progressString = "0".obs;
  RxDouble progress = 0.0.obs;
  late CancelToken cancelToken = CancelToken();
  // RxBool isSelect = false.obs;

  // ━━━━━━━━━━━━━━ تقدم تحميل النطاق ━━━━━━━━━━━━━━
  RxBool isBatchDownloading = false.obs;
  RxInt batchTotal = 0.obs;
  RxInt batchCompleted = 0.obs;

  // ━━━━━━━━━━━━━━ وضع التكرار ━━━━━━━━━━━━━━
  RxInt repeatCount = 0.obs; // 0 = بلا حد
  RxInt currentRepeat = 0.obs;

  // ━━━━━━━━━━━━━━ مؤقت النوم ━━━━━━━━━━━━━━
  Rx<Duration?> sleepTimerDuration = Rx<Duration?>(null);
  Rx<Duration> sleepTimerRemaining = Duration.zero.obs;
  Timer? _sleepTimer;

  // ━━━━━━━━━━━━━━ تتبع الآية الحالية ━━━━━━━━━━━━━━
  RxInt currentPlayingAyahUQ = 0.obs;
  RxInt currentPlayingIndex = 0.obs;
  StreamSubscription<int?>? _indexSubscription;

  // ━━━━━━━━━━━━━━ مؤشر التقدم الكلي ━━━━━━━━━━━━━━
  RxInt totalPlaylistAyahs = 0.obs;
  RxInt completedAyahs = 0.obs;

  // ━━━━━━━━━━━━━━ الاستماع المتتابع ━━━━━━━━━━━━━━
  RxBool autoPlayNext = true.obs;
  StreamSubscription<PlayerState>? _autoNextSubscription;

  final box = GetStorage();

  // ━━━━━━━━━━━━━━ Streams ━━━━━━━━━━━━━━
  Stream<PositionData> get positionDataStream =>
      R.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        playlistAudioPlayer.positionStream,
        playlistAudioPlayer.bufferedPositionStream,
        playlistAudioPlayer.durationStream,
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //  آيات السورة المختارة
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  List get fromSurahAyahs => quranCtrl.state.surahs[fromSurahIndex.value].ayahs;

  List get toSurahAyahs => quranCtrl.state.surahs[toSurahIndex.value].ayahs;

  String get fromSurahName =>
      quranCtrl.state.surahs[fromSurahIndex.value].arabicName;

  String get toSurahName =>
      quranCtrl.state.surahs[toSurahIndex.value].arabicName;

  int get fromSurahNumber => fromSurahIndex.value + 1;
  int get toSurahNumber => toSurahIndex.value + 1;

  /// اختيار سورة البداية
  void selectFromSurah(int index) {
    fromSurahIndex.value = index;
    final ayahs = quranCtrl.state.surahs[index].ayahs;
    startAyah.value = ayahs.first.ayahNumber;
    startAyahUQ.value = ayahs.first.ayahUQNumber;
    // إذا كانت سورة النهاية قبل سورة البداية، نحدّثها
    if (toSurahIndex.value < index) {
      selectToSurah(index);
    }
  }

  /// اختيار سورة النهاية
  void selectToSurah(int index) {
    toSurahIndex.value = index;
    final ayahs = quranCtrl.state.surahs[index].ayahs;
    endAyah.value = ayahs.last.ayahNumber;
    endAyahUQ.value = ayahs.last.ayahUQNumber;
    // إذا كانت سورة البداية بعد سورة النهاية، نحدّثها
    if (fromSurahIndex.value > index) {
      selectFromSurah(index);
    }
  }

  void setStartAyah(int ayahNumber, int ayahUQNumber) {
    startAyah.value = ayahNumber;
    startAyahUQ.value = ayahUQNumber;
  }

  void setEndAyah(int ayahNumber, int ayahUQNumber) {
    endAyah.value = ayahNumber;
    endAyahUQ.value = ayahUQNumber;
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //  التحقق من صلاحية النطاق
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  bool get isRangeValid => startAyahUQ.value <= endAyahUQ.value;

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //  تحميل وتشغيل
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Future<String> getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  AudioSource createAudioSource(String filePath) {
    return AudioSource.uri(Uri.file(filePath));
  }

  String generateUrl(int ayahUQNumber) {
    final readerUrl = ayahReaderInfo[audioCtrl.state.ayahReaderIndex.value].url;
    final readerName = audioCtrl.ayahReaderValue;

    if (readerUrl == ApiConstants.ayahs1stSource) {
      return '$readerUrl$readerName/$ayahUQNumber.mp3';
    } else {
      final ayah = quranCtrl.state.allAyahs[ayahUQNumber - 1];
      final surahNum = quranCtrl
          .getSurahDataByAyah(ayah)
          .surahNumber
          .toString()
          .padLeft(3, '0');
      final ayahNum = ayah.ayahNumber.toString().padLeft(3, '0');
      return '$readerUrl$readerName/$surahNum$ayahNum.mp3';
    }
  }

  String _getFileName(int ayahUQNumber) {
    final readerUrl = ayahReaderInfo[audioCtrl.state.ayahReaderIndex.value].url;
    if (readerUrl == ApiConstants.ayahs1stSource) {
      return '${ayahUQNumber.toString().padLeft(3, "0")}.mp3';
    } else {
      final ayah = quranCtrl.state.allAyahs[ayahUQNumber - 1];
      final surahNum = quranCtrl
          .getSurahDataByAyah(ayah)
          .surahNumber
          .toString()
          .padLeft(3, '0');
      final ayahNum = ayah.ayahNumber.toString().padLeft(3, '0');
      return '$surahNum$ayahNum.mp3';
    }
  }

  /// تحميل ملف صوتي مع التحقق من وجوده مسبقاً
  Future<bool> downloadFile(String url, String fileName) async {
    final localPath = await getLocalPath();
    final localFilePath = '$localPath/${audioCtrl.ayahReaderValue}/$fileName';
    final file = File(localFilePath);

    if (await file.exists()) return true;

    cancelToken = CancelToken();
    try {
      await Directory(dirname(localFilePath)).create(recursive: true);
      downloading.value = true;
      onDownloading.value = true;
      progressString.value = "0";
      progress.value = 0;
      await Dio().download(
        url,
        localFilePath,
        onReceiveProgress: (rec, total) {
          if (total > 0) {
            progressString.value = ((rec / total) * 100).toStringAsFixed(0);
            progress.value = (rec / total).toDouble();
          }
        },
        cancelToken: cancelToken,
      );
      downloading.value = false;
      onDownloading.value = false;
      progressString.value = "100";
      return true;
    } catch (e) {
      downloading.value = false;
      onDownloading.value = false;
      progressString.value = "0";
      log('Error during download: $e');
      return false;
    }
  }

  /// بناء قائمة الصوت من نطاق آيات مستمر وتشغيلها
  Future<bool> buildAndPlayRange(int fromAyahUQ, int toAyahUQ) async {
    if (fromAyahUQ < 1 || toAyahUQ < 1 || fromAyahUQ > toAyahUQ) return false;
    final List<AudioSource> sources = [];
    final List<int> indexMap = [];
    final localPath = await getLocalPath();

    final total = toAyahUQ - fromAyahUQ + 1;
    batchTotal.value = total;
    batchCompleted.value = 0;
    isBatchDownloading.value = true;

    for (int uq = fromAyahUQ; uq <= toAyahUQ; uq++) {
      final fileName = _getFileName(uq);
      final filePath = '$localPath/${audioCtrl.ayahReaderValue}/$fileName';
      final url = generateUrl(uq);

      final success = await downloadFile(url, fileName);
      if (success) {
        sources.add(createAudioSource(filePath));
        indexMap.add(uq);
      } else {
        isBatchDownloading.value = false;
        return false;
      }
      batchCompleted.value = sources.length;
    }

    isBatchDownloading.value = false;

    ayahsPlayList.assignAll(sources);
    audioIndexToAyahUQ.assignAll(indexMap);
    totalPlaylistAyahs.value = sources.length;
    completedAyahs.value = 0;

    await playlistAudioPlayer.setAudioSources(sources);

    _startTrackingCurrentAyah();
    return true;
  }

  /// تشغيل playlist محفوظة
  Future<void> playFromSavedPlayList(PlayListModel playlist) async {
    currentRepeat.value = 0;
    await buildAndPlayRange(playlist.fromAyahUQ, playlist.toAyahUQ);
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //  حفظ / تحميل / حذف
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  void saveList() {
    if (!isRangeValid) return;
    final fromName = fromSurahName.replaceAll('سُورَةُ ', '');
    final toName = toSurahName.replaceAll('سُورَةُ ', '');
    final name = fromSurahNumber == toSurahNumber
        ? fromName
        : '$fromName - $toName';
    playLists.add(
      PlayListModel(
        id: playLists.length,
        name: name,
        readerName: audioCtrl.ayahReaderValue,
        fromSurahNumber: fromSurahNumber,
        fromSurahName: fromSurahName,
        fromAyah: startAyah.value,
        fromAyahUQ: startAyahUQ.value,
        toSurahNumber: toSurahNumber,
        toSurahName: toSurahName,
        toAyah: endAyah.value,
        toAyahUQ: endAyahUQ.value,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
    PlayListStorage.savePlayList(playLists);
    saveCard.currentState?.expand();
  }

  void loadSavedPlayList() async {
    final loaded = await PlayListStorage.loadPlayList();
    playLists.value = RxList<PlayListModel>(loaded);
  }

  Future<void> deletePlayList(BuildContext context, int index) async {
    await PlayListStorage.deletePlayList(index).then(
      (value) =>
          context.showCustomErrorSnackBar('deletedPlayList'.tr, isDone: false),
    );
    playLists.removeAt(index);
    for (int i = index; i < playLists.length; i++) {
      playLists[i].id = i;
    }
    PlayListStorage.savePlayList(playLists);
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //  تتبع الآية الحالية (Segment Tracking)
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  void _startTrackingCurrentAyah() {
    _indexSubscription?.cancel();
    _indexSubscription = playlistAudioPlayer.currentIndexStream.listen((index) {
      if (index != null && index < audioIndexToAyahUQ.length) {
        currentPlayingIndex.value = index;
        currentPlayingAyahUQ.value = audioIndexToAyahUQ[index];
        completedAyahs.value = index;
      }
    });

    _autoNextSubscription?.cancel();
    _autoNextSubscription = playlistAudioPlayer.playerStateStream.listen((
      state,
    ) {
      if (state.processingState == ProcessingState.completed) {
        _onPlaylistCompleted();
      }
    });
  }

  void _onPlaylistCompleted() {
    if (repeatCount.value > 0) {
      currentRepeat.value++;
      if (currentRepeat.value >= repeatCount.value) {
        // وصلنا للعدد المطلوب — إيقاف
        currentRepeat.value = 0;
        playlistAudioPlayer.stop();
        return;
      }
    }
    // تكرار بلا حد أو لم نصل للعدد بعد
    if (playlistAudioPlayer.loopMode == LoopMode.all) {
      playlistAudioPlayer.seek(Duration.zero, index: 0);
      playlistAudioPlayer.play();
    }
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //  وضع التكرار (Loop Mode)
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  void cycleLoopMode() {
    const modes = [LoopMode.off, LoopMode.all];
    final current = modes.indexOf(playlistAudioPlayer.loopMode);
    final next = modes[(current + 1) % modes.length];
    playlistAudioPlayer.setLoopMode(next);
    update(['playlist_loop_mode']);
  }

  void setRepeatCount(int count) {
    repeatCount.value = count;
    currentRepeat.value = 0;
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //  مؤقت النوم (Sleep Timer)
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  void startSleepTimer(Duration duration) {
    cancelSleepTimer();
    sleepTimerDuration.value = duration;
    sleepTimerRemaining.value = duration;
    _sleepTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final remaining = sleepTimerRemaining.value - const Duration(seconds: 1);
      if (remaining <= Duration.zero) {
        _onSleepTimerEnd();
      } else {
        sleepTimerRemaining.value = remaining;
      }
    });
  }

  void cancelSleepTimer() {
    _sleepTimer?.cancel();
    _sleepTimer = null;
    sleepTimerDuration.value = null;
    sleepTimerRemaining.value = Duration.zero;
  }

  void _onSleepTimerEnd() {
    cancelSleepTimer();
    playlistAudioPlayer.pause();
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //  تصدير / استيراد Playlist
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  /// مشاركة القائمة كملف صوتي واحد MP3
  Future<void> exportPlaylist(PlayListModel playlist) async {
    final localPath = await getLocalPath();

    // تحميل الملفات إن لم تكن موجودة
    final total = playlist.toAyahUQ - playlist.fromAyahUQ + 1;
    batchTotal.value = total;
    batchCompleted.value = 0;
    isBatchDownloading.value = true;

    final List<String> filePaths = [];
    for (int uq = playlist.fromAyahUQ; uq <= playlist.toAyahUQ; uq++) {
      final fileName = _getFileName(uq);
      final filePath = '$localPath/${audioCtrl.ayahReaderValue}/$fileName';

      if (!await File(filePath).exists()) {
        final url = generateUrl(uq);
        final success = await downloadFile(url, fileName);
        if (!success) {
          isBatchDownloading.value = false;
          return;
        }
      }
      filePaths.add(filePath);
      batchCompleted.value = filePaths.length;
    }

    // دمج الملفات في ملف واحد
    final directory = await getTemporaryDirectory();
    final mergedFileName =
        '${playlist.displayName.replaceAll(RegExp(r'[^\w\s\u0600-\u06FF]'), '')}_${DateTime.now().millisecondsSinceEpoch}.mp3';
    final mergedFile = File('${directory.path}/$mergedFileName');
    final sink = mergedFile.openWrite();
    for (final path in filePaths) {
      final bytes = await File(path).readAsBytes();
      sink.add(bytes);
    }
    await sink.flush();
    await sink.close();

    isBatchDownloading.value = false;

    final params = ShareParams(
      files: [XFile(mergedFile.path, mimeType: 'audio/mpeg')],
      text: '${'playList'.tr}: ${playlist.displayName}',
    );
    await SharePlus.instance.share(params);
  }

  Future<bool> importPlaylist(String jsonString) async {
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final playlist = PlayListModel.fromJson(json);
      playlist.id = playLists.length;
      playLists.add(playlist);
      PlayListStorage.savePlayList(playLists);
      return true;
    } catch (e) {
      log('Error importing playlist: $e');
      return false;
    }
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //  مساعدات UI
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  void scrollToAyah(int ayahNumber) {
    if (scrollController.hasClients) {
      double position = (ayahNumber - 1) * ayahItemHeight;
      scrollController.jumpTo(position);
    }
  }

  void ayahPosition(bool isStart) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToAyah(isStart ? startAyah.value : endAyah.value);
    });
  }

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (d.inHours > 0) {
      return '${d.inHours}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //  Lifecycle
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  @override
  void onInit() {
    super.onInit();
    // تهيئة القيم الافتراضية من أول سورة
    final firstSurah = quranCtrl.state.surahs.first.ayahs;
    final lastSurah = quranCtrl.state.surahs.first.ayahs;
    startAyahUQ.value = firstSurah.first.ayahUQNumber;
    endAyahUQ.value = lastSurah.last.ayahUQNumber;
    startAyah.value = firstSurah.first.ayahNumber;
    endAyah.value = lastSurah.last.ayahNumber;
  }

  @override
  void onClose() {
    _indexSubscription?.cancel();
    _autoNextSubscription?.cancel();
    _sleepTimer?.cancel();
    playlistAudioPlayer.dispose();
    scrollController.dispose();
    surahScrollController.dispose();
    super.onClose();
  }
}

class PlayListStorage {
  static const String _storageKey = 'playList';

  static Future<void> savePlayList(List<PlayListModel> playLists) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final playListJson = playLists.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList(_storageKey, playListJson);
  }

  static Future<List<PlayListModel>> loadPlayList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final playListsJson =
        prefs.getStringList(_storageKey)?.cast<String>() ?? [];
    return playListsJson
        .map((r) => PlayListModel.fromJson(jsonDecode(r)))
        .toList();
  }

  static Future<void> deletePlayList(int id) async {
    List<PlayListModel> playLists = await loadPlayList();
    playLists.removeWhere((r) => r.id == id);
    await savePlayList(playLists);
  }
}
