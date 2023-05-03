import 'dart:async';
import 'dart:io';
import 'dart:developer' as developer;
import 'package:alquranalkareem/cubit/cubit.dart';
import 'package:alquranalkareem/l10n/app_localizations.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/handler_animation.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    with AutomaticKeepAliveClientMixin<AudioSorahList>, SingleTickerProviderStateMixin {

  SorahRepository sorahRepository = SorahRepository();
  List<Sorah>? sorahList;
  final ScrollController controller = ScrollController();
  ValueNotifier<double> _position = ValueNotifier(0);
  ValueNotifier<double> _duration = ValueNotifier(99999);
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
  String progressString = "0";
  double progress = 0;
  String? currentPlay;
  bool autoPlay = false;
  double? sliderValue;
  int sorahNum = 1;
  String? selectedValue;
  bool repeatSurah = false;
  bool repeatSurahOnline = false;
  int intValue = 1;
  late Source audioUrl;
  var url;
  String? fileNameDownload;
  String? urlDownload;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late CancelToken cancelToken;
  bool loading = false;
  TextEditingController textController = TextEditingController();
  int selectedSurah = -1;
  double lastPosition = 0.0;
  bool _isInitialLoadComplete = false;


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
    AudioPlayer.global.setAudioContext(audioContext);
    getList();
    audioPlayer.onDurationChanged.listen((duration) {
      if (!_isInitialLoadComplete) {
        audioPlayer.seek(Duration(seconds: lastPosition.toInt()));
        _isInitialLoadComplete = true;
      }
      setState(() {
        _duration.value = duration.inSeconds.toDouble();
        _totalDuration = duration.toString().split('.').first;
      });
    });
    audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position.value = position.inSeconds.toDouble();
        lastPosition = _position.value;
        _currentTime = position.toString().split('.').first;
        saveLastSurahListen(sorahNum, (sorahNum - 1), _position.value);
        // print('Position value: ${_position.value}');
      });
    });
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    initConnectivity();
    loadLastSurahListen();
    _loadLastSurahAndPosition();
    // print(_position.value);
    super.initState();
  }

  // Save & Last Surah Listen
  Future<void> saveLastSurahListen(int surahNum, selectedSurah, double position) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastSurah', surahNum);
    await prefs.setInt('selectedSurah', selectedSurah);
    await prefs.setDouble('lastPosition', position);
  }

  Future loadLastSurahListen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? lastSurah = prefs.getInt('lastSurah');
    selectedSurah = prefs.getInt('selectedSurah') ?? -1;
    lastPosition = prefs.getDouble('lastPosition') ?? 0.0;

    return {
      'lastSurah': lastSurah ?? 1,
      'selectedSurah': selectedSurah,
      'lastPosition': lastPosition,
    };
  }

  Future<void> _loadLastSurahAndPosition() async {
    final lastSurahData = await loadLastSurahListen();
    // Print the data to see if it contains the correct last position value
    print('Last Surah Data: $lastSurahData');

    setState(() {
      sorahNum = lastSurahData['lastSurah'];
      selectedSurah = lastSurahData['selectedSurah'];
      _position.value = lastSurahData['lastPosition'];
    });

    // print('_position.value after assignment: ${_position.value}'); // Add this line

    // await playSorahOnline(this.context); // Play the Surah after loading the last position
    // await Future.delayed(Duration(milliseconds: 500));
    // await audioPlayer.seek(Duration(seconds: lastPosition!.toInt())); // Seek to the last position
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  playSorahOnline(BuildContext context) async {
    int result = 1;

    AudioCubit audioCubit = AudioCubit.get(context);
    String? sorahNumString;
    if (sorahNum < 10) {
      sorahNumString = "00" + sorahNum.toString();
    } else if (sorahNum < 100) {
      sorahNumString = "0" + sorahNum.toString();
    } else if (sorahNum < 1000) {
      sorahNumString = sorahNum.toString();
    }

    String paddedString = sorahNumString!; // copy the padded string to a new variable
    intValue = int.parse(paddedString); // temporarily convert the padded string to an integer

    // convert intValue back to a padded string
    paddedString = intValue.toString().padLeft(3, '0');

    // use sorahNum as an integer in your code
    // int? sorahNumInt = int.tryParse(sorahNumString);

    // use sorahNumString as a string with leading zeroes
    // String sorahNumWithLeadingZeroes = sorahNumString;

    String reader = audioCubit.sorahReaderValue!;
    String readerN = audioCubit.sorahReaderNameValue!;
    String fileName = "$readerN$paddedString.mp3";
    print('sorah reader: $reader');
    url = "$reader${fileName}";
    setState(() {
      audioUrl = UrlSource(url);
    });
    audioPlayer.onPlayerComplete.listen((event) async {
      setState(() {
        isPlayOnline = false;
        isPlay = false;
      });
      if (repeatSurahOnline == true) {
        await audioPlayer.play(audioUrl);
        setState(() {
          isPlayOnline = true;
        });
      } else {

        await audioPlayer.play(audioUrl);
        sorahNum++;
        intValue++;
        playSorahOnline(context);
        isPlayOnline = true;
      }
    });
    print("url $url");
    if (isPlayOnline) {
      audioPlayer.pause();
      setState(() {
        isPlayOnline = false;
      });
    } else {
      try {
        if (_connectionStatus == ConnectivityResult.none) {
          customMobileNoteSnackBar(context,
              AppLocalizations.of(context)!.noInternet);
        } else if (_connectionStatus == ConnectivityResult.mobile) {
          setState(() {
            loading = true;
          });
          customMobileNoteSnackBar(context,
              AppLocalizations.of(context)!.mobileDataListen);
          await audioPlayer.play(audioUrl);
          setState(() {
            loading = false;
          });
          if (result == 1) {
            setState(() {
              isPlayOnline = true;
            });
          }
        } else if (_connectionStatus == ConnectivityResult.wifi) {
          setState(() {
            loading = true;
          });
          await audioPlayer.play(audioUrl);
          setState(() {
            loading = false;
          });
          if (result == 1) {
            setState(() {
              isPlayOnline = true;
            });
          }
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
    // int sorahNumInt = sorahNum;
    String sorahNumWithLeadingZeroes = sorahNumString!;
    String reader = audioCubit.sorahReaderValue!;
    String readerN = audioCubit.sorahReaderNameValue!;
    fileNameDownload = "$readerN$sorahNumWithLeadingZeroes.mp3";
    print('sorah reader: $reader');
    urlDownload = "$reader${fileNameDownload}";
    audioPlayer.onPlayerComplete.listen((event) async {
      setState(() {
        isPlay = false;
      });
      if (repeatSurah == true) {
        await playFile(context, url, fileNameDownload!);
        setState(() {
          isPlay = true;
        });
      }
    });
    print("url $url");
    if (isPlay) {
      audioPlayer.pause();
      setState(() {
        isPlay = false;
      });
    } else {
      await playFile(context, urlDownload!, fileNameDownload!);
    }
  }

  Future playFile(BuildContext context, String url, String fileName) async {
    var path;
    int result = 1;

    if (downloading) {
      cancelToken.cancel("User canceled the download");
    } else {
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
            customMobileNoteSnackBar(context,
                AppLocalizations.of(context)!.mobileDataSurahs);
            await downloadFile(path, url, fileName);
          } else if (_connectionStatus == ConnectivityResult.wifi
              || _connectionStatus == ConnectivityResult.mobile) {
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


  }

  skip_previous(BuildContext context) async {

    if (isPlayOnline == true) {
      await audioPlayer.stop();
      sorahNum--;
      intValue--;
      playSorahOnline(context);
      await audioPlayer.play(audioUrl);
      isPlayOnline = true;
    } else if (isPlay == true) {
      await audioPlayer.stop();
      sorahNum--;
      intValue--;
      playSorah(context);
      await playFile(context, urlDownload!, fileNameDownload!);
      isPlay = true;
    }
  }

  skip_next(BuildContext context) async {
    if (isPlayOnline == true) {
      await audioPlayer.stop();
      sorahNum++;
      intValue++;
      playSorahOnline(context);
      await audioPlayer.play(audioUrl);
      isPlayOnline = true;
    } else if (isPlay == true) {
      await audioPlayer.stop();
      sorahNum++;
      intValue++;
      playSorah(context);
      await playFile(context, urlDownload!, fileNameDownload!);
      isPlay = true;
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

      // Initialize the cancel token
      cancelToken = CancelToken();

      await dio.download(url, path, onReceiveProgress: (rec, total) {
        // print("Rec: $rec , Total: $total");
        setState(() {
          progressString = ((rec / total) * 100).toStringAsFixed(0);
          progress = (rec / total).toDouble();
        });
        print(progressString);
      },
          cancelToken: cancelToken);
    } catch (e) {
      if (e is DioError && e.type == DioErrorType.cancel) {
        print('Download canceled');
        // Delete the partially downloaded file
        try {
          final file = File(path);
          await file.delete();
          print('Partially downloaded file deleted');
        } catch (e) {
          print('Error deleting partially downloaded file: $e');
        }
      } else {
        print(e);
      }
    }
    setState(() {
      downloading = false;
      progressString = "100";
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
    positionSubscription?.cancel();
    durationSubscription?.cancel();
    _connectivitySubscription.cancel();
    if (isPlay) {
      audioPlayer.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    controller.dispose();
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
    //print('state = $state');
  }

  getList() async {
    sorahRepository.all().then((values) {
      setState(() {
        sorahList = values;
      });
    });
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

  void searchSurah(String searchInput) {
    int index = sorahList!
        .indexWhere((sorah) => sorah.searchText.contains(searchInput));
    if (index != -1) {
      controller.jumpTo(index * 65.0); // Assuming 65.0 is the height of each ListTile
      setState(() {
        selectedSurah = index;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    super.build(context);
    AudioCubit audioCubit = AudioCubit.get(context);
    QuranCubit cubit = QuranCubit.get(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: SorahPlayScaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: platformView(
                orientation(context,
                    Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: .1,
                        child: SvgPicture.asset('assets/svg/quran_au_ic.svg',
                          colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn),
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/svg/quran_au_ic.svg',
                        height: 100,
                        colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn),
                        width: MediaQuery.of(context).size.width / 1 / 2,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: orientation(context,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        lastListen(context),
                        surahSearch(context),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        lastListen(context),
                        surahSearch(context),
                      ],
                    ),
                  ),
                ),
                surahList(context),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: playWidget(context),
                ),
              ],
            ),
                    Stack(
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
                                  colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn),
                                  width: MediaQuery.of(context).size.width,
                                ),
                              ),
                              SvgPicture.asset(
                                'assets/svg/quran_au_ic.svg',
                                height: 100,
                                colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn),
                                width: MediaQuery.of(context).size.width / 1 / 2,
                              ),
                              surahSearch(context),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: lastListen(context),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1 / 2,
                          child: surahList(context),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SlideTransition(
                            position: audioCubit.offset,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 64.0),
                              child: Container(
                                height: MediaQuery.of(context).size.height * 1 / 3 * .6,
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
                                child: StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setState) {
                                      return Stack(
                                        children: [
                                          Opacity(
                                            opacity: .1,
                                            child: SvgPicture.asset('assets/svg/surah_name/00$sorahNum.svg',
                                              colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn),
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
                                                colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn),
                                                width: MediaQuery.of(context).size.width / 1 / 2,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: SizedBox(
                                              height: 120,
                                              width: MediaQuery.of(context).size.width / 1 / 2,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
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
                                                      skip_previous(context);
                                                      setState(() {
                                                        sorahNum--;
                                                        intValue--;
                                                        selectedSurah--;
                                                      });
                                                    },

                                                  ),
                                                  SizedBox(
                                                    height: 120,
                                                    child: Stack(
                                                      alignment: Alignment.center,
                                                      children: [
                                                        Align(
                                                          alignment: Alignment.topCenter,
                                                          child: IconButton(
                                                              onPressed: () {
                                                                setState((){
                                                                  repeatSurahOnline = !repeatSurahOnline;
                                                                });
                                                              },
                                                              icon: Icon(
                                                                Icons.repeat_one,
                                                                color: repeatSurahOnline == true
                                                                    ? Theme.of(context).colorScheme.surface
                                                                    : Theme.of(context).colorScheme.surface.withOpacity(.4),
                                                              )),
                                                        ),
                                                        Align(
                                                          alignment: Alignment.center,
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
                                                                child: Stack(
                                                                  alignment: Alignment.center,
                                                                  children: [
                                                                    if (loading)
                                                                      Lottie.asset('assets/lottie/play_button.json',
                                                                          width: 20, height: 20),
                                                                    if (!loading)
                                                                      Icon(
                                                                        isPlayOnline ? Icons.pause : Icons.online_prediction_outlined,
                                                                        size: 24,
                                                                        color: Theme.of(context).colorScheme.surface,
                                                                      ),
                                                                  ],
                                                                )
                                                            ),
                                                            onTap: () {
                                                              playSorahOnline(context);
                                                            },
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment.bottomCenter,
                                                          child: Text(AppLocalizations.of(context)!.online,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily: 'kufi',
                                                                height: -1.5,
                                                                color: Theme.of(context).dividerColor
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: SizedBox(
                                                      height: 120,
                                                      child: Stack(
                                                        alignment: Alignment.center,
                                                        children: [
                                                          Align(
                                                            alignment: Alignment.topCenter,
                                                            child: IconButton(
                                                                onPressed: () {
                                                                  setState((){
                                                                    repeatSurah = !repeatSurah;
                                                                  });
                                                                },
                                                                icon: Icon(
                                                                  Icons.repeat_one,
                                                                  color: repeatSurah == true
                                                                      ? Theme.of(context).colorScheme.surface
                                                                      : Theme.of(context).colorScheme.surface.withOpacity(.4),
                                                                )),
                                                          ),
                                                          Align(
                                                            alignment: Alignment.center,
                                                            child: GestureDetector(
                                                              child: SquarePercentIndicator(
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
                                                                child: downloading
                                                                    ? Container(
                                                                  alignment: Alignment.center,
                                                                  child: Text(
                                                                    progressString,
                                                                    style: TextStyle(
                                                                        fontSize: 14,
                                                                        fontFamily: 'kufi',
                                                                        color: Theme.of(context).colorScheme.surface),
                                                                  ),
                                                                )
                                                                    : Icon(
                                                                  isPlay
                                                                      ? Icons.pause
                                                                      : Icons.download_outlined,
                                                                  size: 24,
                                                                  color: Theme.of(context).colorScheme.surface,
                                                                ),
                                                              ),
                                                              onTap: () {
                                                                playSorah(context);
                                                              },
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment: Alignment.bottomCenter,
                                                            child: Text(AppLocalizations.of(context)!.download,
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontFamily: 'kufi',
                                                                  height: -1.5,
                                                                  color: Theme.of(context).dividerColor
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
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
                                                      skip_next(context);
                                                      setState(() {
                                                        sorahNum++;
                                                        intValue++;
                                                        selectedSurah++;
                                                      });
                                                    },
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
                                                      onPressed: () => sorahReaderDropDown(context),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(bottom: 16.0),
                                              child: SizedBox(
                                                height: 20,
                                                width: MediaQuery.of(context).size.width / 1 / 2,
                                                child: Row(
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
                                                        child: FlutterSlider(
                                                          values: [lastPosition == null ? _position.value : lastPosition],
                                                          max: _duration.value,
                                                          min: 0,
                                                          rtl: true,
                                                          trackBar: FlutterSliderTrackBar(
                                                            inactiveTrackBarHeight: 5,
                                                            activeTrackBarHeight: 5,
                                                            inactiveTrackBar: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(8),
                                                              color: Theme.of(context).colorScheme.surface.withOpacity(.5),
                                                            ),
                                                            activeTrackBar: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(4),
                                                                color: Theme.of(context).colorScheme.surface),
                                                          ),
                                                          handlerAnimation: const FlutterSliderHandlerAnimation(
                                                              curve: Curves.elasticOut,
                                                              reverseCurve: null,
                                                              duration: Duration(milliseconds: 700),
                                                              scale: 1.4),
                                                          onDragging: (handlerIndex, lowerValue, upperValue) {
                                                            lowerValue = lowerValue;
                                                            upperValue = upperValue;
                                                            setState(() {
                                                              _position.value = lowerValue;
                                                              lastPosition = lowerValue;
                                                              audioPlayer.seek(Duration(seconds: _position.value.toInt()));
                                                            });
                                                          },
                                                          handler: FlutterSliderHandler(
                                                            decoration: const BoxDecoration(),
                                                            child: Material(
                                                              type: MaterialType.circle,
                                                              color: Colors.transparent,
                                                              elevation: 3,
                                                              child: SvgPicture.asset('assets/svg/slider_ic.svg'),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        flex: 2,
                                                        child: Center(
                                                            child: Text(_totalDuration,
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
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                ),
                              ),
                            )),
                      ),
                    ],
                  )),
                Stack(
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
                            colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn),
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/svg/quran_au_ic.svg',
                          height: 100,
                          colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn),
                          width: MediaQuery.of(context).size.width / 1 / 2,
                        ),
                        surahSearch(context),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: lastListen(context),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1 / 2,
                    child: surahList(context),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SlideTransition(
                      position: audioCubit.offset,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 64.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 1 / 3 * .6,
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
                          child: StatefulBuilder(
                              builder: (BuildContext context, StateSetter setState) {
                                return Stack(
                                  children: [
                                    Opacity(
                                      opacity: .1,
                                      child: SvgPicture.asset('assets/svg/surah_name/00$sorahNum.svg',
                                        colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn),
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
                                          colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn),
                                          width: MediaQuery.of(context).size.width / 1 / 2,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: SizedBox(
                                        height: 120,
                                        width: MediaQuery.of(context).size.width / 1 / 2,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
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
                                                skip_previous(context);
                                                setState(() {
                                                  sorahNum--;
                                                  intValue--;
                                                  selectedSurah--;
                                                });
                                              },

                                            ),
                                            SizedBox(
                                              height: 120,
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Align(
                                                    alignment: Alignment.topCenter,
                                                    child: IconButton(
                                                        onPressed: () {
                                                          setState((){
                                                            repeatSurahOnline = !repeatSurahOnline;
                                                          });
                                                        },
                                                        icon: Icon(
                                                          Icons.repeat_one,
                                                          color: repeatSurahOnline == true
                                                              ? Theme.of(context).colorScheme.surface
                                                              : Theme.of(context).colorScheme.surface.withOpacity(.4),
                                                        )),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.center,
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
                                                          child: Stack(
                                                            alignment: Alignment.center,
                                                            children: [
                                                              if (loading)
                                                                Lottie.asset('assets/lottie/play_button.json',
                                                                    width: 20, height: 20),
                                                              if (!loading)
                                                                Icon(
                                                                  isPlayOnline ? Icons.pause : Icons.online_prediction_outlined,
                                                                  size: 24,
                                                                  color: Theme.of(context).colorScheme.surface,
                                                                ),
                                                            ],
                                                          )
                                                      ),
                                                      onTap: () {
                                                        playSorahOnline(context);
                                                      },
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.bottomCenter,
                                                    child: Text(AppLocalizations.of(context)!.online,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontFamily: 'kufi',
                                                          height: -1.5,
                                                          color: Theme.of(context).dividerColor
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: SizedBox(
                                                height: 120,
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Align(
                                                      alignment: Alignment.topCenter,
                                                      child: IconButton(
                                                          onPressed: () {
                                                            setState((){
                                                              repeatSurah = !repeatSurah;
                                                            });
                                                          },
                                                          icon: Icon(
                                                            Icons.repeat_one,
                                                            color: repeatSurah == true
                                                                ? Theme.of(context).colorScheme.surface
                                                                : Theme.of(context).colorScheme.surface.withOpacity(.4),
                                                          )),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.center,
                                                      child: GestureDetector(
                                                        child: SquarePercentIndicator(
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
                                                          child: downloading
                                                              ? Container(
                                                            alignment: Alignment.center,
                                                            child: Text(
                                                              progressString,
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily: 'kufi',
                                                                  color: Theme.of(context).colorScheme.surface),
                                                            ),
                                                          )
                                                              : Icon(
                                                            isPlay
                                                                ? Icons.pause
                                                                : Icons.download_outlined,
                                                            size: 24,
                                                            color: Theme.of(context).colorScheme.surface,
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          playSorah(context);
                                                        },
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.bottomCenter,
                                                      child: Text(AppLocalizations.of(context)!.download,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontFamily: 'kufi',
                                                            height: -1.5,
                                                            color: Theme.of(context).dividerColor
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
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
                                                skip_next(context);
                                                setState(() {
                                                  sorahNum++;
                                                  intValue++;
                                                  selectedSurah++;
                                                });
                                              },
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
                                                onPressed: () => sorahReaderDropDown(context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 16.0),
                                        child: SizedBox(
                                          height: 20,
                                          width: MediaQuery.of(context).size.width / 1 / 2,
                                          child: Row(
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
                                                  child: FlutterSlider(
                                                    values: [lastPosition == null ? _position.value : lastPosition],
                                                    max: _duration.value,
                                                    min: 0,
                                                    rtl: true,
                                                    trackBar: FlutterSliderTrackBar(
                                                      inactiveTrackBarHeight: 5,
                                                      activeTrackBarHeight: 5,
                                                      inactiveTrackBar: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(8),
                                                        color: Theme.of(context).colorScheme.surface.withOpacity(.5),
                                                      ),
                                                      activeTrackBar: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(4),
                                                          color: Theme.of(context).colorScheme.surface),
                                                    ),
                                                    handlerAnimation: const FlutterSliderHandlerAnimation(
                                                        curve: Curves.elasticOut,
                                                        reverseCurve: null,
                                                        duration: Duration(milliseconds: 700),
                                                        scale: 1.4),
                                                    onDragging: (handlerIndex, lowerValue, upperValue) {
                                                      lowerValue = lowerValue;
                                                      upperValue = upperValue;
                                                      setState(() {
                                                        _position.value = lowerValue;
                                                        lastPosition = lowerValue;
                                                        audioPlayer.seek(Duration(seconds: _position.value.toInt()));
                                                      });
                                                    },
                                                    handler: FlutterSliderHandler(
                                                      decoration: const BoxDecoration(),
                                                      child: Material(
                                                        type: MaterialType.circle,
                                                        color: Colors.transparent,
                                                        elevation: 3,
                                                        child: SvgPicture.asset('assets/svg/slider_ic.svg'),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 2,
                                                  child: Center(
                                                      child: Text(_totalDuration,
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
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                          ),
                        ),
                      )),
                ),
              ],
            )),
      ),
    );
  }

  Widget playWidget(BuildContext context) {
    AudioCubit audioCubit = AudioCubit.get(context);
    return SlideTransition(
        position: audioCubit.offset, child: Padding(
      padding: orientation(context,
          const EdgeInsets.symmetric(horizontal: 16.0),
          const EdgeInsets.symmetric(horizontal: 64.0)),
      child: Container(
        height: orientation(context,
            280.0,
            150.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(12.0),
              topLeft: Radius.circular(12.0)),
          border: Border.all(
              width: 2,
              color: Theme.of(context).colorScheme.surface
          ),
          color: Theme.of(context).colorScheme.background,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: orientation(context,
              StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Stack(
                      children: [
                        SizedBox(
                          height: orientation(context, 130.0, 30.0),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Opacity(
                                opacity: .1,
                                child: SvgPicture.asset('assets/svg/surah_name/00$sorahNum.svg',
                                  colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn),
                                  width: MediaQuery.of(context).size.width,
                                ),
                              ),
                              SvgPicture.asset(
                                'assets/svg/surah_name/00$sorahNum.svg',
                                height: 100,
                                colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 32.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
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
                                    skip_previous(context);
                                    setState(() {
                                      sorahNum--;
                                      intValue--;
                                      selectedSurah--;
                                    });
                                  },
                                ),
                                GestureDetector(
                                  child: SizedBox(
                                    height: 120,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: IconButton(
                                              onPressed: () {
                                                setState((){
                                                  repeatSurahOnline = !repeatSurahOnline;
                                                });
                                              },
                                              icon: Icon(
                                                Icons.repeat_one,
                                                color: repeatSurahOnline == true
                                                    ? Theme.of(context).colorScheme.surface
                                                    : Theme.of(context).colorScheme.surface.withOpacity(.4),
                                              )),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
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
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  if (loading)
                                                    Lottie.asset('assets/lottie/play_button.json',
                                                        width: 20, height: 20),
                                                  if (!loading)
                                                    Icon(
                                                      isPlayOnline ? Icons.pause : Icons.online_prediction_outlined,
                                                      size: 24,
                                                      color: Theme.of(context).colorScheme.surface,
                                                    ),
                                                ],
                                              )
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Text(AppLocalizations.of(context)!.online,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'kufi',
                                                height: -1.5,
                                                color: Theme.of(context).dividerColor
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    playSorahOnline(context);
                                  },
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    height: 120,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: IconButton(
                                              onPressed: () {
                                                setState((){
                                                  repeatSurah = !repeatSurah;
                                                });
                                              },
                                              icon: Icon(
                                                Icons.repeat_one,
                                                color: repeatSurah == true
                                                    ? Theme.of(context).colorScheme.surface
                                                    : Theme.of(context).colorScheme.surface.withOpacity(.4),
                                              )),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: SquarePercentIndicator(
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
                                                  child: downloading
                                                      ? Container(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      progressString,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: 'kufi',
                                                          color: Theme.of(context).colorScheme.surface),
                                                    ),
                                                  )
                                                      : Icon(
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
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Text(AppLocalizations.of(context)!.download,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'kufi',
                                                height: -1.5,
                                                color: Theme.of(context).dividerColor
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
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
                                    skip_next(context);
                                    setState(() {
                                      sorahNum++;
                                      intValue++;
                                      selectedSurah++;
                                    });
                                  },
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
                                    onPressed: () => sorahReaderDropDown(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            height: 70,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Center(
                                        child: Text(_currentTime,
                                          style: TextStyle(
                                            fontFamily: 'kufi',
                                            fontSize: 14,
                                            color: ThemeProvider.themeOf(context).id == 'dark'
                                                ? Theme.of(context).canvasColor
                                                : Theme.of(context).primaryColor,
                                          ),
                                        ))),
                                Expanded(
                                  flex: 6,
                                  child: Container(
                                    height: 50,
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width,
                                    child: FlutterSlider(
                                      values: [lastPosition == null ? _position.value : lastPosition],
                                      max: _duration.value,
                                      min: 0,
                                      rtl: true,
                                      trackBar: FlutterSliderTrackBar(
                                        inactiveTrackBarHeight: 5,
                                        activeTrackBarHeight: 5,
                                        inactiveTrackBar: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Theme.of(context).colorScheme.surface.withOpacity(.5),
                                        ),
                                        activeTrackBar: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4),
                                            color: Theme.of(context).colorScheme.surface),
                                      ),
                                      handlerAnimation: const FlutterSliderHandlerAnimation(
                                          curve: Curves.elasticOut,
                                          reverseCurve: null,
                                          duration: Duration(milliseconds: 700),
                                          scale: 1.4),
                                      onDragging: (handlerIndex, lowerValue, upperValue) {
                                        lowerValue = lowerValue;
                                        upperValue = upperValue;
                                        setState(() {
                                          _position.value = lowerValue;
                                          lastPosition = lowerValue;
                                          audioPlayer.seek(Duration(seconds: _position.value.toInt()));
                                        });
                                      },
                                      handler: FlutterSliderHandler(
                                        decoration: const BoxDecoration(),
                                        child: Material(
                                          type: MaterialType.circle,
                                          color: Colors.transparent,
                                          elevation: 3,
                                          child: SvgPicture.asset('assets/svg/slider_ic.svg'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Center(child: Text(_totalDuration,
                                      style: TextStyle(
                                        fontFamily: 'kufi',
                                        fontSize: 14,
                                        color: ThemeProvider.themeOf(context).id == 'dark'
                                            ? Theme.of(context).canvasColor
                                            : Theme.of(context).primaryColor,
                                      ),))),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
              ),
              StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Stack(
                      children: [
                        Opacity(
                          opacity: .1,
                          child: SvgPicture.asset('assets/svg/surah_name/00$sorahNum.svg',
                            colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn),
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
                              colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn),
                              width: MediaQuery.of(context).size.width / 1 / 2,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: SizedBox(
                            height: 120,
                            width: MediaQuery.of(context).size.width / 1 / 2,
                            child: Row(
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
                                    skip_previous(context);
                                    setState(() {
                                      sorahNum--;
                                      intValue--;
                                      selectedSurah--;
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 120,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: IconButton(
                                            onPressed: () {
                                              setState((){
                                                repeatSurahOnline = !repeatSurahOnline;
                                              });
                                            },
                                            icon: Icon(
                                              Icons.repeat_one,
                                              color: repeatSurahOnline == true
                                                  ? Theme.of(context).colorScheme.surface
                                                  : Theme.of(context).colorScheme.surface.withOpacity(.4),
                                            )),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
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
                                                isPlayOnline
                                                    ? Icons.pause
                                                    : Icons.online_prediction_outlined,
                                                size: 24,
                                                color: Theme.of(context).colorScheme.surface,
                                              )
                                          ),
                                          onTap: () {
                                            playSorahOnline(context);
                                          },
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Text(AppLocalizations.of(context)!.online,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'kufi',
                                              height: -1.5,
                                              color: Theme.of(context).dividerColor
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    height: 120,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: IconButton(
                                              onPressed: () {
                                                setState((){
                                                  repeatSurah = !repeatSurah;
                                                });
                                              },
                                              icon: Icon(
                                                Icons.repeat_one,
                                                color: repeatSurah == true
                                                    ? Theme.of(context).colorScheme.surface
                                                    : Theme.of(context).colorScheme.surface.withOpacity(.4),
                                              )),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: SquarePercentIndicator(
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
                                              child: downloading
                                                  ? Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  progressString,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'kufi',
                                                      color: Theme.of(context).colorScheme.surface),
                                                ),
                                              )
                                                  : Icon(
                                                isPlay
                                                    ? Icons.pause
                                                    : Icons.download_outlined,
                                                size: 24,
                                                color: Theme.of(context).colorScheme.surface,
                                              ),
                                              onTap: () {
                                                playSorah(context);
                                              },
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Text(AppLocalizations.of(context)!.download,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'kufi',
                                                height: -1.5,
                                                color: Theme.of(context).dividerColor
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
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
                                    skip_next(context);
                                    setState(() {
                                      sorahNum++;
                                      intValue++;
                                      selectedSurah++;
                                    });
                                  },
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
                                    onPressed: () => sorahReaderDropDown(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: SizedBox(
                              height: 20,
                              width: MediaQuery.of(context).size.width / 1 / 2,
                              child: Row(
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
                                      child: FlutterSlider(
                                        values: [lastPosition == null ? _position.value : lastPosition],
                                        max: _duration.value,
                                        min: 0,
                                        rtl: true,
                                        trackBar: FlutterSliderTrackBar(
                                          inactiveTrackBarHeight: 5,
                                          activeTrackBarHeight: 5,
                                          inactiveTrackBar: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            color: Theme.of(context).colorScheme.surface.withOpacity(.5),
                                          ),
                                          activeTrackBar: BoxDecoration(
                                              borderRadius: BorderRadius.circular(4),
                                              color: Theme.of(context).colorScheme.surface),
                                        ),
                                        handlerAnimation: const FlutterSliderHandlerAnimation(
                                            curve: Curves.elasticOut,
                                            reverseCurve: null,
                                            duration: Duration(milliseconds: 700),
                                            scale: 1.4),
                                        onDragging: (handlerIndex, lowerValue, upperValue) {
                                          lowerValue = lowerValue;
                                          upperValue = upperValue;
                                          setState(() {
                                            _position.value = lowerValue;
                                            lastPosition = lowerValue;
                                            audioPlayer.seek(Duration(seconds: _position.value.toInt()));
                                          });
                                        },
                                        handler: FlutterSliderHandler(
                                          decoration: const BoxDecoration(),
                                          child: Material(
                                            type: MaterialType.circle,
                                            color: Colors.transparent,
                                            elevation: 3,
                                            child: SvgPicture.asset('assets/svg/slider_ic.svg'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: Center(
                                          child: Text(_totalDuration,
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
                            ),
                          ),
                        ),
                      ],
                    );
                  }
              )),
        ),
      ),
    ));
  }

  Widget playWidgetLand(BuildContext context) {
    AudioCubit audioCubit = AudioCubit.get(context);
    return SlideTransition(
        position: audioCubit.offset,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64.0),
          child: Container(
            height: MediaQuery.of(context).size.height * 1 / 3 * .6,
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
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Stack(
                    children: [
                      Opacity(
                        opacity: .1,
                        child: SvgPicture.asset('assets/svg/surah_name/00$sorahNum.svg',
                          colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn),
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
                            colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn),
                            width: MediaQuery.of(context).size.width / 1 / 2,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          height: 120,
                          width: MediaQuery.of(context).size.width / 1 / 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
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
                                  skip_previous(context);
                                  setState(() {
                                    sorahNum--;
                                    intValue--;
                                    selectedSurah--;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 120,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: IconButton(
                                          onPressed: () {
                                            setState((){
                                              repeatSurahOnline = !repeatSurahOnline;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.repeat_one,
                                            color: repeatSurahOnline == true
                                                ? Theme.of(context).colorScheme.surface
                                                : Theme.of(context).colorScheme.surface.withOpacity(.4),
                                          )),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
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
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                if (loading)
                                                  Lottie.asset('assets/lottie/play_button.json',
                                                      width: 20, height: 20),
                                                if (!loading)
                                                  Icon(
                                                    isPlayOnline ? Icons.pause : Icons.online_prediction_outlined,
                                                    size: 24,
                                                    color: Theme.of(context).colorScheme.surface,
                                                  ),
                                              ],
                                            )
                                        ),
                                        onTap: () {
                                          playSorahOnline(context);
                                        },
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text(AppLocalizations.of(context)!.online,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'kufi',
                                            height: -1.5,
                                            color: Theme.of(context).dividerColor
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  height: 120,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: IconButton(
                                            onPressed: () {
                                              setState((){
                                                repeatSurah = !repeatSurah;
                                              });
                                            },
                                            icon: Icon(
                                              Icons.repeat_one,
                                              color: repeatSurah == true
                                                  ? Theme.of(context).colorScheme.surface
                                                  : Theme.of(context).colorScheme.surface.withOpacity(.4),
                                            )),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: GestureDetector(
                                          child: SquarePercentIndicator(
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
                                            child: downloading
                                                ? Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                progressString,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'kufi',
                                                    color: Theme.of(context).colorScheme.surface),
                                              ),
                                            )
                                                : Icon(
                                              isPlay
                                                  ? Icons.pause
                                                  : Icons.download_outlined,
                                              size: 24,
                                              color: Theme.of(context).colorScheme.surface,
                                            ),
                                          ),
                                          onTap: () {
                                            playSorah(context);
                                          },
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Text(AppLocalizations.of(context)!.download,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'kufi',
                                              height: -1.5,
                                              color: Theme.of(context).dividerColor
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
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
                                  skip_next(context);
                                  setState(() {
                                    sorahNum++;
                                    intValue++;
                                    selectedSurah++;
                                  });
                                },
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
                                  onPressed: () => sorahReaderDropDown(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: SizedBox(
                            height: 20,
                            width: MediaQuery.of(context).size.width / 1 / 2,
                            child: Row(
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
                                    child: FlutterSlider(
                                      values: [lastPosition == null ? _position.value : lastPosition],
                                      max: _duration.value,
                                      min: 0,
                                      rtl: true,
                                      trackBar: FlutterSliderTrackBar(
                                        inactiveTrackBarHeight: 5,
                                        activeTrackBarHeight: 5,
                                        inactiveTrackBar: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Theme.of(context).colorScheme.surface.withOpacity(.5),
                                        ),
                                        activeTrackBar: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4),
                                            color: Theme.of(context).colorScheme.surface),
                                      ),
                                      handlerAnimation: const FlutterSliderHandlerAnimation(
                                          curve: Curves.elasticOut,
                                          reverseCurve: null,
                                          duration: Duration(milliseconds: 700),
                                          scale: 1.4),
                                      onDragging: (handlerIndex, lowerValue, upperValue) {
                                        lowerValue = lowerValue;
                                        upperValue = upperValue;
                                        setState(() {
                                          _position.value = lowerValue;
                                          lastPosition = lowerValue;
                                          audioPlayer.seek(Duration(seconds: _position.value.toInt()));
                                        });
                                      },
                                      handler: FlutterSliderHandler(
                                        decoration: const BoxDecoration(),
                                        child: Material(
                                          type: MaterialType.circle,
                                          color: Colors.transparent,
                                          elevation: 3,
                                          child: SvgPicture.asset('assets/svg/slider_ic.svg'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Center(
                                        child: Text(_totalDuration,
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
                          ),
                        ),
                      ),
                    ],
                  );
                }
            ),
          ),
        ));
  }

  Widget surahList(BuildContext context) {
    AudioCubit audioCubit = AudioCubit.get(context);
    return Padding(
      padding: orientation(context,
          EdgeInsets.only(right: 16.0, left: 16.0, top: 300.0, bottom: 16.0),
          EdgeInsets.only(right: 16.0, left: 16.0, top: 16.0, bottom: 16.0)),
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
              padding: EdgeInsets.zero,
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
                                color: (index % 2 == 0
                                    ? selectedSurah == index ? Theme.of(context).cardColor.withOpacity(.2)
                                    : Theme.of(context)
                                    .colorScheme.background
                                    : selectedSurah == index ? Theme.of(context).cardColor.withOpacity(.2)
                                    : Theme.of(context)
                                    .dividerColor
                                    .withOpacity(.3)),
                              border: Border.all(
                                width: 2,
                                color: selectedSurah == index
                                    ? Theme.of(context).colorScheme.surface
                                    : Colors.transparent

                              )
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
                                            FontWeight.bold,
                                            height: 2),
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
                                        colorFilter: ColorFilter.mode(ThemeProvider
                                            .themeOf(
                                            context)
                                            .id ==
                                            'dark'
                                            ? Theme.of(context)
                                            .canvasColor
                                            : Theme.of(context)
                                            .primaryColorDark, BlendMode.srcIn),
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
                            selectedSurah = index;
                            sorahNum = index + 1;
                          });
                          switch (audioCubit
                              .controllerSorah
                              .status) {
                          // case AnimationStatus
                          //     .completed:
                          //   audioCubit
                          //       .controllerSorah
                          //       .reverse();
                          //   break;
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
    );
  }

  Widget surahSearch(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AnimSearchBar(
        width: orientation(context,
            MediaQuery.of(context).size.width * .75,
            300.0),
        textController: textController,
        rtl: true,
        textFieldColor: Theme.of(context).colorScheme.surface,
        helpText: AppLocalizations.of(context)!.searchToSurah,
        textFieldIconColor: Theme.of(context).canvasColor,
        searchIconColor: Theme.of(context).canvasColor,
        style: TextStyle(
            color: Theme.of(context).canvasColor,
            fontFamily: 'kufi',
            fontSize: 15),
        onSubmitted: (String value) {
          searchSurah(value);
        },
        autoFocus: false,
        color: Theme.of(context).colorScheme.surface,
        onSuffixTap: () {
          setState(() {
            textController.clear();
          });
        },
      ),
    );
  }

  Widget lastListen(BuildContext context) {
    AudioCubit audioCubit = AudioCubit.get(context);
    return GestureDetector(
      child: Container(
        width: orientation(context,
            MediaQuery.of(context).size.width * .75,
            300.0),
        height: 80,
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme.surface
              .withOpacity(.2),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        margin: orientation(context,
            EdgeInsets.only(top: 75.0, right: 16.0),
            EdgeInsets.only(top: 16.0, right: 16.0)),
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 30,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.all(Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.lastListen,
                    style: TextStyle(
                      fontFamily: 'kufi',
                      fontSize: 14,
                      color: Theme.of(context).canvasColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Divider(
                    endIndent: 8,
                    indent: 8,
                    height: 8,
                  ),
                  Icon(
                    Icons.record_voice_over_outlined,
                    color: Theme.of(context).canvasColor,
                    size: 22,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SvgPicture.asset(
                  'assets/svg/surah_name/00$sorahNum.svg',
                  width: 100,
                  colorFilter: ColorFilter.mode(
                      ThemeProvider.themeOf(context).id == 'dark'
                          ? Theme.of(context).canvasColor
                          : Theme.of(context).primaryColorLight,
                      BlendMode.srcIn
                  ),
                ),
                Text(
                  '| ${formatDuration(Duration(seconds: lastPosition.toInt()))} |',
                  style: TextStyle(
                    fontFamily: 'kufi',
                    fontSize: 14,
                    color: ThemeProvider.themeOf(context).id == 'dark'
                        ? Theme.of(context).canvasColor
                        : Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
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
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
