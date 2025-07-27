part of '../../quran.dart';

class AudioController extends GetxController {
  static AudioController get instance =>
      GetInstance().putOrFind(() => AudioController());

  AudioState state = AudioState();

  final generalCtrl = GeneralController.instance;
  final quranCtrl = QuranController.instance;

  @override
  void onInit() async {
    state.isPlay.value = false;
    state.sliderValue = 0;
    loadQuranReader();
    await Future.wait([
      GeneralController.instance
          .getCachedArtUri()
          .then((v) => state.cachedArtUri = v),
      getApplicationDocumentsDirectory().then((v) => state.dir = v),
    ]);
    ConnectivityService.instance.init();
    super.onInit();
  }

  @override
  void onClose() {
    state.audioPlayer.pause();
    state.audioPlayer.dispose();
    ConnectivityService.instance.onClose();
    super.onClose();
  }

  /// -------- [DownloadsMethods] ----------

  Future<String> _downloadFileIfNotExist(String url, String fileName,
      {bool showSnakbars = true, bool setDownloadingStatus = true}) async {
    String path = join(state.dir.path, fileName);
    var file = File(path);
    bool exists = await file.exists();

    if (!exists) {
      if (setDownloadingStatus && state.downloading.isFalse) {
        state.downloading.value = true;
        state.onDownloading.value = true;
      }

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        print('Error creating directory: $e');
      }

      if (showSnakbars && !state.snackBarShownForBatch) {
        if (ConnectivityService.instance.noConnection.value) {
          Get.context!.showCustomErrorSnackBar('noInternet'.tr);
        } else if (ConnectivityService.instance.connectionStatus
            .contains(ConnectivityResult.mobile)) {
          state.snackBarShownForBatch = true; // Set the flag to true
          Get.context!.customMobileNoteSnackBar('mobileDataAyat'.tr);
        }
      }

      // Proceed with the download
      if (!ConnectivityService.instance.connectionStatus
          .contains(ConnectivityResult.none)) {
        try {
          await _downloadFile(path, url, fileName);
        } catch (e) {
          log('Error downloading file: $e');
        }
      }
    }

    if (setDownloadingStatus && state.downloading.isTrue) {
      state.downloading.value = false;
      state.onDownloading.value = false;
    }

