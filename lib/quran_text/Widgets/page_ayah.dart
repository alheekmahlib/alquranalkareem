import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spring/spring.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../shared/share/ayah_to_images.dart';
import '../../shared/widgets/controllers_put.dart';
import '../../shared/widgets/svg_picture.dart';
import '../../shared/widgets/widgets.dart';
import '../text_page_view.dart';

class PageAyah extends StatelessWidget {
  final surah;
  // final List<InlineSpan> text;
  final int index;
  final int nomPageF;
  PageAyah(
      {super.key,
      required this.surah,
      // required this.text,
      required this.index,
      required this.nomPageF});
  Color? backColor;

  @override
  Widget build(BuildContext context) {
    final List<InlineSpan> pageAyahsUI = quranTextController
        .currentPageAyahText(nomPageF)
        .map(
          (e) => TextSpan(
            text: e.text,
            style: TextStyle(
              fontSize: generalController.fontSizeArabic.value,
              fontFamily: 'uthmanic2',
              background: Paint()
                ..color = audioController.determineColor(index)
                ..strokeJoin = StrokeJoin.round
                ..strokeCap = StrokeCap.round
                ..style = PaintingStyle.fill,
              // background: Paint()
              //   ..color =
              //       index == audioController.ayahSelected.value
              //           ? quranTextController.selected.value
              //               ? backColor!
              //               : Colors.transparent
              //           : Colors.transparent
              //   ..strokeJoin = StrokeJoin.round
              //   ..strokeCap = StrokeCap.round
              //   ..style = PaintingStyle.fill
            ),
          ),
        )
        .toList();
    backColor = Theme.of(context).colorScheme.surface.withOpacity(0.4);
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            springController.play(motion: Motion.reverse);
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
                borderRadius: const BorderRadius.all(Radius.circular(8))),
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
                      TextSpan(
                        style: TextStyle(
                          fontSize: generalController.fontSizeArabic.value,
                          fontFamily: 'uthmanic2',
                          background: Paint()
                            ..color = audioController.determineColor(index)
                            ..strokeJoin = StrokeJoin.round
                            ..strokeCap = StrokeCap.round
                            ..style = PaintingStyle.fill,
                          // background: Paint()
                          //   ..color =
                          //       index == audioController.ayahSelected.value
                          //           ? quranTextController.selected.value
                          //               ? backColor!
                          //               : Colors.transparent
                          //           : Colors.transparent
                          //   ..strokeJoin = StrokeJoin.round
                          //   ..strokeCap = StrokeCap.round
                          //   ..style = PaintingStyle.fill
                        ),
                        children: pageAyahsUI,
                      ),
                      contextMenuBuilder: buildMyContextMenuText(),
                      onSelectionChanged: handleSelectionChangedText,
                    ),
                  ),
                ),
                Center(
                  child: spaceLine(
                    20,
                    MediaQuery.of(context).size.width / 1 / 2,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: pageNumber(
                      arabicNumber.convert(nomPageF! + index).toString(),
                      context,
                      Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
          // ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
            child: juzNum(
                '${quranTextController.juz}',
                context,
                ThemeProvider.themeOf(context).id == 'dark'
                    ? Colors.white
                    : Colors.black,
                25),
          ),
        )
      ],
    );
  }
}
