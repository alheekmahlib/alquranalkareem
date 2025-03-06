import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sliding_box/flutter_sliding_box.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../core/widgets/seek_bar.dart';

class SurahAudioState {
  /// -------- [Variables] ----------
  ArabicNumbers arabicNumber = ArabicNumbers();

  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayer downAudioPlayer = AudioPlayer();
  // RxBool isDownloading = false.obs;
  RxBool onDownloading = false.obs;
  RxBool isPlaying = false.obs;
  RxString progressString = "0".obs;
  RxDouble progress = 0.0.obs;
  RxInt surahNum = 1.obs;
  var url;
  late var cancelToken = CancelToken();
  TextEditingController textController = TextEditingController();
  RxInt selectedSurah = 0.obs;
  late ItemScrollController surahListController = ItemScrollController();
  RxString surahReaderValue = "https://download.quranicaudio.com/quran/".obs;
  RxString surahReaderNameValue = "abdul_basit_murattal/".obs;
  final bool isDisposed = false;
  List<AudioSource>? surahsPlayList;
  List<Map<int, AudioSource>> downloadSurahsPlayList = [];
  double? lastTime;
  RxInt lastPosition = 0.obs;
  Rx<PositionData>? positionData;
  var activeButton = RxString('');
  final BoxController boxController = BoxController();
  final TextEditingController textEditingController = TextEditingController();
  RxInt surahReaderIndex = 1.obs;
  final Rx<Map<int, bool>> surahDownloadStatus = Rx<Map<int, bool>>({});
  RxInt seekNextSeconds = 5.obs;
  final box = GetStorage();
  RxInt fileSize = 0.obs;
  RxInt downloadProgress = 0.obs;
  RxBool audioServiceInitialized = false.obs;
}
