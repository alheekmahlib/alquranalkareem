import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../quran_text/Widgets/page_ayah.dart';
import '../../quran_text/Widgets/single_ayah.dart';
import '../../quran_text/Widgets/widgets.dart';
import '../../shared/widgets/controllers_put.dart';
import '../text_page_view.dart';

class ScrollableList extends StatefulWidget {
  final surah;
  final int nomPageF;
  final int nomPageL;
  const ScrollableList(
      {super.key,
      required this.surah,
      required this.nomPageF,
      required this.nomPageL});

  @override
  State<ScrollableList> createState() => _ScrollableListState();
}

class _ScrollableListState extends State<ScrollableList> {
  Color? backColor;

  Color determineColor(int b) {
    return quranTextController.selected.value == true
        ? audioController.ayahSelected.value == b
            ? backColor!
            : Colors.transparent
        : Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    backColor = Theme.of(context).colorScheme.surface.withOpacity(0.4);
    return Obx(
      () => ScrollablePositionedList.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemScrollController: quranTextController.itemScrollController,
        itemPositionsListener: quranTextController.itemPositionsListener,
        itemCount: quranTextController.value == 1
            ? widget.surah!.ayahs!.length
            : (widget.nomPageL - widget.nomPageF) + 1,
        itemBuilder: (context, index) {
          List<InlineSpan> text = [];
          int ayahLenght = widget.surah!.ayahs!.length;
          if (quranTextController.value == 1) {
            for (int index = 0; index < ayahLenght; index++) {
              if (widget.surah!.ayahs![index].text!.length > 1) {
                quranTextController.sajda2 = widget.surah!.ayahs![index].sajda;
                lastAyah = widget.surah!.ayahs!.last.numberInSurah;
              }
            }
          } else {
            for (int b = 0; b < ayahLenght; b++) {
              if (widget.surah!.ayahs![b].text!.length > 1) {
                if (widget.surah!.ayahs![b].page == (index + widget.nomPageF)) {
                  quranTextController.juz =
                      widget.surah!.ayahs![b].juz.toString();
                  quranTextController.sajda = widget.surah!.ayahs![b].sajda;
                  // text2 = surah!.ayahs![b].text! as List<String>;
                  text.add(TextSpan(children: [
                    TextSpan(
                        text: widget.surah!.ayahs![b].text!,
                        style: TextStyle(
                            fontSize: generalController.fontSizeArabic.value,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'uthmanic2',
                            color: ThemeProvider.themeOf(context).id == 'dark'
                                ? Colors.white
                                : Colors.black,
                            background: Paint()
                              // ..color = () {
                              //   int? ayahNumber;
                              //   if (audioController.ayahSelected.value != -1 &&
                              //       surah!.ayahs!.length >=
                              //           audioController.ayahSelected.value) {
                              //     ayahNumber =
                              //         audioController.ayahSelected.value;
                              //   }
                              //   return surah!.ayahs![b].numberInSurah ==
                              //           audioController.ayahSelected.value
                              //       ? quranTextController.selected.value
                              //           ? backColor
                              //           : Colors.transparent
                              //       : Colors.transparent;
                              // }()!
                              ..color =
                                  quranTextController.selected.value == true
                                      ? audioController.ayahSelected.value == b
                                          ? backColor!
                                          : Colors.transparent
                                      : Colors.transparent
                              // ..color = b == audioController.ayahSelected.value
                              //     ? quranTextController.selected.value
                              //         ? backColor!
                              //         : Colors.transparent
                              //     : Colors.transparent
                              ..strokeJoin = StrokeJoin.round
                              ..strokeCap = StrokeCap.round
                              ..style = PaintingStyle.fill),
                        recognizer: TapGestureRecognizer()
                          ..onTapDown = (TapDownDetails details) {
                            print(
                                'audioController.ayahSelected.value ${audioController.ayahSelected.value}');
                            print('b $b');
                            textText = text.map((e) => e).toString();
                            textTitle = text.map((e) => e).toString();
                            audioController.lastAyahInPage.value =
                                widget.surah!.ayahs![b].numberInSurah!;
                            pageN = widget.surah!.ayahs![b].pageInSurah! - 1;
                            textSurahNum = widget.surah!.number;
                            menu(
                                context,
                                b,
                                index,
                                details,
                                translateController.data,
                                widget.surah!,
                                widget.nomPageF,
                                widget.nomPageL);
                            quranTextController.selected.value =
                                !quranTextController.selected.value;
                            backColor = Colors.transparent;
                            ayatController.sorahTextNumber =
                                widget.surah!.number!.toString();
                            ayatController.ayahTextNumber = widget
                                .surah!.ayahs![b].numberInSurah
                                .toString();
                            audioController.ayahSelected.value = b;
                            setState(() {});
                          })
                  ]));
                  text.add(
                    TextSpan(children: [
                      TextSpan(
                        text:
                            ' ${arabicNumber.convert(widget.surah!.ayahs![b].numberInSurah.toString())} ',
                        style: TextStyle(
                          fontSize: generalController.fontSizeArabic.value + 5,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'uthmanic2',
                          color: ThemeProvider.themeOf(context).id == 'dark'
                              ? Theme.of(context).colorScheme.surface
                              : Theme.of(context).primaryColorLight,
                        ),
                      )
                    ]),
                  );
                }
              }
            }
          }
          return quranTextController.value == 1
              ? SingleAyah(
                  surah: widget.surah,
                  index: index,
                  nomPageF: widget.nomPageF,
                  nomPageL: widget.nomPageL)
              : PageAyah(
                  surah: widget.surah,
                  text: text,
                  index: index,
                  nomPageF: widget.nomPageF);
        },
      ),
    );
  }
}
