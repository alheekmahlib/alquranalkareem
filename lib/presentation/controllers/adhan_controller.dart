import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/data/models/prayer_day_model.dart';
import '../../core/services/services_locator.dart';
import '../../core/utils/constants/lists.dart';
import '../../core/utils/constants/location_enum.dart';
import '../../core/utils/constants/lottie.dart';
import '../../core/utils/constants/lottie_constants.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import '../../core/widgets/home_widget/home_widget_config.dart';
import '/core/services/location/locations.dart';
import '/core/utils/helpers/date_formatter.dart';
import 'general_controller.dart';

class AdhanController extends GetxController {
  late PrayerTimes prayerTimes;
  String nextPrayerTime = "";
  final DateTime now = DateTime.now();
  RxBool prayerAlarm = true.obs;
  final sharedCtrl = sl<SharedPreferences>();
  var countdownTime = "".obs;
  late SunnahTimes sunnahTimes;
  // RxBool formatted12Hour = true.obs;
  // RxBool isHijri = true.obs;
  HijriCalendar hijriDateNow = HijriCalendar.now();
  late Coordinates coordinates;
  // Create date components from the provided date
  late DateComponents dateComponents;
  // Get calculation parameters based on your desired calculation method
  late CalculationParameters params;
  RxDouble timeProgress = 0.0.obs;
  Timer? timer;
  RxString fajrTime = ''.obs;
  RxString dhuhrTime = ''.obs;
  RxString asrTime = ''.obs;
  RxString maghribTime = ''.obs;
  RxString ishaTime = ''.obs;
  RxString lastThirdTime = ''.obs;
  RxString midnightTime = ''.obs;
  RxBool isHanafi = true.obs;
  RxInt highLatitudeRuleIndex = 2.obs;
  RxBool twilightAngle = true.obs;
  RxBool middleOfTheNight = false.obs;
  RxBool seventhOfTheNight = false.obs;
  var prayerTimesNow;
  final generalCtrl = sl<GeneralController>();
  RxBool autoCalculationMethod = true.obs;
  RxString calculationMethodString = 'أم القرى'.obs;
  RxString selectedCountry = 'Saudi Arabia'.obs;
  List<String> countries = [];
  late final HighLatitudeRule highLatitudeRule;
  var index = RxInt(0);
  List<RxInt> adjustments = List.generate(7, (_) => 0.obs);

  Future<List<String>>? countryListFuture;
  fetchCountryList() {
    countryListFuture = getCountryList();
  }

  int get adjustment {
    if (index.value >= 0 && index.value < adjustments.length) {
      return adjustments[index.value].value;
    }
    return 0;
  }

  int get currentPrayer => prayerTimes.currentPrayer().index - 1;
  int get nextPrayer => prayerTimes.nextPrayer().index;

  Future<String> get getFajrTime async {
    Duration adjustment = Duration(minutes: adjustments[0].value);
    DateTime adjustedFajrTime = prayerTimes.fajr.add(adjustment);
    return await DateFormatter.justTime(adjustedFajrTime);
  }

  Future<String> get getDhuhrTime async {
    Duration adjustment = Duration(minutes: adjustments[1].value);
    DateTime adjustedDhuhrTime = prayerTimes.dhuhr.add(adjustment);

    return await DateFormatter.justTime(adjustedDhuhrTime);
  }

  Future<String> get getAsrTime async {
    Duration adjustment = Duration(minutes: adjustments[2].value);
    DateTime adjustedAsrTime = prayerTimes.asr.add(adjustment);

    return await DateFormatter.justTime(adjustedAsrTime);
  }

  Future<String> get getMaghribTime async {
    Duration adjustment = Duration(minutes: adjustments[3].value);
    DateTime adjustedMaghribTime = prayerTimes.maghrib.add(adjustment);

    return await DateFormatter.justTime(adjustedMaghribTime);
  }

