import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/core/utils/constants/extensions/extensions.dart';
import '/presentation/screens/quran_page/extensions/bookmark_page_icon_path.dart';
import '../../../../../core/services/services_locator.dart';
import '../../../../controllers/general/general_controller.dart';
import '../../controllers/audio/audio_controller.dart';
import '../../controllers/bookmarks_controller.dart';
import '../../controllers/extensions/quran/quran_getters.dart';
import '../../controllers/quran/quran_controller.dart';

class TopTitleWidget extends StatelessWidget {
  final int index;
  final bool isRight;
  TopTitleWidget({super.key, required this.index, required this.isRight});
  final bookmarkCtrl = BookmarksController.instance;
  final quranCtrl = QuranController.instance;
  final audioCtrl = AudioController.instance;
  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: isRight
          ? Row(
              children: [
                GestureDetector(
                  onTap: () => bookmarkCtrl.addPageBookmarkOnTap(index),
                  child: bookmarkIcon(
                      height: context.customOrientation(30.h, 55.h)),
                ),
                const Gap(16),
                Text(
                  '${'juz'.tr}: ${quranCtrl.getJuzByPage(index).juz.toString().convertNumbers()}',
                  style: TextStyle(
                      fontSize: context.customOrientation(18.0, 22.0),
                      // fontWeight: FontWeight.bold,
                      fontFamily: 'naskh',
                      color: const Color(0xff77554B)),
                ),
                const Spacer(),
                Row(
                  children: List.generate(
                      quranCtrl.getSurahsByPage(index).length,
                      (i) => Text(
                            ' ${quranCtrl.getSurahsByPage(index)[i].arabicName.replaceAll('سُورَةُ ', '')} ',
                            style: TextStyle(
                                fontSize: context.customOrientation(18.0, 22.0),
                                // fontWeight: FontWeight.bold,
                                fontFamily: 'naskh',
                                color: const Color(0xff77554B)),
                          )),
                ),
              ],
            )
          : Row(
              children: [
                Row(
                  children: List.generate(
                      quranCtrl.getSurahsByPage(index).length,
                      (i) => Text(
                            ' ${quranCtrl.getSurahsByPage(index)[i].arabicName.replaceAll('سُورَةُ ', '')} ',
                            style: TextStyle(
                                fontSize: context.customOrientation(18.0, 22.0),
                                // fontWeight: FontWeight.bold,
                                fontFamily: 'naskh',
                                color: const Color(0xff77554B)),
                          )),
                ),
                const Spacer(),
                Text(
                  '${'juz'.tr}: ${quranCtrl.getJuzByPage(index).juz.toString().convertNumbers()}',
                  style: TextStyle(
                      fontSize: context.customOrientation(18.0, 22.0),
                      // fontWeight: FontWeight.bold,
                      fontFamily: 'naskh',
                      color: const Color(0xff77554B)),
                ),
                const Gap(16),
                GestureDetector(
                  onTap: () => bookmarkCtrl.addPageBookmarkOnTap(index),
                  child: bookmarkIcon(
                      height: context.customOrientation(30.h, 55.h)),
                ),
              ],
            ),
    );
  }

  Widget bookmarkIcon({double? height, double? width, int? pageNum}) {
    return Obx(() {
      return Semantics(
        button: true,
        enabled: true,
        label: 'Add Bookmark',
        child: SvgPicture.asset(
          sl<BookmarksController>()
                  .hasPageBookmark(
                      pageNum ?? quranCtrl.state.currentPageNumber.value)
                  .value
              ? 'assets/svg/bookmarked.svg'
              : Get.context!.bookmarkPageIconPath(),
          width: width,
          height: height,
        ),
      );
    });
  }
}
