import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/controller/general_controller.dart';
import '../../shared/widgets/controllers_put.dart';
import '../../shared/widgets/svg_picture.dart';
import '../../shared/widgets/widgets.dart';
import '../data/model/sorah_bookmark.dart';
import '../data/repository/translate_repository.dart';

bool cahData = true;
bool issChange = false;

class MPages extends StatelessWidget {
  const MPages({Key? key}) : super(key: key);

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
                    initialPage: generalController.cuMPage - 1, keepPage: true),
                itemCount: 604,
                onPageChanged: (page) {
                  cahData = false;
                  issChange = true;
                  bookmarksController.getBookmarks();
                  generalController.toggleAnimation();
                  SoraBookmark soraBookmark =
                      bookmarksController.soraBookmarkList![page];
                  generalController.cuMPage = page + 1;
                  print("new page${generalController.cuMPage}");
                  ayatController.currentAyahNumber.value =
                      '${ayatController.ayatList.first.ayaNum!}';
                  ayatController.fetchAyat(generalController.cuMPage);
                  ayaListNotFut = null;
                  cahData = false;
                  issChange = true;
                  // setState(() {
                  // });
                  print("page changed $page");
                  generalController.pageChanged(context, page);
                  generalController.saveMLastPlace(
                      page + 1, (soraBookmark.SoraNum! + 1).toString());
                  print('last sorah ${soraBookmark.SoraNum}');
                  cahData = true;
                  // audioCubit.ayahNumber = ayat!.last.ayaNum;
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
                                              generalController.lastRead)
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
                                              generalController.lastRead)
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
                        ));
                }),
          ),
          // ),
        ),
      );
    } else {
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: GetBuilder<GeneralController>(
          builder: (generalController) => PageView.builder(
              controller: generalController.dPageController = PageController(
                  initialPage: generalController.cuMPage - 1, keepPage: true),
              itemCount: 604,
              onPageChanged: (page) {
                cahData = false;
                issChange = true;
                bookmarksController.getBookmarks();
                generalController.toggleAnimation();
                SoraBookmark soraBookmark =
                    bookmarksController.soraBookmarkList![page + 1];
                ayatController.fetchAyat(generalController.cuMPage);
                generalController.cuMPage = page;
                issChange = true;
                cahData = false;
                ayaListNotFut = null;
                print("page changed $page");
                generalController.pageChanged(context, page);
                generalController.saveMLastPlace(
                    page + 1, (soraBookmark.SoraNum! + 1).toString());
                print('last sorah ${soraBookmark.SoraNum}');
                cahData = true;
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
                                              generalController.lastRead)
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
                                              generalController.lastRead)
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
        generalController.toggleAnimation();
        // switch (generalController.controller.status) {
        //   case AnimationStatus.completed:
        //     generalController.controller.reverse();
        //     break;
        //   case AnimationStatus.dismissed:
        //     generalController.controller.forward();
        //     break;
        //   default:
        // }

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
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
              ),
              Image.asset(
                "assets/pages/000${index + 1}.png",
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width,
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
        generalController.toggleAnimation();
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
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
          ),
          Image.asset(
            "assets/pages/000${index + 1}.png",
            fit: BoxFit.contain,
            height: orientation == Orientation.portrait
                ? generalController.height! - 60
                : null,
            width: MediaQuery.of(context).size.width,
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

  var viewport = 1 / 2;
  ArabicNumbers arabicNumber = ArabicNumbers();

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return SizedBox(
      height: generalController.height,
      width: MediaQuery.of(context).size.width,
      child: GetBuilder<GeneralController>(
        builder: (generalController) => PageView.builder(
            controller: generalController.dPageController = PageController(
                viewportFraction: viewport,
                // initialPage: widget.initialPageNum - 1,
                keepPage: true),
            itemCount: 604,
            onPageChanged: (page) {
              cahData = false;
              issChange = true;
              bookmarksController.getBookmarks();
              generalController.cuMPage = page + 1;
              ayaListNotFut = null;
              // setState(() {
              //   issChange = true;
              //   cahData = false;
              // });
              SoraBookmark soraBookmark =
                  bookmarksController.soraBookmarkList![page + 1];
              ayatController.fetchAyat(generalController.cuMPage);
              print("page changed ${generalController.cuMPage}");
              generalController.pageChanged(context, page);
              generalController.saveMLastPlace(
                  page + 1, (soraBookmark.SoraNum! + 1).toString());
              cahData = true;
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
                                                    generalController.lastRead)
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
                                                    generalController.lastRead)
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
        viewport = viewport == 1 / 2 ? 1 : 1 / 2;
      },
      onTap: () {
        generalController.showControl();
        generalController.toggleAnimation();
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
