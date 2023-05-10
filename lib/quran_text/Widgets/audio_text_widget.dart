import 'dart:async';
import 'dart:io';
import 'package:alquranalkareem/quran_page/cubit/audio/cubit.dart';
import 'package:alquranalkareem/shared/widgets/widgets.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';
import '../../l10n/app_localizations.dart';
import '../cubit/quran_text_cubit.dart';
import 'dart:developer' as developer;

import '../text_page_view.dart';


class AudioTextWidget extends StatefulWidget {
  AudioTextWidget({Key? key}) : super(key: key);

  @override
  State<AudioTextWidget> createState() => _AudioTextWidgetState();
}

class _AudioTextWidgetState extends State<AudioTextWidget>{
  Duration? duration = const Duration();
  Duration? position = const Duration();
  AudioPlayer audioPlayer = AudioPlayer();
  final ValueNotifier<double> _position = ValueNotifier(0);
  final ValueNotifier<double> _duration = ValueNotifier(0);
  AudioCache cashPlayer = AudioCache();
  bool isPlay = false;
  StreamSubscription? durationSubscription;
  StreamSubscription? positionSubscription;
  bool downloading = false;
  String progressString = "0";
  double progress = 0;
  String? currentPlay;
  bool autoPlay = false;
  double? sliderValue;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;




