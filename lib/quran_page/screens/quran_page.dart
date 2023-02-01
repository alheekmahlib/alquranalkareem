import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:theme_provider/theme_provider.dart';
import '../../cubit/cubit.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/widgets.dart';
import '../cubit/bookmarks/bookmarks_cubit.dart';
import '../data/model/sorah_bookmark.dart';

class MPages extends StatefulWidget {
  int initialPageNum;
  MPages({Key? key, required this.initialPageNum}) : super(key: key);

  static int currentPage2 = 1;

  @override
  State<MPages> createState() => _MPagesState();
}

class _MPagesState extends State<MPages> {
  bool selected = false;

  @override
  void initState() {
    BookmarksCubit.get(context).getBookmarksList();
    QuranCubit.get(context).getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BookmarksCubit bookmarksCubit = BookmarksCubit.get(context);
    QuranCubit cubit = QuranCubit.get(context);
    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      return SafeArea(
        top: false,
        bottom: false,
        child: AnimatedContainer(
          height: selected
              ? MediaQuery.of(context).size.height / 1 / 2 * 1.8
              : MediaQuery.of(context).size.height / 1 / 2 * 1.5,
          duration: const Duration(milliseconds: 300),
          child: PageView.builder(
              controller: cubit.dPageController = PageController(
                  initialPage: widget.initialPageNum - 1, keepPage: true),
              itemCount: 604,
              onPageChanged: (page) {
                SoraBookmark soraBookmark =
                    bookmarksCubit.soraBookmarkList![page];
                setState(() {
                  cubit.cuMPage = page;
                });
                print("page changed $page");
                cubit.pageChanged(context, page);
                cubit.saveMLastPlace(
                    page + 1, (soraBookmark.SoraNum! + 1).toString());
                print('last sorah ${soraBookmark.SoraNum}');
              },
              itemBuilder: (_, index) {
                return (index % 2 == 0
                    ? Padding(
                        padding: const EdgeInsets.only(
                            right: 6.0, top: 16.0, bottom: 16.0),
                        child: Container(
                          width: cubit.width,
                          decoration: BoxDecoration(
<<<<<<< HEAD
                              color: Theme.of(context).colorScheme.background,
=======
                              color: Theme.of(context).backgroundColor,
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  bottomRight: Radius.circular(12))),
                          child: Stack(
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
                                              bookmarksCubit
                                                  .addBookmark(
                                                      cubit.cuMPage,
                                                      bookmarksCubit
                                                          .soraBookmarkList![
                                                              index]
                                                          .SoraName_ar!,
                                                      cubit.lastRead)
                                                  .then((value) =>
                                                      customSnackBar(
                                                          context,
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .addBookmark));
                                              print('addBookmark');
                                              setState(() {
                                                cubit.savelastBookmark(index);
                                              });
                                            },
                                            icon: SvgPicture.asset(
                                                'assets/svg/bookmark_ic.svg',
                                                width: 30,
                                                height: 30,
                                                color: cubit.lastBook != index
                                                    ? Theme.of(context)
                                                        .primaryColorDark
                                                    : null),
                                          );
                                        } else
                                          return CircularProgressIndicator();
                                      }))
                            ],
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(
                            left: 6.0, top: 16.0, bottom: 16.0),
                        child: Container(
                          width: cubit.width,
                          decoration: BoxDecoration(
<<<<<<< HEAD
                              color: Theme.of(context).colorScheme.background,
=======
                              color: Theme.of(context).backgroundColor,
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12))),
                          child: Stack(
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
                                            bookmarksCubit
                                                .addBookmark(
                                                    cubit.cuMPage,
                                                    bookmarksCubit
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
                                              cubit.savelastBookmark(index);
                                            });
                                          },
                                          icon: SvgPicture.asset(
                                              'assets/svg/bookmark_ic.svg',
                                              width: 30,
                                              height: 30,
                                              color: cubit.lastBook != index
                                                  ? Theme.of(context)
                                                      .primaryColorDark
                                                  : null),
                                        );
                                      } else
                                        return CircularProgressIndicator();
                                    }),
                              )
                            ],
                          ),
                        ),
                      ));
              }),
        ),
      );
    } else {
      return SizedBox(
        height: selected
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.height,
        child: PageView.builder(
            controller: cubit.dPageController = PageController(
                initialPage: widget.initialPageNum - 1, keepPage: true),
            itemCount: 604,
            onPageChanged: (page) {
              SoraBookmark soraBookmark =
                  bookmarksCubit.soraBookmarkList![page + 1];
              setState(() {
                cubit.cuMPage = page;
              });
              print("page changed $page");
              cubit.pageChanged(context, page);
              cubit.saveMLastPlace(
                  page + 1, (soraBookmark.SoraNum! + 1).toString());
              print('last sorah ${soraBookmark.SoraNum}');
            },
            itemBuilder: (_, index) {
              return SingleChildScrollView(
                child: (index % 2 == 0
                    ? Container(
                        decoration: BoxDecoration(
<<<<<<< HEAD
                            color: Theme.of(context).colorScheme.background,
=======
                            color: Theme.of(context).backgroundColor,
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(12),
                                bottomRight: Radius.circular(12))),
                        child: Stack(
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
                                          bookmarksCubit
                                              .addBookmark(
                                                  cubit.cuMPage,
                                                  bookmarksCubit
                                                      .soraBookmarkList![index]
                                                      .SoraName_ar!,
                                                  cubit.lastRead)
                                              .then((value) => customSnackBar(
                                                  context,
                                                  AppLocalizations.of(context)!
                                                      .addBookmark));
                                          print('addBookmark');
                                          setState(() {
                                            cubit.savelastBookmark(index);
                                          });
                                        },
                                        icon: SvgPicture.asset(
                                            'assets/svg/bookmark_ic.svg',
                                            width: 30,
                                            height: 30,
                                            color: cubit.lastBook != index
                                                ? Theme.of(context)
                                                    .primaryColorDark
                                                : null),
                                      );
                                    } else
                                      return CircularProgressIndicator();
                                  }),
                            )
                          ],
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
<<<<<<< HEAD
                            color: Theme.of(context).colorScheme.background,
