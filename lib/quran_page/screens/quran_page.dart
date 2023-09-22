import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/controller/general_controller.dart';
import '../../shared/services/controllers_put.dart';
import '../../shared/utils/constants/svg_picture.dart';
import '../../shared/widgets/widgets.dart';

class MPages extends StatelessWidget {
  MPages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bookmarksController.getBookmarks();
    final Orientation orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.portrait) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0),
          child: GetBuilder<GeneralController>(
            builder: (generalController) => PageView.builder(
                controller: generalController.dPageController = PageController(
                    initialPage: generalController.cuMPage.value - 1,
                    keepPage: true),
                itemCount: 604,
                onPageChanged: (page) {
                  generalController.pageChanged(page);
                },
                itemBuilder: (_, index) {
                  return (index % 2 == 0
                      ? rightPage(
                          context,
                          Stack(
                            children: [
                              _pages(context, index),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: () {
                                    // Check if there's a bookmark for the current page
                                    if (bookmarksController
                                        .isPageBookmarked(index + 1)) {
                                      bookmarksController.deleteBookmarks(
                                          index + 1, context);
                                    } else {
                                      // If there's no bookmark for the current page, add a new one
                                      bookmarksController
                                          .addBookmark(
                                              index + 1,
                                              bookmarksController
                                                  .soraBookmarkList![index + 1]
                                                  .SoraName_ar!,
                                              generalController
                                                  .timeNow.lastRead)
                                          .then((value) => customSnackBar(
                                              context,
                                              AppLocalizations.of(context)!
                                                  .addBookmark));
                                      print('addBookmark');
                                      print(
                                          '${generalController.timeNow.lastRead}');
                                      // bookmarksController
                                      //     .savelastBookmark(index + 1);
                                    }
                                  },
                                  icon: bookmarkIcon(context, 30.0, 30.0),
                                ),
                              ),
                            ],
                          ),
                        )
                      : leftPage(
                          context,
                          Stack(
                            children: [
                              _pages(context, index),
                              Align(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  onPressed: () {
                                    // Check if there's a bookmark for the current page
                                    if (bookmarksController
                                        .isPageBookmarked(index + 1)) {
                                      bookmarksController.deleteBookmarks(
                                          index + 1, context);
                                    } else {
                                      // If there's no bookmark for the current page, add a new one
                                      bookmarksController
                                          .addBookmark(
                                              index + 1,
                                              bookmarksController
                                                  .soraBookmarkList![index + 1]
                                                  .SoraName_ar!,
                                              generalController
                                                  .timeNow.lastRead)
                                          .then((value) => customSnackBar(
                                              context,
                                              AppLocalizations.of(context)!
                                                  .addBookmark));
                                      print('addBookmark');
                                      print(
                                          '${generalController.timeNow.lastRead}');
                                      // bookmarksController
                                      //     .savelastBookmark(index + 1);
                                    }
                                  },
                                  icon: bookmarkIcon(context, 30.0, 30.0),
                                ),
                              ),
                            ],
                          ),
                        ));
                }),
          ),
          // ),
        ),
      );
    } else {
      return SizedBox(
        height: MediaQuery.sizeOf(context).height,
        child: GetBuilder<GeneralController>(
          builder: (generalController) => PageView.builder(
              controller: generalController.dPageController = PageController(
                  initialPage: generalController.cuMPage.value - 1,
                  keepPage: true),
              itemCount: 604,
              onPageChanged: (page) {
                generalController.pageChanged(page);
              },
              itemBuilder: (_, index) {
                return SingleChildScrollView(
                  child: (index % 2 == 0
                      ? rightPage(
                          context,
                          Stack(
                            children: [
                              _pages2(context, index, orientation),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: () {
                                    // Check if there's a bookmark for the current page
                                    if (bookmarksController
                                        .isPageBookmarked(index + 1)) {
                                      bookmarksController.deleteBookmarks(
                                          index + 1, context);
                                    } else {
                                      // If there's no bookmark for the current page, add a new one
                                      bookmarksController
                                          .addBookmark(
                                              index + 1,
                                              bookmarksController
                                                  .soraBookmarkList![index + 1]
                                                  .SoraName_ar!,
                                              generalController
                                                  .timeNow.lastRead)
                                          .then((value) => customSnackBar(
                                              context,
                                              AppLocalizations.of(context)!
                                                  .addBookmark));
                                      print('addBookmark');
                                      // bookmarksController
                                      //     .savelastBookmark(index + 1);
                                    }
                                  },
                                  icon: bookmarkIcon(context, 30.0, 30.0),
                                ),
                              ),
                            ],
                          ),
                        )
                      : leftPage(
                          context,
                          Stack(
                            children: [
                              _pages2(context, index, orientation),
                              Align(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  onPressed: () {
                                    // Check if there's a bookmark for the current page
                                    if (bookmarksController
                                        .isPageBookmarked(index + 1)) {
                                      bookmarksController.deleteBookmarks(
                                          index + 1, context);
                                    } else {
                                      // If there's no bookmark for the current page, add a new one
                                      bookmarksController
                                          .addBookmark(
                                              index + 1,
                                              bookmarksController
                                                  .soraBookmarkList![index + 1]
                                                  .SoraName_ar!,
                                              generalController
                                                  .timeNow.lastRead)
                                          .then((value) => customSnackBar(
                                              context,
                                              AppLocalizations.of(context)!
                                                  .addBookmark));
                                      print('addBookmark');
                                      // bookmarksController
                                      //     .savelastBookmark(index + 1);
                                    }
                                  },
                                  icon: bookmarkIcon(context, 30.0, 30.0),
                                ),
                              ),
                            ],
                          ),
                        )),
                );
              }),
        ),
      );
    }
  }

  Widget _pages(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        generalController.showControl();
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

  Widget _pages2(BuildContext context, int index, Orientation orientation) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return InkWell(
      onTap: () {
        generalController.showControl();
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
                ? generalController.height! - 60
                : null,
            width: MediaQuery.sizeOf(context).width,
            alignment: Alignment.center,
          ),
          Image.asset(
            "assets/pages/000${index + 1}.png",
            fit: BoxFit.contain,
            height: orientation == Orientation.portrait
                ? generalController.height! - 60
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

class DPages extends StatelessWidget {
  final int initialPageNum;
  DPages(this.initialPageNum, {Key? key}) : super(key: key);

  // var viewport = 1 / 2;
  // ArabicNumbers arabicNumber = ArabicNumbers();

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return SizedBox(
      height: generalController.height,
      width: MediaQuery.sizeOf(context).width,
      child: GetBuilder<GeneralController>(
        builder: (generalController) => PageView.builder(
            controller: generalController.dPageController = PageController(
                viewportFraction: generalController.viewport,
                // initialPage: widget.initialPageNum - 1,
                keepPage: true),
            itemCount: 604,
            onPageChanged: (page) {
              generalController.pageChanged(page);
            },
            itemBuilder: (_, index) {
              return LayoutBuilder(builder: (context, constrains) {
                if (constrains.maxWidth > 650) {
                  generalController.dPageController =
                      PageController(viewportFraction: 1);
                } else if (constrains.maxHeight > 600) {
                  generalController.dPageController =
                      PageController(viewportFraction: 1);
                }
                return Center(
                  child: SingleChildScrollView(
                    child: (index % 2 == 0
                        ? rightPage(
                            context,
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 6.0, top: 16.0, bottom: 16.0),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(8),
                                        bottomRight: Radius.circular(8))),
                                child: Stack(
                                  children: [
                                    _dPages(context, index, orientation),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        onPressed: () {
                                          // Check if there's a bookmark for the current page
                                          if (bookmarksController
                                              .isPageBookmarked(index + 1)) {
                                            bookmarksController.deleteBookmarks(
                                                index + 1, context);
                                          } else {
                                            // If there's no bookmark for the current page, add a new one
                                            bookmarksController
                                                .addBookmark(
                                                    index + 1,
                                                    bookmarksController
                                                        .soraBookmarkList![
                                                            index + 1]
                                                        .SoraName_ar!,
                                                    generalController
                                                        .timeNow.lastRead)
                                                .then((value) => customSnackBar(
                                                    context,
                                                    AppLocalizations.of(
                                                            context)!
                                                        .addBookmark));
                                            print('addBookmark');
                                            // bookmarksController
                                            //     .savelastBookmark(index + 1);
                                          }
                                        },
                                        icon: bookmarkIcon(context, 30.0, 30.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                        : leftPage(
                            context,
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 6.0, top: 16.0, bottom: 16.0),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomLeft: Radius.circular(8))),
                                child: Stack(
                                  children: [
                                    _dPages(context, index, orientation),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: IconButton(
                                        onPressed: () {
                                          // Check if there's a bookmark for the current page
                                          if (bookmarksController
                                              .isPageBookmarked(index + 1)) {
                                            bookmarksController.deleteBookmarks(
                                                index + 1, context);
                                          } else {
                                            // If there's no bookmark for the current page, add a new one
                                            bookmarksController
                                                .addBookmark(
                                                    index + 1,
                                                    bookmarksController
                                                        .soraBookmarkList![
                                                            index + 1]
                                                        .SoraName_ar!,
                                                    generalController
                                                        .timeNow.lastRead)
                                                .then((value) => customSnackBar(
                                                    context,
                                                    AppLocalizations.of(
                                                            context)!
                                                        .addBookmark));
                                            print('addBookmark');
                                            // bookmarksController
                                            //     .savelastBookmark(index + 1);
                                          }
                                        },
                                        icon: bookmarkIcon(context, 30.0, 30.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))),
                  ),
                );
              });
            }),
      ),
    );
  }

  Widget _dPages(BuildContext context, int index, Orientation orientation) {
    return InkWell(
      onDoubleTap: () {
        generalController.viewport =
            generalController.viewport == 1 / 2 ? 1 : 1 / 2;
      },
      onTap: () {
        generalController.showControl();
      },
      child: Center(
        child: Stack(
          children: <Widget>[
            Image.asset(
              "assets/pages/00${index + 1}.png",
              fit: BoxFit.contain,
              color: ThemeProvider.themeOf(context).id == 'dark'
                  ? Colors.white
                  : null,
              alignment: Alignment.center,
            ),
            Image.asset(
              "assets/pages/000${index + 1}.png",
              fit: BoxFit.fitWidth,
              alignment: Alignment.center,
            ),
          ],
        ),
      ),
    );
  }
}
