import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/svg_picture.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/general_controller.dart';
import '../../../controllers/quranText_controller.dart';
import 'widgets.dart';

class PageAyah extends StatelessWidget {
  final surah;
  final int index;
  final List<InlineSpan> text;
  final int nomPageF;
  final int nomPageL;
  PageAyah(
      {super.key,
      required this.surah,
      required this.text,
      required this.index,
      required this.nomPageF,
      required this.nomPageL});

  @override
  Widget build(BuildContext context) {
    sl<QuranTextController>().backColor =
        Get.theme.colorScheme.surface.withOpacity(0.4);
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            sl<GeneralController>().textWidgetPosition.value = -240;
          },
          // child: AutoScrollTag(
          //   key: ValueKey(index),
          //   controller: sl<QuranTextController>().scrollController!,
          //   index: index,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
                color: Get.theme.colorScheme.background,
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: spaceLine(
                      20,
                      MediaQuery.sizeOf(context).width / 1 / 2,
                    ),
                  ),
                ),
                sl<QuranTextController>()
                    .besmAllahWidget(context, surah, index),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Obx(() {
                    // allText = text.map((e) => e).toString();
                    return SelectableText.rich(
                      showCursor: true,
                      cursorWidth: 3,
                      cursorColor: Get.theme.dividerColor,
                      cursorRadius: const Radius.circular(5),
                      scrollPhysics: const ClampingScrollPhysics(),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.justify,
                      TextSpan(
                        style: TextStyle(
                          fontSize:
                              sl<GeneralController>().fontSizeArabic.value,
                          fontFamily: 'uthmanic2',
                          // background: Paint()
                          //   ..color = sl<AudioController>().determineColor(index)
                          //   ..strokeJoin = StrokeJoin.round
                          //   ..strokeCap = StrokeCap.round
                          //   ..style = PaintingStyle.fill,
                          // background: Paint()
                          //   ..color =
                          //       index == sl<AudioController>().ayahSelected.value
                          //           ? sl<QuranTextController>().selected.value
                          //               ? backColor!
                          //               : Colors.transparent
                          //           : Colors.transparent
                          //   ..strokeJoin = StrokeJoin.round
                          //   ..strokeCap = StrokeCap.round
                          //   ..style = PaintingStyle.fill
                        ),
                        // children: pageAyahsUI,
                        children: text.map((e) => e).toList(),
                      ),
                      // contextMenuBuilder: buildMyContextMenuText(),
                      // onSelectionChanged: handleSelectionChangedText,
                    );
                  }),
                ),
                Center(
                  child: spaceLine(
                    20,
                    MediaQuery.sizeOf(context).width / 1 / 2,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: pageNumber(
                      arabicNumber.convert(nomPageF + index).toString(),
                      context,
                      Get.theme.primaryColor),
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
            child: juzNum('${sl<QuranTextController>().juz}', context,
                Get.isDarkMode ? Colors.white : Colors.black, 25),
          ),
        )
      ],
    );
  }
}
