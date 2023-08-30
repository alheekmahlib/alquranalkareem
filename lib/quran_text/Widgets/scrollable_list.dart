import 'package:alquranalkareem/quran_text/Widgets/page_ayah.dart';
import 'package:alquranalkareem/shared/controller/audio_controller.dart';
import 'package:alquranalkareem/shared/controller/quranText_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../quran_text/Widgets/single_ayah.dart';
import '../../shared/widgets/controllers_put.dart';

class ScrollableList extends StatefulWidget {
  // final surah;
  final int nomPageF;
  final int nomPageL;
  const ScrollableList(
      {super.key,
      // required this.surah,
      required this.nomPageF,
      required this.nomPageL});

  @override
  State<ScrollableList> createState() => _ScrollableListState();
}

class _ScrollableListState extends State<ScrollableList> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioController>(
      builder: (audioController) => ScrollablePositionedList.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,

        // controller: quranTextController.scrollController,
        itemScrollController: quranTextController.itemScrollController,
        itemPositionsListener: quranTextController.itemPositionsListener,
        itemCount: quranTextController.value.value == 1
            ? quranTextController.currentSurahAyahs.length
            : (widget.nomPageL - widget.nomPageF) + 1,
        itemBuilder: (context, index) {
          List<InlineSpan> text = [];
          int ayahLenght = quranTextController.currentSurahAyahs.length;
          if (quranTextController.value.value == 1) {
            for (int index = 0; index < ayahLenght; index++) {
              if (quranTextController.currentSurahAyahs[index].text!.length >
                  1) {
                quranTextController.sajda2 =
                    quranTextController.currentSurahAyahs[index].sajda;
                // lastAyah = quranTextController.currentSurahAyahs.last.numberInSurah;
              }
            }
          } else {
            quranTextController.setSurahsPages();
            // quranTextController.surahPagesList
            // for (int b = 0; b < ayahLenght; b++) {
            //   if (widget.surah!.ayahs![b].text!.length > 1) {
            //     if (widget.surah!.ayahs![b].page == (index + widget.nomPageF)) {
            //       quranTextController.juz =
            //           widget.surah!.ayahs![b].juz.toString();
            //       quranTextController.sajda = widget.surah!.ayahs![b].sajda;
            //       // text2 = surah!.ayahs![b].text! as List<String>;
            //       text.add(TextSpan(children: [
            //         TextSpan(
            //             text:
            //                 ' ${widget.surah!.ayahs![b].text!} ${arabicNumber.convert(widget.surah!.ayahs![b].numberInSurah.toString())}',
            //             style: TextStyle(
            //               fontWeight: FontWeight.normal,
            //               fontFamily: 'uthmanic2',
            //               background: Paint()
            //                 ..color = audioController.determineColor(index)
            //                 ..strokeJoin = StrokeJoin.round
            //                 ..strokeCap = StrokeCap.round
            //                 ..style = PaintingStyle.fill,
            //               color: ThemeProvider.themeOf(context).id == 'dark'
            //                   ? Colors.white
            //                   : Colors.black,
            //             ),
            //             recognizer: TapGestureRecognizer()
            //               ..onTapDown = (TapDownDetails details) {
            //                 print(
            //                     'audioController.ayahSelected.value ${audioController.ayahSelected.value}');
            //                 print('b $b');
            //                 textText = text.map((e) => e).toString();
            //                 textTitle = text.map((e) => e).toString();
            //                 audioController.lastAyahInPage.value =
            //                     widget.surah!.ayahs![b].numberInSurah!;
            //                 pageN = widget.surah!.ayahs![b].pageInSurah! - 1;
            //                 textSurahNum = widget.surah!.number;
            //                 menu(
            //                     context,
            //                     b,
            //                     index,
            //                     details,
            //                     translateController.data,
            //                     widget.surah!,
            //                     widget.nomPageF,
            //                     widget.nomPageL);
            //                 quranTextController.selected.value =
            //                     !quranTextController.selected.value;
            //                 // backColor = Colors.transparent;
            //                 ayatController.sorahTextNumber =
            //                     widget.surah!.number!.toString();
            //                 ayatController.ayahTextNumber = widget
            //                     .surah!.ayahs![b].numberInSurah
            //                     .toString();
            //                 audioController.ayahSelected.value = b;
            //                 quranTextController.update();
            //               })
            //       ]));
            //     }
            //   }
            // }
          }
          return GetBuilder<QuranTextController>(
            builder: (c) => quranTextController.value.value == 1
                ? SingleAyah(
                    surah: quranTextController.surahsAyahs,
                    index: index,
                    nomPageF: widget.nomPageF,
                    nomPageL: widget.nomPageL)
                : PageAyah(
                    surah: quranTextController.surahsAyahs,
                    // text: text,
                    index: index,
                    nomPageF: widget.nomPageF),
          );
        },
      ),
    );
  }
}

// class CustomTextSpan extends TextSpan {
//   // final TextSpan _textSpan;
//   // CustomTextSpan(this._textSpan);
//   CustomTextSpan view(TextSpan _textSpan) => Obx(() => _textSpan as Widget);
// }
