import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '/presentation/screens/home/home_screen.dart';
import '../../screens/adhkar/screens/adhkar_view.dart';
import '../../screens/books/screens/books_screen.dart';
import '../../screens/quran_page/screens/quran_home.dart';
import '../../screens/surah_audio/audio_surah.dart';
import 'general_state.dart';

class GeneralController extends GetxController {
  static GeneralController get instance => Get.isRegistered<GeneralController>()
      ? Get.find<GeneralController>()
      : Get.put<GeneralController>(GeneralController());

  GeneralState state = GeneralState();

  @override
  void onInit() async {
    Future.delayed(const Duration(seconds: 1)).then((_) async {
      try {
        await WakelockPlus.enable();
      } catch (e) {
        print('Failed to enable wakelock: $e');
      }
    });
    super.onInit();
  }

  /// -------- [Methods] ----------

  /// Greeting
  updateGreeting() {
    final now = DateTime.now();
    final isMorning = now.hour < 12;
    state.greeting.value =
        isMorning ? 'صبحكم الله بالخير' : 'مساكم الله بالخير';
  }

  scrollToAyah(int ayahNumber) {
    if (state.ayahListController.hasClients) {
      double position = (ayahNumber - 1) * state.ayahItemWidth;
      state.ayahListController.jumpTo(position);
    } else {
      print("Controller not attached to any scroll views.");
    }
  }

  Widget screenSelect() {
    switch (state.screenSelectedValue.value) {
      case 0:
        return const HomeScreen();
      case 1:
        return QuranHome();
      case 3:
        return const AdhkarView();
      case 4:
        return const AudioScreen();
      case 5:
        return BooksScreen();
      default:
        return const HomeScreen();
    }
  }
}
