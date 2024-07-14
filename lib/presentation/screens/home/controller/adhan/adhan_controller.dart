import 'dart:async';
import 'dart:convert';

import 'package:adhan/adhan.dart';
import 'package:alquranalkareem/presentation/screens/home/controller/adhan/adhan_state.dart';
import 'package:alquranalkareem/presentation/screens/home/controller/adhan/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';

import '/core/services/location/locations.dart';
import '/core/utils/helpers/date_formatter.dart';
import '../../../../../core/data/models/prayer_day_model.dart';
import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/lists.dart';
import '../../../../../core/utils/constants/lottie.dart';
import '../../../../../core/utils/constants/lottie_constants.dart';
import '../../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../../../../core/widgets/home_widget/hijri_widget/hijri_widget_config.dart';
import '../../../../../core/widgets/home_widget/prayers_widget/prayers_widget_config.dart';
import '../../../../controllers/notification_controller.dart';
import '../../data/model/prayer_details.dart';
import '../../data/model/prayer_list.dart';

class AdhanController extends GetxController {
  static AdhanController get instance => Get.isRegistered<AdhanController>()
      ? Get.find<AdhanController>()
      : Get.put<AdhanController>(AdhanController());

  AdhanState state = AdhanState();

  fetchCountryList() {
    state.countryListFuture = getCountryList();
  }

  int get adjustment {
    if (state.index.value >= 0 &&
        state.index.value < state.adjustments.length) {
      return state.adjustments[state.index.value].value;
    }
    return 0;
  }

  int get currentPrayer => state.prayerTimes.currentPrayer().index - 1;
  int get nextPrayer => state.prayerTimes.nextPrayer().index;

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

  String get getFridayDhuhrTime =>
      state.hijriDateNow.dayWeName == 'Friday' ? 'Friday' : 'Dhuhr';

  RxBool getCurrentSelectedPrayer(int index) =>
      currentPrayer == index ? true.obs : false.obs;

  PrayerDetail getCurrentPrayerDetails() {
    final Prayer currentPrayerEnum = state.prayerTimes.currentPrayer();
    final DateTime? currentPrayerTime =
        state.prayerTimes.timeForPrayer(currentPrayerEnum);

    return PrayerDetail(
      prayerName: prayerNameFromEnum(currentPrayerEnum),
      prayerTime: currentPrayerTime,
      prayerDisplayName: DateFormatter.formatPrayerTime(currentPrayerTime),
    );
  }

  PrayerDetail getNextPrayerDetails() {
    final Prayer nextPrayerEnum = state.prayerTimes.nextPrayer();
    final DateTime? nextPrayerTime =
        state.prayerTimes.timeForPrayer(nextPrayerEnum);

    return PrayerDetail(
      prayerName: prayerNameFromEnum(nextPrayerEnum).tr,
      prayerTime: nextPrayerTime,
      prayerDisplayName: DateFormatter.formatPrayerTime(nextPrayerTime),
    );
  }

  String prayerNameFromEnum(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return "Fajr";
      case Prayer.sunrise:
        return "Sunrise";
      case Prayer.dhuhr:
        return "Dhuhr";
      case Prayer.asr:
        return "Asr";
      case Prayer.maghrib:
        return "Maghrib";
      case Prayer.isha:
        return "Isha";
      case Prayer.none:
      default:
        return "Fajr";
    }
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

  Duration getTimeLeftForNextPrayer() {
    final now = DateTime.now();
    final Prayer? nextPrayer = state.prayerTimes.nextPrayer();
    if (nextPrayer == null) {
      return Duration.zero;
    }
    final DateTime? nextPrayerDateTime =
        state.prayerTimes.timeForPrayer(nextPrayer);
    if (nextPrayerDateTime == null || nextPrayerDateTime.isBefore(now)) {
      return Duration.zero;
    }
    return nextPrayerDateTime.difference(now);
  }

  DateTime getTimeLeftForHomeWidgetNextPrayer() {
    final now = DateTime.now();
    final Prayer? nextPrayer = adhanCtrl.state.prayerTimes.nextPrayer();
    if (nextPrayer == null) {
      return now.add(const Duration(hours: 1));
    }
    final DateTime? nextPrayerDateTime =
        adhanCtrl.state.prayerTimes.timeForPrayer(nextPrayer);
    if (nextPrayerDateTime == null || nextPrayerDateTime.isBefore(now)) {
      return now.add(const Duration(hours: 1));
    }
    return nextPrayerDateTime;
  }

