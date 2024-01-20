import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/l10n/app_localizations.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/svg_picture.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/bookmarks_controller.dart';
import '../../../controllers/general_controller.dart';
import '../../../controllers/quran_controller.dart';
import '../data/model/surahs_model.dart';
import '../data/model/verse.dart';
import '../widgets/left_page.dart';
import '../widgets/right_page.dart';
import '/core/utils/constants/extensions.dart';

class MPages extends StatelessWidget {
  MPages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    sl<BookmarksController>().getBookmarks();

    return context.customOrientation(
        SafeArea(
          child: SizedBox(
            height: 1280,
            width: 800,
            child: GetBuilder<GeneralController>(
              builder: (generalController) => PageView.builder(
                  controller: sl<GeneralController>().pageController(),
                  itemCount: 604,
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
                                                  context,
                                                  AppLocalizations.of(context)!
                                                      .addBookmark));
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
                                                  context,
                                                  AppLocalizations.of(context)!
                                                      .addBookmark));
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
                                                    context,
                                                    AppLocalizations.of(
                                                            context)!
                                                        .addBookmark));
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
                                                    context,
                                                    AppLocalizations.of(
                                                            context)!
                                                        .addBookmark));
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

    // Get.put(BottomSheetController());
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
        padding: const EdgeInsets.symmetric(vertical: 58.0, horizontal: 22.0),
        child: SizedBox(
          width: 305,
          child: Obx(() {
            if (quranCtrl.surahs.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            List<Ayah> ayahs = quranCtrl.getAyahsForCurrentPage();
            List<InlineSpan> textSpans = ayahs.map((ayah) {
              // TODO: fix this issue please
              return TextSpan(
                text: '${ayah.code_v2} ',
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'hafs${index + 1}',
                  height: 1.7,
                  color: Theme.of(context).primaryColorDark,
                ),
              );
            }).toList();

            return Text.rich(
              TextSpan(children: textSpans),
              textAlign: index == 0 || index == 1
                  ? TextAlign.center
                  : TextAlign.justify,
            );
          }),
        ),
      ),
    );
  }

  Widget _pages2(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        if (sl<GeneralController>().opened.value == true) {
          sl<GeneralController>().opened.value = false;
          sl<GeneralController>().update();
        } else {
          sl<GeneralController>().showControl();
        }
      },
      child: QuranPage(
        imageUrl: 'assets/pages/00${index + 1}.png',
        imageUrl2: 'assets/pages/000${index + 1}.png',
        currentPage: index + 1,
      ),
    );
  }
}
