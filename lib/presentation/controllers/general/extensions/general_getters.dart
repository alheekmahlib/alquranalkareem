import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../../../core/utils/constants/string_constants.dart';
import '../../../screens/calendar/events.dart';
import '../general_controller.dart';

extension GeneralGetters on GeneralController {
  /// -------- [Getters] ----------

  List get eidDaysList => [
    '1-10',
    '2-10',
    '3-10',
    '10-12',
    '11-12',
    '12-12',
    '13-12',
  ];

  String get eidGreetingContent =>
      EventController.instance.hijriNow.hMonth == 10
      ? 'eidGreetingContent'.tr
      : 'eidGreetingContent2'.tr;

  bool get eidDays {
    String todayString =
        '${EventController.instance.hijriNow.hDay}-${EventController.instance.hijriNow.hMonth}';
    return eidDaysList.contains(todayString);
  }

  Future<Uri> getCachedArtUri() async {
    final file = await DefaultCacheManager().getSingleFile(
      StringConstants.appsIcon1024,
    );
    return await file.exists()
        ? file.uri
        : Uri.parse(StringConstants.appsIcon1024);
  }

  Future<void> getLastPageAndFontSize() async {
    try {
      double fontSizeFromPref = state.box.read(FONT_SIZE) ?? 24.0;
      if (fontSizeFromPref != 0.0 && fontSizeFromPref > 0) {
        state.fontSizeArabic.value = fontSizeFromPref;
      } else {
        state.fontSizeArabic.value = 24.0;
      }
    } catch (e) {
      print('Failed to load last page: $e');
    }
  }
}