=======
                            color: Theme.of(context).backgroundColor,
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12))),
                        child: Stack(
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
                                          bookmarksCubit
                                              .addBookmark(
                                                  cubit.cuMPage,
                                                  bookmarksCubit
                                                      .soraBookmarkList![index]
                                                      .SoraName_ar!,
                                                  cubit.lastRead)
                                              .then((value) => customSnackBar(
                                                  context,
                                                  AppLocalizations.of(context)!
                                                      .addBookmark));
                                          print('addBookmark');
                                          setState(() {
                                            cubit.savelastBookmark(index);
                                          });
                                        },
                                        icon: SvgPicture.asset(
                                            'assets/svg/bookmark_ic.svg',
                                            width: 30,
                                            height: 30,
                                            color: cubit.lastBook != index
                                                ? Theme.of(context)
                                                    .primaryColorDark
                                                : null),
                                      );
                                    } else
                                      return CircularProgressIndicator();
                                  }),
                            )
                          ],
                        ),
                      )),
              );
            }),
      );
    }
  }

  int? id;
  Widget _pages(BuildContext context, int index) {
    QuranCubit cubit = QuranCubit.get(context);
    return InkWell(
      onDoubleTap: () {
        cubit.width == MediaQuery.of(context).size.width;
        setState(() {
          selected = !selected;
        });
      },
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
          padding: const EdgeInsets.symmetric(vertical: 32.0),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _pages2(BuildContext context, int index, Orientation orientation) {
    QuranCubit cubit = QuranCubit.get(context);
    Orientation orientation = MediaQuery.of(context).orientation;
    return Column(
      children: [
        InkWell(
          onDoubleTap: () {
            cubit.height2 = cubit.height2 == 2732 ? 9000 : 2732;
            cubit.width2 = cubit.width2 == 2732 ? 9000 : 2732;
            setState(() {});
          },
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
            ],
          ),
        ),
      ],
    );
  }
}

class DPages extends StatefulWidget {
  int initialPageNum;
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
            setState(() {
              cubit.cuMPage = page;
            });
            SoraBookmark soraBookmark =
                bookmarksCubit.soraBookmarkList![page + 1];
            print("page changed $page");
            cubit.pageChanged(context, page);
            cubit.saveMLastPlace(
                page + 1, (soraBookmark.SoraNum! + 1).toString());
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
                      ? Padding(
                          padding: const EdgeInsets.only(
                              right: 6.0, top: 16.0, bottom: 16.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            decoration: BoxDecoration(
<<<<<<< HEAD
                                color: Theme.of(context).colorScheme.background,
=======
                                color: Theme.of(context).backgroundColor,
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
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
                                              bookmarksCubit
                                                  .addBookmark(
                                                      cubit.cuMPage,
                                                      bookmarksCubit
                                                          .soraBookmarkList![
                                                              index]
                                                          .SoraName_ar!,
                                                      cubit.lastRead)
                                                  .then((value) =>
                                                      customSnackBar(
                                                          context,
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .addBookmark));
                                              print('addBookmark');
                                              setState(() {
                                                cubit.savelastBookmark(index);
                                              });
                                            },
                                            icon: SvgPicture.asset(
                                                'assets/svg/bookmark_ic.svg',
                                                width: 30,
                                                height: 30,
                                                color: cubit.lastBook != index
                                                    ? Theme.of(context)
                                                        .primaryColorDark
                                                    : null),
                                          );
                                        } else
                                          return CircularProgressIndicator();
                                      }),
                                )
                              ],
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                              left: 6.0, top: 16.0, bottom: 16.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            decoration: BoxDecoration(
<<<<<<< HEAD
                                color: Theme.of(context).colorScheme.background,
=======
                                color: Theme.of(context).backgroundColor,
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
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
                                              bookmarksCubit
                                                  .addBookmark(
                                                      cubit.cuMPage,
                                                      bookmarksCubit
                                                          .soraBookmarkList![
                                                              index]
                                                          .SoraName_ar!,
                                                      cubit.lastRead)
                                                  .then((value) =>
                                                      customSnackBar(
                                                          context,
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .addBookmark));
                                              print('addBookmark');
                                              setState(() {
                                                cubit.savelastBookmark(index);
                                              });
                                            },
                                            icon: SvgPicture.asset(
                                                'assets/svg/bookmark_ic.svg',
                                                width: 30,
                                                height: 30,
                                                color: cubit.lastBook != index
                                                    ? Theme.of(context)
                                                        .primaryColorDark
                                                    : null),
                                          );
                                        } else
                                          return CircularProgressIndicator();
                                      }),
                                )
                              ],
                            ),
                          ),
                        )),
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
