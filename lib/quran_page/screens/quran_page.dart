
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:theme_provider/theme_provider.dart';
import '../../cubit/cubit.dart';
import '../../l10n/app_localizations.dart';
import '../../quran_text/cubit/surah_text_cubit.dart';
import '../../quran_text/model/QuranModel.dart';
import '../../shared/widgets/svg_picture.dart';
import '../../shared/widgets/widgets.dart';
import '../cubit/bookmarks/bookmarks_cubit.dart';
import '../data/model/sorah_bookmark.dart';
import '../data/model/verse.dart';
import '../data/repository/translate_repository.dart';

class MPages extends StatefulWidget {
  final int initialPageNum;
  MPages({Key? key, required this.initialPageNum}) : super(key: key);

  static int currentPage2 = 1;

  @override
  State<MPages> createState() => _MPagesState();
}
bool cahData=true;
bool issChange=false;
class _MPagesState extends State<MPages> with SingleTickerProviderStateMixin {

  List<List<Verse>> allVerses = [];
  ArabicNumbers arabicNumber = ArabicNumbers();
  QuranCubit? _quranCubit;

  @override
  void initState() {
    BookmarksCubit.get(context).getBookmarksList();
    // QuranCubit.get(context).getList();
    // fetchData();
    QuranCubit.get(context).screenController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    QuranCubit.get(context).screenAnimation = Tween<double>(begin: 1, end: 0.95).animate(QuranCubit.get(context).screenController!);
    // QuranCubit.get(context).loadFontSize();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _quranCubit = QuranCubit.get(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Future<void> fetchData() async {
  //   String jsonString = await rootBundle.loadString('assets/json/glyphs1260.json');
  //   final List<dynamic> jsonResponse = jsonDecode(jsonString);
  //
  //   // Split the JSON data into pages
  //   int currentPage = 1;
  //   List<Verse> currentPageVerses = [];
  //   for (var json in jsonResponse) {
  //     if (json['page_number'] == currentPage) {
  //       currentPageVerses.add(Verse.fromJson(json));
  //     } else {
  //       allVerses.add(currentPageVerses);
  //       currentPageVerses = [Verse.fromJson(json)];
  //       currentPage++;
  //     }
  //   }
  //   allVerses.add(currentPageVerses);
  //
  //   setState(() {});
  // }



  @override
  Widget build(BuildContext context) {
    BookmarksCubit bookmarksCubit = BookmarksCubit.get(context);
    QuranCubit cubit = QuranCubit.get(context);
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
          // top: false,
          // bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            // child: AnimatedContainer(
              // height: MediaQuery.of(context).size.height / 1 / 2 * 1.5,
              // height: cubit.selected
              //     ? MediaQuery.of(context).size.height / 1 / 2 * 1.8
              //     : MediaQuery.of(context).size.height / 1 / 2 * 1.5,
              // duration: const Duration(milliseconds: 300),
              child: PageView.builder(
                  controller: cubit.dPageController = PageController(
                      initialPage: widget.initialPageNum - 1, keepPage: true),
                  itemCount: 604,
                  onPageChanged: (page) {
                    cahData=false;
                    issChange=true;
                    SoraBookmark soraBookmark =
                    bookmarksCubit.soraBookmarkList![page];
                    setState(() {
                      cubit.cuMPage = page;
                      print("new page${cubit.cuMPage}");
                      issChange=true;
                      cahData=false;
                      ayaListNotFut=null;
                      // myval=0;
                    });
                    print("page changed $page");
                    cubit.pageChanged(context, page);
                    cubit.saveMLastPlace(
                        page + 1, (soraBookmark.SoraNum! + 1).toString());
                    print('last sorah ${soraBookmark.SoraNum}');
                    cahData=true;

                  },
                  itemBuilder: (_, index) {
                    return (index % 2 == 0
                        ? rightPage(context,
                      Stack(
                        children: [
                          _pages(context, index),
                          Align(
                              alignment: Alignment.topRight,
                              child: FutureBuilder(
                                  future: cubit.loadlastBookmark(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<int> snapshot) {
                                    if (snapshot.hasData) {
                                      return IconButton(
                                        onPressed: () {
                                          // Check if there's a bookmark for the current page
                                          if (bookmarksCubit.bookmarksController.isPageBookmarked(cubit.cuMPage)) {
                                            bookmarksCubit.bookmarksController
                                                .deleteBookmarks(cubit.cuMPage, context)
                                                .then((deleted) {
                                              if (deleted) {
                                                setState(() {
                                                  // The color of the SVG picture will be updated since the state has changed.
                                                });
                                              }
                                            });
                                          } else {
                                            // If there's no bookmark for the current page, add a new one
                                            bookmarksCubit
                                                .addBookmark(
                                                cubit.cuMPage,
                                                bookmarksCubit.soraBookmarkList![index].SoraName_ar!,
                                                cubit.lastRead)
                                                .then((value) =>
                                                customSnackBar(
                                                    context, AppLocalizations.of(context)!.addBookmark));
                                            print('addBookmark');
                                            setState(() {
                                              cubit.savelastBookmark(index);
                                            });
                                          }

                                        },
                                        icon: bookmarkIcon(context, 30.0, 30.0, bookmarksCubit),
                                      );
                                    } else
                                      return const CircularProgressIndicator();
                                  })),
                        ],
                      ),
                    )
                        : leftPage(context,
                      Stack(
                        children: [
                          _pages(context, index),
                          Align(
                            alignment: Alignment.topLeft,
                            child: FutureBuilder(
                                future: cubit.loadlastBookmark(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<int> snapshot) {
                                  if (snapshot.hasData) {
                                    return IconButton(
                                      onPressed: () {
                                        if (bookmarksCubit.bookmarksController.isPageBookmarked(cubit.cuMPage)) {
                                          bookmarksCubit.bookmarksController
                                              .deleteBookmarks(cubit.cuMPage, context)
                                              .then((deleted) {
                                            if (deleted) {
                                              setState(() {
                                                // The color of the SVG picture will be updated since the state has changed.
                                              });
                                            }
                                          });
                                        } else {
                                          // If there's no bookmark for the current page, add a new one
                                          bookmarksCubit
                                              .addBookmark(
                                              cubit.cuMPage,
                                              bookmarksCubit.soraBookmarkList![index].SoraName_ar!,
                                              cubit.lastRead)
                                              .then((value) =>
                                              customSnackBar(
                                                  context, AppLocalizations.of(context)!.addBookmark));
                                          print('addBookmark');
                                          setState(() {
                                            cubit.savelastBookmark(index);
                                          });
                                        }
                                      },
                                      icon: bookmarkIcon(context, 30.0, 30.0, bookmarksCubit),
                                    );
                                  } else
                                    return const CircularProgressIndicator();
                                }),
                          ),
                        ],
                      ),
                    ));
                  }),
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
          child: PageView.builder(
              controller: cubit.dPageController = PageController(
                  initialPage: widget.initialPageNum - 1, keepPage: true),
              itemCount: 604,
              onPageChanged: (page) {
                cahData=false;
                issChange=true;
                SoraBookmark soraBookmark =
                bookmarksCubit.soraBookmarkList![page + 1];
                setState(() {
                  cubit.cuMPage = page;
                  issChange=true;
                  cahData=false;
                  ayaListNotFut=null;
                });
                print("page changed $page");
                cubit.pageChanged(context, page);
                cubit.saveMLastPlace(
                    page + 1, (soraBookmark.SoraNum! + 1).toString());
                print('last sorah ${soraBookmark.SoraNum}');
                cahData=true;
              },
              itemBuilder: (_, index) {
                return SingleChildScrollView(
                  child: (index % 2 == 0
                      ? rightPage(context,
                    Stack(
                      children: [
                        _pages2(context, index, orientation),
                        Align(
                          alignment: Alignment.topRight,
                          child: FutureBuilder(
                              future: cubit.loadlastBookmark(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<int> snapshot) {
                                if (snapshot.hasData) {
                                  return IconButton(
                                    onPressed: () {
                                      // Check if there's a bookmark for the current page
                                      if (bookmarksCubit.bookmarksController.isPageBookmarked(cubit.cuMPage)) {
                                        bookmarksCubit.bookmarksController
                                            .deleteBookmarks(cubit.cuMPage, context)
                                            .then((deleted) {
                                          if (deleted) {
                                            setState(() {
                                              // The color of the SVG picture will be updated since the state has changed.
                                            });
                                          }
                                        });
                                      } else {
                                        // If there's no bookmark for the current page, add a new one
                                        bookmarksCubit
                                            .addBookmark(
                                            cubit.cuMPage,
                                            bookmarksCubit.soraBookmarkList![index].SoraName_ar!,
                                            cubit.lastRead)
                                            .then((value) =>
                                            customSnackBar(
                                                context, AppLocalizations.of(context)!.addBookmark));
                                        print('addBookmark');
                                        setState(() {
                                          cubit.savelastBookmark(index);
                                        });
                                      }

                                    },
                                    icon: bookmarkIcon(context, 30.0, 30.0, bookmarksCubit),
                                  );
                                } else
                                  return const CircularProgressIndicator();
                              }),
                        ),
                      ],
                    ),
                  )
                      : leftPage(context,
                    Stack(
                      children: [
                        _pages2(context, index, orientation),
                        Align(
                          alignment: Alignment.topLeft,
                          child: FutureBuilder(
                              future: cubit.loadlastBookmark(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<int> snapshot) {
                                if (snapshot.hasData) {
                                  return IconButton(
                                    onPressed: () {
                                      // Check if there's a bookmark for the current page
                                      if (bookmarksCubit.bookmarksController.isPageBookmarked(cubit.cuMPage)) {
                                        bookmarksCubit.bookmarksController
                                            .deleteBookmarks(cubit.cuMPage, context)
                                            .then((deleted) {
                                          if (deleted) {
                                            setState(() {
                                              // The color of the SVG picture will be updated since the state has changed.
                                            });
                                          }
                                        });
                                      } else {
                                        // If there's no bookmark for the current page, add a new one
                                        bookmarksCubit
                                            .addBookmark(
                                            cubit.cuMPage,
                                            bookmarksCubit.soraBookmarkList![index].SoraName_ar!,
                                            cubit.lastRead)
                                            .then((value) =>
                                            customSnackBar(
                                                context, AppLocalizations.of(context)!.addBookmark));
                                        print('addBookmark');
                                        setState(() {
                                          cubit.savelastBookmark(index);
                                        });
                                      }

                                    },
                                    icon: bookmarkIcon(context, 30.0, 30.0, bookmarksCubit),
                                  );
                                } else
                                  return const CircularProgressIndicator();
                              }),
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

  int? id;
  Widget _pages(BuildContext context, int index) {
    QuranCubit cubit = QuranCubit.get(context);
    return InkWell(
      // onDoubleTap: () {
      //   cubit.width == MediaQuery.of(context).size.width;
      //   setState(() {
      //     cubit.selected = !cubit.selected;
      //   });
      // },
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
            height: orientation == Orientation.portrait
                ? cubit.height! - 60
                : null,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
          ),
          Image.asset(
            "assets/pages/000${index + 1}.png",
            fit: BoxFit.contain,
            height: orientation == Orientation.portrait
                ? cubit.height! - 60
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

class DPages extends StatefulWidget {
  final int initialPageNum;
  DPages(this.initialPageNum, {Key? key}) : super(key: key);

  static int currentPage2 = 1;
  static late int currentIndex2;

  @override
  State<DPages> createState() => _DPagesState();
}

class _DPagesState extends State<DPages> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool noViewport = false;
  var viewport = 1 / 2;
  ArabicNumbers arabicNumber = ArabicNumbers();

  @override
  void initState() {
    BookmarksCubit.get(context).getBookmarksList();
    QuranCubit.get(context).loadlastBookmark();
    noViewport = true;
    DPages.currentIndex2 = widget.initialPageNum - 1;
    QuranCubit.get(context).cuMPage = widget.initialPageNum;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    QuranCubit cubit = QuranCubit.get(context);
    BookmarksCubit bookmarksCubit = BookmarksCubit.get(context);
    Orientation orientation = MediaQuery.of(context).orientation;

    return SizedBox(
      height: cubit.height,
      width: MediaQuery.of(context).size.width,
      child: PageView.builder(
          controller: cubit.dPageController = PageController(
              viewportFraction: viewport,
              initialPage: widget.initialPageNum - 1,
              keepPage: true),
          itemCount: 604,
          onPageChanged: (page) {
            cahData=false;
            issChange=true;
            setState(() {
              cubit.cuMPage = page;
              issChange=true;
              cahData=false;
              ayaListNotFut=null;
            });
            SoraBookmark soraBookmark =
            bookmarksCubit.soraBookmarkList![page + 1];
            print("page changed $page");
            cubit.pageChanged(context, page);
            cubit.saveMLastPlace(
                page + 1, (soraBookmark.SoraNum! + 1).toString());
            cahData=true;
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
                      ? rightPage(context, Padding(
                    padding: const EdgeInsets.only(
                        right: 6.0, top: 16.0, bottom: 16.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8))),
                      child: Stack(
                        children: [
                          _dPages(context, index, orientation),
                          Align(
                            alignment: Alignment.topRight,
                            child: FutureBuilder(
                                future: cubit.loadlastBookmark(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<int> snapshot) {
                                  if (snapshot.hasData) {
                                    return IconButton(
                                      onPressed: () {
                                        // Check if there's a bookmark for the current page
                                        if (bookmarksCubit.bookmarksController.isPageBookmarked(cubit.cuMPage)) {
                                          bookmarksCubit.bookmarksController
                                              .deleteBookmarks(cubit.cuMPage, context)
                                              .then((deleted) {
                                            if (deleted) {
                                              setState(() {
                                                // The color of the SVG picture will be updated since the state has changed.
                                              });
                                            }
                                          });
                                        } else {
                                          // If there's no bookmark for the current page, add a new one
                                          bookmarksCubit
                                              .addBookmark(
                                              cubit.cuMPage,
                                              bookmarksCubit.soraBookmarkList![index].SoraName_ar!,
                                              cubit.lastRead)
                                              .then((value) =>
                                              customSnackBar(
                                                  context, AppLocalizations.of(context)!.addBookmark));
                                          print('addBookmark');
                                          setState(() {
                                            cubit.savelastBookmark(index);
                                          });
                                        }

                                      },
                                      icon: bookmarkIcon(context, 30.0, 30.0, bookmarksCubit),
                                    );
                                  } else
                                    return const CircularProgressIndicator();
                                }),
                          ),
                        ],
                      ),
                    ),
                  ))
                      : leftPage(context, Padding(
                    padding: const EdgeInsets.only(
                        left: 6.0, top: 16.0, bottom: 16.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8))),
                      child: Stack(
                        children: [
                          _dPages(context, index, orientation),
                          Align(
                            alignment: Alignment.topLeft,
                            child: FutureBuilder(
                                future: cubit.loadlastBookmark(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<int> snapshot) {
                                  if (snapshot.hasData) {
                                    return IconButton(
                                      onPressed: () {
                                        // Check if there's a bookmark for the current page
                                        if (bookmarksCubit.bookmarksController.isPageBookmarked(cubit.cuMPage)) {
                                          bookmarksCubit.bookmarksController
                                              .deleteBookmarks(cubit.cuMPage, context)
                                              .then((deleted) {
                                            if (deleted) {
                                              setState(() {
                                                // The color of the SVG picture will be updated since the state has changed.
                                              });
                                            }
                                          });
                                        } else {
                                          // If there's no bookmark for the current page, add a new one
                                          bookmarksCubit
                                              .addBookmark(
                                              cubit.cuMPage,
                                              bookmarksCubit.soraBookmarkList![index].SoraName_ar!,
                                              cubit.lastRead)
                                              .then((value) =>
                                              customSnackBar(
                                                  context, AppLocalizations.of(context)!.addBookmark));
                                          print('addBookmark');
                                          setState(() {
                                            cubit.savelastBookmark(index);
                                          });
                                        }

                                      },
                                      icon: bookmarkIcon(context, 30.0, 30.0, bookmarksCubit),
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
