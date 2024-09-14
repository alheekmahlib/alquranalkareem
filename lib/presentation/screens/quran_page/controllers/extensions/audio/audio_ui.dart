import 'dart:developer';

import 'package:alquranalkareem/presentation/screens/quran_page/controllers/audio/audio_controller.dart';
import 'package:alquranalkareem/presentation/screens/quran_page/controllers/extensions/quran/quran_ui.dart';
import 'package:get/get.dart';

import '../../../../../../core/utils/constants/lists.dart';
import '../../../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../../../../../core/utils/helpers/global_key_manager.dart';

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
    if (state.isPlay.value) {
      quranCtrl.showControl();
    } else if (quranCtrl.state.selectedAyahIndexes.isNotEmpty) {
      quranCtrl.state.selectedAyahIndexes.clear();
      quranCtrl.update(['clearSelection']);
    } else {
      quranCtrl.showControl();
    }
    GlobalKeyManager().drawerKey.currentState!.closeSlider();
  }
}
