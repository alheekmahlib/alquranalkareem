import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/size_config.dart';
import '../../../../core/utils/constants/svg_picture.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/bookmarks_controller.dart';
import '../../../controllers/general_controller.dart';
import '../../../controllers/quran_controller.dart';
import '../data/model/surahs_model.dart';
import '../widgets/left_page.dart';
import '../widgets/right_page.dart';
import '/core/utils/constants/extensions.dart';

class MPages extends StatelessWidget {
  MPages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    sl<BookmarksController>().getBookmarks();
    SizeConfig().init(context);

    return context.customOrientation(
        SafeArea(
          child: SizedBox(
            height: 1280,
            width: 800,
            child: GetBuilder<GeneralController>(
              builder: (generalController) => PageView.builder(
                  controller: sl<GeneralController>().pageController(),
                  itemCount: 604,
                  physics: const ClampingScrollPhysics(),
                  onPageChanged: sl<GeneralController>().pageChanged,
                  itemBuilder: (_, index) {
                    return (index % 2 == 0
                        ? Semantics(
                            image: true,
                            label: 'Quran Page',
                            child: RightPage(
                              child: Stack(
                                children: [
                                  _pages(context, index),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      onPressed: () {
                                        if (sl<BookmarksController>()
                                            .isPageBookmarked(index + 1)) {
                                          sl<BookmarksController>()
                                              .deleteBookmarks(
                                                  index + 1, context);
                                        } else {
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
                                          print('addBookmark');
                                          print(
                                              '${sl<GeneralController>().timeNow.lastRead}');
                                          // sl<BookmarksController>()
                                          //     .savelastBookmark(index + 1);
                                        }
                                      },
                                      icon: bookmarkIcon(context, 30.0, 30.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Semantics(
                            image: true,
                            label: 'Quran Page',
                            child: LeftPage(
                              child: Stack(
                                children: [
                                  _pages(context, index),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: IconButton(
                                      onPressed: () {
                                        if (sl<BookmarksController>()
                                            .isPageBookmarked(index + 1)) {
                                          sl<BookmarksController>()
                                              .deleteBookmarks(
                                                  index + 1, context);
                                        } else {
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
                                          print('addBookmark');
                                          print(
                                              '${sl<GeneralController>().timeNow.lastRead}');
                                          // sl<BookmarksController>()
                                          //     .savelastBookmark(index + 1);
                                        }
                                      },
                                      icon: bookmarkIcon(context, 30.0, 30.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                  }),
            ),
          ),
        ),
        SafeArea(
          child: SizedBox(
            width: 800,
            child: GetBuilder<GeneralController>(
              builder: (generalController) => PageView.builder(
                  controller: sl<GeneralController>().pageController(),
                  itemCount: 604,
                  physics: const ClampingScrollPhysics(),
                  onPageChanged: sl<GeneralController>().pageChanged,
                  itemBuilder: (_, index) {
                    return SingleChildScrollView(
                      child: (index % 2 == 0
                          ? Semantics(
                              image: true,
                              label: 'Quran Page',
                              child: RightPage(
                                child: Stack(
                                  children: [
                                    _pages2(context, index),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        onPressed: () {
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
                                            print('addBookmark');
                                            // sl<BookmarksController>()
                                            //     .savelastBookmark(index + 1);
                                          }
                                        },
                                        icon: bookmarkIcon(context, 30.0, 30.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Semantics(
                              image: true,
                              label: 'Quran Page',
                              child: LeftPage(
                                child: Stack(
                                  children: [
                                    _pages2(context, index),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: IconButton(
                                        onPressed: () {
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
                                            print('addBookmark');
                                            // sl<BookmarksController>()
                                            //     .savelastBookmark(index + 1);
                                          }
                                        },
                                        icon: bookmarkIcon(context, 30.0, 30.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                    );
                  }),
            ),
          ),
        ));
  }

  Widget _pages(BuildContext context, int index) {
    final quranCtrl = sl<QuranController>();
    return InkWell(
      onTap: () {
        if (sl<GeneralController>().opened.value == true) {
          sl<GeneralController>().opened.value = false;
          sl<GeneralController>().update();
        } else {
          sl<GeneralController>().showControl();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 24.0),
        child: Center(
          child: Obx(() {
            if (quranCtrl.surahs.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            List<Ayah> ayahs = quranCtrl.getAyahsForCurrentPage();
            String text = ayahs.map((ayah) => "${ayah.code_v2} ").join();

            return Text.rich(
              TextSpan(
                text: text,
                style: TextStyle(
                  fontFamily: 'page${index + 1}',
                  fontSize: getProportionateScreenWidth(18),
                  height: 1.7,
                  letterSpacing: .01,
                  wordSpacing: .01,
                  color: Colors.black,
                ),
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            );
          }),
        ),
      ),
    );
  }

  Widget _pages2(BuildContext context, int index) {
    final quranCtrl = sl<QuranController>();
    return InkWell(
      onTap: () {
        if (sl<GeneralController>().opened.value == true) {
          sl<GeneralController>().opened.value = false;
          sl<GeneralController>().update();
        } else {
          sl<GeneralController>().showControl();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 24.0),
        child: Center(
          child: Obx(() {
            if (quranCtrl.surahs.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            List<Ayah> ayahs = quranCtrl.getAyahsForCurrentPage();
            String text = ayahs.map((ayah) => ayah.code_v2).join();

            return Text(
              text,
              style: TextStyle(
                fontFamily: 'page${index + 1}',
                fontSize: getProportionateScreenWidth(18),
                height: 1.7,
                letterSpacing: .01,
                wordSpacing: .01,
                color: Colors.black,
              ),
              textAlign: TextAlign.justify,
              textDirection: TextDirection.rtl,
            );
          }),
        ),
      ),
      // child: QuranPage(
      //   imageUrl: 'assets/pages/00${index + 1}.png',
      //   imageUrl2: 'assets/pages/000${index + 1}.png',
      //   currentPage: index + 1,
      // ),
    );
  }
}