    update(['audio_seekBar_id']);
    return path;
  }

  Future<bool> _downloadFile(String path, String url, String fileName) async {
    Dio dio = Dio();
    try {
      await Directory(dirname(path)).create(recursive: true);
      state.progressString.value = 'Indeterminate';
      state.progress.value = 0;
      var incrementalProgress = 0.0;
      const incrementalStep = 0.1;

      await dio.download(url, path, onReceiveProgress: (rec, total) {
        if (total <= 0) {
          // Update the progress value incrementally
          incrementalProgress += incrementalStep;
          if (incrementalProgress >= 1) {
            incrementalProgress = 0; // Reset if it reaches 1
          }
          // Update your UI based on incrementalProgress here
          // For example, update a progress bar's value or animate an indicator
        } else {
          // Handle determinate progress as before
          double progressValue = (rec / total).toDouble().clamp(0.0, 1.0);
          state.progress.value = progressValue;
          update(['audio_seekBar_id']);
          log('ayah downloading progress: $progressValue');
        }
      });
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        print('Download canceled');
        try {
          final file = File(path);
          if (await file.exists()) {
            await file.delete();
            state.onDownloading.value = false;
            print('Partially downloaded file deleted');
          }
        } catch (e) {
          print('Error deleting partially downloaded file: $e');
        }
        return false;
      } else {
        print(e);
      }
    } finally {
      state.progressString.value = 'Completed';
      print('Download completed or failed');
    }
    return true;
  }

  void cancelDownload() {
    state.cancelToken.cancel('Request cancelled');
  }

  /// -------- [PlayingMethods] ----------

  Future<void> moveToNextPage({bool withScroll = true}) async {
    if (withScroll) {
      await quranCtrl.state.quranPageController.animateToPage(
          (quranCtrl.state.currentPageNumber.value),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut);
      log('Going To Next Page at: ${quranCtrl.state.currentPageNumber.value} ');
    }
  }

  void moveToPreviousPage({bool withScroll = true}) {
    if (withScroll) {
      quranCtrl.state.quranPageController.animateToPage(
          (quranCtrl.state.currentPageNumber.value - 2),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut);
    }
  }

  Future<void> playFile() async {
    state.tmpDownloadedAyahsCount = 0.obs;
    final selectedSurah = quranCtrl.state.surahs[currentSurahNumInPage - 1];
    final ayahsFilesNames = selectedSurahAyahsFileNames;
    final ayahsUrls = selectedSurahAyahsUrls;
    final surahKey =
        'surah_${selectedSurah.surahNumber}ـ${state.readerIndex.value}';

    bool isSurahDownloaded = state.box.read(surahKey) ?? false;

    if (!isSurahDownloaded) {
      final futures;
      try {
        if (state.playSingleAyahOnly) {
          final path =
              await _downloadFileIfNotExist(currentAyahUrl, currentAyahFileName)
                  .then((_) {
            state.downloading.value = false;
            state.onDownloading.value = false;
          });
          futures = state.audioPlayer.setAudioSource(AudioSource.file(
            path,
            tag: mediaItemForCurrentAyah,
          ));
        } else {
          state.snackBarShownForBatch = false;
          futures = List.generate(
            ayahsFilesNames.length,
            (i) => _downloadFileIfNotExist(ayahsUrls[i], ayahsFilesNames[i],
                    setDownloadingStatus: false)
                .whenComplete(() {
              log('${state.tmpDownloadedAyahsCount.value} => download completed at ${DateTime.now().millisecond}');
              state.tmpDownloadedAyahsCount.value++;
            }),
          );
        }

        state.downloading.value = true;
        state.onDownloading.value = true;
        await Future.wait(futures);
        state.downloading.value = false;
        state.onDownloading.value = false;

        state.box.write(surahKey, true);

        print('تحميل سورة ${selectedSurahAyahsFileNames} تم بنجاح.');
      } catch (e) {
        log('Error in playFile: $e', name: 'AudioController');
      }
    } else {
      state.downloading.value = false;
      print('سورة ${selectedSurahAyahsFileNames} محملة بالكامل.');
    }

    try {
      if (state.playSingleAyahOnly) {
        final path =
            await _downloadFileIfNotExist(currentAyahUrl, currentAyahFileName);
        await state.audioPlayer.setAudioSource(AudioSource.file(
          path,
          tag: mediaItemForCurrentAyah,
        ));
      } else {
        await state.audioPlayer.setAudioSource(
          ConcatenatingAudioSource(
            children: List.generate(
              ayahsFilesNames.length,
              (i) => AudioSource.file(
                join(state.dir.path, ayahsFilesNames[i]),
                tag: mediaItemsForCurrentSurah[i],
              ),
            ),
          ),
          initialIndex: state.isDirectPlaying.value
              ? currentAyahInPage
              : state.selectedAyahNum.value,
        );
      }

      log('${'-' * 30} player is starting.. ${'-' * 30}',
          name: 'AudioController');

      state.audioPlayer.currentIndexStream.listen((index) async {
        if (isLastAyahInPageButNotInSurah || isLastAyahInSurahAndPage) {
          await moveToNextPage(withScroll: true);
        }
        if (index != null && index != 0 && index != state.selectedAyahNum) {
          log('state.currentAyahUQInPage.value: ${state.currentAyahUQInPage}');
          state.selectedAyahNum.value = index;
          state.currentAyahUQInPage.value =
              selectedSurahAyahsUniqueNumbers[state.selectedAyahNum.value];
          // quranCtrl.toggleAyahSelection(state.currentAyahUQInPage.value);
          // quranCtrl.clearAndAddSelection(state.currentAyahUQInPage.value);
          // quranCtrl.toggleAyahSelection(state.currentAyahUQInPage.value);
        }
      });

      state.isPlay.value = true;
      await state.audioPlayer
          .play()
          .then((_) => state.isPlay.value = true)
          .whenComplete(() {
        state.audioPlayer.stop();
        state.isPlay.value = false;
      });
    } catch (e) {
      state.isPlay.value = false;
      state.audioPlayer.stop();
      log('Error in playFile: $e', name: 'AudioController');
    }
  }

  Future<void> playAyah() async {
    if (quranCtrl.state.isPages.value == 1) {
      state.currentAyahUQInPage.value = state.currentAyahUQInPage.value == 1
          ? quranCtrl.state.allAyahs
              .firstWhere((ayah) =>
                  ayah.page ==
                  quranCtrl.state.itemPositionsListener.itemPositions.value.last
                          .index +
                      1)
              .ayahUQNumber
          : state.currentAyahUQInPage.value;
    } else {
      state.currentAyahUQInPage.value = state.currentAyahUQInPage.value == 1
          ? quranCtrl.state.allAyahs
              .firstWhere((ayah) =>
                  ayah.page == quranCtrl.state.currentPageNumber.value)
              .ayahUQNumber
          : state.currentAyahUQInPage.value;
    }
    // quranCtrl.clearAndAddSelection(state.currentAyahUQInPage.value);

    // quranCtrl.clearAndAddSelection(state.currentAyahUQInPage.value);
    if (state.audioPlayer.playing || state.isPlay.value) {
      state.isPlay.value = false;
      await state.audioPlayer.pause();
      print('state.audioPlayer: pause');
    } else {
      // quranCtrl.toggleAyahSelection(state.currentAyahUQInPage.value);
      // quranCtrl.clearAndAddSelection(state.currentAyahUQInPage.value);
      await playFile();
    }
  }

  Future<void> skipNextAyah() async {
    if (state.currentAyahUQInPage.value == 6236) {
      pausePlayer;
    } else if (isLastAyahInPageButNotInSurah || isLastAyahInSurahAndPage) {
      await moveToNextPage(withScroll: true);
      quranCtrl.clearAndAddSelection(state.currentAyahUQInPage.value += 1);
      await state.audioPlayer.seekToNext();
    } else {
      quranCtrl.clearAndAddSelection(state.currentAyahUQInPage.value += 1);
      await state.audioPlayer.seekToNext();
    }
  }

  Future<void> skipPreviousAyah() async {
    if (state.currentAyahUQInPage.value == 1) {
      pausePlayer;
    } else if (isFirstAyahInPageButNotInSurah) {
      moveToPreviousPage();
      quranCtrl.clearAndAddSelection(state.currentAyahUQInPage.value -= 1);
      await state.audioPlayer.seekToPrevious();
    } else {
      quranCtrl.toggleAyahSelection(state.currentAyahUQInPage.value -= 1);
      await state.audioPlayer.seekToPrevious();
    }
  }

  void didChangeAppLifecycleState(AppLifecycleState states) {
    if (states == AppLifecycleState.paused) {
      state.audioPlayer.stop();
      state.isPlay.value = false;
    }
  }
}