  Future<String> get getIshaTime async {
    Duration adjustment = Duration(minutes: adjustments[4].value);
    DateTime adjustedIshaTime = prayerTimes.isha.add(adjustment);

    return await DateFormatter.justTime(adjustedIshaTime);
  }

  Future<String> get lastThirdStartTime async {
    Duration adjustment = Duration(minutes: adjustments[5].value);
    DateTime adjustedLastThirdTime =
        sunnahTimes.lastThirdOfTheNight.add(adjustment);

    return await DateFormatter.justTime(adjustedLastThirdTime);
  }

  Future<String> get getMidnightTime async {
    Duration adjustment = Duration(minutes: adjustments[6].value);
    DateTime adjustedMidnightTime =
        sunnahTimes.middleOfTheNight.add(adjustment);

    return await DateFormatter.justTime(adjustedMidnightTime);
  }

  String get getFridayDhuhrTime =>
      hijriDateNow.dayWeName == 'Friday' ? 'Friday' : 'Dhuhr';

  RxBool getCurrentSelectedPrayer(int index) =>
      currentPrayer == index ? true.obs : false.obs;

  String getCurrentPrayerName() {
    final Prayer currentPrayer = prayerTimes.currentPrayer();
    return prayerNameFromEnum(currentPrayer);
  }

  String getNextPrayerName() {
    final Prayer nextPrayer = prayerTimes.nextPrayer();
    return prayerNameFromEnum(nextPrayer).tr;
  }

  DateTime? getCurrentPrayerTime() {
    final Prayer currentPrayer = prayerTimes.currentPrayer();
    return prayerTimes.timeForPrayer(currentPrayer);
  }

  DateTime? getNextPrayerTime() {
    final Prayer nextPrayer = prayerTimes.nextPrayer();
    return prayerTimes.timeForPrayer(nextPrayer);
  }

  String getCurrentPrayerDisplayName() {
    final DateTime? time = getCurrentPrayerTime();
    return DateFormatter.formatPrayerTime(time);
  }

