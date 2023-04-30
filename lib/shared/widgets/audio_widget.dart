import 'dart:async';
import 'dart:io';
import 'package:alquranalkareem/quran_page/cubit/audio/cubit.dart';
import 'package:alquranalkareem/cubit/cubit.dart';
import 'package:alquranalkareem/shared/widgets/ayah_list.dart';
import 'package:alquranalkareem/shared/widgets/widgets.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';
import 'package:theme_provider/theme_provider.dart';
import 'dart:developer' as developer;
import '../../l10n/app_localizations.dart';

class AudioWidget extends StatefulWidget {
  AudioWidget({Key? key}) : super(key: key);

  @override
  State<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  Duration? duration = const Duration();
  Duration? position = const Duration();
  AudioPlayer audioPlayer = AudioPlayer();

  AudioCache cashPlayer = AudioCache();
  bool isPlay = false;
  StreamSubscription? durationSubscription;
  StreamSubscription? positionSubscription;
  bool downloading = false;
  String progressString = "0";
  double progress = 0;
<<<<<<< Updated upstream
  String? currentPlay;
  bool autoPlay = false;
  double? sliderValue;
  // String? readerValue;



=======
  bool downloadingPage = false;
  String progressPageString = "0";
  double progressPage = 0;
  double? sliderValue;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
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

=======
    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration.value = duration.inMilliseconds.toDouble();
      });
    });
    audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _position.value = position.inMilliseconds.toDouble();
      });
    });
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    initConnectivity();
    super.initState();
  }

  Future playFile(BuildContext context, String url, String fileName) async {
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
=======
  Future playPageFile(BuildContext context, String url, String fileName) async {
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
          if (exists) {
            await audioPlayer.play(DeviceFileSource(path));
          } else {
            customErrorSnackBar(
                context, AppLocalizations.of(context)!.noInternet);
          }
        } else if (_connectionStatus == ConnectivityResult.mobile) {
          await downloadPageFile(path, url, fileName);
          customMobileNoteSnackBar(
              context, AppLocalizations.of(context)!.mobileDataAyat);
        } else if (_connectionStatus == ConnectivityResult.wifi) {
          await downloadPageFile(path, url, fileName);
        }
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

>>>>>>> Stashed changes
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

  Future downloadPageFile(String path, String url, String fileName) async {
    Dio dio = Dio();
    try {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        print(e);
      }
      setState(() {
        downloadingPage = true;
        progressPageString = "0";
        progressPage = 0;
      });
      await dio.download(
        url,
        path,
        onReceiveProgress: (rec, total) {
          // print("Rec: $rec , Total: $total");
          setState(() {
            progressPageString = ((rec / total) * 100).toStringAsFixed(0);
            progressPage = (rec / total).toDouble();
          });
          print(progressPageString);
        },
      );
    } catch (e) {
      print(e);
    }
    setState(() {
      downloadingPage = false;
      progressPageString = "100";
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
    _connectivitySubscription.cancel();
    positionSubscription?.cancel();
    durationSubscription?.cancel();
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
    String fileName =
        "$reader/${audioCubit.sorahName!}${audioCubit.ayahNum!}.mp3";
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
      await playFile(context, url, fileName);
    }
  }

<<<<<<< Updated upstream
  int? pNum;
  @override
  Widget build(BuildContext context) {
    QuranCubit cubit = QuranCubit.get(context);
=======
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

    // String sorahNumWithLeadingZeroes = sorahNumString!;

    String reader = audioCubit.readerValue!;
    String fileName =
        "$reader/PageMp3s/Page${sorahNumString!}.mp3";
    print(AudioCubit.get(context).readerValue);
    String url = "https://everyayah.com/data/$fileName";
    audioPlayer.onPlayerComplete.listen((event) async {
      setState(() {
        isPagePlay = false;
        // sorahNumInt++;
      });

      // QuranCubit.get(context)
      //     .dPageController!
      //     .jumpToPage(QuranCubit.get(context).cuMPage++);
      if (QuranCubit.get(context).cuMPage == 604) {
        null;
      } else {
        QuranCubit.get(context)
            .dPageController!
            .jumpToPage(sorahNumInt++);
        // await playPageFile(context, url, fileName);
        playPage(context, sorahNumInt);
      }
    });
    print("url $url");
    if (isPagePlay) {
      audioPlayer.pause();
      setState(() {
        isPagePlay = false;
      });
    } else {
      await playPageFile(context, url, fileName);
    }
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

  @override
  Widget build(BuildContext context) {
    QuranCubit cubit = QuranCubit.get(context);
    AudioCubit audioCubit = AudioCubit.get(context);
>>>>>>> Stashed changes
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 120.0),
        child: Container(
          height: 100,
<<<<<<< Updated upstream
          width: 250,
          decoration: BoxDecoration(
            color: Theme.of(context).bottomAppBarColor.withOpacity(.94),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Column(
=======
          width: 320,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(.94),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
>>>>>>> Stashed changes
            children: [
              Expanded(
                  flex: 2,
                  child: Stack(
<<<<<<< Updated upstream
=======
                    alignment: Alignment.center,
>>>>>>> Stashed changes
                    children: [
                      Center(
                        child: Container(
                          height: 30,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
<<<<<<< Updated upstream
                              color: ThemeProvider.themeOf(context).id ==
                                  'dark'
                                  ? const Color(0xffcdba72).withOpacity(.4)
                                  : Theme.of(context)
                                  .dividerColor
                                  .withOpacity(.4),
=======
                              color: ThemeProvider.themeOf(context).id == 'dark'
                                  ? const Color(0xffcdba72).withOpacity(.4)
                                  : Theme.of(context)
                                      .dividerColor
                                      .withOpacity(.4),
>>>>>>> Stashed changes
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8),
                                topLeft: Radius.circular(8),
                              )),
                        ),
                      ),
                      // ayahList(context, DPages.currentPage2),
<<<<<<< Updated upstream
                      AyahList(
                        pageNum: cubit.cuMPage,
                      )
=======
                      (isPlay || isPagePlay)
                          ? StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                              return Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  width: 290,
                                  child: SliderTheme(
                                    data: SliderThemeData(
                                        thumbShape: RoundSliderThumbShape(
                                            enabledThumbRadius: 8)),
                                    child: Slider(
                                      activeColor:
                                          Theme.of(context).colorScheme.background,
                                      inactiveColor:
                                          Theme.of(context).primaryColorDark,
                                      min: 0,
                                      max: _duration.value,
                                      value: _position.value,
                                      onChanged: (value) async {
                                          await audioPlayer
                                              .seek(Duration(milliseconds: value.toInt()));
                                      },
                                    ),
                                  ),
                                );
                            }
                          )
                          : AyahList(
                              pageNum: cubit.cuMPage,
                            )
>>>>>>> Stashed changes
                    ],
                  )),
              Expanded(
                flex: 3,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
<<<<<<< Updated upstream
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
=======
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/svg/space_line.svg',
                            height: 50,
                            width:
                            MediaQuery.of(context).size.width / 1 / 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SquarePercentIndicator(
                                width: 35,
                                height: 35,
                                startAngle: StartAngle.topRight,
                                // reverse: true,
                                borderRadius: 8,
                                shadowWidth: 1.5,
                                progressWidth: 2,
                                shadowColor: Colors.grey,
                                progressColor:
                                downloading ? Theme.of(context).canvasColor : Colors.transparent,
                                progress: progress,
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                      color:
                                      Theme.of(context).colorScheme.surface,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8))),
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
                                      if (audioCubit.ayahNum == null) {
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
                              SquarePercentIndicator(
                                width: 35,
                                height: 35,
                                startAngle: StartAngle.topRight,
                                // reverse: true,
                                borderRadius: 8,
                                shadowWidth: 1.5,
                                progressWidth: 2,
                                shadowColor: Colors.grey,
                                progressColor:
                                downloadingPage ? Theme.of(context).canvasColor : Colors.transparent,
                                progress: progressPage,
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8))),
                                  child: downloadingPage
                                      ? Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      progressPageString,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'kufi',
                                          color: Theme.of(context).canvasColor),
                                    ),
                                  )
                                      : IconButton(
                                    icon: Icon(
                                      isPagePlay
                                          ? Icons.pause
                                          : Icons.text_snippet_outlined,
                                      size: 20,
                                    ),
                                    color: Theme.of(context).canvasColor,
                                    onPressed: () {
                                      print(progressPageString);
                                      if (_connectionStatus ==
                                          ConnectivityResult.none) {
                                        customErrorSnackBar(
                                            context,
                                            AppLocalizations.of(context)!
                                                .noInternet);
                                        // } else if (_connectionStatus == ConnectivityResult.mobile) {
                                        //   // playSorahOnline(context);
                                        //   customMobilSnackBar(context,
                                        //       AppLocalizations.of(context)!.noInternet);
                                      } else if (_connectionStatus ==
                                          ConnectivityResult.wifi ||
                                          _connectionStatus ==
                                              ConnectivityResult.mobile) {
                                        playPage(context,
                                            QuranCubit.get(context).cuMPage);
                                      }
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
>>>>>>> Stashed changes
                                ),
                              ),
                            ],
                          ),
<<<<<<< Updated upstream
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
=======
>>>>>>> Stashed changes
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
