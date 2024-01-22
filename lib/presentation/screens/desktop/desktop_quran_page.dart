import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/services_locator.dart';
import '../../../core/utils/constants/svg_picture.dart';
import '../../../core/widgets/widgets.dart';
import '../../controllers/bookmarks_controller.dart';
import '../../controllers/general_controller.dart';
import '../quran_page/widgets/left_page.dart';
import '/presentation/screens/quran_page/widgets/right_page.dart';

class DPages extends StatelessWidget {
  DPages({Key? key}) : super(key: key);

  // var viewport = 1 / 2;
  // ArabicNumbers arabicNumber = ArabicNumbers();

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    sl<BookmarksController>().getBookmarks();
    return SizedBox(
      height: sl<GeneralController>().height,
      width: MediaQuery.sizeOf(context).width,
      child: Obx(
        () => PageView.builder(
            controller: sl<GeneralController>().dPageController(
                viewport: sl<GeneralController>().viewport.value),
            itemCount: 604,
            onPageChanged: sl<GeneralController>().pageChanged,
            itemBuilder: (_, index) {
              return Center(
                child: SingleChildScrollView(
                  child: (index % 2 == 0
                      ? Semantics(
                          image: true,
                          label: 'Quran Page',
                          child: RightPage(
                              child: Container(
                            margin: const EdgeInsets.only(
                                right: 6.0, top: 16.0, bottom: 16.0),
                            decoration: BoxDecoration(
                                color: Get.theme.colorScheme.background,
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    bottomRight: Radius.circular(8))),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: _dPages(context, index, orientation),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      // Check if there's a bookmark for the current page
                                      if (sl<BookmarksController>()
                                          .isPageBookmarked(index + 1)) {
                                        sl<BookmarksController>()
                                            .deleteBookmarks(
                                                index + 1, context);
                                      } else {
                                        // If there's no bookmark for the current page, add a new one
                                        sl<BookmarksController>()
                                            .addBookmark(
                                                index + 1,
                                                sl<BookmarksController>()
                                                    .soraBookmarkList![
                                                        index + 1]
                                                    .SoraName_ar!,
                                                sl<GeneralController>()
                                                    .timeNow
                                                    .lastRead)
                                            .then((value) => customSnackBar(
                                                context, 'addBookmark'.tr));

                                        // sl<BookmarksController>()
                                        //     .savelastBookmark(index + 1);
                                      }
                                      print('index: ${index + 1}');
                                    },
                                    child: bookmarkIcon(context, 30.0, 30.0,
                                        pageNum: index + 1),
                                  ),
                                ),
                              ],
                            ),
                          )),
                        )
                      : Semantics(
                          image: true,
                          label: 'Quran Page',
                          child: LeftPage(
                              child: Container(
                            margin: const EdgeInsets.only(
                                left: 6.0, top: 16.0, bottom: 16.0),
                            decoration: BoxDecoration(
                                color: Get.theme.colorScheme.background,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8))),
                            child: Stack(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child:
                                        _dPages(context, index, orientation)),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      // Check if there's a bookmark for the current page
                                      if (sl<BookmarksController>()
                                          .isPageBookmarked(index + 1)) {
                                        sl<BookmarksController>()
                                            .deleteBookmarks(
                                                index + 1, context);
                                      } else {
                                        // If there's no bookmark for the current page, add a new one
                                        sl<BookmarksController>()
                                            .addBookmark(
                                                index + 1,
                                                sl<BookmarksController>()
                                                    .soraBookmarkList![
                                                        index + 1]
                                                    .SoraName_ar!,
                                                sl<GeneralController>()
                                                    .timeNow
                                                    .lastRead)
                                            .then((value) => customSnackBar(
                                                context, 'addBookmark'.tr));
                                        // sl<BookmarksController>()
                                        //     .savelastBookmark(index + 1);
                                      }
                                      print('index: ${index + 1}');
                                    },
                                    child: bookmarkIcon(context, 30.0, 30.0,
                                        pageNum: index + 1),
                                  ),
                                ),
                              ],
                            ),
                          )),
                        )),
                ),
              );
            }),
      ),
    );
  }

  Widget _dPages(BuildContext context, int index, Orientation orientation) {
    return InkWell(
      onDoubleTap: () {
        sl<GeneralController>().viewport.value =
            sl<GeneralController>().viewport.value == .5 ? 1.0 : .5;
      },
      onTap: () {
        if (sl<GeneralController>().opened.value == true) {
          sl<GeneralController>().opened.value = false;
          sl<GeneralController>().update();
        } else {
          sl<GeneralController>().showControl();
        }
      },
      child: Center(
        child: Stack(
          children: <Widget>[
            Image.asset(
              "assets/pages/00${index + 1}.png",
              fit: BoxFit.contain,
              color: Get.isDarkMode ? Colors.white : null,
              alignment: Alignment.center,
            ),
            Image.asset(
              "assets/pages/000${index + 1}.png",
              fit: BoxFit.fitWidth,
              alignment: Alignment.center,
            ),
            // QuranPage(
            //   imageUrl: 'assets/pages/00${index + 1}.png',
            //   imageUrl2: 'assets/pages/000${index + 1}.png',
            //   currentPage: index + 1,
            // )
          ],
        ),
      ),
    );
  }
}
