import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../../../core/services/l10n/app_localizations.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/svg_picture.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/bookmarks_controller.dart';
import '../../../controllers/general_controller.dart';

class MPages extends StatelessWidget {
  MPages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    sl<BookmarksController>().getBookmarks();

    return orientation(
        context,
        SafeArea(
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
                          child: rightPage(
                            context,
                            Stack(
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
                          child: leftPage(
                            context,
                            Stack(
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
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
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
                              child: rightPage(
                                context,
                                Stack(
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
                              child: leftPage(
                                context,
                                Stack(
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
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Stack(
            children: <Widget>[
              Image.asset(
                "assets/pages/00${index + 1}.png",
                fit: BoxFit.contain,
                color: ThemeProvider.themeOf(context).id == 'dark'
                    ? Colors.white
                    : null,
                width: MediaQuery.sizeOf(context).width,
                alignment: Alignment.center,
              ),
              Image.asset(
                "assets/pages/000${index + 1}.png",
                fit: BoxFit.contain,
                width: MediaQuery.sizeOf(context).width,
                alignment: Alignment.center,
              ),
              // HighlightingWidget(
              //   safha: index + 1,
              // )
              // QuranPage(
              //   imageUrl: 'assets/pages/00${index + 1}.png',
              //   imageUrl2: 'assets/pages/000${index + 1}.png',
              //   currentPage: index + 1,
              // )
            ],
          ),
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
      child: Stack(
        children: <Widget>[
          Image.asset(
            "assets/pages/00${index + 1}.png",
            fit: BoxFit.contain,
            color: ThemeProvider.themeOf(context).id == 'dark'
                ? Colors.white
                : null,
            height: orientation == Orientation.portrait
                ? sl<GeneralController>().height! - 60
                : null,
            width: MediaQuery.sizeOf(context).width,
            alignment: Alignment.center,
          ),
          Image.asset(
            "assets/pages/000${index + 1}.png",
            fit: BoxFit.contain,
            height: orientation == Orientation.portrait
                ? sl<GeneralController>().height! - 60
                : null,
            width: MediaQuery.sizeOf(context).width,
            alignment: Alignment.center,
          ),
          // QuranPage(
          //   imageUrl: 'assets/pages/00${index + 1}.png',
          //   imageUrl2: 'assets/pages/000${index + 1}.png',
          //   currentPage: index + 1,
          // )
        ],
      ),
    );
  }
}
