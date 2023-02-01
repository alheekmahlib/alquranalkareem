import 'dart:async';
import 'dart:io';

import 'package:alquranalkareem/cubit/cubit.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';
import 'package:theme_provider/theme_provider.dart';
import '../../quran_page/data/model/sorah.dart';
import '../../quran_page/data/repository/sorah_repository.dart';
import '../quran_page/cubit/audio/cubit.dart';
import '../shared/widgets/widgets.dart';



class AudioSorahList extends StatefulWidget {
  const AudioSorahList({super.key});

  @override
  _AudioSorahListState createState() => _AudioSorahListState();
}

class _AudioSorahListState extends State<AudioSorahList>
    with AutomaticKeepAliveClientMixin<AudioSorahList> {
  SorahRepository sorahRepository = SorahRepository();
  List<Sorah>? sorahList;
  final ScrollController controller = ScrollController();
  final ValueNotifier<double> _position = ValueNotifier(0);
  final ValueNotifier<double> _duration = ValueNotifier(0);
  ArabicNumbers arabicNumber = ArabicNumbers();
  String _currentTime = '0:00';
  String _totalDuration = '0:00';
  AudioPlayer audioPlayer = AudioPlayer();

  AudioCache cashPlayer = AudioCache();
  bool isPlayOnline = false;
  bool isPlay = false;
  StreamSubscription? durationSubscription;
  StreamSubscription? positionSubscription;
  bool downloading = false;
  String progressString = "0%";
  double progress = 0;
  String? currentPlay;
  bool autoPlay = false;
  double? sliderValue;
  int sorahNum = 1;
  String? selectedValue;




  @override
  void initState() {
    isPlay = false;
    // currentPlay = null;
    sliderValue = 0;
    // initAudioPlayer();

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
    getList();
    audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration.value = duration.inSeconds.toDouble();
        _totalDuration = duration.toString().split('.').first;
      });
    });
    audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position.value = position.inSeconds.toDouble();
        _currentTime = position.toString().split('.').first;
      });
    });

    super.initState();
  }

  playSorahOnline(BuildContext context) async {
    var path;
    int result = 1;
    late Source audioUrl;
    AudioCubit audioCubit = AudioCubit.get(context);
    String? sorahNumString;
    if (sorahNum < 10) {
      sorahNumString = "00" + sorahNum.toString();
    } else if (sorahNum < 100) {
      sorahNumString = "0" + sorahNum.toString();
    } else if (sorahNum < 1000) {
      sorahNumString = sorahNum.toString();
    }

// use sorahNum as an integer in your code
    int sorahNumInt = sorahNum;

// use sorahNumString as a string with leading zeroes
    String sorahNumWithLeadingZeroes = sorahNumString!;

    String reader = audioCubit.sorahReaderValue!;
    String readerN = audioCubit.sorahReaderNameValue!;
    String fileName = "$readerN$sorahNumWithLeadingZeroes.mp3";
    print('sorah reader: $reader');
    var url = "$reader${fileName}";
    audioUrl = UrlSource(url);
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlayOnline = false;
        isPlay = false;
      });
    });
    print("url $url");
    if (isPlayOnline) {
      audioPlayer.pause();
      setState(() {
        isPlayOnline = false;
      });
    } else {
      try {
        await audioPlayer.play(audioUrl);
        if (result == 1) {
          setState(() {
            isPlayOnline = true;
          });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  playSorah(BuildContext context) async {
    AudioCubit audioCubit = AudioCubit.get(context);
    String? sorahNumString;

    if (sorahNum < 10) {
      sorahNumString = "00" + sorahNum.toString();
    } else if (sorahNum < 100) {
      sorahNumString = "0" + sorahNum.toString();
    } else if (sorahNum < 1000) {
      sorahNumString = sorahNum.toString();
    }
    int sorahNumInt = sorahNum;
    String sorahNumWithLeadingZeroes = sorahNumString!;
    String reader = audioCubit.sorahReaderValue!;
    String readerN = audioCubit.sorahReaderNameValue!;
    String fileName = "$readerN$sorahNumWithLeadingZeroes.mp3";
    print('sorah reader: $reader');
    String url = "$reader${fileName}";
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
    if (sorahNum != null) {
      playSorah(context);
    } else {
      // playPage(context, DPages.currentPage2.toString());
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
    controller.dispose();
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

  getList() async {
    sorahRepository.all().then((values) {
      setState(() {
        sorahList = values;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Orientation orientation = MediaQuery.of(context).orientation;
    AudioCubit audioCubit = AudioCubit.get(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: SorahPlayScaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: (Platform.isMacOS || Platform.isWindows || Platform.isLinux)
            ? Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1 / 2,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: .1,
                      child: SvgPicture.asset('assets/svg/quran_au_ic.svg',
                        color: Theme.of(context).colorScheme.surface,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/svg/quran_au_ic.svg',
                      height: 100,
                      color: Theme.of(context).colorScheme.surface,
                      width: MediaQuery.of(context).size.width / 1 / 2,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1 / 2,
                child: Padding(
                  padding: orientation == Orientation.portrait
                      ? EdgeInsets.only(right: 16.0, left: 16.0, top: 250.0, bottom: 16.0)
                      : EdgeInsets.only(right: 16.0, left: 16.0, top: 100.0, bottom: 16.0),
                  child: sorahList != null
                      ? AnimationLimiter(
                          child: Scrollbar(
                            thumbVisibility: true,
                            // interactive: true,
                            controller: controller,
                            child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: sorahList!.length,
                                controller: controller,
                                itemBuilder: (_, index) {
                                  Sorah sorah = sorahList![index];
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 450),
                                    child: SlideAnimation(
                                      verticalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: GestureDetector(
                                              child: Container(
                                                  height: 65,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(8),
                                                    ),
                                                    color: (index % 2 == 0
                                                        ? Theme.of(context)
                                                        .colorScheme.background
                                                        : Theme.of(context)
                                                        .dividerColor
                                                        .withOpacity(.3)),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                    child: Row(
                                                      children: [
                                                        Stack(
                                                          alignment: Alignment.center,
                                                          children: [
                                                            SizedBox(
                                                                height: 40,
                                                                width: 40,
                                                                child: SvgPicture.asset(
                                                                  'assets/svg/sora_num.svg',
                                                                )),
                                                            Text(
                                                              "${arabicNumber.convert(sorah.id)}",
                                                              style: TextStyle(
                                                                  color: ThemeProvider.themeOf(
                                                                                  context)
                                                                              .id ==
                                                                          'dark'
                                                                      ? Theme.of(
                                                                              context)
                                                                          .canvasColor
                                                                      : Theme.of(
                                                                              context)
                                                                          .primaryColorLight,
                                                                  fontFamily: "kufi",
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight.bold),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(width: 100,),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                          children: [
                                                            SvgPicture.asset(
                                                              'assets/svg/surah_name/00${index + 1}.svg',
                                                              color: ThemeProvider
                                                                              .themeOf(
                                                                                  context)
                                                                          .id ==
                                                                      'dark'
                                                                  ? Theme.of(context)
                                                                      .canvasColor
                                                                  : Theme.of(context)
                                                                      .primaryColorDark,
                                                              width: 100,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets.only(
                                                                      right: 8.0),
                                                              child: Text(
                                                                sorah.nameEn,
                                                                style: TextStyle(
                                                                  fontFamily: "naskh",
                                                                  fontWeight:
                                                                      FontWeight.w600,
                                                                  fontSize: 10,
                                                                  color: ThemeProvider.themeOf(
                                                                                  context)
                                                                              .id ==
                                                                          'dark'
                                                                      ? Theme.of(
                                                                              context)
                                                                          .canvasColor
                                                                      : Theme.of(
                                                                              context)
                                                                          .primaryColorLight,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              onTap: () {
                                                setState(() {
                                                  sorahNum = index + 1;
                                                });
                                                switch (audioCubit
                                                    .controllerSorah
                                                    .status) {
                                                  case AnimationStatus
                                                      .completed:
                                                    audioCubit
                                                        .controllerSorah
                                                        .reverse();
                                                    break;
                                                  case AnimationStatus
                                                      .dismissed:
                                                    audioCubit
                                                        .controllerSorah
                                                        .forward();
                                                    break;
                                                  default:
                                                }
                                              },
                                            ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        )
                      : Center(
                          child: Lottie.asset('assets/lottie/loading.json',
                              width: 150, height: 150),
                        ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SlideTransition(
                  position: audioCubit.offset, child: Padding(
                padding: orientation == Orientation.portrait
                    ? const EdgeInsets.symmetric(horizontal: 16.0)
                    : const EdgeInsets.symmetric(horizontal: 64.0),
                child: Container(
                  height: orientation == Orientation.portrait
                      ? MediaQuery.of(context).size.height * 1 / 3 * .9
                      : MediaQuery.of(context).size.height * 1 / 3 * .6,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12.0),
                        topLeft: Radius.circular(12.0)),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.surface,
                      width: 1,
                    ),
                    color: Theme.of(context).colorScheme.background,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: orientation == Orientation.portrait
                        ? StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: orientation == Orientation.portrait ? 130 : 30,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Opacity(
                                    opacity: .1,
                                    child: SvgPicture.asset('assets/svg/surah_name/00$sorahNum.svg',
                                      color: Theme.of(context).colorScheme.surface,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    'assets/svg/surah_name/00$sorahNum.svg',
                                    height: 100,
                                    color: Theme.of(context).colorScheme.surface,
                                    width: MediaQuery.of(context).size.width / 1 / 2,
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      icon: Icon(Icons.close_outlined,
                                          color: ThemeProvider.themeOf(context).id == 'dark'
                                              ? Theme.of(context).canvasColor
                                              : Theme.of(context).primaryColorDark),
                                      onPressed: () => AudioCubit.get(context).controllerSorah.reverse(),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Visibility(
                                      visible: downloading,
                                      child: Text(
                                        progressString,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'kufi',
                                            color: Theme.of(context).colorScheme.surface),
                                      ),),
                                    GestureDetector(
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.background,
                                            borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(8),
                                              topLeft: Radius.circular(8),
                                            ),
                                            border: Border.all(
                                                width: 2,
                                                color: Theme.of(context).dividerColor)),
                                        child: Icon(
                                          Icons.skip_next,
                                          color: Theme.of(context).colorScheme.surface,
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          sorahNum--;
                                        });
                                        audioPlayer.stop();
                                        audioPlayer.play(UrlSource(sorahNum.toString()));
                                      },
                                    ),
                                    GestureDetector(
                                      child: Column(
                                        children: [
                                          Container(
                                              height: 50,
                                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                                              width: 50,
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context).colorScheme.background,
                                                  borderRadius: const BorderRadius.only(
                                                    topRight: Radius.circular(8),
                                                    topLeft: Radius.circular(8),
                                                  ),
                                                  border: Border.all(
                                                      width: 2,
                                                      color: Theme.of(context).dividerColor)),
                                              child: Icon(
                                                isPlayOnline
                                                    ? Icons.pause
                                                    : Icons.online_prediction_outlined,
                                                size: 24,
                                                color: Theme.of(context).colorScheme.surface,
                                              )
                                          ),
                                          Text('اونلاين',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'kufi',
                                                color: Theme.of(context).dividerColor
                                            ),
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        playSorahOnline(context);
                                      },
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          SquarePercentIndicator(
                                            width: 50,
                                            height: 50,
                                            borderRadius: 8,
                                            shadowWidth: 1.5,
                                            progressWidth: 4,
                                            shadowColor: Colors.grey,
                                            progressColor: ThemeProvider.themeOf(context)
                                                .id ==
                                                'dark'
                                                ? Colors.white
                                                : Theme.of(context).primaryColorLight,
                                            progress: progress,
                                            child: GestureDetector(
                                              child: Container(
                                                  height: 50,
                                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context).colorScheme.background,
                                                      borderRadius: const BorderRadius.only(
                                                        topRight: Radius.circular(8),
                                                        topLeft: Radius.circular(8),
                                                      ),
                                                      border: Border.all(
                                                          width: 2,
                                                          color: Theme.of(context).dividerColor)),
                                                  child: Icon(
                                                    isPlay
                                                        ? Icons.pause
                                                        : Icons.download_outlined,
                                                    size: 24,
                                                    color: Theme.of(context).colorScheme.surface,
                                                  )
                                              ),
                                              onTap: () {
                                                playSorah(context);
                                              },
                                            ),
                                          ),
                                          Text('تحميل',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'kufi',
                                                color: Theme.of(context).dividerColor
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.background,
                                            borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(8),
                                              topLeft: Radius.circular(8),
                                            ),
                                            border: Border.all(
                                                width: 2,
                                                color: Theme.of(context).dividerColor)),
                                        child: Icon(
                                          Icons.skip_previous,
                                          color: Theme.of(context).colorScheme.surface,
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          sorahNum++;
                                        });
                                        audioPlayer.stop();
                                        audioPlayer.play(UrlSource(sorahNum.toString()));
                                      },
                                    ),
                                    sorahReaderDropDown(context),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Center(
                                            child: Text(_currentTime,
                                              style: TextStyle(
                                                color: ThemeProvider.themeOf(
                                                    context)
                                                    .id ==
                                                    'dark'
                                                    ? Theme.of(
                                                    context)
                                                    .canvasColor
                                                    : Theme.of(
                                                    context)
                                                    .primaryColorLight,
                                              ),
                                        ))),
                                    Expanded(
                                      flex: 6,
                                      child: Container(
                                        height: 50,
                                        alignment: Alignment.center,
                                        width: MediaQuery.of(context).size.width,
                                        child: SliderTheme(
                                          data: SliderThemeData(
                                              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8)),
                                          child: Slider(
                                            activeColor: Theme.of(context).colorScheme.surface,
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
                                    ),
                                    Expanded(
                                        flex: 2,
                                        child: Center(child: Text(_totalDuration,
                                          style: TextStyle(
                                            color: ThemeProvider.themeOf(
                                                context)
                                                .id ==
                                                'dark'
                                                ? Theme.of(
                                                context)
                                                .canvasColor
                                                : Theme.of(
                                                context)
                                                .primaryColorLight,
                                          ),))),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    )
                        : StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Opacity(
                              opacity: .1,
                              child: SvgPicture.asset('assets/svg/surah_name/00$sorahNum.svg',
                                color: Theme.of(context).colorScheme.surface,
                                width: MediaQuery.of(context).size.width,
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: Icon(Icons.close_outlined,
                                    color: ThemeProvider.themeOf(context).id == 'dark'
                                        ? Theme.of(context).canvasColor
                                        : Theme.of(context).primaryColorDark),
                                onPressed: () => AudioCubit.get(context).controllerSorah.reverse(),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 23.0),
                                child: SvgPicture.asset(
                                  'assets/svg/surah_name/00$sorahNum.svg',
                                  height: 70,
                                  color: Theme.of(context).colorScheme.surface,
                                  width: MediaQuery.of(context).size.width / 1 / 2,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width / 1 / 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Visibility(
                                          visible: downloading,
                                          child: Text(
                                            progressString,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'kufi',
                                                color: Theme.of(context).colorScheme.surface),
                                          ),),
                                        GestureDetector(
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.background,
                                                borderRadius: const BorderRadius.only(
                                                  topRight: Radius.circular(8),
                                                  topLeft: Radius.circular(8),
                                                ),
                                                border: Border.all(
                                                    width: 2,
                                                    color: Theme.of(context).dividerColor)),
                                            child: Icon(
                                              Icons.skip_next,
                                              color: Theme.of(context).colorScheme.surface,
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              sorahNum--;
                                            });
                                            audioPlayer.stop();
                                            audioPlayer.play(UrlSource(sorahNum.toString()));
                                          },
                                        ),
                                        GestureDetector(
                                          child: Column(
                                            children: [
                                              Container(
                                                  height: 50,
                                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context).colorScheme.background,
                                                      borderRadius: const BorderRadius.only(
                                                        topRight: Radius.circular(8),
                                                        topLeft: Radius.circular(8),
                                                      ),
                                                      border: Border.all(
                                                          width: 2,
                                                          color: Theme.of(context).dividerColor)),
                                                  child: Icon(
                                                    isPlayOnline
                                                        ? Icons.pause
                                                        : Icons.online_prediction_outlined,
                                                    size: 24,
                                                    color: Theme.of(context).colorScheme.surface,
                                                  )
                                              ),
                                              Text('اونلاين',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'kufi',
                                                    color: Theme.of(context).dividerColor
                                                ),
                                              )
                                            ],
                                          ),
                                          onTap: () {
                                            playSorahOnline(context);
                                          },
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Column(
                                            children: [
                                              SquarePercentIndicator(
                                                width: 50,
                                                height: 50,
                                                borderRadius: 8,
                                                shadowWidth: 1.5,
                                                progressWidth: 4,
                                                shadowColor: Colors.grey,
                                                progressColor: ThemeProvider.themeOf(context)
                                                    .id ==
                                                    'dark'
                                                    ? Colors.white
                                                    : Theme.of(context).primaryColorLight,
                                                progress: progress,
                                                child: GestureDetector(
                                                  child: Container(
                                                      height: 50,
                                                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                          color: Theme.of(context).colorScheme.background,
                                                          borderRadius: const BorderRadius.only(
                                                            topRight: Radius.circular(8),
                                                            topLeft: Radius.circular(8),
                                                          ),
                                                          border: Border.all(
                                                              width: 2,
                                                              color: Theme.of(context).dividerColor)),
                                                      child: Icon(
                                                        isPlay
                                                            ? Icons.pause
                                                            : Icons.download_outlined,
                                                        size: 24,
                                                        color: Theme.of(context).colorScheme.surface,
                                                      )
                                                  ),
                                                  onTap: () {
                                                    playSorah(context);
                                                  },
                                                ),
                                              ),
                                              Text('تحميل',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'kufi',
                                                    color: Theme.of(context).dividerColor
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.background,
                                                borderRadius: const BorderRadius.only(
                                                  topRight: Radius.circular(8),
                                                  topLeft: Radius.circular(8),
                                                ),
                                                border: Border.all(
                                                    width: 2,
                                                    color: Theme.of(context).dividerColor)),
                                            child: Icon(
                                              Icons.skip_previous,
                                              color: Theme.of(context).colorScheme.surface,
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              sorahNum++;
                                            });
                                            audioPlayer.stop();
                                            audioPlayer.play(UrlSource(sorahNum.toString()));
                                          },
                                        ),
                                        sorahReaderDropDown(context),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            flex: 2,
                                            child: Center(
                                                child: Text(_currentTime,
                                                  style: TextStyle(
                                                    color: ThemeProvider.themeOf(
                                                        context)
                                                        .id ==
                                                        'dark'
                                                        ? Theme.of(
                                                        context)
                                                        .canvasColor
                                                        : Theme.of(
                                                        context)
                                                        .primaryColorLight,
                                                  ),
                                            ))),
                                        Expanded(
                                          flex: 6,
                                          child: Container(
                                            height: 50,
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context).size.width,
                                            child: SliderTheme(
                                              data: SliderThemeData(
                                                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8)),
                                              child: Slider(
                                                activeColor: Theme.of(context).colorScheme.surface,
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
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Center(child: Text(_totalDuration,
                                              style: TextStyle(
                                                color: ThemeProvider.themeOf(
                                                    context)
                                                    .id ==
                                                    'dark'
                                                    ? Theme.of(
                                                    context)
                                                    .canvasColor
                                                    : Theme.of(
                                                    context)
                                                    .primaryColorLight,
                                              ),))),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    ),
                  ),
                ),
              )),
            ),
          ],
        )
            : Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: .1,
                    child: SvgPicture.asset('assets/svg/quran_au_ic.svg',
                      color: Theme.of(context).colorScheme.surface,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/svg/quran_au_ic.svg',
                    height: 100,
                    color: Theme.of(context).colorScheme.surface,
                    width: MediaQuery.of(context).size.width / 1 / 2,
                  ),
                ],
              ),
            ),
            Padding(
              padding: orientation == Orientation.portrait
                  ? EdgeInsets.only(right: 16.0, left: 16.0, top: 250.0, bottom: 16.0)
                  : EdgeInsets.only(right: 16.0, left: 16.0, top: 100.0, bottom: 16.0),
              child: sorahList != null
                  ? AnimationLimiter(
                      child: Scrollbar(
                        thumbVisibility: true,
                        // interactive: true,
                        controller: controller,
                        child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: sorahList!.length,
                            controller: controller,
                            itemBuilder: (_, index) {
                              Sorah sorah = sorahList![index];
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 450),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: GestureDetector(
                                          child: Container(
                                              height: 65,
                                              color: (index % 2 == 0
                                                  ? Theme.of(context)
                                                      .colorScheme.background
                                                  : Theme.of(context)
                                                      .dividerColor
                                                      .withOpacity(.3)),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 8),
                                                child: Row(
                                                  // mainAxisAlignment:
                                                  //     MainAxisAlignment
                                                  //         .spaceBetween,
                                                  children: [
                                                    Stack(
                                                      alignment: Alignment.center,
                                                      children: [
                                                        SizedBox(
                                                            height: 40,
                                                            width: 40,
                                                            child: SvgPicture.asset(
                                                              'assets/svg/sora_num.svg',
                                                            )),
                                                        Text(
                                                          "${sorah.id}",
                                                          style: TextStyle(
                                                              color: ThemeProvider.themeOf(
                                                                              context)
                                                                          .id ==
                                                                      'dark'
                                                                  ? Theme.of(
                                                                          context)
                                                                      .canvasColor
                                                                  : Theme.of(
                                                                          context)
                                                                      .primaryColorLight,
                                                              fontFamily: "kufi",
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight.bold),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(width: 100,),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        SvgPicture.asset(
                                                          'assets/svg/surah_name/00${index + 1}.svg',
                                                          color: ThemeProvider
                                                                          .themeOf(
                                                                              context)
                                                                      .id ==
                                                                  'dark'
                                                              ? Theme.of(context)
                                                                  .canvasColor
                                                              : Theme.of(context)
                                                                  .primaryColorDark,
                                                          width: 100,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                  right: 8.0),
                                                          child: Text(
                                                            sorah.nameEn,
                                                            style: TextStyle(
                                                              fontFamily: "naskh",
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              fontSize: 10,
                                                              color: ThemeProvider.themeOf(
                                                                              context)
                                                                          .id ==
                                                                      'dark'
                                                                  ? Theme.of(
                                                                          context)
                                                                      .canvasColor
                                                                  : Theme.of(
                                                                          context)
                                                                      .primaryColorLight,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )),
                                          onTap: () {
                                            setState(() {
                                              sorahNum = index + 1;
                                            });
                                            switch (audioCubit
                                                .controllerSorah
                                                .status) {
                                              case AnimationStatus
                                                  .completed:
                                                audioCubit
                                                    .controllerSorah
                                                    .reverse();
                                                break;
                                              case AnimationStatus
                                                  .dismissed:
                                                audioCubit
                                                    .controllerSorah
                                                    .forward();
                                                break;
                                              default:
                                            }
                                          },
                                        ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    )
                  : Center(
                      child: Lottie.asset('assets/lottie/loading.json',
                          width: 150, height: 150),
                    ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SlideTransition(
                  position: audioCubit.offset, child: Padding(
                padding: orientation == Orientation.portrait
                    ? const EdgeInsets.symmetric(horizontal: 16.0)
                    : const EdgeInsets.symmetric(horizontal: 64.0),
                child: Container(
                  height: orientation == Orientation.portrait
                      ? MediaQuery.of(context).size.height * 1 / 3 * .9
                      : MediaQuery.of(context).size.height * 1 / 3 * .9,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12.0),
                        topLeft: Radius.circular(12.0)),
                    color: Theme.of(context).colorScheme.background,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: orientation == Orientation.portrait
                        ? StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: orientation == Orientation.portrait ? 130 : 30,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Opacity(
                                    opacity: .1,
                                    child: SvgPicture.asset('assets/svg/surah_name/00$sorahNum.svg',
                                      color: Theme.of(context).colorScheme.surface,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    'assets/svg/surah_name/00$sorahNum.svg',
                                    height: 100,
                                    color: Theme.of(context).colorScheme.surface,
                                    width: MediaQuery.of(context).size.width / 1 / 2,
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      icon: Icon(Icons.close_outlined,
                                          color: ThemeProvider.themeOf(context).id == 'dark'
                                              ? Theme.of(context).canvasColor
                                              : Theme.of(context).primaryColorDark),
                                      onPressed: () => AudioCubit.get(context).controllerSorah.reverse(),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Visibility(
                                      visible: downloading,
                                      child: Text(
                                        progressString,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'kufi',
                                            color: Theme.of(context).colorScheme.surface),
                                      ),),
                                    GestureDetector(
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.background,
                                            borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(8),
                                              topLeft: Radius.circular(8),
                                            ),
                                            border: Border.all(
                                                width: 2,
                                                color: Theme.of(context).dividerColor)),
                                        child: Icon(
                                          Icons.skip_next,
                                          color: Theme.of(context).colorScheme.surface,
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          sorahNum--;
                                        });
                                        audioPlayer.stop();
                                        audioPlayer.play(UrlSource(sorahNum.toString()));
                                      },
                                    ),
                                    GestureDetector(
                                      child: Column(
                                        children: [
                                          Container(
                                              height: 50,
                                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                                              width: 50,
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context).colorScheme.background,
                                                  borderRadius: const BorderRadius.only(
                                                    topRight: Radius.circular(8),
                                                    topLeft: Radius.circular(8),
                                                  ),
                                                  border: Border.all(
                                                      width: 2,
                                                      color: Theme.of(context).dividerColor)),
                                              child: Icon(
                                                isPlayOnline
                                                    ? Icons.pause
                                                    : Icons.online_prediction_outlined,
                                                size: 24,
                                                color: Theme.of(context).colorScheme.surface,
                                              )
                                          ),
                                          Text('اونلاين',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'kufi',
                                                color: Theme.of(context).dividerColor
                                            ),
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        playSorahOnline(context);
                                      },
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          SquarePercentIndicator(
                                            width: 50,
                                            height: 50,
                                            borderRadius: 8,
                                            shadowWidth: 1.5,
                                            progressWidth: 4,
                                            shadowColor: Colors.grey,
                                            progressColor: ThemeProvider.themeOf(context)
                                                .id ==
                                                'dark'
                                                ? Colors.white
                                                : Theme.of(context).primaryColorLight,
                                            progress: progress,
                                            child: GestureDetector(
                                              child: Container(
                                                  height: 50,
                                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context).colorScheme.background,
                                                      borderRadius: const BorderRadius.only(
                                                        topRight: Radius.circular(8),
                                                        topLeft: Radius.circular(8),
                                                      ),
                                                      border: Border.all(
                                                          width: 2,
                                                          color: Theme.of(context).dividerColor)),
                                                  child: Icon(
                                                    isPlay
                                                        ? Icons.pause
                                                        : Icons.download_outlined,
                                                    size: 24,
                                                    color: Theme.of(context).colorScheme.surface,
                                                  )
                                              ),
                                              onTap: () {
                                                playSorah(context);
                                              },
                                            ),
                                          ),
                                          Text('تحميل',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'kufi',
                                                color: Theme.of(context).dividerColor
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.background,
                                            borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(8),
                                              topLeft: Radius.circular(8),
                                            ),
                                            border: Border.all(
                                                width: 2,
                                                color: Theme.of(context).dividerColor)),
                                        child: Icon(
                                          Icons.skip_previous,
                                          color: Theme.of(context).colorScheme.surface,
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          sorahNum++;
                                        });
                                        audioPlayer.stop();
                                        audioPlayer.play(UrlSource(sorahNum.toString()));
                                      },
                                    ),
                                    sorahReaderDropDown(context),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Center(
                                            child: Text(_currentTime,
                                              style: TextStyle(
                                                color: ThemeProvider.themeOf(
                                                    context)
                                                    .id ==
                                                    'dark'
                                                    ? Theme.of(
                                                    context)
                                                    .canvasColor
                                                    : Theme.of(
                                                    context)
                                                    .primaryColorLight,
                                              ),
                                        ))),
                                    Expanded(
                                      flex: 6,
                                      child: Container(
                                        height: 50,
                                        alignment: Alignment.center,
                                        width: MediaQuery.of(context).size.width,
                                        child: SliderTheme(
                                          data: SliderThemeData(
                                              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8)),
                                          child: Slider(
                                            activeColor: Theme.of(context).colorScheme.surface,
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
                                    ),
                                    Expanded(
                                        flex: 2,
                                        child: Center(child: Text(_totalDuration,
                                          style: TextStyle(
                                            color: ThemeProvider.themeOf(
                                                context)
                                                .id ==
                                                'dark'
                                                ? Theme.of(
                                                context)
                                                .canvasColor
                                                : Theme.of(
                                                context)
                                                .primaryColorLight,
                                          ),))),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    )
                        : StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Opacity(
                              opacity: .1,
                              child: SvgPicture.asset('assets/svg/surah_name/00$sorahNum.svg',
                                color: Theme.of(context).colorScheme.surface,
                                width: MediaQuery.of(context).size.width,
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: Icon(Icons.close_outlined,
                                    color: ThemeProvider.themeOf(context).id == 'dark'
                                        ? Theme.of(context).canvasColor
                                        : Theme.of(context).primaryColorDark),
                                onPressed: () => AudioCubit.get(context).controllerSorah.reverse(),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 23.0),
                                child: SvgPicture.asset(
                                  'assets/svg/surah_name/00$sorahNum.svg',
                                  height: 70,
                                  color: Theme.of(context).colorScheme.surface,
                                  width: MediaQuery.of(context).size.width / 1 / 2,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width / 1 / 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Visibility(
                                          visible: downloading,
                                          child: Text(
                                            progressString,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'kufi',
                                                color: Theme.of(context).colorScheme.surface),
                                          ),),
                                        GestureDetector(
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.background,
                                                borderRadius: const BorderRadius.only(
                                                  topRight: Radius.circular(8),
                                                  topLeft: Radius.circular(8),
                                                ),
                                                border: Border.all(
                                                    width: 2,
                                                    color: Theme.of(context).dividerColor)),
                                            child: Icon(
                                              Icons.skip_next,
                                              color: Theme.of(context).colorScheme.surface,
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              sorahNum--;
                                            });
                                            audioPlayer.stop();
                                            audioPlayer.play(UrlSource(sorahNum.toString()));
                                          },
                                        ),
                                        GestureDetector(
                                          child: Column(
                                            children: [
                                              Container(
                                                  height: 50,
                                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context).colorScheme.background,
                                                      borderRadius: const BorderRadius.only(
                                                        topRight: Radius.circular(8),
                                                        topLeft: Radius.circular(8),
                                                      ),
                                                      border: Border.all(
                                                          width: 2,
                                                          color: Theme.of(context).dividerColor)),
                                                  child: Icon(
                                                    isPlayOnline
                                                        ? Icons.pause
                                                        : Icons.online_prediction_outlined,
                                                    size: 24,
                                                    color: Theme.of(context).colorScheme.surface,
                                                  )
                                              ),
                                              Text('اونلاين',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'kufi',
                                                    color: Theme.of(context).dividerColor
                                                ),
                                              )
                                            ],
                                          ),
                                          onTap: () {
                                            playSorahOnline(context);
                                          },
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Column(
                                            children: [
                                              SquarePercentIndicator(
                                                width: 50,
                                                height: 50,
                                                borderRadius: 8,
                                                shadowWidth: 1.5,
                                                progressWidth: 4,
                                                shadowColor: Colors.grey,
                                                progressColor: ThemeProvider.themeOf(context)
                                                    .id ==
                                                    'dark'
                                                    ? Colors.white
                                                    : Theme.of(context).primaryColorLight,
                                                progress: progress,
                                                child: GestureDetector(
                                                  child: Container(
                                                      height: 50,
                                                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                          color: Theme.of(context).colorScheme.background,
                                                          borderRadius: const BorderRadius.only(
                                                            topRight: Radius.circular(8),
                                                            topLeft: Radius.circular(8),
                                                          ),
                                                          border: Border.all(
                                                              width: 2,
                                                              color: Theme.of(context).dividerColor)),
                                                      child: Icon(
                                                        isPlay
                                                            ? Icons.pause
                                                            : Icons.download_outlined,
                                                        size: 24,
                                                        color: Theme.of(context).colorScheme.surface,
                                                      )
                                                  ),
                                                  onTap: () {
                                                    playSorah(context);
                                                  },
                                                ),
                                              ),
                                              Text('تحميل',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'kufi',
                                                    color: Theme.of(context).dividerColor
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.background,
                                                borderRadius: const BorderRadius.only(
                                                  topRight: Radius.circular(8),
                                                  topLeft: Radius.circular(8),
                                                ),
                                                border: Border.all(
                                                    width: 2,
                                                    color: Theme.of(context).dividerColor)),
                                            child: Icon(
                                              Icons.skip_previous,
                                              color: Theme.of(context).colorScheme.surface,
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              sorahNum++;
                                            });
                                            audioPlayer.stop();
                                            audioPlayer.play(UrlSource(sorahNum.toString()));
                                          },
                                        ),
                                        sorahReaderDropDown(context),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            flex: 2,
                                            child: Center(
                                                child: Text(_currentTime,
                                                  style: TextStyle(
                                                    color: ThemeProvider.themeOf(
                                                        context)
                                                        .id ==
                                                        'dark'
                                                        ? Theme.of(
                                                        context)
                                                        .canvasColor
                                                        : Theme.of(
                                                        context)
                                                        .primaryColorLight,
                                                  ),
                                            ))),
                                        Expanded(
                                          flex: 6,
                                          child: Container(
                                            height: 50,
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context).size.width,
                                            child: SliderTheme(
                                              data: SliderThemeData(
                                                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8)),
                                              child: Slider(
                                                activeColor: Theme.of(context).colorScheme.surface,
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
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Center(child: Text(_totalDuration,
                                              style: TextStyle(
                                                color: ThemeProvider.themeOf(
                                                    context)
                                                    .id ==
                                                    'dark'
                                                    ? Theme.of(
                                                    context)
                                                    .canvasColor
                                                    : Theme.of(
                                                    context)
                                                    .primaryColorLight,
                                              ),))),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    ),
                  ),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget playDropDown(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    QuranCubit cubit = QuranCubit.get(context);
    List<String> name = <String>[
      'اونلاين',
      'تحميل',
    ];
    List<Widget> icons = <Widget>[
      Icon(Icons.online_prediction_outlined,
        color: Theme.of(context).canvasColor,
        size: 20,
      ),
      Icon(Icons.download_outlined,
        color: Theme.of(context).canvasColor,
        size: 20,
      ),
    ];
    List<Widget> wid = <Icon>[
      playSorahOnline(context),
      playSorah(context),
    ];
    return DropdownButton2(
      isExpanded: true,
      items: [
        DropdownMenuItem<String>(
          child: ListView.builder(
            itemCount: name.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  ListTile(
                    title: Text(
                      name[index],
                      style: TextStyle(
                          color: cubit.radioValue == index
                              ? const Color(0xfffcbb76)
                              : Theme.of(context).canvasColor,
                          fontSize: 14,
                          fontFamily: 'kufi'),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: icons[index]
                    ),
                    onTap: () {
                      setState(() {
                        wid[index];
                      });
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(
                    endIndent: 16,
                    indent: 16,
                    height: 3,
                  ),
                ],
              );
            },
          ),
        )
      ],
      value: selectedValue,
      onChanged: (value) {
        setState(() {
          selectedValue = value as String;
        });
      },
      customButton: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            color:
            Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(
                Radius.circular(8))),
        child: Icon(
          isPlay
              ? Icons.pause
              : Icons.play_arrow,
          size: 15,
        ),
      ),
      iconSize: 24,
      buttonHeight: 50,
      buttonWidth: 50,
      buttonElevation: 0,
      itemHeight: orientation == Orientation.portrait ? 230 : 125,
      dropdownDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(.9),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      dropdownMaxHeight: orientation == Orientation.portrait ? 230 : 125,
      dropdownWidth: 230,
      dropdownPadding: null,
      dropdownElevation: 0,
      scrollbarRadius: const Radius.circular(8),
      scrollbarThickness: 6,
      scrollbarAlwaysShow: true,
      offset: const Offset(0, 0),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
