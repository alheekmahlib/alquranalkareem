import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/extensions/extensions.dart';
import '../../../../../core/utils/constants/svg_picture.dart';
import '../../../../controllers/audio_controller.dart';
import '../../../../controllers/bookmarks_controller.dart';
import '../../../../controllers/general_controller.dart';
import '../../../../controllers/quran_controller.dart';

class TopTitleWidget extends StatelessWidget {
  final int index;
  final bool isRight;
  TopTitleWidget({super.key, required this.index, required this.isRight});
  final bookmarkCtrl = sl<BookmarksController>();
  final quranCtrl = sl<QuranController>();
  final audioCtrl = sl<AudioController>();
  final generalCtrl = sl<GeneralController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: isRight
          ? Row(
              children: [
                GestureDetector(
                  onTap: () {
                    bookmarkCtrl.addPageBookmarkOnTap(context, index);
                  },
                  child: bookmarkIcon(
                      width: context.customOrientation(20.w, 15.w)),
                ),
                // Expanded(
                //     flex: 2,
                //     child: customSvg(
                //       'assets/svg/juz/${quranCtrl.getJuzByPage(index).juz}.svg',
                //       color: const Color(0xff77554B),
                //     )),
                // const Spacer(),
                // Expanded(
                //   flex: 1,
                //   child: context.surahNameWidget(
                //     quranCtrl.getSurahNumberFromPage(index).toString(),
                //     const Color(0xff77554B),
                //   ),
                // ),
                const Gap(16),
                Text(
                  '${'juz'.tr}: ${generalCtrl.convertNumbers(quranCtrl.getJuzByPage(index).juz.toString())}',
                  style: TextStyle(
                      fontSize: context.customOrientation(18.0, 22.0),
                      // fontWeight: FontWeight.bold,
                      fontFamily: 'naskh',
                      color: const Color(0xff77554B)),
                ),
                const Spacer(),
                Text(
                  quranCtrl.getSurahNameFromPage(index),
                  style: TextStyle(
                      fontSize: context.customOrientation(18.0, 22.0),
                      // fontWeight: FontWeight.bold,
                      fontFamily: 'naskh',
                      color: const Color(0xff77554B)),
                ),
              ],
            )
          : Row(
              children: [
                // Expanded(
                //   flex: 2,
                //   child: context.surahNameWidget(
                //     quranCtrl.getSurahNumberFromPage(index).toString(),
                //     const Color(0xff77554B),
                //   ),
                // ),
                // const Spacer(),
                // Expanded(
                //     flex: 2,
                //     child: customSvg(
                //       'assets/svg/juz/${quranCtrl.getJuzByPage(index).juz}.svg',
                //       color: const Color(0xff77554B),
                //     )),
                Text(
                  quranCtrl.getSurahNameFromPage(index),
                  style: TextStyle(
                      fontSize: context.customOrientation(18.0, 22.0),
                      // fontWeight: FontWeight.bold,
                      fontFamily: 'naskh',
                      color: const Color(0xff77554B)),
                ),
                const Spacer(),
                Text(
                  '${'juz'.tr}: ${generalCtrl.convertNumbers(quranCtrl.getJuzByPage(index).juz.toString())}',
                  style: TextStyle(
                      fontSize: context.customOrientation(18.0, 22.0),
                      // fontWeight: FontWeight.bold,
                      fontFamily: 'naskh',
                      color: const Color(0xff77554B)),
                ),
                const Gap(16),
                GestureDetector(
                  onTap: () {
                    bookmarkCtrl.addPageBookmarkOnTap(context, index);
                  },
                  child: bookmarkIcon(
                      width: context.customOrientation(20.w, 15.w)),
                ),
              ],
            ),
    );
  }
}
