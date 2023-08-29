import 'package:alquranalkareem/quran_text/Widgets/text_overflow_detector.dart';
import 'package:alquranalkareem/quran_text/Widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/widgets/controllers_put.dart';
import '../../shared/widgets/lottie.dart';
import '../../shared/widgets/show_tafseer.dart';
import '../../shared/widgets/svg_picture.dart';
import '../../shared/widgets/widgets.dart';
import '../text_page_view.dart';

class SingleAyah extends StatelessWidget {
  final surah;
  final int index;
  final int nomPageF;
  final int nomPageL;
  const SingleAyah(
      {super.key,
      required this.surah,
      required this.index,
      required this.nomPageF,
      required this.nomPageL});

  @override
  Widget build(BuildContext context) {
    Color backColor = Theme.of(context).colorScheme.surface.withOpacity(0.4);
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            quranTextController.controller.reverse();
            backColor = Colors.transparent;
          },
          // child: AutoScrollTag(
          //   key: ValueKey(index),
          //   controller: quranTextController.scrollController!,
          //   index: index,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.all(Radius.circular(4))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: spaceLine(
                      20,
                      MediaQuery.of(context).size.width / 1 / 2,
                    ),
                  ),
                ),
                surah!.number == 9
                    ? const SizedBox.shrink()
                    : surah!.ayahs![index].numberInSurah == 1
                        ? besmAllah(context)
                        : const SizedBox.shrink(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Obx(
                    () => SelectableText.rich(
                      showCursor: true,
                      cursorWidth: 3,
                      cursorColor: Theme.of(context).dividerColor,
                      cursorRadius: const Radius.circular(5),
                      scrollPhysics: const ClampingScrollPhysics(),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.justify,
                      TextSpan(children: [
                        TextSpan(
                            text: surah!.ayahs![index].text!,
                            style: TextStyle(
                              fontSize: generalController.fontSizeArabic.value,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'uthmanic2',
                              color: ThemeProvider.themeOf(context).id == 'dark'
                                  ? Colors.white
                                  : Colors.black,
                              background: Paint()
                                ..color =
                                    index == audioController.ayahSelected.value
                                        ? quranTextController.selected.value
                                            ? backColor
                                            : Colors.transparent
                                        : Colors.transparent
                                ..strokeJoin = StrokeJoin.round
                                ..strokeCap = StrokeCap.round
                                ..style = PaintingStyle.fill,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTapDown = (TapDownDetails details) {
                                quranTextController.selected.value =
                                    !quranTextController.selected.value;
                                // lastAyahInPage =
                                //     surah!.ayahs![index].numberInSurah;
                                textSurahNum = surah!.number;
                                backColor = Colors.transparent;
                                ayatController.sorahTextNumber =
                                    surah!.number!.toString();
                                ayatController.ayahTextNumber = surah!
                                    .ayahs![index].numberInSurah
                                    .toString();
                                audioController.ayahSelected.value = index;
                                menu(
                                    context,
                                    index,
                                    index,
                                    details,
                                    translateController.data,
                                    surah,
                                    nomPageF,
                                    nomPageL);
                              }),
                        TextSpan(
                          text:
                              ' ${arabicNumber.convert(surah!.ayahs![index].numberInSurah.toString())}',
                          style: TextStyle(
                            fontSize:
                                generalController.fontSizeArabic.value + 5,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'uthmanic2',
                            color: ThemeProvider.themeOf(context).id == 'dark'
                                ? Theme.of(context).colorScheme.surface
                                : Theme.of(context).primaryColorLight,
                          ),
                        )
                      ]),
                      contextMenuBuilder: buildMyContextMenuText(),
                      onSelectionChanged: handleSelectionChanged,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(
                                Icons.translate_rounded,
                                color: Theme.of(context).colorScheme.surface,
                                size: 24,
                              ),
                              onPressed: () => translateDropDown(context),
                            )),
                        spaceLine(
                          20,
                          MediaQuery.of(context).size.width / 1 / 2,
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: juzNumEn(
                            'Part\n${surah!.ayahs![index].juz}',
                            context,
                            ThemeProvider.themeOf(context).id == 'dark'
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 16.0, right: 32.0, left: 32.0),
                  child: Obx(
                    () {
                      if (translateController.isLoading.value) {
                        return search(50.0, 50.0);
                      }
                      return ReadMoreLess(
                        text: (surah!.ayahs!.length > index &&
                                translateController.data.length >
                                    surah!.ayahs![index].number - 1)
                            ? translateController
                                        .data[surah!.ayahs![index].number - 1]
                                    ['text'] ??
                                ''
                            : '',
                        textStyle: TextStyle(
                          fontSize: generalController.fontSizeArabic.value - 10,
                          fontFamily: 'kufi',
                          color: ThemeProvider.themeOf(context).id == 'dark'
                              ? Colors.white
                              : Colors.black,
                        ),
                        textAlign: TextAlign.center,
                        readMoreText: AppLocalizations.of(context)!.readMore,
                        readLessText: AppLocalizations.of(context)!.readLess,
                        buttonTextStyle: TextStyle(
                          fontSize: 12,
                          fontFamily: 'kufi',
                          color: ThemeProvider.themeOf(context).id == 'dark'
                              ? Colors.white
                              : Theme.of(context).primaryColorLight,
                        ),
                        iconColor: ThemeProvider.themeOf(context).id == 'dark'
                            ? Colors.white
                            : Theme.of(context).primaryColorLight,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: juzNum(
                '${surah!.ayahs![index].juz}',
                context,
                ThemeProvider.themeOf(context).id == 'dark'
                    ? Colors.white
                    : Colors.black,
                25),
          ),
        ),
      ],
    );
  }
}
