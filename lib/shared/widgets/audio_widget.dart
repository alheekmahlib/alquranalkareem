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

  static _AudioWidgetState? of(BuildContext context) =>
      context.findAncestorStateOfType<_AudioWidgetState>();
}

class _AudioWidgetState extends State<AudioWidget>{
  Duration? duration = const Duration();
  Duration? position = const Duration();
  AudioPlayer audioPlayer = AudioPlayer();
  final ValueNotifier<double> _position = ValueNotifier(0);
  final ValueNotifier<double> _duration = ValueNotifier(0);
  AudioCache cashPlayer = AudioCache();
  bool isPlay = false;
  bool isPagePlay = false;
  StreamSubscription? durationSubscription;
  StreamSubscription? positionSubscription;
  bool downloading = false;
  String progressString = "0%";
  double progress = 0;
  double? sliderValue;




  @override
  void initState() {
    isPlay = false;
    isPagePlay = false;
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

  Future playPageFile(String url, String fileName) async {

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
          isPagePlay = true;
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
      isPagePlay = false;
      // currentPlay = null;
    });
    if (AudioCubit.get(context).sorahName != null) {
      playAyah(context);
    } else {
      playPage(context, QuranCubit.get(context).cuMPage);
    }
  }

  void deactivate() {
    // positionSubscription!.cancel();
    // durationSubscription!.cancel();
    if (isPlay) {
      audioPlayer.pause();
    }
    if (isPagePlay) {
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
      if (isPagePlay) {
        audioPlayer.pause();
        setState(() {
          isPagePlay = false;
        });
      }
    }
    //print('state = $state');
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

  playPage(BuildContext context, int pageNum) async {
    AudioCubit audioCubit = AudioCubit.get(context);
    QuranCubit cubit = QuranCubit.get(context);
    pageNum = cubit.cuMPage;
    String? sorahNumString;
    if (pageNum < 10) {
      sorahNumString = "00" + pageNum.toString();
    } else if (pageNum < 100) {
      sorahNumString = "0" + pageNum.toString();
    } else if (pageNum < 1000) {
      sorahNumString = pageNum.toString();
    }
    late int sorahNumInt;
    setState(() {
      sorahNumInt = pageNum;
    });

    String sorahNumWithLeadingZeroes = sorahNumString!;


    String reader = audioCubit.readerValue!;
    String fileName = "Abdul_Basit_Murattal_192kbps/PageMp3s/Page${sorahNumInt!}.mp3";
    print(AudioCubit.get(context).readerValue);
    String url = "https://everyayah.com/data/$fileName";
    audioPlayer.onPlayerComplete.listen((event) async {
      setState(() {
        isPagePlay = false;
        sorahNumInt++;

      });
      if (AudioCubit.get(context).sorahName == null) {
        QuranCubit.get(context).dPageController!.jumpToPage(QuranCubit.get(context).cuMPage++);
        // await playPageFile(url, fileName);
      }
    });
    print("url $url");
    if (isPagePlay) {
      audioPlayer.pause();
      setState(() {
        isPagePlay = false;
      });
    } else {
      await playPageFile(url, fileName);
    }
  }

  @override
  Widget build(BuildContext context) {
    QuranCubit cubit = QuranCubit.get(context);
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 120.0),
            child: Container(
              height: 100,
              width: 320,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(.94),
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
                                      },
                                    ),
                                  ),
                                ],
                              ),
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
                                        isPagePlay
                                            ? Icons.pause
                                            : Icons.text_snippet_outlined,
                                        size: 15,
                                      ),
                                      color: Theme.of(context).canvasColor,
                                      onPressed: () {
                                        print(progressString);
                                        playPage(context, QuranCubit.get(context).cuMPage);
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
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
