part of '../../../quran.dart';

extension AudioUi on AudioController {
  /// -------- [OnTap] ----------
  void startPlayingToggle() {
    state.isStartPlaying.value = true;
    Future.delayed(const Duration(seconds: 3), () {
      state.isStartPlaying.value = false;
    });
  }

  void playAyahOnTap(int surahNum, int ayahNum, int ayahUQNum,
      [bool singleAyahOnly = false]) {
    state.selectedAyahNum.value = ayahNum - 1;
    state.currentSurahNumInPage.value = surahNum;
    state.currentAyahUQInPage.value = ayahUQNum;
    state.playSingleAyahOnly = singleAyahOnly;
    log('s: ${quranCtrl.state.surahs[state.currentSurahNumInPage.value - 1].arabicName} | state.currentAyahUQInPage: ${state.currentAyahUQInPage.value}',
        name: 'AudioController_playAyahOnTap');
    playAyah();
  }

  Future<void> changeReadersOnTap(int index) async {
    // state.audioPlayer.stop();
    // state.isPlay.value = false;
    state.readerName.value = ayahReaderInfo[index]['name'];
    state.readerValue = ayahReaderInfo[index]['readerD'];
    state.readerIndex.value = index;
    state.box.write(AUDIO_PLAYER_SOUND, ayahReaderInfo[index]['readerD']);
    state.box.write(READER_NAME, ayahReaderInfo[index]['name']);
    state.box.write(READER_INDEX, index);
    // state.isPlay.value = true;
    state.isDirectPlaying.value = false;
    Get.back();
    state.isPlay.value
        ? await playFile().then((_) => state.audioPlayer.play())
        : state.audioPlayer.stop();
  }

  void clearSelection() {
    if (state.audioPlayer.playing) {
      quranCtrl.showControl();
    } else if (quranCtrl.state.selectedAyahIndexes.isNotEmpty) {
      quranCtrl.state.selectedAyahIndexes.clear();
      quranCtrl.state.selectedAyahIndexes.refresh();
      QuranLibrary().quranCtrl.clearSelection();
      quranCtrl.update(['clearSelection']);
    } else {
      quranCtrl.showControl();
    }
    GlobalKeyManager().drawerKey.currentState!.closeSlider();
  }
}
