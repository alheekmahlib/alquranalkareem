import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '/presentation/screens/home/home_screen.dart';
import '../../../core/services/location/locations.dart';
import '../../../core/utils/constants/shared_preferences_constants.dart';
import '../../screens/adhkar/screens/adhkar_view.dart';
import '../../screens/books/screens/books_screen.dart';
import '../../screens/prayers/controller/adhan/adhan_controller.dart';
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
    state.activeLocation.value = state.box.read(ACTIVE_LOCATION) ?? true;
    await initLocation();
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

  /// -------- [PrayersMethods] ----------

  Future<void> initLocation() async {
    try {
      await LocationHelper.instance.getPositionDetails();
    } catch (e) {
      log(e.toString(), name: "Main", error: e);
    }
  }

  Future<void> toggleLocationService() async {
    bool isEnabled = await LocationHelper.instance.isLocationServiceEnabled();
    if (!isEnabled) {
      await LocationHelper.instance.openLocationSettings();
      await Future.delayed(const Duration(seconds: 3));
      isEnabled = await LocationHelper.instance.isLocationServiceEnabled();
      if (isEnabled || state.activeLocation.value) {
        await initLocation().then((_) async {
          state.activeLocation.value = true;
          // await sl<NotificationController>().initializeNotification();
          await AdhanController.instance.initializeAdhan();
          state.box.write(ACTIVE_LOCATION, true);
          AdhanController.instance.onInit();
        });
      } else {
        log('Location services were not enabled by the user.');
      }
    } else {
      await initLocation().then((_) async {
        state.activeLocation.value = true;
        // await sl<NotificationController>().initializeNotification();
        await AdhanController.instance.initializeAdhan();
        state.box.write(ACTIVE_LOCATION, true);
        AdhanController.instance.onInit();
      });
      log('Location services are already enabled.');
    }
    AdhanController.instance.update();
  }
}
