import 'dart:async';

import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sliding_box/flutter_sliding_box.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/widgets/seek_bar.dart';

class SurahAudioState {
  /// -------- [Variables] ----------
  final ScrollController controller = ScrollController();
  RxInt position = RxInt(0);
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
  List<ConnectivityResult> connectionStatus = [ConnectivityResult.none];
  final Connectivity connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;
  late var cancelToken = CancelToken();
  TextEditingController textController = TextEditingController();
  RxInt selectedSurah = 0.obs;
  RxString sorahReaderValue = "https://download.quranicaudio.com/quran/".obs;
  RxString sorahReaderNameValue = "abdul_basit_murattal/".obs;
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
}
