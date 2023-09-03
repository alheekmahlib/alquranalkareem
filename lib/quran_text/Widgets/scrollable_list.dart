import 'package:alquranalkareem/quran_text/model/QuranModel.dart';
import 'package:alquranalkareem/shared/controller/audio_controller.dart';
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
  final SurahText surah;
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

  // int? get isHeighlited {
  //   if (audioController.ayahSelected.value == -1) return null;
  //
  //   final i = widget.surah.ayahs!
  //       .firstWhereOrNull(
  //           (a) => a == widget.surah.ayahs![audioController.ayahSelected.value])
  //       ?.numberInSurah;
  //   return i;
  // }
  int? get isHeighlited {
    if (audioController.ayahSelected.value == -1) return null;
    if (widget.surah.ayahs == null ||
        audioController.ayahSelected.value! >= widget.surah.ayahs!.length ||
        audioController.ayahSelected.value! < 0) {
      return null;
    }

    final i = widget.surah.ayahs!
        .firstWhereOrNull(
            (a) => a == widget.surah.ayahs![audioController.ayahSelected.value])
        ?.numberInSurah;
    return i;
  }

  // int? get isHeighlited {
  //   if (heighlitedAyah.value == -1) return null;
  //
  //   final i = surahs[currentSurah.number - 1]
  //       .ayahs
  //       .firstWhereOrNull((a) => a == allAyahs[heighlitedAyah.value - 1])
  //       ?.number;
  //   return i ;
  // }

  @override
  Widget build(BuildContext context) {
    backColor = const Color(0xff91a57d).withOpacity(0.4);
    return GetBuilder<AudioController>(builder: (audioController) {
      return ScrollablePositionedList.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        // controller: quranTextController.scrollController,
        itemScrollController: quranTextController.itemScrollController,
        itemPositionsListener: quranTextController.itemPositionsListener,
        itemCount: quranTextController.value.value == 1
            ? widget.surah.ayahs!.length
            : (widget.nomPageL - widget.nomPageF) + 1,
        itemBuilder: (context, index) {
          List<InlineSpan> text = [];
          // int ayahLenght = quranTextController.currentSurahAyahs.length;
          int ayahLenght = widget.surah!.ayahs!.length;
          if (quranTextController.value.value == 1) {
            for (int index = 0; index < ayahLenght; index++) {
              if (widget.surah.ayahs![index].text!.length > 1) {
                quranTextController.sajda2 = widget.surah.ayahs![index].sajda;
                // lastAyah = quranTextController.currentSurahAyahs.last.numberInSurah;
              }
            }
          } else {
            // quranTextController.setSurahsPages();
            // quranTextController.surahPagesList
            for (int b = 0; b < ayahLenght; b++) {
              if (widget.surah!.ayahs![b].text!.length > 1) {
                if (widget.surah!.ayahs![b].page == (index + widget.nomPageF)) {
                  quranTextController.juz =
                      widget.surah!.ayahs![b].juz.toString();
                  quranTextController.sajda = widget.surah!.ayahs![b].sajda;
                  // text2 = surah!.ayahs![b].text! as List<String>;
                  text.add(TextSpan(children: [
                    TextSpan(
                        text:
                            ' ${widget.surah!.ayahs![b].text!} ${arabicNumber.convert(widget.surah!.ayahs![b].numberInSurah.toString())}',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: 'uthmanic2',
                          background: Paint()
                            ..color = b + 2 == isHeighlited
                                ? quranTextController.selected.value
                                    ? backColor!
                                    : Colors.transparent
                                : Colors.transparent
                            ..strokeJoin = StrokeJoin.round
                            ..strokeCap = StrokeCap.round
                            ..style = PaintingStyle.fill,
                          color: ThemeProvider.themeOf(context).id == 'dark'
                              ? Colors.white
                              : Colors.black,
                        ),
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
                            // backColor = Colors.transparent;
                            ayatController.sorahTextNumber =
                                widget.surah!.number!.toString();
                            ayatController.ayahTextNumber = widget
                                .surah!.ayahs![b].numberInSurah
                                .toString();
                            audioController.ayahSelected.value =
                                widget.surah!.ayahs![b].numberInSurah!;
                            print(
                                'ayahSelected ${audioController.ayahSelected.value}');
                            // audioController.update();
                            setState(() {});
                          })
                  ]));
                }
              }
            }
          }
          return Obx(
            () => quranTextController.value.value == 1
                ? SingleAyah(
                    surah: widget.surah,
                    index: index,
                    nomPageF: widget.nomPageF,
                    nomPageL: widget.nomPageL)
                : PageAyah(
                    surah: widget.surah,
                    text: text,
                    index: index,
                    nomPageF: widget.nomPageF),
          );
        },
      );
    });
  }
}

// class CustomTextSpan extends TextSpan {
//   // final TextSpan _textSpan;
//   // CustomTextSpan(this._textSpan);
//   CustomTextSpan view(TextSpan _textSpan) => Obx(() => _textSpan as Widget);
// }
