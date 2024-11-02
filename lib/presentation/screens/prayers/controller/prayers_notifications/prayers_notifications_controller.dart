part of '../../prayers.dart';

class PrayersNotificationsCtrl extends GetxController {
  static PrayersNotificationsCtrl get instance =>
      Get.isRegistered<PrayersNotificationsCtrl>()
          ? Get.find<PrayersNotificationsCtrl>()
          : Get.put(PrayersNotificationsCtrl());

  NotiState state = NotiState();

  @override
  Future<void> onInit() async {
    getSharedVariables;
    state.adhanData = loadAdhanData();
    log('downloadedAdhanData.value: ${state.downloadedAdhanData.length}');
    super.onInit();
  }

  void get getSharedVariables {
    state.selectedAdhanPath.value = state.box.read(ADHAN_PATH) ?? '';
    final downloadedSoundData = state.box.read('Downloaded_Adhan_Sounds_Data');
    log('Retrieved Data: $downloadedSoundData');

    if (null != downloadedSoundData) {
      state.downloadedAdhanData.value =
          (jsonDecode(downloadedSoundData) as List<dynamic>?)?.map((e) {
                return AdhanData.fromJson(e as Map<String, dynamic>);
              }).toList() ??
              [];
      log('Parsed Data Length: ${state.downloadedAdhanData.length}');
    }
  }

  Future<List<AdhanData>> loadAdhanData() async {
    final jsonString =
        await rootBundle.loadString('assets/json/adhanSounds.json');
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((data) => AdhanData.fromJson(data)).toList();
  }

  Future<void> adhanDownload(AdhanData adhanData) async {
    if (state.isDownloading.value) return;
    state.downloadIndex.value = adhanData.index;
    state.isDownloading.toggle();
    state.progress.value = 0;
    await AudioDownloader()
        .downloadAndUnzipAdhan(adhanData, onReceiveProgress: onReceiveProgress)
        .then((d) {
      state.downloadedAdhanData.add(d);
      final downloadedAdanSoundsAsMap =
          jsonEncode(state.downloadedAdhanData.map((e) => e.toJson()).toList());
      state.box
          .write('Downloaded_Adhan_Sounds_Data', downloadedAdanSoundsAsMap);
      log('Saved Data: $downloadedAdanSoundsAsMap');
      if (state.downloadedAdhanData.length == 1) {
        selectAdhanOnTap(0);
      }
    });

    state.isDownloading.toggle();
  }
}
