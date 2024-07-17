import 'dart:async' show StreamSubscription;
import 'dart:io';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';

class AudioState {
  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayer textAudioPlayer = AudioPlayer();
  RxBool isPlay = false.obs;
  RxBool downloading = false.obs;
  RxBool onDownloading = false.obs;
  RxString progressString = '0'.obs;
  RxDouble progress = 0.0.obs;
  String? currentPlay;
  RxBool autoPlay = false.obs;
  double? sliderValue;
  String? readerValue;
  RxString readerName = 'عبد الباسط عبد الصمد'.obs;
  String? pageAyahNumber;
  List<ConnectivityResult> connectionStatus = [ConnectivityResult.none];
  final Connectivity connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;
  late Directory dir;
  late Uri cachedArtUri;
  late var cancelToken = CancelToken();
  final bool isDisposed = false; // to keep track of the controller lifecycle
  RxBool isProcessingNextAyah = false.obs;
  Duration? lastPosition;
  Duration? pageLastPosition;
  RxInt pageNumber = 0.obs;
  RxInt lastAyahInPage = 0.obs;
  RxInt lastAyahInTextPage = 0.obs;
  RxInt lastAyahInSurah = 0.obs;
  Color? backColor;
  RxInt selectedAyahNum = 1.obs;
  RxInt currentAyahUQInPage = 1.obs;
  RxInt currentSurahNumInPage = 1.obs;
  bool goingToNewSurah = false;
  RxBool selected = false.obs;
  RxInt readerIndex = 0.obs;
  RxBool isStartPlaying = false.obs;

  /// wether the app should play next ayahs or not..
  bool playSingleAyahOnly = false;

  /// to use it in future.. for now the app is playing all ayahs until user stop the player..
  bool stopWhenSurahEnds = false;

  /// used for download seek bar.
  /// [4444] is the initial state when there is no downloadings.
  RxInt tmpDownloadedAyahsCount = 0.obs;

  /// GetStorage Box [SharedPreferences]
  final box = GetStorage();
}
