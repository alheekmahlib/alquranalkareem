part of '../../../prayers.dart';

extension AdhanGetters on AdhanController {
  /// -------- [Getters] ----------
  int get adjustment {
    if (state.index.value >= 0 &&
        state.index.value < state.adjustments.length) {
      return state.adjustments[state.index.value].value;
    }
    return 0;
  }

  int get currentPrayer => state.prayerTimes.currentPrayer().index - 1;
  int get nextPrayer => state.prayerTimes.nextPrayer().index;

  String get getFridayDhuhrTime =>
      state.hijriDateNow.dayWeName == 'Friday' ? 'Friday' : 'Dhuhr';

  PrayerDetail get getCurrentPrayerDetails {
    final Prayer currentPrayerEnum = state.prayerTimes.currentPrayer();
    final DateTime? currentPrayerTime =
        state.prayerTimes.timeForPrayer(currentPrayerEnum);

    return PrayerDetail(
      prayerName: prayerNameFromEnum(currentPrayerEnum),
      prayerTime: currentPrayerTime,
      prayerDisplayName: DateFormatter.formatPrayerTime(currentPrayerTime),
    );
  }

  PrayerDetail get getNextPrayerDetails {
    final Prayer nextPrayerEnum = state.prayerTimes.nextPrayer();
    final DateTime? nextPrayerTime =
        state.prayerTimes.timeForPrayer(nextPrayerEnum);

    return PrayerDetail(
      prayerName: prayerNameFromEnum(nextPrayerEnum).tr,
      prayerTime: nextPrayerTime,
      prayerDisplayName: DateFormatter.formatPrayerTime(nextPrayerTime),
    );
  }

  Widget get LottieWidget {
    DateTime sunrise = state.prayerTimes.sunrise;
    DateTime maghrib = state.prayerTimes.maghrib;

    if (state.now.isAfter(sunrise) && state.now.isBefore(maghrib)) {
      return customLottie(LottieConstants.assetsLottieSun,
          height: 30, width: 30);
    } else {
      return customLottie(LottieConstants.assetsLottieMoon, height: 120);
    }
  }

  Duration get getTimeLeftForNextPrayer {
    final now = DateTime.now();
    final Prayer? nextPrayer = state.prayerTimes.nextPrayer();
    if (nextPrayer == null) {
      return Duration.zero;
    }
    DateTime? nextPrayerDateTime = state.prayerTimes.timeForPrayer(nextPrayer);

    // إذا لم تكن هناك صلاة قادمة (مثلاً بعد العشاء) أو كانت الصلاة القادمة قد مرت
    if (nextPrayerDateTime == null || nextPrayerDateTime.isBefore(now)) {
      // إذا كانت الصلاة القادمة هي الفجر، نضبط التاريخ ليكون لليوم التالي
      if (nextPrayer == Prayer.fajr) {
        nextPrayerDateTime = nextPrayerDateTime?.add(const Duration(days: 1));
      } else {
        return Duration.zero;
      }
    }

    return nextPrayerDateTime!.difference(now);
  }

  DateTime get getTimeLeftForHomeWidgetNextPrayer {
    final now = DateTime.now();
    final Prayer? nextPrayer = state.prayerTimes.nextPrayer();
    if (nextPrayer == null) {
      return now.add(const Duration(hours: 1));
    }
    final DateTime? nextPrayerDateTime =
        state.prayerTimes.timeForPrayer(nextPrayer);
    if (nextPrayerDateTime == null || nextPrayerDateTime.isBefore(now)) {
      return now.add(const Duration(hours: 1));
    }
    return nextPrayerDateTime;
  }

  void get getShared {
    state.isHanafi.value = state.box.read(SHAFI) ?? true;
    state.highLatitudeRuleIndex.value = state.box.read(HIGH_LATITUDE_RULE) ?? 2;
    state.autoCalculationMethod.value =
        state.box.read(AUTO_CALCULATION) ?? true;
    state.adjustments[0].value = state.box.read(ADJUSTMENT_FAJR) ?? 0;
    state.adjustments[1].value = state.box.read(ADJUSTMENT_DHUHR) ?? 0;
    state.adjustments[2].value = state.box.read(ADJUSTMENT_ASR) ?? 0;
    state.adjustments[3].value = state.box.read(ADJUSTMENT_MAGHRIB) ?? 0;
    state.adjustments[4].value = state.box.read(ADJUSTMENT_ISHA) ?? 0;
    state.adjustments[5].value = state.box.read(ADJUSTMENT_THIRD) ?? 0;
    state.adjustments[6].value = state.box.read(ADJUSTMENT_MIDNIGHT) ?? 0;
  }

  Duration get getDelayUntilNextIsha {
    DateTime nextIsha = state.prayerTimes.isha;

    // If today's Isha time is already passed, schedule for tomorrow
    if (state.now.isAfter(nextIsha)) {
      nextIsha = nextIsha.add(const Duration(minutes: 15));
    }

    return nextIsha.difference(state.now);
  }

  getPrayerSelected(int index, var v1, var v2) =>
      state.box.read(prayerNameList[index]['sharedAlarm']) == true ? v1 : v2;

  Future<PrayerDay> getPrayerTimesForDay(DateTime date) async {
    final hijriDate = HijriCalendar.fromDate(date);
    return PrayerDay(
      date: date,
      fajr: state.prayerTimes.fajr,
      dhuhr: state.prayerTimes.dhuhr,
      asr: state.prayerTimes.asr,
      maghrib: state.prayerTimes.maghrib,
      isha: state.prayerTimes.isha,
      hijriDate: hijriDate,
    );
  }

  Madhab getMadhab(bool madhab) {
    if (madhab) {
      return Madhab.shafi;
    } else {
      return Madhab.hanafi;
    }
  }

  HighLatitudeRule getHighLatitudeRule(int index) {
    switch (index) {
      case 0:
        state.twilightAngle.value = false;
        state.seventhOfTheNight.value = false;
        state.middleOfTheNight.value = true;
        state.box.write(HIGH_LATITUDE_RULE, 0);
        return HighLatitudeRule.middle_of_the_night;
      case 1:
        state.twilightAngle.value = false;
        state.middleOfTheNight.value = false;
        state.seventhOfTheNight.value = true;
        state.box.write(HIGH_LATITUDE_RULE, 1);
        return HighLatitudeRule.seventh_of_the_night;
      case 2:
        state.middleOfTheNight.value = false;
        state.seventhOfTheNight.value = false;
        state.twilightAngle.value = true;
        state.box.write(HIGH_LATITUDE_RULE, 2);
        return HighLatitudeRule.twilight_angle;
      default:
        return HighLatitudeRule.twilight_angle;
    }
  }

  RxBool getCurrentSelectedPrayer(int index) =>
      currentPrayer == index ? true.obs : false.obs;

  Future<String> getPrayerTime(int prayerIndex, DateTime prayerTime) async {
    try {
      Duration adjustment =
          Duration(minutes: state.adjustments[prayerIndex].value);
      DateTime adjustedPrayerTime = prayerTime.add(adjustment);
      return await DateFormatter.justTime(adjustedPrayerTime);
    } catch (e) {
      return 'Error fetching time';
    }
  }
}
