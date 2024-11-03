part of '../../../prayers.dart';

extension AdhanGetters on AdhanController {
  /// -------- [Getters] ----------
  int get adjustment {
    if (state.adjustmentIndex.value >= 0 &&
        state.adjustmentIndex.value < state.adjustments.length) {
      return state.adjustments[state.adjustmentIndex.value].value;
    }
    return 0;
  }

  int get currentPrayer => state.prayerTimes.currentPrayer().index - 1;
  int get nextPrayer => state.prayerTimes.nextPrayer().index;

  String get getFridayDhuhrTime =>
      state.hijriDateNow.dayWeName == 'Friday'.tr ? 'Friday'.tr : 'Dhuhr'.tr;

  PrayerDetail getPrayerDetails({required bool isNextPrayer}) {
    final Prayer? currentPrayer = state.prayerTimes.currentPrayer();
    final Prayer? targetPrayer;

    if (isNextPrayer) {
      if (currentPrayer == Prayer.isha) {
        targetPrayer = Prayer.fajr;
      } else {
        targetPrayer = state.prayerTimes.nextPrayer();
      }
    } else {
      targetPrayer = currentPrayer;
    }

    if (targetPrayer == null) {
      return PrayerDetail(
        prayerName: "Unknown",
        prayerTime: null,
        prayerDisplayName: "",
      );
    }

    DateTime? targetPrayerDateTime =
        state.prayerTimes.timeForPrayer(targetPrayer);
    if (isNextPrayer &&
        targetPrayer == Prayer.fajr &&
        currentPrayer == Prayer.isha) {
      targetPrayerDateTime = targetPrayerDateTime?.add(const Duration(days: 1));
    }

    return PrayerDetail(
      prayerName: prayerNameFromEnum(targetPrayer).tr,
      prayerTime: targetPrayerDateTime,
      prayerDisplayName: DateFormatter.formatPrayerTime(targetPrayerDateTime),
    );
  }

  RxDouble get getTimeLeftPercentage {
    final now = DateTime.now();
    final Prayer? currentPrayer = state.prayerTimes.currentPrayer();
    final Prayer? nextPrayer;

    if (currentPrayer == Prayer.isha) {
      nextPrayer = Prayer.fajr;
    } else {
      nextPrayer = state.prayerTimes.nextPrayer();
    }
    if (nextPrayer == null) {
      return 0.0.obs;
    }
    DateTime? nextPrayerDateTime = state.prayerTimes.timeForPrayer(nextPrayer);
    DateTime? currentPrayerDateTime =
        state.prayerTimes.timeForPrayer(currentPrayer!);

    if (nextPrayer == Prayer.fajr && currentPrayer == Prayer.isha) {
      nextPrayerDateTime = nextPrayerDateTime?.add(const Duration(days: 1));
    }
    if (nextPrayerDateTime == null ||
        currentPrayerDateTime == null ||
        nextPrayerDateTime.isBefore(now)) {
      return 0.0.obs;
    }

    final totalDuration =
        nextPrayerDateTime.difference(currentPrayerDateTime).inMinutes;
    final elapsedDuration = now.difference(currentPrayerDateTime).inMinutes;

    double percentage =
        ((elapsedDuration / totalDuration) * 100).clamp(0, 100).toDouble();
    return percentage.obs;
  }

  Duration get getTimeLeftForNextPrayer {
    final now = DateTime.now();
    final Prayer? currentPrayer = state.prayerTimes.currentPrayer();
    final Prayer? nextPrayer;

    if (currentPrayer == Prayer.isha) {
      nextPrayer = Prayer.fajr;
    } else {
      nextPrayer = state.prayerTimes.nextPrayer();
    }
    if (nextPrayer == null) {
      return Duration.zero;
    }
    DateTime? nextPrayerDateTime = state.prayerTimes.timeForPrayer(nextPrayer);
    if (nextPrayer == Prayer.fajr && currentPrayer == Prayer.isha) {
      nextPrayerDateTime = nextPrayerDateTime?.add(const Duration(days: 1));
    }
    if (nextPrayerDateTime == null || nextPrayerDateTime.isBefore(now)) {
      return Duration.zero;
    }
    return nextPrayerDateTime.difference(now);
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

  Widget get LottieWidget {
    DateTime sunrise = state.prayerTimes.sunrise;
    DateTime maghrib = state.prayerTimes.maghrib;

    if (state.now.isAfter(sunrise) && state.now.isBefore(maghrib)) {
      // return customLottie(LottieConstants.assetsLottieSun,
      //     height: 30, width: 30);
      return RiveAnimation.asset(
        'assets/rive/sun.riv',
        fit: BoxFit.cover,
        controllers: [
          SimpleAnimation('Timeline 1', autoplay: true),
        ],
      );
    } else {
      return customLottie(LottieConstants.assetsLottieMoon, height: 120);
    }
  }

  RxBool get prohibitionTimesBool {
    DateTime fajr = state.prayerTimes.fajr;
    DateTime sunrise = state.prayerTimes.sunrise;
    DateTime dhuhr = state.prayerTimes.dhuhr;
    DateTime asr = state.prayerTimes.asr;
    DateTime maghrib = state.prayerTimes.maghrib;

    if (state.now.isAfter(fajr) &&
        state.now.isBefore(sunrise.add(const Duration(minutes: 15)))) {
      state.prohibitionTimesIndex.value = 0;
      return true.obs;
    } else if (state.now.isAfter(dhuhr) &&
        state.now.isBefore(dhuhr.subtract(const Duration(minutes: 10)))) {
      state.prohibitionTimesIndex.value = 1;
      return true.obs;
    } else if (state.now.isAfter(asr) && state.now.isBefore(maghrib)) {
      state.prohibitionTimesIndex.value = 2;
      return true.obs;
    } else {
      return false.obs;
    }
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

  RxBool getIsAlarmed(String prayerTitle) =>
      null == GetStorage('AdhanSounds').read('scheduledAdhan_$prayerTitle')
          ? true.obs
          : false.obs;

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
        // initializeAdhan();
        return HighLatitudeRule.middle_of_the_night;
      case 1:
        state.twilightAngle.value = false;
        state.middleOfTheNight.value = false;
        state.seventhOfTheNight.value = true;
        state.box.write(HIGH_LATITUDE_RULE, 1);
        // initializeAdhan();
        return HighLatitudeRule.seventh_of_the_night;
      case 2:
        state.middleOfTheNight.value = false;
        state.seventhOfTheNight.value = false;
        state.twilightAngle.value = true;
        state.box.write(HIGH_LATITUDE_RULE, 2);
        // initializeAdhan();
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
