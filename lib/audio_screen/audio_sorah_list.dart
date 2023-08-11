import 'package:alquranalkareem/audio_screen/controller/surah_audio_controller.dart';
import 'package:alquranalkareem/l10n/app_localizations.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/handler_animation.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../quran_page/data/model/sorah.dart';
import '../../shared/widgets/lottie.dart';
import '../cubit/sorahRepository/sorah_repository_cubit.dart';
import '../quran_page/cubit/audio/cubit.dart';
import '../shared/widgets/svg_picture.dart';
import '../shared/widgets/widgets.dart';

class AudioSorahList extends StatefulWidget {
  const AudioSorahList({super.key});

  @override
  _AudioSorahListState createState() => _AudioSorahListState();
}

class _AudioSorahListState extends State<AudioSorahList>
    with
        AutomaticKeepAliveClientMixin<AudioSorahList>,
        SingleTickerProviderStateMixin {
  late final SurahAudioController surahAudioController =
      Get.put(SurahAudioController());

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: SorahPlayScaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: platformView(
            orientation(
                context,
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Opacity(
                            opacity: .1,
                            child: quranIcon(context, height / 1 / 2, width),
                          ),
                          quranIcon(context, 100, width / 1 / 2),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: orientation(
                        context,
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
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: width / 1 / 2,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 96.0),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Opacity(
                                opacity: .1,
                                child:
                                    quranIcon(context, height / 1 / 2, width),
                              ),
                              quranIcon(context, 100, width / 1 / 2),
                              surahSearch(context),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: lastListen(context),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: width / 1 / 2,
                        child: surahList(context),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: playWidgetLand(context),
                    ),
                  ],
                )),
            Stack(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: width / 1 / 2,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(
                          opacity: .1,
                          child: quranIcon(context, height / 1 / 2, width),
                        ),
                        quranIcon(context, 100, width / 1 / 2),
                        surahSearch(context),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 32.0, horizontal: 16.0),
                    child: lastListen(context),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: width / 1 / 2,
                    child: surahList(context),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: playWidgetLand(context),
                ),
              ],
            )),
      ),
    );
  }

  Widget playWidget(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SlideTransition(
        position: surahAudioController.offset,
        child: Padding(
          padding: orientation(
              context,
              const EdgeInsets.symmetric(horizontal: 0.0),
              const EdgeInsets.symmetric(horizontal: 64.0)),
          child: Container(
            height: 260.0,
            width: width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12.0),
                  topLeft: Radius.circular(12.0)),
              border: Border.all(
                  width: 2, color: Theme.of(context).colorScheme.surface),
              color: Theme.of(context).colorScheme.background,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: orientation(context, StatefulBuilder(
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
                            child: SvgPicture.asset(
                              'assets/svg/surah_name/00${surahAudioController.sorahNum}.svg',
                              colorFilter: ColorFilter.mode(
                                  Theme.of(context).colorScheme.surface,
                                  BlendMode.srcIn),
                              width: width,
                            ),
                          ),
                          SvgPicture.asset(
                            'assets/svg/surah_name/00${surahAudioController.sorahNum}.svg',
                            height: 100,
                            colorFilter: ColorFilter.mode(
                                Theme.of(context).colorScheme.surface,
                                BlendMode.srcIn),
                            width: width / 1 / 2,
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(Icons.close_outlined,
                                  color: ThemeProvider.themeOf(context).id ==
                                          'dark'
                                      ? Theme.of(context).canvasColor
                                      : Theme.of(context).primaryColorDark),
                              onPressed: () => surahAudioController
                                  .controllerSorah
                                  .reverse(),
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
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
                                surahAudioController.skip_previous(context);
                                setState(() {
                                  surahAudioController.sorahNum--;
                                  surahAudioController.intValue--;
                                  surahAudioController.selectedSurah--;
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
                                            setState(() {
                                              surahAudioController
                                                      .repeatSurahOnline =
                                                  !surahAudioController
                                                      .repeatSurahOnline;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.repeat_one,
                                            color: surahAudioController
                                                        .repeatSurahOnline ==
                                                    true
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .surface
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .surface
                                                    .withOpacity(.4),
                                          )),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        height: 50,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        width: 50,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            borderRadius:
                                                const BorderRadius.only(
                                              topRight: Radius.circular(8),
                                              topLeft: Radius.circular(8),
                                            ),
                                            border: Border.all(
                                                width: 2,
                                                color: Theme.of(context)
                                                    .dividerColor)),
                                        child: StreamBuilder<PlayerState>(
                                            stream: surahAudioController
                                                .audioPlayer.playerStateStream,
                                            builder: (context, snapshot) {
                                              final playerState = snapshot.data;
                                              final processingState =
                                                  playerState?.processingState;
                                              final playing =
                                                  playerState?.playing;
                                              if (processingState ==
                                                  ProcessingState.idle) {
                                                return Icon(
                                                  Icons
                                                      .online_prediction_outlined,
                                                  size: 24,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                                );
                                              } else if (processingState ==
                                                  ProcessingState.loading) {
                                                return playButtonLottie(
                                                    20.0, 20.0);
                                              } else if (playing == true) {
                                                return Icon(
                                                  Icons.pause,
                                                  size: 24,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                                );
                                              } else if (playing != true) {
                                                return Icon(
                                                  Icons
                                                      .online_prediction_outlined,
                                                  size: 24,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                                );
                                              } else {
                                                return const SizedBox.shrink();
                                              }
                                            }),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        AppLocalizations.of(context)!.online,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'kufi',
                                            height: -1.5,
                                            color:
                                                Theme.of(context).dividerColor),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                surahAudioController.playSorahOnline(context);
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
                                            setState(() {
                                              surahAudioController.repeatSurah =
                                                  !surahAudioController
                                                      .repeatSurah;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.repeat_one,
                                            color: surahAudioController
                                                        .repeatSurah ==
                                                    true
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .surface
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .surface
                                                    .withOpacity(.4),
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
                                        progressColor:
                                            ThemeProvider.themeOf(context).id ==
                                                    'dark'
                                                ? Colors.white
                                                : Theme.of(context)
                                                    .primaryColorLight,
                                        progress:
                                            surahAudioController.progress.value,
                                        child: GestureDetector(
                                          child: Container(
                                              height: 50,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              width: 50,
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .background,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(8),
                                                    topLeft: Radius.circular(8),
                                                  ),
                                                  border: Border.all(
                                                      width: 2,
                                                      color: Theme.of(context)
                                                          .dividerColor)),
                                              child: surahAudioController
                                                      .downloading.value
                                                  ? Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        surahAudioController
                                                            .progressString
                                                            .value,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontFamily: 'kufi',
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .surface),
                                                      ),
                                                    )
                                                  : Icon(
                                                      surahAudioController
                                                              .isPlay.value
                                                          ? Icons.pause
                                                          : Icons
                                                              .download_outlined,
                                                      size: 24,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                    )),
                                          onTap: () {
                                            surahAudioController
                                                .playSorah(context);
                                          },
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        AppLocalizations.of(context)!.download,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'kufi',
                                            height: -1.5,
                                            color:
                                                Theme.of(context).dividerColor),
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
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
                                surahAudioController.skip_next(context);
                                setState(() {
                                  surahAudioController.sorahNum++;
                                  surahAudioController.intValue++;
                                  surahAudioController.selectedSurah++;
                                });
                              },
                            ),
                            Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
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
                                    child: Text(
                                  surahAudioController.currentTime,
                                  style: TextStyle(
                                    fontFamily: 'kufi',
                                    fontSize: 14,
                                    color: ThemeProvider.themeOf(context).id ==
                                            'dark'
                                        ? Theme.of(context).canvasColor
                                        : Theme.of(context).primaryColor,
                                  ),
                                ))),
                            Expanded(
                              flex: 6,
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                width: width,
                                child: FlutterSlider(
                                  values: [
                                    surahAudioController.lastPosition == false
                                        ? surahAudioController.position.value
                                        : surahAudioController.lastPosition
                                  ],
                                  max: surahAudioController.duration.value,
                                  min: 0,
                                  rtl: true,
                                  trackBar: FlutterSliderTrackBar(
                                    inactiveTrackBarHeight: 5,
                                    activeTrackBarHeight: 5,
                                    inactiveTrackBar: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface
                                          .withOpacity(.5),
                                    ),
                                    activeTrackBar: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface),
                                  ),
                                  handlerAnimation:
                                      const FlutterSliderHandlerAnimation(
                                          curve: Curves.elasticOut,
                                          reverseCurve: null,
                                          duration: Duration(milliseconds: 700),
                                          scale: 1.4),
                                  onDragging:
                                      (handlerIndex, lowerValue, upperValue) {
                                    lowerValue = lowerValue;
                                    upperValue = upperValue;
                                    setState(() {
                                      surahAudioController.position.value =
                                          lowerValue;
                                      surahAudioController.lastPosition =
                                          lowerValue;
                                      surahAudioController.audioPlayer.seek(
                                          Duration(
                                              seconds: surahAudioController
                                                  .position.value
                                                  .toInt()));
                                    });
                                  },
                                  handler: FlutterSliderHandler(
                                    decoration: const BoxDecoration(),
                                    child: Material(
                                      type: MaterialType.circle,
                                      color: Colors.transparent,
                                      elevation: 3,
                                      child: SvgPicture.asset(
                                          'assets/svg/slider_ic.svg'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 2,
                                child: Center(
                                    child: Text(
                                  surahAudioController.totalDuration,
                                  style: TextStyle(
                                    fontFamily: 'kufi',
                                    fontSize: 14,
                                    color: ThemeProvider.themeOf(context).id ==
                                            'dark'
                                        ? Theme.of(context).canvasColor
                                        : Theme.of(context).primaryColor,
                                  ),
                                ))),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }), StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Stack(
                  children: [
                    Opacity(
                      opacity: .1,
                      child: SvgPicture.asset(
                        'assets/svg/surah_name/00${surahAudioController.sorahNum}.svg',
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.surface,
                            BlendMode.srcIn),
                        width: width,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(Icons.close_outlined,
                            color: ThemeProvider.themeOf(context).id == 'dark'
                                ? Theme.of(context).canvasColor
                                : Theme.of(context).primaryColorDark),
                        onPressed: () =>
                            surahAudioController..controllerSorah.reverse(),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 23.0),
                        child: SvgPicture.asset(
                          'assets/svg/surah_name/00${surahAudioController.sorahNum}.svg',
                          height: 70,
                          colorFilter: ColorFilter.mode(
                              Theme.of(context).colorScheme.surface,
                              BlendMode.srcIn),
                          width: width / 1 / 2,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        height: 120,
                        width: width / 1 / 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Visibility(
                              visible: surahAudioController.downloading.value,
                              child: Text(
                                surahAudioController.progressString.value,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'kufi',
                                    color:
                                        Theme.of(context).colorScheme.surface),
                              ),
                            ),
                            GestureDetector(
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
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
                                surahAudioController.skip_previous(context);
                                setState(() {
                                  surahAudioController.sorahNum--;
                                  surahAudioController.intValue--;
                                  surahAudioController.selectedSurah--;
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
                                          setState(() {
                                            surahAudioController
                                                    .repeatSurahOnline =
                                                !surahAudioController
                                                    .repeatSurahOnline;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.repeat_one,
                                          color: surahAudioController
                                                      .repeatSurahOnline ==
                                                  true
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .surface
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .surface
                                                  .withOpacity(.4),
                                        )),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      child: Container(
                                        height: 50,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        width: 50,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            borderRadius:
                                                const BorderRadius.only(
                                              topRight: Radius.circular(8),
                                              topLeft: Radius.circular(8),
                                            ),
                                            border: Border.all(
                                                width: 2,
                                                color: Theme.of(context)
                                                    .dividerColor)),
                                        child: StreamBuilder<PlayerState>(
                                            stream: surahAudioController
                                                .audioPlayer.playerStateStream,
                                            builder: (context, snapshot) {
                                              final playerState = snapshot.data;
                                              final processingState =
                                                  playerState?.processingState;
                                              final playing =
                                                  playerState?.playing;
                                              if (processingState ==
                                                  ProcessingState.idle) {
                                                return Icon(
                                                  Icons
                                                      .online_prediction_outlined,
                                                  size: 24,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                                );
                                              } else if (processingState ==
                                                  ProcessingState.loading) {
                                                return playButtonLottie(
                                                    20.0, 20.0);
                                              } else if (playing == true) {
                                                return Icon(
                                                  Icons.pause,
                                                  size: 24,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                                );
                                              } else if (playing != true) {
                                                return Icon(
                                                  Icons
                                                      .online_prediction_outlined,
                                                  size: 24,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                                );
                                              } else {
                                                return const SizedBox.shrink();
                                              }
                                            }),
                                      ),
                                      onTap: () {
                                        surahAudioController
                                            .playSorahOnline(context);
                                      },
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      AppLocalizations.of(context)!.online,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'kufi',
                                          height: -1.5,
                                          color:
                                              Theme.of(context).dividerColor),
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
                                            setState(() {
                                              surahAudioController.repeatSurah =
                                                  !surahAudioController
                                                      .repeatSurah;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.repeat_one,
                                            color: surahAudioController
                                                        .repeatSurah ==
                                                    true
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .surface
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .surface
                                                    .withOpacity(.4),
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
                                        progressColor:
                                            ThemeProvider.themeOf(context).id ==
                                                    'dark'
                                                ? Colors.white
                                                : Theme.of(context)
                                                    .primaryColorLight,
                                        progress:
                                            surahAudioController.progress.value,
                                        child: GestureDetector(
                                          child: surahAudioController
                                                  .downloading.value
                                              ? Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    surahAudioController
                                                        .progressString.value,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'kufi',
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .surface),
                                                  ),
                                                )
                                              : Icon(
                                                  surahAudioController
                                                          .isPlay.value
                                                      ? Icons.pause
                                                      : Icons.download_outlined,
                                                  size: 24,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                                ),
                                          onTap: () {
                                            surahAudioController
                                                .playSorah(context);
                                          },
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        AppLocalizations.of(context)!.download,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'kufi',
                                            height: -1.5,
                                            color:
                                                Theme.of(context).dividerColor),
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
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
                                surahAudioController.skip_next(context);
                                setState(() {
                                  surahAudioController.sorahNum++;
                                  surahAudioController.intValue++;
                                  surahAudioController.selectedSurah++;
                                });
                              },
                            ),
                            Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
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
                          width: width / 1 / 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Center(
                                      child: Text(
                                    surahAudioController.currentTime,
                                    style: TextStyle(
                                      color: ThemeProvider.themeOf(context)
                                                  .id ==
                                              'dark'
                                          ? Theme.of(context).canvasColor
                                          : Theme.of(context).primaryColorLight,
                                    ),
                                  ))),
                              Expanded(
                                flex: 6,
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  width: width,
                                  child: FlutterSlider(
                                    values: [
                                      // ignore: unnecessary_null_comparison
                                      surahAudioController.lastPosition == null
                                          ? surahAudioController.position.value
                                          : surahAudioController.lastPosition
                                    ],
                                    max: surahAudioController.duration.value,
                                    min: 0,
                                    rtl: true,
                                    trackBar: FlutterSliderTrackBar(
                                      inactiveTrackBarHeight: 5,
                                      activeTrackBarHeight: 5,
                                      inactiveTrackBar: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface
                                            .withOpacity(.5),
                                      ),
                                      activeTrackBar: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface),
                                    ),
                                    handlerAnimation:
                                        const FlutterSliderHandlerAnimation(
                                            curve: Curves.elasticOut,
                                            reverseCurve: null,
                                            duration:
                                                Duration(milliseconds: 700),
                                            scale: 1.4),
                                    onDragging:
                                        (handlerIndex, lowerValue, upperValue) {
                                      lowerValue = lowerValue;
                                      upperValue = upperValue;
                                      setState(() {
                                        surahAudioController.position.value =
                                            lowerValue;
                                        surahAudioController.lastPosition =
                                            lowerValue;
                                        surahAudioController.audioPlayer.seek(
                                            Duration(
                                                seconds: surahAudioController
                                                    .position.value
                                                    .toInt()));
                                      });
                                    },
                                    handler: FlutterSliderHandler(
                                      decoration: const BoxDecoration(),
                                      child: Material(
                                        type: MaterialType.circle,
                                        color: Colors.transparent,
                                        elevation: 3,
                                        child: SvgPicture.asset(
                                            'assets/svg/slider_ic.svg'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Center(
                                      child: Text(
                                    surahAudioController.totalDuration,
                                    style: TextStyle(
                                      color: ThemeProvider.themeOf(context)
                                                  .id ==
                                              'dark'
                                          ? Theme.of(context).canvasColor
                                          : Theme.of(context).primaryColorLight,
                                    ),
                                  ))),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              })),
            ),
          ),
        ));
  }

  Widget playWidgetLand(BuildContext context) {
    AudioCubit audioCubit = AudioCubit.get(context);
    double width = MediaQuery.of(context).size.width;
    return SlideTransition(
        position: surahAudioController.offset,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64.0),
          child: Container(
            height: 160,
            width: width,
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
                    child: SvgPicture.asset(
                      'assets/svg/surah_name/00${surahAudioController.sorahNum}.svg',
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.surface,
                          BlendMode.srcIn),
                      width: width,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.close_outlined,
                          color: ThemeProvider.themeOf(context).id == 'dark'
                              ? Theme.of(context).canvasColor
                              : Theme.of(context).primaryColorDark),
                      onPressed: () =>
                          surahAudioController.controllerSorah.reverse(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 23.0),
                      child: SvgPicture.asset(
                        'assets/svg/surah_name/00${surahAudioController.sorahNum}.svg',
                        height: 70,
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.surface,
                            BlendMode.srcIn),
                        width: width / 1 / 2,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      height: 120,
                      width: width / 1 / 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.background,
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
                              surahAudioController.skip_previous(context);
                              setState(() {
                                surahAudioController.sorahNum--;
                                surahAudioController.intValue--;
                                surahAudioController.selectedSurah--;
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
                                        setState(() {
                                          surahAudioController
                                                  .repeatSurahOnline =
                                              !surahAudioController
                                                  .repeatSurahOnline;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.repeat_one,
                                        color: surahAudioController
                                                    .repeatSurahOnline ==
                                                true
                                            ? Theme.of(context)
                                                .colorScheme
                                                .surface
                                            : Theme.of(context)
                                                .colorScheme
                                                .surface
                                                .withOpacity(.4),
                                      )),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    child: Container(
                                      height: 50,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(8),
                                            topLeft: Radius.circular(8),
                                          ),
                                          border: Border.all(
                                              width: 2,
                                              color: Theme.of(context)
                                                  .dividerColor)),
                                      child: StreamBuilder<PlayerState>(
                                          stream: surahAudioController
                                              .audioPlayer.playerStateStream,
                                          builder: (context, snapshot) {
                                            final playerState = snapshot.data;
                                            final processingState =
                                                playerState?.processingState;
                                            final playing =
                                                playerState?.playing;
                                            if (processingState ==
                                                ProcessingState.idle) {
                                              return Icon(
                                                Icons
                                                    .online_prediction_outlined,
                                                size: 24,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface,
                                              );
                                            } else if (processingState ==
                                                ProcessingState.loading) {
                                              return playButtonLottie(
                                                  20.0, 20.0);
                                            } else if (playing == true) {
                                              return Icon(
                                                Icons.pause,
                                                size: 24,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface,
                                              );
                                            } else if (playing != true) {
                                              return Icon(
                                                Icons
                                                    .online_prediction_outlined,
                                                size: 24,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface,
                                              );
                                            } else {
                                              return const SizedBox.shrink();
                                            }
                                          }),
                                    ),
                                    onTap: () {
                                      surahAudioController
                                          .playSorahOnline(context);
                                    },
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    AppLocalizations.of(context)!.online,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'kufi',
                                        height: -1.5,
                                        color: Theme.of(context).dividerColor),
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
                                          setState(() {
                                            surahAudioController.repeatSurah =
                                                !surahAudioController
                                                    .repeatSurah;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.repeat_one,
                                          color: surahAudioController
                                                      .repeatSurah ==
                                                  true
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .surface
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .surface
                                                  .withOpacity(.4),
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
                                        progressColor:
                                            ThemeProvider.themeOf(context).id ==
                                                    'dark'
                                                ? Colors.white
                                                : Theme.of(context)
                                                    .primaryColorLight,
                                        progress:
                                            surahAudioController.progress.value,
                                        child: surahAudioController
                                                .downloading.value
                                            ? Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  surahAudioController
                                                      .progressString.value,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'kufi',
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .surface),
                                                ),
                                              )
                                            : Icon(
                                                surahAudioController
                                                        .isPlay.value
                                                    ? Icons.pause
                                                    : Icons.download_outlined,
                                                size: 24,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface,
                                              ),
                                      ),
                                      onTap: () {
                                        surahAudioController.playSorah(context);
                                      },
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      AppLocalizations.of(context)!.download,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'kufi',
                                          height: -1.5,
                                          color:
                                              Theme.of(context).dividerColor),
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
                                  color:
                                      Theme.of(context).colorScheme.background,
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
                              surahAudioController.skip_next(context);
                              setState(() {
                                surahAudioController.sorahNum++;
                                surahAudioController.intValue++;
                                surahAudioController.selectedSurah++;
                              });
                            },
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
                        width: width / 1 / 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                flex: 2,
                                child: Center(
                                    child: Text(
                                  surahAudioController.currentTime,
                                  style: TextStyle(
                                    color: ThemeProvider.themeOf(context).id ==
                                            'dark'
                                        ? Theme.of(context).canvasColor
                                        : Theme.of(context).primaryColorLight,
                                  ),
                                ))),
                            Expanded(
                              flex: 6,
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                width: width,
                                child: FlutterSlider(
                                  values: [
                                    // ignore: unnecessary_null_comparison
                                    surahAudioController.lastPosition == null
                                        ? surahAudioController.position.value
                                        : surahAudioController.lastPosition
                                  ],
                                  max: surahAudioController.duration.value,
                                  min: 0,
                                  rtl: true,
                                  trackBar: FlutterSliderTrackBar(
                                    inactiveTrackBarHeight: 5,
                                    activeTrackBarHeight: 5,
                                    inactiveTrackBar: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface
                                          .withOpacity(.5),
                                    ),
                                    activeTrackBar: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface),
                                  ),
                                  handlerAnimation:
                                      const FlutterSliderHandlerAnimation(
                                          curve: Curves.elasticOut,
                                          reverseCurve: null,
                                          duration: Duration(milliseconds: 700),
                                          scale: 1.4),
                                  onDragging:
                                      (handlerIndex, lowerValue, upperValue) {
                                    lowerValue = lowerValue;
                                    upperValue = upperValue;
                                    setState(() {
                                      surahAudioController.position.value =
                                          lowerValue;
                                      surahAudioController.lastPosition =
                                          lowerValue;
                                      surahAudioController.audioPlayer.seek(
                                          Duration(
                                              seconds: surahAudioController
                                                  .position.value
                                                  .toInt()));
                                    });
                                  },
                                  handler: FlutterSliderHandler(
                                    decoration: const BoxDecoration(),
                                    child: Material(
                                      type: MaterialType.circle,
                                      color: Colors.transparent,
                                      elevation: 3,
                                      child: SvgPicture.asset(
                                          'assets/svg/slider_ic.svg'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 2,
                                child: Center(
                                    child: Text(
                                  surahAudioController.totalDuration,
                                  style: TextStyle(
                                    color: ThemeProvider.themeOf(context).id ==
                                            'dark'
                                        ? Theme.of(context).canvasColor
                                        : Theme.of(context).primaryColorLight,
                                  ),
                                ))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ));
  }

  Widget surahList(BuildContext context) {
    AudioCubit audioCubit = AudioCubit.get(context);
    return BlocBuilder<SorahRepositoryCubit, List<Sorah>?>(
      builder: (context, state) {
        if (state == null) {
          return Center(
            child: loadingLottie(200.0, 200.0),
          );
        }
        return Padding(
          padding: orientation(
              context,
              const EdgeInsets.only(
                  right: 16.0, left: 16.0, top: 300.0, bottom: 16.0),
              const EdgeInsets.only(
                  right: 16.0, left: 16.0, top: 16.0, bottom: 16.0)),
          child: AnimationLimiter(
            child: Scrollbar(
              thumbVisibility: true,
              // interactive: true,
              controller: surahAudioController.controller,
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state.length,
                  controller: surahAudioController.controller,
                  padding: EdgeInsets.zero,
                  itemBuilder: (_, index) {
                    final sorah = state[index];
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
                                        ? surahAudioController.selectedSurah ==
                                                index
                                            ? Theme.of(context)
                                                .cardColor
                                                .withOpacity(.2)
                                            : Theme.of(context)
                                                .colorScheme
                                                .background
                                        : surahAudioController.selectedSurah ==
                                                index
                                            ? Theme.of(context)
                                                .cardColor
                                                .withOpacity(.2)
                                            : Theme.of(context)
                                                .dividerColor
                                                .withOpacity(.3)),
                                    border: Border.all(
                                        width: 2,
                                        color: surahAudioController
                                                    .selectedSurah ==
                                                index
                                            ? Theme.of(context)
                                                .colorScheme
                                                .surface
                                            : Colors.transparent)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
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
                                            "${surahAudioController.arabicNumber.convert(sorah.id)}",
                                            style: TextStyle(
                                                color: ThemeProvider.themeOf(
                                                                context)
                                                            .id ==
                                                        'dark'
                                                    ? Theme.of(context)
                                                        .canvasColor
                                                    : Theme.of(context)
                                                        .primaryColorLight,
                                                fontFamily: "kufi",
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                height: 2),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 100,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/svg/surah_name/00${index + 1}.svg',
                                            colorFilter: ColorFilter.mode(
                                                ThemeProvider.themeOf(context)
                                                            .id ==
                                                        'dark'
                                                    ? Theme.of(context)
                                                        .canvasColor
                                                    : Theme.of(context)
                                                        .primaryColorDark,
                                                BlendMode.srcIn),
                                            width: 100,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Text(
                                              sorah.nameEn,
                                              style: TextStyle(
                                                fontFamily: "naskh",
                                                fontWeight: FontWeight.w600,
                                                fontSize: 10,
                                                color: ThemeProvider.themeOf(
                                                                context)
                                                            .id ==
                                                        'dark'
                                                    ? Theme.of(context)
                                                        .canvasColor
                                                    : Theme.of(context)
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
                                surahAudioController.selectedSurah.value =
                                    index;
                                surahAudioController.sorahNum.value = index + 1;
                              });
                              switch (
                                  surahAudioController.controllerSorah.status) {
                                // case AnimationStatus
                                //     .completed:
                                //   audioCubit
                                //       .controllerSorah
                                //       .reverse();
                                //   break;
                                case AnimationStatus.dismissed:
                                  surahAudioController.controllerSorah
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
          ),
        );
      },
    );
  }

  Widget surahSearch(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AnimSearchBar(
        width: orientation(context, width * .75, 300.0),
        textController: surahAudioController.textController,
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
          surahAudioController.searchSurah(context, value);
        },
        autoFocus: false,
        color: Theme.of(context).colorScheme.surface,
        onSuffixTap: () {
          setState(() {
            surahAudioController.textController.clear();
          });
        },
      ),
    );
  }

  Widget lastListen(BuildContext context) {
    AudioCubit audioCubit = AudioCubit.get(context);
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      child: Container(
        width: orientation(context, width * .75, 300.0),
        height: 80,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(.2),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        margin: orientation(
            context,
            const EdgeInsets.only(top: 75.0, right: 16.0),
            const EdgeInsets.only(bottom: 16.0, left: 32.0)),
        child: Column(
          children: <Widget>[
            Container(
              width: width,
              height: 30,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
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
                  const Divider(
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
                  'assets/svg/surah_name/00${surahAudioController.sorahNum}.svg',
                  width: 100,
                  colorFilter: ColorFilter.mode(
                      ThemeProvider.themeOf(context).id == 'dark'
                          ? Theme.of(context).canvasColor
                          : Theme.of(context).primaryColorLight,
                      BlendMode.srcIn),
                ),
                Text(
                  '| ${surahAudioController.formatDuration(Duration(seconds: surahAudioController.lastPosition.toInt()))} |',
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
        surahAudioController.controller
            .jumpTo((surahAudioController.sorahNum.value - 1) * 65.0);
        switch (surahAudioController.controllerSorah.status) {
          case AnimationStatus.completed:
            surahAudioController.controllerSorah.reverse();
            break;
          case AnimationStatus.dismissed:
            surahAudioController.controllerSorah.forward();
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
