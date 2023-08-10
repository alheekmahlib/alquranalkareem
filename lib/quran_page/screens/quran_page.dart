import 'package:alquranalkareem/shared/controller/ayat_controller.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../cubit/cubit.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/controller/general_controller.dart';
import '../../shared/widgets/svg_picture.dart';
import '../../shared/widgets/widgets.dart';
import '../cubit/audio/cubit.dart';
import '../data/model/sorah_bookmark.dart';
import '../data/model/verse.dart';
import '../data/repository/bookmarks_controller.dart';
import '../data/repository/translate_repository.dart';

bool cahData = true;
bool issChange = false;

class MPages extends StatefulWidget {
  MPages({Key? key}) : super(key: key);

  static int currentPage2 = 1;

  @override
  State<MPages> createState() => _MPagesState();
}

class _MPagesState extends State<MPages> with SingleTickerProviderStateMixin {
  List<List<Verse>> allVerses = [];
  ArabicNumbers arabicNumber = ArabicNumbers();
  QuranCubit? quranCubit;
  late final BookmarksController bookmarksController =
      Get.put(BookmarksController());
  late final AyatController ayatController = Get.put(AyatController());
  late final GeneralController generalController = Get.put(GeneralController());

  @override
  void initState() {
    QuranCubit cubit = QuranCubit.get(context);
    bookmarksController.getBookmarksList();

    /// TODO: FIX THE ANIMATION
    cubit.screenController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    cubit.screenAnimation =
        Tween<double>(begin: 1, end: 0.95).animate(cubit.screenController!);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    quranCubit = QuranCubit.get(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(GeneralController());
    QuranCubit cubit = QuranCubit.get(context);
    AudioCubit audioCubit = AudioCubit.get(context);
    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      return AnimatedBuilder(
        animation: cubit.screenAnimation!,
        builder: (context, child) {
          return Transform.scale(
            scale: cubit.screenAnimation!.value,
            child: child,
          );
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            child: GetBuilder<GeneralController>(
              builder: (generalController) => PageView.builder(
                  controller: cubit.dPageController = PageController(
                      initialPage: generalController.cuMPage - 1,
                      keepPage: true),
                  itemCount: 604,
                  onPageChanged: (page) {
                    cahData = false;
                    issChange = true;
                    SoraBookmark soraBookmark =
                        bookmarksController.soraBookmarkList![page];
                    generalController.cuMPage = page + 1;
                    print("new page${generalController.cuMPage}");
                    ayatController.currentAyahNumber.value =
                        '${ayatController.ayatList.first.ayaNum!}';
                    ayaListNotFut = null;
                    cahData = false;
                    issChange = true;
                    // setState(() {
                    // });
                    print("page changed $page");
                    cubit.pageChanged(context, page);
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
                                    child: GetBuilder<BookmarksController>(
                                        builder: (bookmarksController) {
                                      return IconButton(
                                        onPressed: () {
                                          // Check if there's a bookmark for the current page
                                          if (bookmarksController
                                              .isPageBookmarked(
                                                  generalController.cuMPage)) {
                                            bookmarksController.deleteBookmarks(
                                                generalController.cuMPage,
                                                context);
                                          } else {
                                            // If there's no bookmark for the current page, add a new one
                                            bookmarksController
                                                .addBookmark(
                                                    generalController.cuMPage,
                                                    bookmarksController
                                                        .soraBookmarkList![
                                                            index]
                                                        .SoraName_ar!,
                                                    cubit.lastRead)
                                                .then((value) => customSnackBar(
                                                    context,
                                                    AppLocalizations.of(
                                                            context)!
                                                        .addBookmark));
                                            print('addBookmark');
                                            bookmarksController
                                                .savelastBookmark(index);
                                          }
                                        },
                                        icon: bookmarkIcon(context, 30.0, 30.0),
                                      );
                                    })),
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
                                  child: GetBuilder<BookmarksController>(
                                      builder: (bookmarksController) {
                                    return IconButton(
                                      onPressed: () {
                                        // Check if there's a bookmark for the current page
                                        if (bookmarksController
                                            .isPageBookmarked(
                                                generalController.cuMPage)) {
                                          bookmarksController.deleteBookmarks(
                                              generalController.cuMPage,
                                              context);
                                        } else {
                                          // If there's no bookmark for the current page, add a new one
                                          bookmarksController
                                              .addBookmark(
                                                  generalController.cuMPage,
                                                  bookmarksController
                                                      .soraBookmarkList![index]
                                                      .SoraName_ar!,
                                                  cubit.lastRead)
                                              .then((value) => customSnackBar(
                                                  context,
                                                  AppLocalizations.of(context)!
                                                      .addBookmark));
                                          print('addBookmark');
                                          bookmarksController
                                              .savelastBookmark(index);
                                        }
                                      },
                                      icon: bookmarkIcon(context, 30.0, 30.0),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ));
                  }),
            ),
            // ),
          ),
        ),
      );
    } else {
      return AnimatedBuilder(
        animation: cubit.screenAnimation!,
        builder: (context, child) {
          return Transform.scale(
            scale: cubit.screenAnimation!.value,
            child: child,
          );
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: GetBuilder<GeneralController>(
            builder: (generalController) => PageView.builder(
                controller: cubit.dPageController = PageController(
                    initialPage: generalController.cuMPage - 1, keepPage: true),
                itemCount: 604,
                onPageChanged: (page) {
                  cahData = false;
                  issChange = true;
                  SoraBookmark soraBookmark =
                      bookmarksController.soraBookmarkList![page + 1];
                  generalController.cuMPage = page;
                  setState(() {
                    issChange = true;
                    cahData = false;
                    ayaListNotFut = null;
                  });
                  print("page changed $page");
                  cubit.pageChanged(context, page);
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
                                  child: GetBuilder<BookmarksController>(
                                      builder: (bookmarksController) {
                                    return IconButton(
                                      onPressed: () {
                                        // Check if there's a bookmark for the current page
                                        if (bookmarksController
                                            .isPageBookmarked(
                                                generalController.cuMPage)) {
                                          bookmarksController.deleteBookmarks(
                                              generalController.cuMPage,
                                              context);
                                        } else {
                                          // If there's no bookmark for the current page, add a new one
                                          bookmarksController
                                              .addBookmark(
                                                  generalController.cuMPage,
                                                  bookmarksController
                                                      .soraBookmarkList![index]
                                                      .SoraName_ar!,
                                                  cubit.lastRead)
                                              .then((value) => customSnackBar(
                                                  context,
                                                  AppLocalizations.of(context)!
                                                      .addBookmark));
                                          print('addBookmark');
                                          bookmarksController
                                              .savelastBookmark(index);
                                        }
                                      },
                                      icon: bookmarkIcon(context, 30.0, 30.0),
                                    );
                                  }),
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
                                  child: GetBuilder<BookmarksController>(
                                      builder: (bookmarksController) {
                                    return IconButton(
                                      onPressed: () {
                                        // Check if there's a bookmark for the current page
                                        if (bookmarksController
                                            .isPageBookmarked(
                                                generalController.cuMPage)) {
                                          bookmarksController.deleteBookmarks(
                                              generalController.cuMPage,
                                              context);
                                        } else {
                                          // If there's no bookmark for the current page, add a new one
                                          bookmarksController
                                              .addBookmark(
                                                  generalController.cuMPage,
                                                  bookmarksController
                                                      .soraBookmarkList![index]
                                                      .SoraName_ar!,
                                                  cubit.lastRead)
                                              .then((value) => customSnackBar(
                                                  context,
                                                  AppLocalizations.of(context)!
                                                      .addBookmark));
                                          print('addBookmark');
                                          bookmarksController
                                              .savelastBookmark(index);
                                        }
                                      },
                                      icon: bookmarkIcon(context, 30.0, 30.0),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          )),
                  );
                }),
          ),
        ),
      );
    }
  }

  int? id;
  Widget _pages(BuildContext context, int index) {
    QuranCubit cubit = QuranCubit.get(context);
    return InkWell(
      onTap: () {
        switch (cubit.controller.status) {
          case AnimationStatus.completed:
            cubit.controller.reverse();
            break;
          case AnimationStatus.dismissed:
            cubit.controller.forward();
            break;
          default:
        }
        cubit.showControl();
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
    QuranCubit cubit = QuranCubit.get(context);
    Orientation orientation = MediaQuery.of(context).orientation;
    return InkWell(
      onTap: () {
        switch (cubit.controller.status) {
          case AnimationStatus.completed:
            cubit.controller.reverse();
            break;
          case AnimationStatus.dismissed:
            cubit.controller.forward();
            break;
          default:
        }
        cubit.showControl();
      },
      child: Stack(
        children: <Widget>[
          Image.asset(
            "assets/pages/00${index + 1}.png",
            fit: BoxFit.contain,
            color: ThemeProvider.themeOf(context).id == 'dark'
                ? Colors.white
                : null,
            height:
                orientation == Orientation.portrait ? cubit.height! - 60 : null,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
          ),
          Image.asset(
            "assets/pages/000${index + 1}.png",
            fit: BoxFit.contain,
            height:
                orientation == Orientation.portrait ? cubit.height! - 60 : null,
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

class DPages extends StatefulWidget {
  final int initialPageNum;
  DPages(this.initialPageNum, {Key? key}) : super(key: key);

  static int currentPage2 = 1;
  static late int currentIndex2;

  @override
  State<DPages> createState() => _DPagesState();
}

class _DPagesState extends State<DPages> with SingleTickerProviderStateMixin {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool noViewport = false;
  var viewport = 1 / 2;
  ArabicNumbers arabicNumber = ArabicNumbers();
  late final BookmarksController bookmarksController =
      Get.put(BookmarksController());
  late final GeneralController generalController = Get.put(GeneralController());

  @override
  void initState() {
    QuranCubit cubit = QuranCubit.get(context);
    bookmarksController.getBookmarksList();
    bookmarksController.loadlastBookmark();
    noViewport = true;
    DPages.currentIndex2 = widget.initialPageNum - 1;
    generalController.cuMPage = widget.initialPageNum;
    cubit.screenController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    cubit.screenAnimation =
        Tween<double>(begin: 1, end: 0.95).animate(cubit.screenController!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    QuranCubit cubit = QuranCubit.get(context);
    Orientation orientation = MediaQuery.of(context).orientation;

    return AnimatedBuilder(
      animation: cubit.screenAnimation!,
      builder: (context, child) {
        return Transform.scale(
          scale: cubit.screenAnimation!.value,
          child: child,
        );
      },
      child: SizedBox(
        height: cubit.height,
        width: MediaQuery.of(context).size.width,
        child: GetBuilder<GeneralController>(
          builder: (generalController) => PageView.builder(
              controller: cubit.dPageController = PageController(
                  viewportFraction: viewport,
                  // initialPage: widget.initialPageNum - 1,
                  keepPage: true),
              itemCount: 604,
              onPageChanged: (page) {
                cahData = false;
                issChange = true;
                generalController.cuMPage = page + 1;
                ayaListNotFut = null;
                // setState(() {
                //   issChange = true;
                //   cahData = false;
                // });
                SoraBookmark soraBookmark =
                    bookmarksController.soraBookmarkList![page + 1];
                print("page changed ${generalController.cuMPage}");
                cubit.pageChanged(context, page);
                generalController.saveMLastPlace(
                    page + 1, (soraBookmark.SoraNum! + 1).toString());
                cahData = true;
              },
              itemBuilder: (_, index) {
                return LayoutBuilder(builder: (context, constrains) {
                  if (constrains.maxWidth > 650) {
                    cubit.pageController = PageController(viewportFraction: 1);
                  } else if (constrains.maxHeight > 600) {
                    cubit.pageController = PageController(viewportFraction: 1);
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
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
                                        child: FutureBuilder(
                                            future: bookmarksController
                                                .loadlastBookmark(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<int> snapshot) {
                                              if (snapshot.hasData) {
                                                return IconButton(
                                                  onPressed: () {
                                                    // Check if there's a bookmark for the current page
                                                    if (bookmarksController
                                                        .isPageBookmarked(
                                                            generalController
                                                                .cuMPage)) {
                                                      bookmarksController
                                                          .deleteBookmarks(
                                                              generalController
                                                                  .cuMPage,
                                                              context)
                                                          .then((deleted) {
                                                        if (deleted) {
                                                          setState(() {
                                                            // The color of the SVG picture will be updated since the state has changed.
                                                          });
                                                        }
                                                      });
                                                    } else {
                                                      // If there's no bookmark for the current page, add a new one
                                                      bookmarksController
                                                          .addBookmark(
                                                              generalController
                                                                  .cuMPage,
                                                              bookmarksController
                                                                  .soraBookmarkList![
                                                                      index]
                                                                  .SoraName_ar!,
                                                              cubit.lastRead)
                                                          .then((value) => customSnackBar(
                                                              context,
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .addBookmark));
                                                      print('addBookmark');
                                                      setState(() {
                                                        bookmarksController
                                                            .savelastBookmark(
                                                                index);
                                                      });
                                                    }
                                                  },
                                                  icon: bookmarkIcon(
                                                      context, 30.0, 30.0),
                                                );
                                              } else
                                                return const CircularProgressIndicator();
                                            }),
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
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
                                        child: FutureBuilder(
                                            future: bookmarksController
                                                .loadlastBookmark(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<int> snapshot) {
                                              if (snapshot.hasData) {
                                                return IconButton(
                                                  onPressed: () {
                                                    // Check if there's a bookmark for the current page
                                                    if (bookmarksController
                                                        .isPageBookmarked(
                                                            generalController
                                                                .cuMPage)) {
                                                      bookmarksController
                                                          .deleteBookmarks(
                                                              generalController
                                                                  .cuMPage,
                                                              context)
                                                          .then((deleted) {
                                                        if (deleted) {
                                                          setState(() {
                                                            // The color of the SVG picture will be updated since the state has changed.
                                                          });
                                                        }
                                                      });
                                                    } else {
                                                      // If there's no bookmark for the current page, add a new one
                                                      bookmarksController
                                                          .addBookmark(
                                                              generalController
                                                                  .cuMPage,
                                                              bookmarksController
                                                                  .soraBookmarkList![
                                                                      index]
                                                                  .SoraName_ar!,
                                                              cubit.lastRead)
                                                          .then((value) => customSnackBar(
                                                              context,
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .addBookmark));
                                                      print('addBookmark');
                                                      setState(() {
                                                        bookmarksController
                                                            .savelastBookmark(
                                                                index);
                                                      });
                                                    }
                                                  },
                                                  icon: bookmarkIcon(
                                                      context, 30.0, 30.0),
                                                );
                                              } else
                                                return const CircularProgressIndicator();
                                            }),
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
      ),
    );
  }

  Widget _dPages(BuildContext context, int index, Orientation orientation) {
    QuranCubit cubit = QuranCubit.get(context);
    return InkWell(
      onDoubleTap: () {
        setState(() {
          viewport = viewport == 1 / 2 ? 1 : 1 / 2;
        });
      },
      onTap: () {
        cubit.showControl();
        switch (cubit.controller.status) {
          case AnimationStatus.completed:
            cubit.controller.reverse();
            break;
          case AnimationStatus.dismissed:
            cubit.controller.forward();
            break;
          default:
        }
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