  String getNextPrayerDisplayName() {
    final DateTime? time = getNextPrayerTime();
    return DateFormatter.formatPrayerTime(time);
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

  // Future<void> prayerTimesInitialization() async {
  //   getFajrTime = await DateFormatter.justTime(prayerTimes.fajr);
  //   getDhuhrTime = await DateFormatter.justTime(prayerTimes.dhuhr);
  //   getAsrTime = await DateFormatter.justTime(prayerTimes.asr);
  //   getMaghribTime = await DateFormatter.justTime(prayerTimes.maghrib);
  //   getIshaTime = await DateFormatter.justTime(prayerTimes.isha);
  //   lastThirdStartTime =
  //       await DateFormatter.justTime(sunnahTimes.lastThirdOfTheNight);
  //   getMidnightTime =
  //       await DateFormatter.justTime(sunnahTimes.middleOfTheNight);
  //   update();
  // }

  Widget get LottieWidget {
    DateTime sunrise = prayerTimes.sunrise;
    DateTime maghrib = prayerTimes.maghrib;

    if (now.isAfter(sunrise) && now.isBefore(maghrib)) {
      return customLottie(LottieConstants.assetsLottieSun,
          height: 30, width: 30);
    } else {
      return customLottie(LottieConstants.assetsLottieMoon, height: 120);
    }
  }

  Duration getTimeLeftForNextPrayer() {
    final now = DateTime.now();
    final Prayer? nextPrayer = prayerTimes.nextPrayer();
    if (nextPrayer == null) {
      return Duration.zero;
    }
    final DateTime? nextPrayerDateTime = prayerTimes.timeForPrayer(nextPrayer);
    if (nextPrayerDateTime == null || nextPrayerDateTime.isBefore(now)) {
      return Duration.zero;
    }
    return nextPrayerDateTime.difference(now);
  }

  void prayerAlarmSwitch(int index) {
    switch (index) {
      case 0:
        sharedCtrl.setBool(prayerNameList[0]['sharedAlarm'],
            prayerAlarm.value = !prayerAlarm.value);
        break;
      case 1:
        sharedCtrl.setBool(prayerNameList[1]['sharedAlarm'],
            prayerAlarm.value = !prayerAlarm.value);
        break;
      case 2:
        sharedCtrl.setBool(prayerNameList[2]['sharedAlarm'],
            prayerAlarm.value = !prayerAlarm.value);
        break;
      case 3:
        sharedCtrl.setBool(prayerNameList[3]['sharedAlarm'],
            prayerAlarm.value = !prayerAlarm.value);
        break;
      case 4:
        sharedCtrl.setBool(prayerNameList[4]['sharedAlarm'],
            prayerAlarm.value = !prayerAlarm.value);
        break;
    }
    update();
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    getShared;
    if (generalCtrl.activeLocation.value) {
      await generalCtrl.initLocation().then((value) async {
        geo.setLocaleIdentifier(Get.locale!.languageCode);
        await initializeAdhanVariables();
        await initTimes();
        fetchCountryList();
        getCountryList().then((list) => countries = list);
        updateProgress();
        timer = Timer.periodic(
            const Duration(minutes: 1), (Timer t) => updateProgress());
      });
      await HomeWidgetConfig.initialize();
      HomeWidgetConfig().updateHijriDate();
    }
  }

  // Future<PrayerTimes> initializeAdhanVariables() async {
  //   coordinates = Coordinates(Location.instance.position!.latitude,
  //       Location.instance.position!.longitude);
  //   log('coordinates: ${Location.instance.position!.latitude} ${coordinates.longitude}');
  //   dateComponents = DateComponents.from(now);
  //   // params = CalculationMethod.north_america.parameters();
  //   params = getCalculationParametersFromLocation(Location.instance.country)
  //     ..madhab = getMadhab(madhab.value)
  //     ..highLatitudeRule = getHighLatitudeRule(highLatitudeRuleIndex.value);
  //   prayerTimesNow = PrayerTimes(coordinates, dateComponents, params);
  //   sunnahTimes = SunnahTimes(prayerTimesNow);
  //   update();
  //   return prayerTimes = prayerTimesNow;
  // }

  void get getShared {
    isHanafi.value = sharedCtrl.getBool(SHAFI) ?? true;
    highLatitudeRuleIndex.value = sharedCtrl.getInt(HIGH_LATITUDE_RULE) ?? 2;
    autoCalculationMethod.value = sharedCtrl.getBool(AUTO_CALCULATION) ?? true;
    adjustments[0].value = sharedCtrl.getInt('ADJUSTMENT_FAJR') ?? 0;
    adjustments[1].value = sharedCtrl.getInt('ADJUSTMENT_DHUHR') ?? 0;
    adjustments[2].value = sharedCtrl.getInt('ADJUSTMENT_ASR') ?? 0;
    adjustments[3].value = sharedCtrl.getInt('ADJUSTMENT_MAGHRIB') ?? 0;
    adjustments[4].value = sharedCtrl.getInt('ADJUSTMENT_ISHA') ?? 0;
    adjustments[5].value = sharedCtrl.getInt('ADJUSTMENT_THIRD') ?? 0;
    adjustments[6].value = sharedCtrl.getInt('ADJUSTMENT_MIDNIGHT') ?? 0;
  }

  Future<void> initTimes() async {
    print("Updating times...");
    await Future.wait([
      getFajrTime.then((v) => fajrTime.value = v),
      getDhuhrTime.then((v) => dhuhrTime.value = v),
      getAsrTime.then((v) => asrTime.value = v),
      getMaghribTime.then((v) => maghribTime.value = v),
      getIshaTime.then((v) => ishaTime.value = v),
      lastThirdStartTime.then((v) => lastThirdTime.value = v),
      getMidnightTime.then((v) => midnightTime.value = v),
    ]);
    print("Times updated, calling update...");
    update();
  }

  getPrayerSelected(int index, var v1, var v2) =>
      sharedCtrl.getBool(prayerNameList[index]['sharedAlarm']) == true
          ? v1
          : v2;

  // getAnotherTimeSelected(int index, var v1, var v2) =>
  //     sharedCtrl.getBool(anotherTimeList[index]['sharedAlarm']) == true
  //         ? v1
  //         : v2;

  Future<PrayerDay> getPrayerTimesForDay(DateTime date) async {
    // Convert to Hijri
    final hijriDate = HijriCalendar.fromDate(date);

    // Create and return the PrayerDay object
    return PrayerDay(
      date: date,
      fajr: prayerTimes.fajr,
      dhuhr: prayerTimes.dhuhr,
      asr: prayerTimes.asr,
      maghrib: prayerTimes.maghrib,
      isha: prayerTimes.isha,
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
        twilightAngle.value = false;
        seventhOfTheNight.value = false;
        middleOfTheNight.value = true;
        sharedCtrl.setInt(HIGH_LATITUDE_RULE, 0);
        return HighLatitudeRule.middle_of_the_night;
      case 1:
        twilightAngle.value = false;
        middleOfTheNight.value = false;
        seventhOfTheNight.value = true;
        sharedCtrl.setInt(HIGH_LATITUDE_RULE, 1);
        return HighLatitudeRule.seventh_of_the_night;
      case 2:
        middleOfTheNight.value = false;
        seventhOfTheNight.value = false;
        twilightAngle.value = true;
        sharedCtrl.setInt(HIGH_LATITUDE_RULE, 2);
        return HighLatitudeRule.twilight_angle;
      default:
        return HighLatitudeRule.twilight_angle;
    }
  }

  Future<void> initializeAdhanVariables() async {
    coordinates = Coordinates(Location.instance.position!.latitude,
        Location.instance.position!.longitude);
    log('coordinates: ${Location.instance.position!.latitude} ${coordinates.longitude}');
    dateComponents = DateComponents.from(now);

    if (!autoCalculationMethod.value) {
      params =
          await getCalculationParametersFromLocation(selectedCountry.value);
    } else {
      params =
          await getCalculationParametersFromLocation(Location.instance.country);
    }

    params
      ..madhab = getMadhab(isHanafi.value)
      ..highLatitudeRule = getHighLatitudeRule(highLatitudeRuleIndex.value);

    prayerTimesNow = PrayerTimes(coordinates, dateComponents, params);
    sunnahTimes = SunnahTimes(prayerTimesNow);
    update();
    prayerTimes = prayerTimesNow;
    return await initTimes();
  }

  Future<CalculationParameters> getCalculationParametersFromLocation(
      String location) async {
    // LocationEnum select = location.getCountry();
    LocationEnum select =
        ((await getCalculationParametersFromJson(location)) ?? location)
            .getCountry();
    switch (select) {
      case LocationEnum.umm_al_qura:
        return CalculationMethod.umm_al_qura.getParameters();
      case LocationEnum.NorthAmerica:
        return CalculationMethod.north_america.getParameters();
      case LocationEnum.Egyptian:
        return CalculationMethod.egyptian.getParameters();
      case LocationEnum.Dubai:
        return CalculationMethod.dubai.getParameters();
      case LocationEnum.Karachi:
        return CalculationMethod.karachi.getParameters();
      case LocationEnum.Kuwait:
        return CalculationMethod.kuwait.getParameters();
      case LocationEnum.Qatar:
        return CalculationMethod.qatar.getParameters();
      case LocationEnum.Turkey:
        return CalculationMethod.turkey.getParameters();
      case LocationEnum.Singapore:
        return CalculationMethod.singapore.getParameters();
      case LocationEnum.muslim_world_league:
        return CalculationMethod.muslim_world_league.getParameters();
      case LocationEnum.Other:
        return CalculationMethod.other.getParameters();
      // default:
      //   return await getCalculationParametersByCountry(location);
    }
  }

  Future<String?> getCalculationParametersByCountry(String countryName) async {
    for (final c in countries) {
      final countryDataAsJson = jsonDecode(c);
      if (countryDataAsJson['country'] == countryName) {
        return countryDataAsJson['params'];
      }
    }
    return null;
  }

  Future<String?> getCalculationParametersFromJson(String countryName) async {
    final jsonString = await rootBundle.loadString('assets/json/madhab.json');
    final jsonData = jsonDecode(jsonString);
    final countryData =
        List<Map<String, dynamic>>.from(jsonData).firstWhereOrNull(
      (item) => item['country'] == countryName,
    );

    if (countryData == null) return null; // Handle missing country data

    // Create and return CalculationParameters object
    return countryData['params'];
  }

  Future<List<String>> getCountryList() async {
    final jsonString = await rootBundle.loadString('assets/json/madhab.json');
    final jsonData = jsonDecode(jsonString) as List<dynamic>; // Decode as List

    // List<String> countries = [];
    for (var item in jsonData) {
      // Assuming each item is a map with a "country" key
      countries.add(item['country'] as String);
    }
    return countries;
  }

  // TODO: upcoming feature
  // Future<List<PrayerDay>> generatePrayerCalendarForHijriMonth() async {
  //   List<PrayerDay> calendar = [];
  //   // Calculate the start of the Hijri month
  //   HijriCalendar hijriDate = HijriCalendar()
  //     ..hYear = hijriDateNow.hYear
  //     ..hMonth = hijriDateNow.hMonth
  //     ..hDay = 1; // Start from the first day of the month
  //
  //   // Convert the start of the Hijri month to Gregorian
  //   DateTime startDate = hijriDate.hijriToGregorian(
  //       hijriDateNow.hYear, hijriDateNow.hMonth, hijriDateNow.hDay);
  //
  //   // Determine the number of days in the Hijri month
  //   int monthLength = hijriDateNow.lengthOfMonth;
  //
  //   for (int i = 0; i < monthLength; i++) {
  //     // Increment the day starting from the first day of the Hijri month
  //     DateTime date = startDate.add(Duration(days: i));
  //
  //     // Calculate prayer times for the Gregorian date
  //     var prayerTimesForDay = await getPrayerTimesForDay(date);
  //
  //     // Re-calculate the Hijri date for each day (since the month can vary in length)
  //     HijriCalendar recalculatedHijriDate = HijriCalendar.fromDate(date);
  //
  //     // Create a new entry for the calendar
  //     PrayerDay prayerDay = PrayerDay(
  //       date: date,
  //       hijriDate: recalculatedHijriDate,
  //       fajr: prayerTimesForDay.fajr,
  //       dhuhr: prayerTimesForDay.dhuhr,
  //       asr: prayerTimesForDay.asr,
  //       maghrib: prayerTimesForDay.maghrib,
  //       isha: prayerTimesForDay.isha,
  //     );
  //     calendar.add(prayerDay);
  //   }
  //   return calendar;
  // }
  //
  // Future<void> goToPrayerTimesCalendarForMonth() async {
  //   try {
  //     List<PrayerDay> prayerDays =
  //         await adhanCtrl.generatePrayerCalendarForHijriMonth();
  //     Get.to(() => PrayerTimesCalendar(prayerDays: prayerDays));
  //   } catch (e) {
  //     print(e); // or use a more sophisticated error handling approach
  //   }
  // }

  void updateProgress() {
    var now = DateTime.now();
    var totalMinutes = 24 * 60;
    var currentMinutes = now.hour * 60 + now.minute;
    timeProgress.value = (currentMinutes / totalMinutes) * 100;
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  void shafiOnTap() {
    adhanCtrl.isHanafi.value = true;
    initializeAdhanVariables();
    sharedCtrl.setBool(SHAFI, adhanCtrl.isHanafi.value);
  }

  void hanafiOnTap() {
    adhanCtrl.isHanafi.value = false;
    initializeAdhanVariables();
    sharedCtrl.setBool(SHAFI, adhanCtrl.isHanafi.value);
  }

  Future<void> removeOnTap(int index) async {
    print("Before remove: ${adjustments[index].value}");
    adjustments[index].value -= 1;
    sharedCtrl.setInt(
        prayerNameList[index]['sharedAdjustment'], adjustments[index].value);
    print("After remove: ${adjustments[index].value}");
    await initTimes();
    update();
  }

  Future<void> addOnTap(int index) async {
    print("Before add: ${adjustments[index].value}");
    adjustments[index].value += 1;
    sharedCtrl.setInt(
        prayerNameList[index]['sharedAdjustment'], adjustments[index].value);
    print("After add: ${adjustments[index].value}");
    await initTimes();
    update();
  }

  void switchAutoCalculation(bool value) {
    autoCalculationMethod.value = !autoCalculationMethod.value;
    initializeAdhanVariables();
    sharedCtrl.setBool(AUTO_CALCULATION, value);
  }

  List<Map<String, dynamic>> _prayerNameList = [];

  List<Map<String, dynamic>> get prayerNameList => _generatePrayerNameList();

  set updatePrayerNameList(List<Map<String, dynamic>> newList) {
    _prayerNameList = newList;
    update();
  }

  List<Map<String, dynamic>> _generatePrayerNameList() => [
        {
          'title': 'الفجر',
          'time': fajrTime.value,
          'hourTime': prayerTimes.fajr,
          'minuteTime': prayerTimes.fajr.minute,
          'sharedAlarm': 'ALARM_FAJR',
          'sharedAfter': 'AFTER_FAJR',
          'sharedAdjustment': 'ADJUSTMENT_FAJR',
        },
        {
          'title': 'الظهر',
          'time': dhuhrTime.value,
          'hourTime': prayerTimes.dhuhr,
          'minuteTime': prayerTimes.dhuhr.minute,
          'sharedAlarm': 'ALARM_DHUHR',
          'sharedAfter': 'AFTER_DHUHR',
          'sharedAdjustment': 'ADJUSTMENT_DHUHR',
        },
        {
          'title': 'العصر',
          'time': asrTime.value,
          'hourTime': prayerTimes.asr,
          'minuteTime': prayerTimes.asr.minute,
          'sharedAlarm': 'ALARM_ASR',
          'sharedAfter': 'AFTER_ASR',
          'sharedAdjustment': 'ADJUSTMENT_ASR',
        },
        {
          'title': 'المغرب',
          'time': maghribTime.value,
          'hourTime': prayerTimes.maghrib,
          'minuteTime': prayerTimes.maghrib.minute,
          'sharedAlarm': 'ALARM_MAGHRIB',
          'sharedAfter': 'AFTER_MAGHRIB',
          'sharedAdjustment': 'ADJUSTMENT_MAGHRIB',
        },
        {
          'title': 'العشاء',
          'time': ishaTime.value,
          'hourTime': prayerTimes.isha,
          'minuteTime': prayerTimes.isha.minute,
          'sharedAlarm': 'ALARM_ISHA',
          'sharedAfter': 'AFTER_ISHA',
          'sharedAdjustment': 'ADJUSTMENT_ISHA',
        },
        {
          'title': 'منتصف الليل',
          'time': lastThirdTime.value,
          'hourTime': prayerTimes.isha,
          'minuteTime': prayerTimes.isha.minute,
          'sharedAlarm': 'ALARM_MIDNIGHT',
          'sharedAfter': 'AFTER_MIDNIGHT',
          'sharedAdjustment': 'ADJUSTMENT_MIDNIGHT',
        },
        {
          'title': 'الثلث الأخير',
          'time': midnightTime.value,
          'hourTime': prayerTimes.isha,
          'minuteTime': prayerTimes.isha.minute,
          'sharedAlarm': 'ALARM_LAST_THIRD',
          'sharedAfter': 'AFTER_LAST_THIRD',
          'sharedAdjustment': 'ADJUSTMENT_THIRD',
        },
      ];
}
