import 'package:alquranalkareem/audio_screen/controller/surah_audio_controller.dart';
import 'package:alquranalkareem/audio_screen/widget/download_play_button.dart';
import 'package:alquranalkareem/audio_screen/widget/online_play_button.dart';
import 'package:alquranalkareem/audio_screen/widget/skip_next.dart';
import 'package:alquranalkareem/audio_screen/widget/skip_previous.dart';
import 'package:alquranalkareem/audio_screen/widget/surah_seek_bar.dart';
import 'package:alquranalkareem/l10n/app_localizations.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';

import '../shared/controller/surah_repository_controller.dart';
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
  final SorahRepositoryController sorahRepositoryController =
      Get.put(SorahRepositoryController());

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
                      child: Obx(
                        () => Stack(
                          alignment: Alignment.center,
                          children: [
                            Opacity(
                              opacity: .1,
                              child: surahName(
                                context,
                                130,
                                width,
                              ),
                            ),
                            surahName(
                              context,
                              100,
                              width / 1 / 2,
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
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SkipToPrevious(),
                            OnlinePlayButton(),
                            DownloadPlayButton(),
                            SkipToNext(),
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
                        child: SurahSeekBar(),
                      ),
                    ),
                  ],
                );
              }), StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Stack(
                  children: [
                    Obx(
                      () => Opacity(
                        opacity: .1,
                        child: surahName(
                          context,
                          130,
                          width,
                        ),
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
                        child: Obx(() => surahName(
                              context,
                              70,
                              width / 1 / 2,
                            )),
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
                            SkipToPrevious(),
                            OnlinePlayButton(),
                            DownloadPlayButton(),
                            SkipToNext(),
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
                          child: SurahSeekBar(),
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
                    child: surahName(
                      context,
                      130,
                      width,
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
                      child: surahName(
                        context,
                        70,
                        width,
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
                          SkipToPrevious(),
                          OnlinePlayButton(),
                          DownloadPlayButton(),
                          SkipToNext(),
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
                        child: SurahSeekBar(),
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
          child: Obx(
            () => ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: sorahRepositoryController.sorahs.length,
                controller: surahAudioController.controller,
                padding: EdgeInsets.zero,
                itemBuilder: (_, index) {
                  final sorah = sorahRepositoryController.sorahs[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 450),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Obx(
                          () => GestureDetector(
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
                              print('Surah tapped with index: $index');
                              surahAudioController.isDownloading.value = false;
                              surahAudioController.selectedSurah.value = index;
                              surahAudioController.sorahNum.value = index + 1;
                              surahAudioController.playNextSurah();
                              surahAudioController.changeAudioSource();
                              print(
                                  'Updated sorahNum.value to: ${surahAudioController.sorahNum.value}');
                              switch (
                                  surahAudioController.controllerSorah.status) {
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
                    ),
                  );
                }),
          ),
        ),
      ),
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
            Obx(
              () => Row(
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
