import 'dart:async';
import 'dart:io';
import 'package:alquranalkareem/quran_page/cubit/audio/cubit.dart';
import 'package:alquranalkareem/cubit/cubit.dart';
import 'package:alquranalkareem/shared/widgets/ayah_list.dart';
import 'package:alquranalkareem/shared/widgets/widgets.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';
import 'package:theme_provider/theme_provider.dart';
import '../../quran_page/screens/quran_page.dart';


class AudioWidget extends StatefulWidget {
  AudioWidget({Key? key}) : super(key: key);

  @override
  State<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget>{
  Duration? duration = const Duration();
  Duration? position = const Duration();
  AudioPlayer audioPlayer = AudioPlayer();

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
  // String? readerValue;




  @override
  void initState() {
    isPlay = false;
    // currentPlay = null;
    sliderValue = 0;
    // initAudioPlayer();
    final AudioContext audioContext = AudioContext(
      iOS: AudioContextIOS(
        defaultToSpeaker: true,
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
    super.initState();
  }



  // Save & Load Reader Quran
  // saveQuranReader(String readerValue) async {
  //   SharedPreferences prefService = await SharedPreferences.getInstance();
  //   await prefService.setString('audio_player_sound', readerValue);
  // }
  // loadQuranReader(BuildContext context) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   AudioCubit.get(context).readerValue = prefs.getString('audio_player_sound') ?? "Abdul_Basit_Murattal_192kbps";
  //   print('Quran Reader ${prefs.getString('audio_player_sound')}');
  // }

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
    // positionSubscription!.cancel();
    // durationSubscription!.cancel();
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
    //print('state = $state');
  }

  // void initAudioPlayer() {
  //   positionSubscription = audioPlayer.onPositionChanged.listen(
  //           (Duration p) => setState(() => position = p));
  //   durationSubscription = audioPlayer.onDurationChanged.listen((Duration d) {
  //     if (duration == null) {
  //       //print("posiotn ${d.inMilliseconds}");
  //       setState(() => duration = d);
  //     }
  //   });
  //   // positionSubscription =
  //   //     audioPlayer.onPositionChanged.listen((p) {
  //   //       position = p;
  //   //       print("position ${p.inMilliseconds}");
  //   //     });
  //   // durationSubscription = audioPlayer.onDurationChanged.listen((Duration d) {
  //   //   if (duration == null) {
  //   //     print("duration ${d.inMilliseconds}");
  //   //     duration = d;
  //   //   }
  //   // });
  //   // positionSubscription =
  //   //     audioPlayer.onPlayerStateChanged
  //   //         .listen((p) {
  //   //       position = p as Duration;
  //   //       durationSubscription = audioPlayer.onDurationChanged.listen((Duration d) {
  //   //         if (duration == null) {
  //   //           //print("posiotn ${d.inMilliseconds}");
  //   //           duration = d;
  //   //         }
  //   //       });
  //   //     }
  //   //       //print("posiotn ${p.inMilliseconds}");
  //   //     );
  //
  // }

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
    if (audioCubit.sorahName!.length == 1) {
      audioCubit.sorahName = "00${audioCubit.sorahName!}";
    } else if (audioCubit.sorahName!.length == 2) {
      audioCubit.sorahName = "0${audioCubit.sorahName!}";
    }
    if (audioCubit.ayahNum!.length == 1) {
      audioCubit.ayahNum = "00${audioCubit.ayahNum!}";
    } else if (audioCubit.ayahNum!.length == 2) {
      audioCubit.ayahNum = "0${audioCubit.ayahNum!}";
    } else if (audioCubit.ayahNum!.length == 3) {
      audioCubit.ayahNum = "${audioCubit.ayahNum!}";
    }


    String reader = audioCubit.readerValue!;
    String fileName = "$reader/${audioCubit.sorahName!}${audioCubit.ayahNum!}.mp3";
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
    QuranCubit cubit = QuranCubit.get(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 120.0),
        child: Container(
          height: 100,
          width: 250,
          decoration: BoxDecoration(
            color: Theme.of(context).bottomAppBarColor.withOpacity(.94),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Column(
            children: [
              Expanded(
                  flex: 2,
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          height: 30,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: ThemeProvider.themeOf(context).id ==
                                  'dark'
                                  ? const Color(0xffcdba72).withOpacity(.4)
                                  : Theme.of(context)
                                  .dividerColor
                                  .withOpacity(.4),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8),
                                topLeft: Radius.circular(8),
                              )),
                        ),
                      ),
                      // ayahList(context, DPages.currentPage2),
                      AyahList(
                        pageNum: cubit.cuMPage,
                      )
                    ],
                  )),
              Expanded(
                flex: 3,
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
                                    Theme.of(context).bottomAppBarColor,
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
                          Visibility(
                            visible: downloading,
                              child: Text(
                                progressString,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'kufi',
                                    color: Theme.of(context).canvasColor),
                              ),),
                          // Directionality(
                          //   textDirection: TextDirection.rtl,
                          //   child: Container(
                          //     height: 50,
                          //     width: 180,
                          //     child: SliderTheme(
                          //       data: SliderThemeData(
                          //           thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8)),
                          //       child: Slider(
                          //         activeColor: Theme.of(context).canvasColor,
                          //         inactiveColor: Theme.of(context).primaryColorDark,
                          //         min: 0,
                          //         max: duration!.inMilliseconds.toDouble(),
                          //         value: position!.inMilliseconds.toDouble(),
                          //         onChanged: (value) async {
                          //           await audioPlayer.seek(Duration(milliseconds: value.toInt()));
                          //           setState(() {
                          //             sliderValue = value.toDouble();
                          //           });
                          //         },
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          readerDropDown(context),
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