  void prayerAlarmSwitch(int index) {
    switch (index) {
      case 0:
        state.box.write(prayerNameList[0]['sharedAlarm'],
            state.prayerAlarm.value = !state.prayerAlarm.value);
        break;
      case 1:
        state.box.write(prayerNameList[1]['sharedAlarm'],
            state.prayerAlarm.value = !state.prayerAlarm.value);
        break;
      case 2:
        state.box.write(prayerNameList[2]['sharedAlarm'],
            state.prayerAlarm.value = !state.prayerAlarm.value);
        break;
      case 3:
        state.box.write(prayerNameList[3]['sharedAlarm'],
            state.prayerAlarm.value = !state.prayerAlarm.value);
        break;
      case 4:
        state.box.write(prayerNameList[4]['sharedAlarm'],
            state.prayerAlarm.value = !state.prayerAlarm.value);
        break;
    }
    sl<NotificationController>().initializeNotification();
    update();
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    getShared;
    initializeAdhan();
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

  Future<void> initTimes() async {
    print("====================");
    print("Updating times...");
    print("====================");
    await Future.wait([
      getPrayerTime(0, state.prayerTimes.fajr)
          .then((v) => state.fajrTime.value = v),
      getPrayerTime(1, state.prayerTimes.dhuhr)
          .then((v) => state.dhuhrTime.value = v),
      getPrayerTime(2, state.prayerTimes.asr)
          .then((v) => state.asrTime.value = v),
      getPrayerTime(3, state.prayerTimes.maghrib)
          .then((v) => state.maghribTime.value = v),
      getPrayerTime(4, state.prayerTimes.isha)
          .then((v) => state.ishaTime.value = v),
      getPrayerTime(0, state.sunnahTimes.lastThirdOfTheNight)
          .then((v) => state.lastThirdTime.value = v),
      getPrayerTime(0, state.sunnahTimes.middleOfTheNight)
          .then((v) => state.midnightTime.value = v),
    ]);
    print("Times updated, calling update...");
    update();
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

  Future<void> initializeAdhanVariables() async {
    state.coordinates = Coordinates(Location.instance.position!.latitude,
        Location.instance.position!.longitude);
    state.dateComponents = DateComponents.from(state.now);

    if (!state.autoCalculationMethod.value) {
      state.params =
          await state.selectedCountry.value.getCalculationParameters();
    } else {
      state.params = await Location.instance.country.getCalculationParameters();
    }

    state.params
      ..madhab = getMadhab(state.isHanafi.value)
      ..highLatitudeRule =
          getHighLatitudeRule(state.highLatitudeRuleIndex.value);

    state.prayerTimesNow =
        PrayerTimes(state.coordinates, state.dateComponents, state.params);
    state.sunnahTimes = SunnahTimes(state.prayerTimesNow);
    update();
    state.prayerTimes = state.prayerTimesNow;
    return await initTimes();
  }

  Future<void> initializeAdhan() async {
    if (state.generalCtrl.activeLocation.value) {
      await state.generalCtrl.initLocation().then((value) async {
        geo.setLocaleIdentifier(Get.locale!.languageCode);
        await initializeAdhanVariables();
        await initTimes();
        fetchCountryList();
        getCountryList().then((list) => state.countries = list);
        updateProgress();
        state.timer = Timer.periodic(
            const Duration(minutes: 1), (Timer t) => updateProgress());
      });
      await PrayersWidgetConfig.initialize();
      PrayersWidgetConfig().updatePrayersDate();
    }
    await HijriWidgetConfig.initialize();
    HijriWidgetConfig().updateHijriDate();
  }

  Future<List<String>> getCountryList() async {
    final jsonString = await rootBundle.loadString('assets/json/madhab.json');
    final jsonData = jsonDecode(jsonString) as List<dynamic>; // Decode as List

    // List<String> countries = [];
    for (var item in jsonData) {
      // Assuming each item is a map with a "country" key
      state.countries.add(item['country'] as String);
    }
    return state.countries;
  }

  void updateProgress() {
    var now = DateTime.now();
    var totalMinutes = 24 * 60;
    var currentMinutes = now.hour * 60 + now.minute;
    state.timeProgress.value = (currentMinutes / totalMinutes) * 100;
  }

  Duration getDelayUntilNextIsha() {
    DateTime nextIsha = state.prayerTimes.isha;

    // If today's Isha time is already passed, schedule for tomorrow
    if (state.now.isAfter(nextIsha)) {
      nextIsha = nextIsha.add(const Duration(minutes: 15));
    }

    return nextIsha.difference(state.now);
  }

  @override
  void onClose() {
    state.timer?.cancel();
    super.onClose();
  }

  void shafiOnTap() {
    adhanCtrl.state.isHanafi.value = true;
    initializeAdhanVariables();
    sl<NotificationController>().initializeNotification();
    state.box.write(SHAFI, adhanCtrl.state.isHanafi.value);
  }

  void hanafiOnTap() {
    adhanCtrl.state.isHanafi.value = false;
    initializeAdhanVariables();
    sl<NotificationController>().initializeNotification();
    state.box.write(SHAFI, adhanCtrl.state.isHanafi.value);
  }

  Future<void> removeOnTap(int index) async {
    print("Before remove: ${state.adjustments[index].value}");
    state.adjustments[index].value -= 1;
    state.box.write(prayerNameList[index]['sharedAdjustment'],
        state.adjustments[index].value);
    print("After remove: ${state.adjustments[index].value}");
    await initTimes();
    sl<NotificationController>().initializeNotification();
    update();
  }

  Future<void> addOnTap(int index) async {
    print("Before add: ${state.adjustments[index].value}");
    state.adjustments[index].value += 1;
    state.box.write(prayerNameList[index]['sharedAdjustment'],
        state.adjustments[index].value);
    print("After add: ${state.adjustments[index].value}");
    await initTimes();
    sl<NotificationController>().initializeNotification();
    update();
  }

  Future<void> switchAutoCalculation(bool value) async {
    state.autoCalculationMethod.value = !state.autoCalculationMethod.value;
    await initializeAdhanVariables();
    sl<NotificationController>().initializeNotification();
    state.box.write(AUTO_CALCULATION, value);
  }

  List<Map<String, dynamic>> _prayerNameList = [];

  List<Map<String, dynamic>> get prayerNameList =>
      generatePrayerNameList(state);

  set updatePrayerNameList(List<Map<String, dynamic>> newList) {
    _prayerNameList = newList;
    update();
  }
}
