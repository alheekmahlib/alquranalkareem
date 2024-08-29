import 'dart:developer';
import 'dart:math' as math;

import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../models/dheker_model.dart';
import '../adhkar_controller.dart';

extension AdhkarGetters on AzkarController {
  /// -------- [Getters] ----------
  bool get hasZekerSettedForThisDay {
    final settedDate = state.box.read(SETTED_DATE_FOR_ZEKER);
    return (settedDate != null && settedDate == HijriCalendar.now().fullDate());
  }

  Future<Dhekr> getDailyDhekr() async {
    print('missing daily Dhekr');
    if (state.dhekrOfTheDay != null) return state.dhekrOfTheDay!;
    final String? zekerOfTheDayIdAndId =
        state.box.read(ZEKER_OF_THE_DAY_AND_ID);
    state.dhekrOfTheDay = await _getZekerForThisDay(
        hasZekerSettedForThisDay ? zekerOfTheDayIdAndId : null);

    return state.dhekrOfTheDay!;
  }

  Future<Dhekr> _getZekerForThisDay([String? zekerOfTheDayIdAndZekerId]) async {
    log("zekerOfTheDayIdAndZekerId: ${zekerOfTheDayIdAndZekerId == null ? "null" : "NOT NULL"}");
    if (zekerOfTheDayIdAndZekerId != null) {
      log("before trying to get ziker", name: 'BEFORE');
      final cachedZeker =
          state.allAdhkar[int.parse(zekerOfTheDayIdAndZekerId) - 1];
      log("date: ${HijriCalendar.now().fullDate()}", name: 'CAHECH HADITH');
      return cachedZeker;
    }
    final random = math.Random().nextInt(state.allAdhkar.length);
    log('allAzkar length: ${state.allAdhkar.length}');
    Dhekr? zeker = state.allAdhkar.firstWhereOrNull((z) => z.id == random);
    log('allAzkar length: ${state.allAdhkar.length} 2222');
    while (zeker == null) {
      log('allAzkar length: ${state.allAdhkar.length} ', name: 'while');
      zeker = state.allAdhkar.firstWhereOrNull((z) => z.id == random);
      log('zikr is null  ' * 5);
    }
    log('before listing');
    state.box
      ..write(ZEKER_OF_THE_DAY_AND_ID, '${zeker.id}')
      ..write(SETTED_DATE_FOR_ZEKER, HijriCalendar.now().fullDate());
    return zeker;
  }
}
