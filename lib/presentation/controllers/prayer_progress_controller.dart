import 'package:get/get.dart';

import 'adhan_controller.dart';

class PrayerProgressController extends GetxController {
  static PrayerProgressController get instance =>
      Get.isRegistered<PrayerProgressController>()
          ? Get.find<PrayerProgressController>()
          : Get.put<PrayerProgressController>(PrayerProgressController());

  final adhanCtrl = AdhanController.instance;

  RxDouble progress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    updateProgress();
  }

  void updateProgress() {
    final now = DateTime.now();
    DateTime startTime = DateTime(now.year, now.month, now.day, 0, 0);
    DateTime endTime = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final totalDuration = endTime.difference(startTime).inSeconds;
    final elapsedDuration = now.difference(startTime).inSeconds;

    progress.value = (elapsedDuration / totalDuration) * 100;

    print('Progress: ${progress.value}%');

    // Update progress every minute
    Future.delayed(const Duration(minutes: 1), updateProgress);
  }
}