  @override
  void initState() {
    isPlay = false;
    sliderValue = 0;
    final AudioContext audioContext = const AudioContext(
      iOS: AudioContextIOS(
        // defaultToSpeaker: true,
        category: AVAudioSessionCategory.ambient,
        options: [
          AVAudioSessionOptions.defaultToSpeaker,
          AVAudioSessionOptions.mixWithOthers,
        ],
      ),
      android: AudioContextAndroid(
        isSpeakerphoneOn: true,
        stayAwake: true,
        contentType: AndroidContentType.sonification,
        usageType: AndroidUsageType.assistanceSonification,
        audioFocus: AndroidAudioFocus.gain,
      ),
    );
    AudioPlayer.global.setGlobalAudioContext(audioContext);
    audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration.value = duration.inSeconds.toDouble();
      });
    });
    audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position.value = position.inSeconds.toDouble();
      });
    });
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    initConnectivity();
    super.initState();
  }


  Future playFile(BuildContext context, String url, String fileName) async {

    var path;
    int result = 1;
    try {
      var dir = await getApplicationDocumentsDirectory();
      path = join(dir.path, fileName);
      var file = File(path);
      bool exists = await file.exists();
      if (!exists) {
        try {
          await Directory(dirname(path)).create(recursive: true);
        } catch (e) {
          print(e);
        }
        if (_connectionStatus == ConnectivityResult.none) {
          customErrorSnackBar(context,
              AppLocalizations.of(context)!.noInternet);
          } else if (_connectionStatus == ConnectivityResult.mobile) {
          await downloadFile(path, url, fileName);
          customMobileNoteSnackBar(context,
                AppLocalizations.of(context)!.mobileDataAyat);
        } else if (_connectionStatus == ConnectivityResult.wifi) {
          await downloadFile(path, url, fileName);
        }
      }
      await audioPlayer.play(DeviceFileSource(path));

      if (result == 1) {
        setState(() {
          isPlay = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future downloadFile(String path, String url, String fileName) async {
    Dio dio = Dio();
    try {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        print(e);
      }
      setState(() {
        downloading = true;
        progressString = "0";
        progress = 0;
      });
      await dio.download(url, path, onReceiveProgress: (rec, total) {

        // print("Rec: $rec , Total: $total");
        setState(() {
          progressString = ((rec / total) * 100).toStringAsFixed(0);
          progress = (rec / total).toDouble();
        });
        print(progressString);
      },
      );
    } catch (e) {
      print(e);
    }
    setState(() {
      downloading = false;
      progressString = "100";
    });
    print("Download completed");
  }

  // replay(BuildContext context) {
  //   Navigator.pop(context);
  //   setState(() {
  //     isPlay = false;
  //     currentPlay = null;
  //   });
  //   if (AudioCubit.get(context).sorahName != null) {
  //     playAyah(context);
  //   } else {
  //     playPage(context, DPages.currentPage2.toString());
  //   }
  // }

  void deactivate() {
    if (isPlay) {
      audioPlayer.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if (isPlay) {
        audioPlayer.pause();
        setState(() {
          isPlay = false;
        });
      }
    }
  }

  // playPage(BuildContext context, String page) async {
  //   SharedPreferences prefService = await SharedPreferences.getInstance();
  //   if (isPlay) {
  //     audioPlayer.pause();
  //     setState(() {
  //       isPlay = false;
  //     });
  //   } else {
  //     int? result;
  //     if (currentPlay == page) {
  //       await audioPlayer.resume();
  //       if (result == 1) {
  //         setState(() {
  //           isPlay = true;
  //         });
  //       }
  //     } else {
  //       currentPlay = page;
  //       String fileName = page;
  //       if (page.length == 1) {
  //         fileName = "00$fileName";
  //       } else if (page.length == 2) {
  //         fileName = "0$fileName";
  //       }
  //       fileName =
  //       "${prefService.getString('audio_player_sound')}/PageMp3s/Page$fileName.mp3";
  //       String url = "http://everyayah.com/data/$fileName";
  //       await playFile(context, url, fileName);
  //     }
  //   }
  //   setState(() {
  //     currentPlay = page;
  //   });
  //   audioPlayer.onPlayerComplete.listen((event) {
  //     audioPlayer.pause();
  //     setState(() {
  //       isPlay = false;
  //       currentPlay = null;
  //       position = null;
  //       duration = null;
  //       autoPlay = true;
  //     });
  //     if (AudioCubit.get(context).sorahName == null) {
  //       QuranCubit.get(context).dPageController!.jumpToPage(MPages.currentPage2 ++);
  //     }
  //   });
  // }

  playAyah(BuildContext context) async {
    AudioCubit audioCubit = AudioCubit.get(context);
    QuranTextCubit bookmarksCubit = QuranTextCubit.get(context);

    // Update this part to handle verse number increment
    int currentAyah = int.parse(bookmarksCubit.ayahNum!);
    int currentSorah = int.parse(bookmarksCubit.sorahName!);

    String formatNumber(int number) {
      if (number < 10) {
        return '00$number';
      } else if (number < 100) {
        return '0$number';
      } else {
        return '$number';
      }
    }

    bookmarksCubit.sorahName = formatNumber(currentSorah);
    bookmarksCubit.ayahNum = formatNumber(currentAyah);

    String reader = audioCubit.readerValue!;
    String fileName = "$reader/${bookmarksCubit.sorahName!}${bookmarksCubit.ayahNum!}.mp3";
    print(AudioCubit.get(context).readerValue);
    String url = "https://www.everyayah.com/data/$fileName";

    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlay = false;
      });

      print('lastAyah $lastAyah');
      if (currentAyah == lastAyah) {
        audioPlayer.pause();
      } else {
        QuranTextCubit.get(context).changeSelectedIndex(currentAyah);
        // Increment the ayah number
        currentAyah++;
        bookmarksCubit.ayahNum = formatNumber(currentAyah);

        QuranTextCubit.get(context).value == 1
            ? QuranTextCubit.get(context).itemScrollController.scrollTo(
            index: currentAyah - 1,
            duration: const Duration(seconds: 1),
            curve: Curves.easeOut
        )
            : null;


        // Call playAyah again to play the next ayah
        playAyah(context);
      }


    });

    print("url $url");
    if (isPlay) {
      audioPlayer.pause();
      setState(() {
        isPlay = false;
      });
    } else {
      await playFile(context, url, fileName);
    }
  }

  void playerStop() {
    audioPlayer.stop();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  int? pNum;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: Container(
          height: 60,
          width: 280,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(.94),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: SquarePercentIndicator(
                            width: 35,
                            height: 35,
                            startAngle: StartAngle.topRight,
                            // reverse: true,
                            borderRadius: 8,
                            shadowWidth: 1.5,
                            progressWidth: 2,
                            shadowColor: Colors.grey,
                            progressColor: downloading ? Theme.of(context).canvasColor : Colors.transparent,
                            progress: progress,
                            child: downloading
                                ? Container(
                              alignment: Alignment.center,
                              child: Text(
                                progressString,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'kufi',
                                    color: Theme.of(context).canvasColor),
                              ),
                            )
                                : IconButton(
                              icon: Icon(
                                isPlay ? Icons.pause : Icons.play_arrow,
                                size: 20,
                              ),
                              color: Theme.of(context).canvasColor,
                              onPressed: () {
                                print(progressString);
                                if (QuranTextCubit.get(context).ayahNum == null) {
                                  customErrorSnackBar(
                                      context,
                                      AppLocalizations.of(context)!
                                          .choiceAyah);
                                } else {
                                  playAyah(context);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 50,
                      alignment: Alignment.center,
                      width: 170,
                      child: SliderTheme(
                        data: const SliderThemeData(
                            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8)),
                        child: Slider(
                          activeColor: Theme.of(context).colorScheme.background,
                          inactiveColor: Theme.of(context).primaryColorDark,
                          min: 0,
                          max: _duration.value,
                          value: _position.value.clamp(0, _duration.value),
                          onChanged: (value)  {
                            audioPlayer.seek(Duration(seconds: value.toInt()));
                          },
                        ),
                      ),
                    ),
                    Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          color:
                          Theme.of(context).colorScheme.surface,
                          borderRadius: const BorderRadius.all(
                              Radius.circular(8))),
                      child: IconButton(
                        icon: Icon(Icons.person_search_outlined,
                            size: 20,
                            color: Theme.of(context).canvasColor),
                        onPressed: () => readerDropDown(context),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
