import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';

import '../../data/model/adhan_data.dart';

class NotiState {
  final box = GetStorage('AdhanSounds');

  RxString progressString = "0".obs;
  RxDouble progress = 0.0.obs;
  RxBool isDownloading = false.obs;
  RxInt downloadIndex = 0.obs;
  late var cancelToken = CancelToken();
  late Future<List<AdhanData>> adhanData;
  // Map<String,dynamic> downloaded
  RxList<AdhanData> downloadedAdhanData = RxList();
  RxString selectedAdhanPath = RxString('');
  String? notificationSoundType;
  final audioPlayer = AudioPlayer();
}
