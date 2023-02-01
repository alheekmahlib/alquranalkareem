import 'dart:async';
import 'dart:io';
import 'package:alquranalkareem/quran_page/cubit/audio/cubit.dart';
import 'package:alquranalkareem/cubit/cubit.dart';
import 'package:alquranalkareem/shared/widgets/widgets.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';
import '../../quran_page/screens/quran_page.dart';
import '../cubit/quran_text_cubit.dart';


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
  String progressString = "0%";
  double progress = 0;
  String? currentPlay;
  bool autoPlay = false;
  double? sliderValue;




  @override
  void initState() {
    isPlay = false;
    sliderValue = 0;
    final AudioContext audioContext = AudioContext(
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
    super.initState();
  }

  Future playFile(String url, String fileName) async {

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
        await downloadFile(path, url, fileName);
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
        progressString = "0%";
        progress = 0;
      });
      await dio.download(url, path, onReceiveProgress: (rec, total) {
        // print("Rec: $rec , Total: $total");
        setState(() {
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
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
      progressString = "100%";
    });
    print("Download completed");
  }

  replay(BuildContext context) {
    Navigator.pop(context);
    setState(() {
      isPlay = false;
      currentPlay = null;
    });
    if (AudioCubit.get(context).sorahName != null) {
      playAyah(context);
    } else {
      playPage(context, DPages.currentPage2.toString());
    }
  }

  void deactivate() {
    if (isPlay) {
      audioPlayer.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
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

  playPage(BuildContext context, String page) async {
    SharedPreferences prefService = await SharedPreferences.getInstance();
    if (isPlay) {
      audioPlayer.pause();
      setState(() {
        isPlay = false;
      });
    } else {
      int? result;
      if (currentPlay == page) {
        await audioPlayer.resume();
        if (result == 1) {
          setState(() {
            isPlay = true;
          });
        }
      } else {
        currentPlay = page;
        String fileName = page;
        if (page.length == 1) {
          fileName = "00$fileName";
        } else if (page.length == 2) {
          fileName = "0$fileName";
        }
        fileName =
        "${prefService.getString('audio_player_sound')}/PageMp3s/Page$fileName.mp3";
        String url = "http://everyayah.com/data/$fileName";
        await playFile(url, fileName);
      }
    }
    setState(() {
      currentPlay = page;
    });
    audioPlayer.onPlayerComplete.listen((event) {
      audioPlayer.pause();
      setState(() {
        isPlay = false;
        currentPlay = null;
        position = null;
        duration = null;
        autoPlay = true;
      });
      if (AudioCubit.get(context).sorahName == null) {
        QuranCubit.get(context).dPageController!.jumpToPage(MPages.currentPage2 ++);
      }
    });
  }

  playAyah(BuildContext context) async {
    AudioCubit audioCubit = AudioCubit.get(context);
    QuranTextCubit bookmarksCubit = QuranTextCubit.get(context);
    if (bookmarksCubit.sorahName!.length == 1) {
      bookmarksCubit.sorahName = "00${bookmarksCubit.sorahName!}";
    } else if (bookmarksCubit.sorahName!.length == 2) {
      bookmarksCubit.sorahName = "0${bookmarksCubit.sorahName!}";
    }
    if (bookmarksCubit.ayahNum!.length == 1) {
      bookmarksCubit.ayahNum = "00${bookmarksCubit.ayahNum!}";
    } else if (bookmarksCubit.ayahNum!.length == 2) {
      bookmarksCubit.ayahNum = "0${bookmarksCubit.ayahNum!}";
    } else if (bookmarksCubit.ayahNum!.length == 3) {
      bookmarksCubit.ayahNum = "${bookmarksCubit.ayahNum!}";
    }


    String reader = audioCubit.readerValue!;
    String fileName = "$reader/${bookmarksCubit.sorahName!}${bookmarksCubit.ayahNum!}.mp3";
    print(AudioCubit.get(context).readerValue);
    String url = "https://www.everyayah.com/data/${fileName!}";
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlay = false;
      });
    });
    print("url $url");
    if (isPlay) {
      audioPlayer.pause();
      setState(() {
        isPlay = false;
      });
    } else {
      await playFile(url, fileName);
    }
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
                        Visibility(
                          visible: downloading,
                          child: Align(
                            alignment: Alignment.center,
                            child: SquarePercentIndicator(
                              width: 30,
                              height: 30,
                              startAngle: StartAngle.topRight,
                              // reverse: true,
                              borderRadius: 8,
                              shadowWidth: 1.5,
                              progressWidth: 2,
                              shadowColor: Colors.grey,
                              progressColor: Theme.of(context).canvasColor,
                              progress: progress,
                              // child: IconButton(
                              //   icon: Icon(
                              //     audioCubit.isPlay ? Icons.pause : Icons.play_arrow,
                              //     size: 15,
                              //     // color: Theme.of(context).primaryColorDark,
                              //   ),
                              //   color: Theme.of(context).canvasColor,
                              //   onPressed: () {
                              //     // if(isPlay){
                              //     //   setState(() {
                              //     //     isPlay = false;
                              //     //   });
                              //     //   stopAyah();
                              //     // } else {
                              //     //   setState(() {
                              //     //     isPlay = true;
                              //     //   });
                              //     //   playAyah();
                              //     // }
                              //     print(audioCubit.progressString);
                              //     if (audioCubit.sorahName != null) {
                              //       audioCubit.playAyah();
                              //     }
                              //     else {
                              //       audioCubit.playPage(context, "${DPages.currentPage2}");
                              //     }
                              //   },
                              // ),
                              // Text(
                              //   cubit.progressString,
                              //   style: TextStyle(color: Theme.of(context).hoverColor),
                              // ),
                            ),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color:
                              Theme.of(context).colorScheme.surface,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(8))),
                          child: IconButton(
                            icon: Icon(
                              isPlay
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 15,
                            ),
                            color: Theme.of(context).canvasColor,
                            onPressed: () {
                              print(progressString);
                              playAyah(context);
                              // playPage(context,
                              //     "${DPages.currentPage2}");
                              // if (AudioCubit.get(context).sorahName != null) {
                              //   playAyah(context);
                              // }
                              // else {
                              //   playPage(context,
                              //       "${DPages.currentPage2}");
                              // }
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 50,
                      alignment: Alignment.center,
                      width: 170,
                      child: SliderTheme(
                        data: SliderThemeData(
                            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8)),
                        child: Slider(
                          activeColor: Theme.of(context).colorScheme.background,
                          inactiveColor: Theme.of(context).primaryColorDark,
                          min: 0,
                          max: _duration.value,
                          value: _position.value,
                          onChanged: (value)  {
                            audioPlayer.seek(Duration(seconds: value.toInt()));
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: downloading,
                        child: Text(
                          progressString,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'kufi',
                              color: Theme.of(context).canvasColor),
                        ),),
                    readerDropDown(context),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
