part of '../../prayers.dart';

class AdhanController extends GetxController {
  static AdhanController get instance => Get.isRegistered<AdhanController>()
      ? Get.find<AdhanController>()
      : Get.put<AdhanController>(AdhanController());

  AdhanState state = AdhanState();

  @override
  Future<void> onInit() async {
    super.onInit();
    getShared;
    initializeAdhan();
  }

  @override
  void onClose() {
    state.timer?.cancel();
    super.onClose();
  }

  /// -------- [Methods] ----------

  fetchCountryList() {
    state.countryListFuture = getCountryList();
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

  Future<void> initTimes() async {
    log("====================");
    log("Updating times...");
    log("====================");
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
    log("Times updated, calling update...");
    // update();
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
    state.prayerTimes = state.prayerTimesNow;
    // update();
    return await initTimes();
  }

  Future<void> initializeAdhan() async {
    // if (state.generalCtrl.state.activeLocation.value) {
    await state.generalCtrl.initLocation().then((value) async {
      geo.setLocaleIdentifier(Get.locale!.languageCode);
      await initializeAdhanVariables();
      fetchCountryList();
      getCountryList().then((list) => state.countries = list);
      updateProgress();
      state.timer = Timer.periodic(
          const Duration(minutes: 1), (Timer t) => updateProgress());
    });
    // update();
    // await PrayersWidgetConfig.initialize();
    // PrayersWidgetConfig().updatePrayersDate();
    // }
    // await HijriWidgetConfig.initialize();
    // HijriWidgetConfig().updateHijriDate();
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

  List<Map<String, dynamic>> _prayerNameList = [];

  List<Map<String, dynamic>> get prayerNameList =>
      generatePrayerNameList(state);

  set updatePrayerNameList(List<Map<String, dynamic>> newList) {
    _prayerNameList = newList;
    update();
  }
}
