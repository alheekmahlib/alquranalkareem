import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mini_music_visualizer/mini_music_visualizer.dart';
import 'package:spring/spring.dart';
import 'package:theme_provider/theme_provider.dart';

import '../audio_screen/widget/download_play_button.dart';
import '../audio_screen/widget/online_play_button.dart';
import '../audio_screen/widget/skip_next.dart';
import '../audio_screen/widget/skip_previous.dart';
import '../audio_screen/widget/surah_seek_bar.dart';
import '../l10n/app_localizations.dart';
import '../shared/widgets/controllers_put.dart';
import '../shared/widgets/svg_picture.dart';
import '../shared/widgets/widgets.dart';

class AudioSorahList extends StatelessWidget {
  const AudioSorahList({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    springController = SpringController(initialAnim: Motion.play);
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
    return Spring.slide(
        springController: springController,
        slideType: SlideType.slide_in_bottom,
        delay: const Duration(milliseconds: 0),
        animDuration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        extend: 500,
        withFade: false,
        child: Padding(
          padding: orientation(
              context,
              const EdgeInsets.symmetric(horizontal: 0.0),
              const EdgeInsets.symmetric(horizontal: 64.0)),
          child: Container(
            height: 240.0,
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
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customClose(
                          context,
                          close: () =>
                              springController.play(motion: Motion.reverse),
                        ),
                        Obx(
                          () => Stack(
                            alignment: Alignment.center,
                            children: [
                              Opacity(
                                opacity: .1,
                                child: surahName(
                                  context,
                                  90,
                                  150,
                                ),
                              ),
                              surahName(
                                context,
                                70,
                                150,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              border: Border.all(
                                  color: Theme.of(context).colorScheme.surface,
                                  width: 1)),
                          child: IconButton(
                            icon: Icon(Icons.person_search_outlined,
                                size: 20,
                                color: Theme.of(context).colorScheme.surface),
                            onPressed: () => sorahReaderDropDown(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(flex: 8, child: SurahSeekBar()),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 32.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Expanded(flex: 1, child: DownloadPlayButton()),
                          Expanded(
                            flex: 7,
                            child: Row(
                              children: [
                                Expanded(flex: 1, child: SkipToPrevious()),
                                OnlinePlayButton(),
                                Expanded(flex: 1, child: SkipToNext()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                        padding: EdgeInsets.only(top: 32.0),
                        child: DownloadPlayButton()),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget playWidgetLand(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Spring.slide(
        springController: springController,
        slideType: SlideType.slide_in_bottom,
        delay: const Duration(milliseconds: 0),
        animDuration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        extend: 500,
        withFade: false,
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
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerRight,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 23.0),
                          child: surahName(
                            context,
                            70,
                            width,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: customClose(
                    context,
                    close: () => springController.play(motion: Motion.reverse),
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
                        const SkipToPrevious(),
                        const OnlinePlayButton(),
                        const SkipToNext(),
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
                            onPressed: () => sorahReaderDropDown(context),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: DownloadPlayButton(),
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
                      child: const SurahSeekBar(),
                    ),
                  ),
                ),
              ],
            ),
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
                                        ? surahAudioController
                                                    .selectedSurah.value ==
                                                index
                                            ? Theme.of(context)
                                                .cardColor
                                                .withOpacity(.2)
                                            : Theme.of(context)
                                                .colorScheme
                                                .background
                                        : surahAudioController
                                                    .selectedSurah.value ==
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
                                      Expanded(
                                        flex: 2,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              SizedBox(
                                                  height: 40,
                                                  width: 40,
                                                  child: SvgPicture.asset(
                                                    'assets/svg/sora_num.svg',
                                                  )),
                                              Text(
                                                surahAudioController
                                                    .arabicNumber
                                                    .convert(sorah.id),
                                                style: TextStyle(
                                                    color: ThemeProvider
                                                                    .themeOf(
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
                                        ),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Column(
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
                                      ),
                                      if (index + 1 ==
                                          surahAudioController.sorahNum.value)
                                        MiniMusicVisualizer(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          width: 4,
                                          height: 15,
                                        ),
                                    ],
                                  ),
                                )),
                            onTap: () {
                              print('Surah tapped with index: $index');
                              springController.play(motion: Motion.play);
                              surahAudioController.isDownloading.value = false;
                              surahAudioController.selectedSurah.value = index;
                              surahAudioController.sorahNum.value = index + 1;
                              surahAudioController.playNextSurah();
                              surahAudioController.changeAudioSource();
                              print(
                                  'Updated sorahNum.value to: ${surahAudioController.sorahNum.value}');
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
          surahAudioController.textController.clear();
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
        springController.play(motion: Motion.play);
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
