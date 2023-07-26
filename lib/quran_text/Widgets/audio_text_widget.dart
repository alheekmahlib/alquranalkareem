import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:alquranalkareem/quran_page/cubit/audio/cubit.dart';
import 'package:alquranalkareem/shared/widgets/widgets.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/widgets/seek_bar.dart';
import '../cubit/quran_text_cubit.dart';
import '../text_page_view.dart';

class AudioTextWidget extends StatefulWidget {
  AudioTextWidget({Key? key}) : super(key: key);

  @override
  State<AudioTextWidget> createState() => _AudioTextWidgetState();
}

class _AudioTextWidgetState extends State<AudioTextWidget>
    with WidgetsBindingObserver {
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlay = false;
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
    // final AudioContext audioContext = const AudioContext(
    //   iOS: AudioContextIOS(
    //     category: AVAudioSessionCategory.ambient,
    //     options: [
    //       AVAudioSessionOptions.defaultToSpeaker,
    //       AVAudioSessionOptions.mixWithOthers,
    //     ],
    //   ),
    //   android: AudioContextAndroid(
    //     isSpeakerphoneOn: true,
    //     stayAwake: true,
    //     contentType: AndroidContentType.sonification,
    //     usageType: AndroidUsageType.assistanceSonification,
    //     audioFocus: AndroidAudioFocus.gain,
    //   ),
    // );
    // AudioPlayer.global.setAudioContext(audioContext);
    // audioPlayer.onDurationChanged.listen((duration) {
    //   setState(() {
    //     _duration.value = duration.inSeconds.toDouble();
    //   });
    // });
    // audioPlayer.onPositionChanged.listen((position) {
    //   setState(() {
    //     _position.value = position.inSeconds.toDouble();
    //   });
    // });
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    initConnectivity();
    super.initState();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          audioPlayer.positionStream,
          audioPlayer.bufferedPositionStream,
          audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  // Future playFile(BuildContext context, String url, String fileName) async {
  //   var path;
  //   int result = 1;
  //   try {
  //     var dir = await getApplicationDocumentsDirectory();
  //     path = join(dir.path, fileName);
  //     var file = File(path);
  //     bool exists = await file.exists();
  //     if (!exists) {
  //       try {
  //         await Directory(dirname(path)).create(recursive: true);
  //       } catch (e) {
  //         print(e);
  //       }
  //       if (_connectionStatus == ConnectivityResult.none) {
  //         customErrorSnackBar(
  //             context, AppLocalizations.of(context)!.noInternet);
  //       } else if (_connectionStatus == ConnectivityResult.mobile) {
  //         await downloadFile(path, url, fileName);
  //         customMobileNoteSnackBar(
  //             context, AppLocalizations.of(context)!.mobileDataAyat);
  //       } else if (_connectionStatus == ConnectivityResult.wifi) {
  //         await downloadFile(path, url, fileName);
  //       }
  //     }
  //     await audioPlayer.setAudioSource(AudioSource.asset(path));
  //     audioPlayer.play();
  //     if (result == 1) {
  //       setState(() {
  //         isPlay = true;
  //       });
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  bool isProcessingNextAyah = false;

  Future playFile(BuildContext context, String url, String fileName) async {
    var path;
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
          customErrorSnackBar(
              context, AppLocalizations.of(context)!.noInternet);
        } else if (_connectionStatus == ConnectivityResult.mobile) {
          await downloadFile(path, url, fileName);
          customMobileNoteSnackBar(
              context, AppLocalizations.of(context)!.mobileDataAyat);
        } else if (_connectionStatus == ConnectivityResult.wifi) {
          await downloadFile(path, url, fileName);
        }
      }
      await audioPlayer.setAudioSource(AudioSource.asset(path));
      audioPlayer.playerStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed &&
            !isProcessingNextAyah) {
          isProcessingNextAyah = true;
          setState(() {
            isPlay = false;
          });
          playNextAyah(context);
          print('ProcessingState.completed');
        }
      });
      audioPlayer.play();
      setState(() {
        isPlay = true;
      });
    } catch (e) {
      print(e);
    }
  }

  void playNextAyah(BuildContext context) async {
    AudioCubit audioCubit = AudioCubit.get(context);
    QuranTextCubit textCubit = QuranTextCubit.get(context);

    // Increment Ayah number
    int currentAyah = int.parse(textCubit.ayahNum!) + 1;
    int currentSorah = int.parse(textCubit.sorahName!);

    String formatNumber(int number) {
      if (number < 10) {
        return '00$number';
      } else if (number < 100) {
        return '0$number';
      } else {
        return '$number';
      }
    }

    textCubit.sorahName = formatNumber(currentSorah);
    textCubit.ayahNum = formatNumber(currentAyah);

    String reader = audioCubit.readerValue!;
    String fileName =
        "$reader/${textCubit.sorahName!}${textCubit.ayahNum!}.mp3";
    String url = "https://www.everyayah.com/data/$fileName";
    print('nextURL $url');

    print('currentAyah $currentAyah');
    print('lastAyah $lastAyah');

    if (textCubit.value == 0) {
      textCubit.changeSelectedIndex(currentAyah - 1);
      await playFile(context, url, fileName);
    } else if (textCubit.value == 1) {
      if (currentAyah == lastAyah + 1) {
        audioPlayer.stop();
        setState(() {
          isPlay = false;
        });
      } else {
        textCubit.changeSelectedIndex(currentAyah - 1);
        // textCubit.isSelected + 1;
        textCubit.itemScrollController.scrollTo(
            index: currentAyah - 1,
            duration: const Duration(seconds: 1),
            curve: Curves.easeOut);

        // Call playAyah again to play the next ayah
        await playFile(context, url, fileName);
      }
    }

    // await playFile(context, url, fileName);

    isProcessingNextAyah = false;
  }

  playAyah(BuildContext context) async {
    if (isPlay) {
      audioPlayer.pause();
      setState(() {
        isPlay = false;
      });
    } else {
      if (audioPlayer.playerState.playing == false) {
        audioPlayer.play();
      } else {
        AudioCubit audioCubit = AudioCubit.get(context);
        QuranTextCubit textCubit = QuranTextCubit.get(context);

        int currentAyah = int.parse(textCubit.ayahNum!);
        int currentSorah = int.parse(textCubit.sorahName!);

        String formatNumber(int number) {
          if (number < 10) {
            return '00$number';
          } else if (number < 100) {
            return '0$number';
          } else {
            return '$number';
          }
        }

        textCubit.sorahName = formatNumber(currentSorah);
        textCubit.ayahNum = formatNumber(currentAyah);

        String reader = audioCubit.readerValue!;
        String fileName =
            "$reader/${textCubit.sorahName!}${textCubit.ayahNum!}.mp3";
        String url = "https://www.everyayah.com/data/$fileName";
        print('URL $url');
        playFile(context, url, fileName);
      }
      setState(() {
        isPlay = true;
      });
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
      await dio.download(
        url,
        path,
        onReceiveProgress: (rec, total) {
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

  void deactivate() {
    if (isPlay) {
      audioPlayer.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    audioPlayer.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      audioPlayer.stop();
    }
  }

  // playAyah(BuildContext context) async {
  //   AudioCubit audioCubit = AudioCubit.get(context);
  //   QuranTextCubit textCubit = QuranTextCubit.get(context);
  //
  //   // Update this part to handle verse number increment
  //   int currentAyah = int.parse(textCubit.ayahNum!);
  //   int currentSorah = int.parse(textCubit.sorahName!);
  //
  //   String formatNumber(int number) {
  //     if (number < 10) {
  //       return '00$number';
  //     } else if (number < 100) {
  //       return '0$number';
  //     } else {
  //       return '$number';
  //     }
  //   }
  //
  //   textCubit.sorahName = formatNumber(currentSorah);
  //   textCubit.ayahNum = formatNumber(currentAyah);
  //
  //   String reader = audioCubit.readerValue!;
  //   String fileName =
  //       "$reader/${textCubit.sorahName!}${textCubit.ayahNum!}.mp3";
  //   print(AudioCubit.get(context).readerValue);
  //   String url = "https://www.everyayah.com/data/$fileName";
  //
  //   // audioPlayer.onPlayerComplete.listen((event) {
  //   //   setState(() {
  //   //     isPlay = false;
  //   //   });
  //   //
  //   //   print('lastAyah $lastAyah');
  //   //   if (currentAyah == lastAyah) {
  //   //     audioPlayer.pause();
  //   //   } else {
  //   //     QuranTextCubit.get(context).changeSelectedIndex(currentAyah);
  //   //     // Increment the ayah number
  //   //     currentAyah++;
  //   //     textCubit.ayahNum = formatNumber(currentAyah);
  //   //
  //   //     QuranTextCubit.get(context).value == 1
  //   //         ? QuranTextCubit.get(context).itemScrollController.scrollTo(
  //   //             index: currentAyah - 1,
  //   //             duration: const Duration(seconds: 1),
  //   //             curve: Curves.easeOut)
  //   //         : null;
  //   //
  //   //     // Call playAyah again to play the next ayah
  //   //     playAyah(context);
  //   //   }
  //   // });
  //
  //   print("url $url");
  //   if (isPlay) {
  //     audioPlayer.pause();
  //     setState(() {
  //       isPlay = false;
  //     });
  //   } else {
  //     await playFile(context, url, fileName);
  //   }
  // }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }
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
                            borderRadius: 8,
                            shadowWidth: 1.5,
                            progressWidth: 2,
                            shadowColor: Colors.grey,
                            progressColor: downloading
                                ? Theme.of(context).canvasColor
                                : Colors.transparent,
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
                                      if (QuranTextCubit.get(context).ayahNum ==
                                          null) {
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
                      child: StreamBuilder<PositionData>(
                        stream: _positionDataStream,
                        builder: (context, snapshot) {
                          final positionData = snapshot.data;
                          return SeekBar(
                            duration: positionData?.duration ?? Duration.zero,
                            position: positionData?.position ?? Duration.zero,
                            bufferedPosition:
                                positionData?.bufferedPosition ?? Duration.zero,
                            onChangeEnd: audioPlayer.seek,
                          );
                        },
                      ),
                      // child: SliderTheme(
                      //   data: const SliderThemeData(
                      //       thumbShape:
                      //           RoundSliderThumbShape(enabledThumbRadius: 8)),
                      //   child: Slider(
                      //     activeColor: Theme.of(context).colorScheme.background,
                      //     inactiveColor: Theme.of(context).primaryColorDark,
                      //     min: 0,
                      //     max: _duration.value,
                      //     value: _position.value.clamp(0, _duration.value),
                      //     onChanged: (value) {
                      //       audioPlayer.seek(Duration(seconds: value.toInt()));
                      //     },
                      //   ),
                      // ),
                    ),
                    Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      child: IconButton(
                        icon: Icon(Icons.person_search_outlined,
                            size: 20, color: Theme.of(context).canvasColor),
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

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}
