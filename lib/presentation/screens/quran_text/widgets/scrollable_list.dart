import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../core/services/services_locator.dart';
import '../../../controllers/bookmarksText_controller.dart';
import '../../../controllers/quranText_controller.dart';
import '../../quran_page/widgets/ayahs/ayahs_widget.dart';
import '/presentation/screens/quran_text/data/models/QuranModel.dart';
import '/presentation/screens/quran_text/widgets/single_ayah.dart';

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
  //   if (sl<AudioController>().ayahSelected.value == -1) return null;
  //
  //   final i = widget.surah.ayahs!
  //       .firstWhereOrNull(
  //           (a) => a == widget.surah.ayahs![audioController.ayahSelected.value])
  //       ?.numberInSurah;
  //   return i;
  // }
  // int? get isHeighlited {
  //   if (sl<AudioController>().ayahSelected.value == -1) return null;
  //   if (widget.surah.ayahs == null ||
  //       sl<AudioController>().ayahSelected.value >=
  //           widget.surah.ayahs!.length ||
  //       sl<AudioController>().ayahSelected.value < 0) {
  //     return null;
  //   }
  //
  //   final i = widget.surah.ayahs!
  //       .firstWhereOrNull((a) =>
  //           a ==
  //           widget.surah.ayahs![sl<AudioController>().ayahSelected.value - 1])
  //       ?.numberInSurah;
  //   sl<AudioController>().update();
  //   return i;
  // }

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
    final textController = sl<QuranTextController>();
    sl<BookmarksTextController>().getBookmarksText();
    return ScrollablePositionedList.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      addAutomaticKeepAlives: false,
      // controller: sl<QuranTextController>().scrollController,
      itemScrollController: textController.itemScrollController,

      itemPositionsListener: textController.itemPositionsListener,
      itemCount: textController.value.value == 1
          ? widget.surah.ayahs!.length
          : (widget.nomPageL - widget.nomPageF) + 1,
      itemBuilder: (context, index) {
        List<InlineSpan> text = [];
        // int ayahLenght = textController.currentSurahAyahs.length;
        // int ayahLenght = widget.surah.ayahs!.length;
        if (textController.value.value == 1) {
          textController.ayahText(widget.surah);
        } else {
          // textController.pageText(context, widget.surah, text, index,
          //     widget.nomPageF, widget.nomPageL);
        }
        return Obx(
          () => textController.value.value == 1
              ? SingleAyah(
                  surah: widget.surah,
                  index: index,
                  nomPageF: widget.nomPageF,
                  nomPageL: widget.nomPageL)
              : AyahsWidget(),
        );
      },
    );
  }
}

// class CustomTextSpan extends TextSpan {
//   // final TextSpan _textSpan;
//   // CustomTextSpan(this._textSpan);
//   CustomTextSpan view(TextSpan _textSpan) => Obx(() => _textSpan as Widget);
// }
