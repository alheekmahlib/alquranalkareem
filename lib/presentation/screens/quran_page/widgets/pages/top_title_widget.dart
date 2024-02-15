import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/svg_picture.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../controllers/audio_controller.dart';
import '../../../../controllers/bookmarks_controller.dart';
import '../../../../controllers/general_controller.dart';
import '../../../../controllers/quran_controller.dart';
import '/core/utils/constants/extensions.dart';

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
                    if (bookmarkCtrl.isPageBookmarked(index + 1)) {
                      bookmarkCtrl.deleteBookmarks(index + 1, context);
                    } else {
                      bookmarkCtrl
                          .addAyahBookmark(
                              index + 1,
                              quranCtrl.getSurahNameFromPage(index + 1),
                              generalCtrl.timeNow.lastRead)
                          .then(
                              (value) => customErrorSnackBar('addBookmark'.tr));
                      print('addBookmark');
                      print('${generalCtrl.timeNow.lastRead}');
                      // bookmarkCtrl
                      //     .savelastBookmark(index + 1);
                    }
                  },
                  child: bookmarkIcon(context, 30.0, 30.0),
                ),
                const Gap(16),
                Text(
                  '${'juz'.tr}: ${generalCtrl.convertNumbers(quranCtrl.pages[index + 1].first.juz.toString())}',
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
                  '${'juz'.tr}: ${generalCtrl.convertNumbers(quranCtrl.pages[index].first.juz.toString())}',
                  style: TextStyle(
                      fontSize: context.customOrientation(18.0, 22.0),
                      // fontWeight: FontWeight.bold,
                      fontFamily: 'naskh',
                      color: const Color(0xff77554B)),
                ),
                const Gap(16),
                GestureDetector(
                  onTap: () {
                    if (bookmarkCtrl.isPageBookmarked(index + 1)) {
                      bookmarkCtrl.deleteBookmarks(index + 1, context);
                    } else {
                      bookmarkCtrl
                          .addAyahBookmark(
                              index + 1,
                              quranCtrl.getSurahNameFromPage(index + 1),
                              generalCtrl.timeNow.lastRead)
                          .then(
                              (value) => customErrorSnackBar('addBookmark'.tr));
                      print('addBookmark');
                      print('${generalCtrl.timeNow.lastRead}');
                      // bookmarkCtrl
                      //     .savelastBookmark(index + 1);
                    }
                  },
                  child: bookmarkIcon(context, 30.0, 30.0),
                ),
              ],
            ),
    );
  }
}
