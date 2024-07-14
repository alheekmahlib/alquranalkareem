import 'package:alquranalkareem/presentation/screens/whats_new/controller/state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/lists.dart';
import '../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../screen_type.dart';
import '../screen/whats_new_screen.dart';

class WhatsNewController extends GetxController {
  static WhatsNewController get instance =>
      Get.isRegistered<WhatsNewController>()
          ? Get.find<WhatsNewController>()
          : Get.put<WhatsNewController>(WhatsNewController());

  WhatsNewState state = WhatsNewState();
  @override
  void onInit() {
    navigationPage();
    super.onInit();
  }

  void navigationPage() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      List<Map<String, dynamic>> newFeatures = await getNewFeatures();
      if (newFeatures.isNotEmpty) {
        Get.bottomSheet(
          WhatsNewScreen(
            newFeatures: newFeatures,
          ),
          isScrollControlled: true,
          enableDrag: false,
        );
      } else {
        Get.offAll(() => ScreenTypeL(), transition: Transition.downToUp);
      }
    });
  }

  Future<void> saveLastShownIndex(int index) async {
    await state.box.write(LAST_SHOWN_UPDATE_INDEX, index);
  }

  Future<int> getLastShownIndex() async {
    return state.box.read(LAST_SHOWN_UPDATE_INDEX) ?? 0;
  }

  Future<List<Map<String, dynamic>>> getNewFeatures() async {
    int lastShownIndex = await getLastShownIndex();

    List<Map<String, dynamic>> newFeatures = whatsNewList.where((item) {
      return item['index'] > lastShownIndex;
    }).toList();

    return newFeatures;
  }

  void showWhatsNew() async {
    List<Map<String, dynamic>> newFeatures = await getNewFeatures();
    if (newFeatures.isNotEmpty) {
      await saveLastShownIndex(newFeatures.last['index']);
    }
  }
}
