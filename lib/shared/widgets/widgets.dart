import 'dart:io';

import 'package:alquranalkareem/cubit/cubit.dart';
import 'package:alquranalkareem/notes/cubit/note_cubit.dart';
import 'package:alquranalkareem/quran_page/cubit/bookmarks/bookmarks_cubit.dart';
import 'package:alquranalkareem/quran_text/Widgets/quran_text_search.dart';
import 'package:alquranalkareem/shared/widgets/bookmarks_list.dart';
import 'package:alquranalkareem/shared/widgets/quran_search.dart';
import 'package:alquranalkareem/shared/widgets/sorah_juz_list.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:theme_provider/theme_provider.dart';
import '../../bookmarks_notes_db/notificationDatabase.dart';
import '../../home_page.dart';
import '../../l10n/app_localizations.dart';
import '../../notes/screens/notes_list.dart';
import '../../quran_page/cubit/audio/cubit.dart';
import '../custom_paint/bg_icon.dart';
import '../postPage.dart';
import 'package:intl/intl.dart';




var mScaffoldKey = GlobalKey<ScaffoldState>();
var dScaffoldKey = GlobalKey<ScaffoldState>();
String? selectedValue;

Widget quranPageSearch(
    BuildContext context, GlobalKey<ScaffoldState> searchKey, double width) {
  QuranCubit cubit = QuranCubit.get(context);
  return GestureDetector(
    child: SizedBox(
      height: 50,
      width: 50,
      child: ThemeProvider.themeOf(context).id == 'green'
          ? CustomPaint(
              painter: BgIcon(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    color: Theme.of(context).backgroundColor,
                  ),
                  Icon(
                    cubit.searchFabIcon,
                    color: Theme.of(context).bottomAppBarColor,
                    size: 25,
                  ),
                ],
              ),
            )
          : CustomPaint(
              painter: BgIcon2(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    color: Theme.of(context).backgroundColor,
                  ),
                  Icon(
                    cubit.searchFabIcon,
                    color: Theme.of(context).bottomAppBarColor,
                    size: 25,
                  ),
                ],
              ),
            ),
    ),
    onTap: () {
      if (cubit.isShowBottomSheet) {
        Navigator.pop(context);
      } else {
        searchKey.currentState
            ?.showBottomSheet(

                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8))),
                backgroundColor: Colors.transparent,
                (context) => Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          height: orientation(context,
                              MediaQuery.of(context).size.height * 3 / 4,
                              platformView(MediaQuery.of(context).size.height, MediaQuery.of(context).size.height * 3/4)),
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(12.0),
                                topLeft: Radius.circular(12.0)),
                            color: Theme.of(context).backgroundColor,
                          ),
                          child: QuranSearch(),
                        ),
                      ),
                    ),
                elevation: 40)
            .closed
            .then((value) => {
                  cubit.searchChangeBottomSheetState(
                      isShow: false, icon: Icons.search_outlined),
                });
        cubit.searchCloseBottomSheetState(isShow: true, icon: Icons.close);
      }
    },
  );
}

Widget quranPageSorahList(
    BuildContext context, GlobalKey<ScaffoldState> sorahListKey, double width) {
  QuranCubit cubit = QuranCubit.get(context);
  return GestureDetector(
    child: SizedBox(
      height: 50,
      width: 50,
      child: ThemeProvider.themeOf(context).id == 'green'
          ? CustomPaint(
              painter: BgIcon(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    color: Theme.of(context).backgroundColor,
                  ),
                  Icon(
                    cubit.sorahFabIcon,
                    color: Theme.of(context).bottomAppBarColor,
                    size: 25,
                  ),
                ],
              ),
            )
          : CustomPaint(
              painter: BgIcon2(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    color: Theme.of(context).backgroundColor,
                  ),
                  Icon(
                    cubit.sorahFabIcon,
                    color: Theme.of(context).bottomAppBarColor,
                    size: 25,
                  ),
                ],
              ),
            ),
    ),
    onTap: () {
      if (cubit.isShowBottomSheet) {
        Navigator.pop(context);
      } else {
        sorahListKey.currentState
            ?.showBottomSheet(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8))),
                backgroundColor: Colors.transparent,
                (context) => Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          height: orientation(context,
                              MediaQuery.of(context).size.height * 3 / 4,
                              platformView(MediaQuery.of(context).size.height, MediaQuery.of(context).size.height * 3/4)),
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(12.0),
                                topLeft: Radius.circular(12.0)),
                            color: Theme.of(context).backgroundColor,
                          ),
                          child: const SorahJuzList(),
                        ),
                      ),
                    ),
                elevation: 40)
            .closed
            .then((value) => {
                  cubit.sorahChangeBottomSheetState(
                      isShow: false, icon: Icons.list_alt_outlined),
                });
        cubit.sorahCloseBottomSheetState(isShow: true, icon: Icons.close);
      }
    },
  );
}

Widget notesList(
    BuildContext context, GlobalKey<ScaffoldState> notesListKey, double width) {
  NotesCubit notesCubit = NotesCubit.get(context);
  return GestureDetector(
    child: SizedBox(
      height: 50,
      width: 50,
      child: ThemeProvider.themeOf(context).id == 'green'
          ? CustomPaint(
              painter: BgIcon(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    color: Theme.of(context).backgroundColor,
                  ),
                  Icon(
                    notesCubit.notesFabIcon,
                    color: Theme.of(context).bottomAppBarColor,
                    size: 25,
                  ),
                ],
              ),
            )
          : CustomPaint(
              painter: BgIcon2(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    color: Theme.of(context).backgroundColor,
                  ),
                  Icon(
                    notesCubit.notesFabIcon,
                    color: Theme.of(context).bottomAppBarColor,
                    size: 25,
                  ),
                ],
              ),
            ),
    ),
    onTap: () {
      if (notesCubit.isShowBottomSheet) {
        Navigator.pop(context);
      } else {
        notesListKey.currentState
            ?.showBottomSheet(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8))),
                backgroundColor: Colors.transparent,
                (context) => Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          height: orientation(context,
                              MediaQuery.of(context).size.height * 3 / 4,
                              platformView(MediaQuery.of(context).size.height, MediaQuery.of(context).size.height * 3/4)),
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(12.0),
                                topLeft: Radius.circular(12.0)),
                            color: Theme.of(context).backgroundColor,
                          ),
                          child: const NotesList(),
                        ),
                      ),
                    ),
                elevation: 40)
            .closed
            .then((value) => {
                  notesCubit.notesChangeBottomSheetState(
                      isShow: false, icon: Icons.add_comment_outlined),
                });
        notesCubit.notesCloseBottomSheetState(isShow: true, icon: Icons.close);
      }
    },
  );
}

Widget bookmarksList(BuildContext context,
    GlobalKey<ScaffoldState> bookmarksListKey, double width) {
  QuranCubit cubit = QuranCubit.get(context);
  BookmarksCubit bookmarksCubit = BookmarksCubit.get(context);
  return GestureDetector(
    child: SizedBox(
      height: 50,
      width: 50,
      child: ThemeProvider.themeOf(context).id == 'green'
          ? CustomPaint(
              painter: BgIcon(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    color: Theme.of(context).backgroundColor,
                  ),
                  Icon(
                    cubit.bookmarksFabIcon,
                    color: Theme.of(context).bottomAppBarColor,
                    size: 25,
                  ),
                ],
              ),
            )
          : CustomPaint(
              painter: BgIcon2(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    color: Theme.of(context).backgroundColor,
                  ),
                  Icon(
                    cubit.bookmarksFabIcon,
                    color: Theme.of(context).bottomAppBarColor,
                    size: 25,
                  ),
                ],
              ),
            ),
    ),
    onTap: () {
      if (cubit.isShowBottomSheet) {
        Navigator.pop(context);
      } else {
        bookmarksListKey.currentState
            ?.showBottomSheet(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8))),
                backgroundColor: Colors.transparent,
                (context) => Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          height: orientation(context,
                              MediaQuery.of(context).size.height * 3 / 4,
                              platformView(MediaQuery.of(context).size.height, MediaQuery.of(context).size.height * 3/4)),
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(12.0),
                                topLeft: Radius.circular(12.0)),
                            color: Theme.of(context).backgroundColor,
                          ),
                          child: const BookmarksList(),
                        ),
                      ),
                    ),
                elevation: 40)
            .closed
            .then((value) => {
                  bookmarksCubit.bookmarksChangeBottomSheetState(
                      isShow: false, icon: Icons.bookmarks_outlined),
                });
        bookmarksCubit.bookmarksCloseBottomSheetState(
            isShow: true, icon: Icons.close);
      }
    },
  );
}

<<<<<<< Updated upstream
=======
Widget bookmarksTextList(BuildContext context,
    GlobalKey<ScaffoldState> bookmarksTextListKey, double width) {
  QuranCubit cubit = QuranCubit.get(context);
  QuranTextCubit bookmarksCubit = QuranTextCubit.get(context);
  return GestureDetector(
    child: SizedBox(
      height: 50,
      width: 50,
      child: ThemeProvider.themeOf(context).id == 'green'
          ? CustomPaint(
              painter: BgIcon(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    color: Theme.of(context).colorScheme.background,
                  ),
                  Icon(
                    cubit.bookmarksFabIcon,
                    color: Theme.of(context).colorScheme.surface,
                    size: 25,
                  ),
                ],
              ),
            )
          : CustomPaint(
              painter: BgIcon2(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    color: Theme.of(context).colorScheme.background,
                  ),
                  Icon(
                    cubit.bookmarksFabIcon,
                    color: Theme.of(context).colorScheme.surface,
                    size: 25,
                  ),
                ],
              ),
            ),
    ),
    onTap: () {
      if (cubit.isShowBottomSheet) {
        Navigator.pop(context);
      } else {
        bookmarksTextListKey.currentState
            ?.showBottomSheet(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8))),
                backgroundColor: Colors.transparent,
                (context) => Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          height: orientation(context,
                              MediaQuery.of(context).size.height * 1 / 2  * 1.2,
                              platformView(MediaQuery.of(context).size.height, MediaQuery.of(context).size.height * 3/4)),
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(12.0),
                                topLeft: Radius.circular(12.0)),
                            color: Theme.of(context).colorScheme.background,
                          ),
                          child: const BookmarksTextList(),
                        ),
                      ),
                    ),
                elevation: 100)
            .closed
            .then((value) => {
                  bookmarksCubit.bookmarksChangeBottomSheetState(
                      isShow: false, icon: Icons.bookmarks_outlined),
                });
        bookmarksCubit.bookmarksCloseBottomSheetState(
            isShow: true, icon: Icons.close);
      }
    },
  );
}

Widget quranTextSearch(BuildContext context,
    GlobalKey<ScaffoldState> searchTextListKey, double width) {
  QuranCubit cubit = QuranCubit.get(context);
  QuranTextCubit bookmarksCubit = QuranTextCubit.get(context);
  return GestureDetector(
    child: SizedBox(
      height: 50,
      width: 50,
      child: ThemeProvider.themeOf(context).id == 'green'
          ? CustomPaint(
              painter: BgIcon(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    color: Theme.of(context).colorScheme.background,
                  ),
                  Icon(
                    bookmarksCubit.searchFabIcon,
                    color: Theme.of(context).colorScheme.surface,
                    size: 25,
                  ),
                ],
              ),
            )
          : CustomPaint(
              painter: BgIcon2(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    color: Theme.of(context).colorScheme.background,
                  ),
                  Icon(
                    bookmarksCubit.searchFabIcon,
                    color: Theme.of(context).colorScheme.surface,
                    size: 25,
                  ),
                ],
              ),
            ),
    ),
    onTap: () {
      if (cubit.isShowBottomSheet) {
        Navigator.pop(context);
      } else {
        searchTextListKey.currentState
            ?.showBottomSheet(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8))),
                backgroundColor: Colors.transparent,
                (context) => Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          height: orientation(context,
                              MediaQuery.of(context).size.height * 1 / 2 * 1.2,
                              platformView(MediaQuery.of(context).size.height, MediaQuery.of(context).size.height * 3/4)),
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(12.0),
                                topLeft: Radius.circular(12.0)),
                            color: Theme.of(context).colorScheme.background,
                          ),
                          child: QuranTextSearch(),
                        ),
                      ),
                    ),
                elevation: 100)
            .closed
            .then((value) => {
                  bookmarksCubit.searchTextChangeBottomSheetState(
                      isShow: false, icon: Icons.search_outlined),
                });
        bookmarksCubit.searchTextCloseBottomSheetState(
            isShow: true, icon: Icons.close);
      }
    },
  );
}

>>>>>>> Stashed changes
Widget hijriDate(BuildContext context) {
  ArabicNumbers arabicNumber = ArabicNumbers();
  var _today = HijriCalendar.now();
  AppLocalizations.of(context)!.appLang == "لغة التطبيق"
  ? HijriCalendar.setLocal('ar')
  : HijriCalendar.setLocal('en');
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SvgPicture.asset(
        'assets/svg/hijri/${_today.hMonth}.svg',
<<<<<<< Updated upstream
        height: orientation == Orientation.portrait ? 50 : 100,
        color: Theme.of(context).bottomAppBarColor,
=======
        height: orientation(context, 70.0, 100.0),
        colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn)
>>>>>>> Stashed changes
      ),
      Text(
      arabicNumber.convert('${_today.hDay} / ${_today.hMonth} / ${_today.hYear} هـ \n ${_today.dayWeName}'),
        style: TextStyle(
          fontSize: orientation(context, 16.0, 20.0),
          fontFamily: 'kufi',
          color: Theme.of(context).bottomAppBarColor,
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(
        height: 8.0,
      ),

    ],
  );
}

Widget hijriDate2(BuildContext context) {
  ArabicNumbers arabicNumber = ArabicNumbers();
  var _today = HijriCalendar.now();
  AppLocalizations.of(context)!.appLang == "لغة التطبيق"
  ? HijriCalendar.setLocal('ar')
  : HijriCalendar.setLocal('en');
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SvgPicture.asset(
        'assets/svg/hijri/${_today.hMonth}.svg',
        height: 50.0,
        colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.background,
            BlendMode.srcIn)
      ),
      SizedBox(
        height: 4.0,
      ),
      Text(
      arabicNumber.convert('${_today.hDay} / ${_today.hMonth} / ${_today.hYear} هـ \n ${_today.dayWeName}'),
        style: TextStyle(
          fontSize: 12.0,
          fontFamily: 'kufi',
          color: Theme.of(context).colorScheme.surface,
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(
        height: 8.0,
      ),

    ],
  );
}

Widget hijriDateLand(BuildContext context) {
  ArabicNumbers arabicNumber = ArabicNumbers();
  var _today = HijriCalendar.now();
  AppLocalizations.of(context)!.appLang == "لغة التطبيق"
      ? HijriCalendar.setLocal('ar')
      : HijriCalendar.setLocal('en');
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SvgPicture.asset(
        'assets/svg/hijri_date.svg',
        height: 32,
      ),
      const VerticalDivider(
        width: 2,
        thickness: 1,
        endIndent: 40,
        indent: 40,
      ),
      SvgPicture.asset(
        'assets/svg/hijri/${_today.hMonth}.svg',
<<<<<<< Updated upstream
        color: Theme.of(context).bottomAppBarColor,
=======
          colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn)
>>>>>>> Stashed changes
      ),
      const VerticalDivider(
        width: 2,
        thickness: 1,
        endIndent: 40,
        indent: 40,
      ),
      Text(
        arabicNumber.convert('${_today.hDay} / ${_today.hMonth} / ${_today.hYear} هـ \n ${_today.dayWeName}'),
        style: TextStyle(
          fontSize: 14,
          fontFamily: 'kufi',
          color: Theme.of(context).bottomAppBarColor,
        ),
        textAlign: TextAlign.center,
      ),
      const VerticalDivider(
        width: 2,
        thickness: 1,
        endIndent: 40,
        indent: 40,
      ),
    ],
  );
}

Widget topBar(BuildContext context) {
  return SizedBox(
    height: orientation(context, 130.0, 30.0),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: .1,
          child: SvgPicture.asset('assets/svg/splash_icon.svg'),
        ),
        SvgPicture.asset(
          'assets/svg/Logo_line2.svg',
          height: 80,
          width: MediaQuery.of(context).size.width / 1 / 2,
        ),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: Icon(Icons.close_outlined,
                color: ThemeProvider.themeOf(context).id == 'dark'
                    ? Theme.of(context).canvasColor
                    : Theme.of(context).primaryColorDark),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    ),
  );
}

<<<<<<< Updated upstream
=======
Widget audioSorahtopBar(BuildContext context, String sorahNum) {
  return SizedBox(
    height: orientation(context, 130.0, 30.0),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: .1,
          child: SvgPicture.asset('assets/svg/surah_name/00$sorahNum.svg',
            colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn),
            width: MediaQuery.of(context).size.width,
          ),
        ),
        SvgPicture.asset(
          'assets/svg/surah_name/00$sorahNum.svg',
          height: 100,
          colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn),
          width: MediaQuery.of(context).size.width / 1 / 2,
        ),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: Icon(Icons.close_outlined,
                color: ThemeProvider.themeOf(context).id == 'dark'
                    ? Theme.of(context).canvasColor
                    : Theme.of(context).primaryColorDark),
            onPressed: () => AudioCubit.get(context).controllerSorah.reverse(),
          ),
        ),
      ],
    ),
  );
}

>>>>>>> Stashed changes
Widget delete(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.close_outlined,
              color: Colors.white,
              size: 18,
            ),
            Text(
              AppLocalizations.of(context)!.delete,
              style: const TextStyle(
                  color: Colors.white, fontSize: 14, fontFamily: 'kufi'),
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.close_outlined,
              color: Colors.white,
              size: 18,
            ),
            Text(
              AppLocalizations.of(context)!.delete,
              style: const TextStyle(
                  color: Colors.white, fontSize: 14, fontFamily: 'kufi'),
            )
          ],
        ),
      ],
    ),
  );
}

Widget iconBg(BuildContext context) {
  QuranCubit cubit = QuranCubit.get(context);
  return SizedBox(
    height: 50,
    width: 50,
    child: ThemeProvider.themeOf(context).id == 'green'
        ? CustomPaint(
            painter: BgIcon(),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 35,
                  width: 35,
                  color: Theme.of(context).backgroundColor,
                ),
                Icon(
                  cubit.bookmarksFabIcon,
                  color: Theme.of(context).cardColor,
                  size: 25,
                ),
              ],
            ),
          )
        : CustomPaint(
            painter: BgIcon2(),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 35,
                  width: 35,
                  color: Theme.of(context).backgroundColor,
                ),
                Icon(
                  cubit.bookmarksFabIcon,
                  color: Theme.of(context).cardColor,
                  size: 25,
                ),
              ],
            ),
          ),
  );
}

customSnackBar(BuildContext context, String text) {
  final snackBar = SnackBar(
    duration: const Duration(milliseconds: 3000),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Theme.of(context).bottomAppBarColor,
    content: SizedBox(
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: SvgPicture.asset(
              'assets/svg/snackBar_zakh.svg',
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              text,
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'kufi',
                  fontStyle: FontStyle.italic,
                  fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: RotatedBox(
              quarterTurns: 2,
              child: SvgPicture.asset(
                'assets/svg/snackBar_zakh.svg',
              ),
            ),
          ),
        ],
      ),
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

customErrorSnackBar(BuildContext context, String text) {
  var cancel = BotToast.showCustomNotification(
    enableSlideOff: false,
    toastBuilder: (cancelFunc) {
      return Container(
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          )
        ),
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: SvgPicture.asset(
                'assets/svg/snackBar_zakh.svg',
              ),
            ),
            Expanded(
              flex: 7,
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Opacity(
                        opacity: .8,
                        child: SvgPicture.asset(
                          'assets/svg/alert.svg',
                          height: 25,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        text,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'kufi',
                            fontStyle: FontStyle.italic,
                            fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: RotatedBox(
                quarterTurns: 2,
                child: SvgPicture.asset(
                  'assets/svg/snackBar_zakh.svg',
                ),
              ),
            ),
          ],
        ),
      );
    },
    duration: const Duration(milliseconds: 3000),
  );

}

customMobileNoteSnackBar(BuildContext context, String text) {
  var cancel = BotToast.showCustomNotification(
    enableSlideOff: false,
    toastBuilder: (cancelFunc) {
      return Container(
        height: 80,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          )
        ),
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: SvgPicture.asset(
                'assets/svg/snackBar_zakh.svg',
              ),
            ),
            Expanded(
              flex: 7,
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Opacity(
                        opacity: .8,
                        child: SvgPicture.asset(
                          'assets/svg/alert.svg',
                          height: 25,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1/2,
                        child: Text(
                          text,
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'kufi',
                              fontStyle: FontStyle.italic,
                              fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: RotatedBox(
                quarterTurns: 2,
                child: SvgPicture.asset(
                  'assets/svg/snackBar_zakh.svg',
                ),
              ),
            ),
          ],
        ),
      );
    },
    duration: const Duration(milliseconds: 3000),
  );

}

Widget pageNumber(String num, context, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(
          'assets/svg/page_no_bg.svg',
          height: 50,
          width: 50,
        ),
        Text(
          num,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    ),
  );
}

Widget sorahName(String num, context, Color color) {
  return SizedBox(
<<<<<<< Updated upstream
    height: 100,
    width: 110,
=======
    height: 50,
>>>>>>> Stashed changes
    child: Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(
<<<<<<< Updated upstream
          'assets/svg/Sorah_na_bg.svg',
          height: 100,
          width: 100,
        ),
        Text(
          num,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'naskh',
              color: color),
=======
          'assets/svg/surah_na.svg',
          width: 150,
        ),
        SvgPicture.asset(
          'assets/svg/surah_name/00$num.svg',
          width: 60,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
>>>>>>> Stashed changes
        ),
      ],
    ),
  );
}

<<<<<<< Updated upstream
Widget readerDropDown(BuildContext context) {
  Orientation orientation = MediaQuery.of(context).orientation;
=======
Widget juzNum(String num, context, Color color) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      RotatedBox(
        quarterTurns: 1,
        child: SvgPicture.asset(
          'assets/svg/juz.svg',
          width: 25,
        ),
      ),
      SvgPicture.asset(
        'assets/svg/juz/$num.svg',
        width: 25,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn)
        // width: 100,
      ),
    ],
  );
}

Widget juzNumEn(String num, context, Color color) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        '$num',
        style: TextStyle(
          fontSize: 12,
          fontFamily: 'kufi',
          color: ThemeProvider.themeOf(context).id ==
              'dark'
              ? Colors.white
              : Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
      RotatedBox(
        quarterTurns: 3,
        child: SvgPicture.asset(
          'assets/svg/juz.svg',
          width: 25,
        ),
      ),
    ],
  );
}

readerDropDown(BuildContext context) {
>>>>>>> Stashed changes
  AudioCubit audioCubit = AudioCubit.get(context);
  List<String> readerName = <String>[
    AppLocalizations.of(context)!.reader1,
    AppLocalizations.of(context)!.reader2,
    AppLocalizations.of(context)!.reader3,
    AppLocalizations.of(context)!.reader4,
  ];

  List<String> readerD = <String>[
    "Abdul_Basit_Murattal_192kbps",
    "Minshawy_Murattal_128kbps",
    "Husary_128kbps",
    "Ahmed_ibn_Ali_al-Ajamy_128kbps_ketaballah.net",
  ];

  List<String> readerI = <String>[
    "basit",
    "minshawy",
    "husary",
    "ajamy",
  ];
  modalBottomSheet(context,
      MediaQuery.of(context).size.height / 1/2,
      MediaQuery.of(context).size.width,
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                height: 30,
                width: 30,
                margin: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .background,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    border: Border.all(
                        width: 2,
                        color: Theme.of(context).dividerColor)),
                child: Icon(
                  Icons.close_outlined,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Text(
                AppLocalizations.of(context)!.select_player,
                style: TextStyle(
                    color: Theme.of(context).dividerColor,
                    fontSize: 22,
                    fontFamily: "kufi"
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: ListView.builder(
              itemCount: readerName.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Container(
                      child: ListTile(
                        title: Text(
                          readerName[index],
                          style: TextStyle(
                            color: audioCubit.readerValue == readerD[index]
                                ? Theme.of(context).primaryColorLight
                                : const Color(0xffcdba72),
                            fontSize: 14,
                            fontFamily: "kufi"
                          ),
                        ),
                        trailing: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(2.0)),
                            border: Border.all(
                                color: audioCubit.readerValue == readerD[index]
                                    ? Theme.of(context).primaryColorLight
                                    : const Color(0xffcdba72),
                                width: 2),
                            color: const Color(0xff39412a),
                          ),
                          child: audioCubit.readerValue == readerD[index]
                              ? const Icon(Icons.done,
                              size: 14, color: Color(0xffcdba72))
                              : null,
                        ),
                        onTap: () {
                          audioCubit.readerValue = readerD[index];
                          audioCubit.saveQuranReader(readerD[index]);
                          Navigator.pop(context);
                        },
                        leading: Container(
                          height: 80.0,
                          width: 80.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/${readerI[index]}.jpg'),
                              fit: BoxFit.fitWidth,
                              colorFilter: audioCubit.readerValue == readerD[index]
                                  ? null
                                  : ColorFilter.mode(
                                  Theme.of(context).canvasColor.withOpacity(.4),
                                  BlendMode.lighten),
                            ),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                              width: 2
                            )
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                          width: 1
                        )
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    ),
                    // const Divider(
                    //   endIndent: 16,
                    //   indent: 16,
                    //   height: 3,
                    // ),
                  ],
                );
              },
            ),
          ),

        ],
      ),
    ),
<<<<<<< Updated upstream
=======
  );
}

sorahReaderDropDown(BuildContext context) {
  AudioCubit audioCubit = AudioCubit.get(context);
  List<String> readerName = <String>[
    AppLocalizations.of(context)!.reader1,
    AppLocalizations.of(context)!.reader2,
    AppLocalizations.of(context)!.reader3,
    AppLocalizations.of(context)!.reader4,
  ];

  List<String> readerD = <String>[
    "https://server7.mp3quran.net/",
    "https://server10.mp3quran.net/",
    "https://server13.mp3quran.net/",
    "https://server10.mp3quran.net/",
  ];

  List<String> readerN = <String>[
    "basit/",
    "minsh/",
    "husr/",
    "ajm/",
  ];

  List<String> readerI = <String>[
    "basit",
    "minshawy",
    "husary",
    "ajamy",
  ];
  modalBottomSheet(context,
    MediaQuery.of(context).size.height / 1/2,
    MediaQuery.of(context).size.width,
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                height: 30,
                width: 30,
                margin: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .background,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    border: Border.all(
                        width: 2,
                        color: Theme.of(context).dividerColor)),
                child: Icon(
                  Icons.close_outlined,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Text(
                AppLocalizations.of(context)!.select_player,
                style: TextStyle(
                    color: Theme.of(context).dividerColor,
                    fontSize: 22,
                    fontFamily: "kufi"
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: ListView.builder(
              itemCount: readerName.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Container(
                      child: ListTile(
                        title: Text(
                          readerName[index],
                          style: TextStyle(
                              color: audioCubit.sorahReaderNameValue == readerN[index]
                                  ? Theme.of(context).primaryColorLight
                                  : const Color(0xffcdba72),
                              fontSize: 14,
                              fontFamily: 'kufi'
                          ),
                        ),
                        trailing: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(2.0)),
                            border: Border.all(
                                color: audioCubit.sorahReaderNameValue == readerN[index]
                                    ? Theme.of(context).primaryColorLight
                                    : const Color(0xffcdba72),
                                width: 2),
                            color: const Color(0xff39412a),
                          ),
                          child: audioCubit.sorahReaderNameValue == readerN[index]
                              ? const Icon(Icons.done,
                              size: 14, color: Color(0xfffcbb76))
                              : null,
                        ),
                        onTap: () {
                          audioCubit.sorahReaderValue = readerD[index];
                          audioCubit.sorahReaderNameValue = readerN[index];
                          audioCubit.saveSorahReader(readerD[index], readerN[index]);
                          Navigator.pop(context);
                        },
                        leading: Container(
                          height: 80.0,
                          width: 80.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/${readerI[index]}.jpg'),
                                fit: BoxFit.fitWidth,
                                colorFilter: audioCubit.sorahReaderNameValue == readerN[index]
                                    ? null
                                    : ColorFilter.mode(
                                    Theme.of(context).canvasColor.withOpacity(.4),
                                    BlendMode.lighten),
                              ),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              border: Border.all(
                                  color: Theme.of(context).dividerColor,
                                  width: 2
                              )
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          border: Border.all(
                              color: Theme.of(context).dividerColor,
                              width: 1
                          )
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    ),
                    // const Divider(
                    //   endIndent: 16,
                    //   indent: 16,
                    //   height: 3,
                    // ),
                  ],
                );
              },
            ),
          ),

        ],
      ),
    ),
  );
}

Widget sorahPageReaderDropDown(BuildContext context) {
  AudioCubit audioCubit = AudioCubit.get(context);
  List<String> readerName = <String>[
    AppLocalizations.of(context)!.reader1,
    AppLocalizations.of(context)!.reader2,
    AppLocalizations.of(context)!.reader3,
    AppLocalizations.of(context)!.reader4,
  ];

  List<String> readerD = <String>[
    "https://server7.mp3quran.net/",
    "https://server10.mp3quran.net/",
    "https://server13.mp3quran.net/",
    "https://server10.mp3quran.net/",
  ];

  List<String> readerN = <String>[
    "basit/",
    "minsh/",
    "husr/",
    "ajm/",
  ];

  return DropdownButton2(
    isExpanded: true,
    dropdownOverButton: true,
    alignment: Alignment.center,
    items: [
      DropdownMenuItem<String>(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListView.builder(
            itemCount: readerName.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  ListTile(
                    title: Text(
                      readerName[index],
                      style: TextStyle(
                        color: audioCubit.sorahReaderNameValue == readerN[index]
                            ? const Color(0xfffcbb76)
                            : Theme.of(context).canvasColor,
                        fontSize: 14,
                      ),
                    ),
                    leading: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(2.0)),
                        border: Border.all(
                            color: audioCubit.sorahReaderNameValue == readerN[index]
                                ? const Color(0xfffcbb76)
                                : Theme.of(context).canvasColor,
                            width: 2),
                        color: const Color(0xff39412a),
                      ),
                      child: audioCubit.sorahReaderNameValue == readerN[index]
                          ? const Icon(Icons.done,
                              size: 14, color: Color(0xfffcbb76))
                          : null,
                    ),
                    onTap: () {
                      audioCubit.sorahReaderValue = readerD[index];
                      audioCubit.sorahReaderNameValue = readerN[index];
                      audioCubit.saveSorahReader(readerD[index], readerN[index]);
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(
                    endIndent: 16,
                    indent: 16,
                    height: 3,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    ],
    value: selectedValue,
    onChanged: (value) {
      selectedValue = value as String;
    },
    customButton: Icon(
      Icons.person_search_outlined,
      color: Theme.of(context).colorScheme.surface,
    ),
>>>>>>> Stashed changes
    iconSize: 24,
    buttonHeight: 50,
    buttonWidth: 50,
    buttonElevation: 0,
<<<<<<< Updated upstream
    itemHeight: orientation == Orientation.portrait ? 270 : 125,
    dropdownDecoration: BoxDecoration(
        color: Theme.of(context).bottomAppBarColor.withOpacity(.9),
=======
    itemHeight: orientation(context, 270.0, 125.0),
    dropdownDecoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(.9),
>>>>>>> Stashed changes
        borderRadius: const BorderRadius.all(Radius.circular(8))),
    dropdownMaxHeight: MediaQuery.of(context).size.height,
    dropdownWidth: 200,
    dropdownPadding: null,
    dropdownElevation: 0,
    scrollbarRadius: const Radius.circular(8),
    scrollbarThickness: 6,
    scrollbarAlwaysShow: true,
    offset: const Offset(0, 0),
  );
}

Route animatRoute(Widget myWidget) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => myWidget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route animatNameRoute({required String pushName, required Widget myWidget}) {
  return PageRouteBuilder(
    settings: RouteSettings(name: pushName),
    pageBuilder: (context, animation, secondaryAnimation) => myWidget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Widget customContainer(BuildContext context, Widget myWidget) {
  return ClipPath(
      clipper: const ShapeBorderClipper(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)))),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            color: Theme.of(context).bottomAppBarColor.withOpacity(.2),
            border: Border.symmetric(
                vertical: BorderSide(
                    color: Theme.of(context).bottomAppBarColor, width: 2))),
        child: myWidget,
      ));
}

Widget bookmarkContainer(BuildContext context, Widget myWidget) {
  return ClipPath(
      clipper: const ShapeBorderClipper(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)))),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            color: Theme.of(context).bottomAppBarColor.withOpacity(.8),
            border: Border.symmetric(
                vertical: BorderSide(
                    color: Theme.of(context).bottomAppBarColor, width: 2))),
        child: myWidget,
      ));
}

orientation(BuildContext context, var n1, n2) {
  Orientation orientation = MediaQuery.of(context).orientation;
  return orientation == Orientation.portrait
      ? n1
      : n2;
}

platformView(var p1, p2) {
  return (Platform.isIOS || Platform.isAndroid || Platform.isFuchsia)
      ? p1
      : p2;
}

Widget sentNotification(BuildContext context, List<Map<String, dynamic>> notifications, Function updateStatus) {
  WidgetsBinding.instance?.addPostFrameCallback((_) {
    updateStatus();
  });
  Future<List<Map<String, dynamic>>> loadNotifications() async {
    final dbHelper = NotificationDatabaseHelper.instance;
    final notifications = await dbHelper.queryAllRows();

    return notifications.map((notification) {
      return {
        'id': notification['id'],
        'title': notification['title'],
        'timestamp': notification['timestamp'] != null
            ? DateTime.parse(notification['timestamp'])
            : DateTime.now(), // Set to the current time if null
      };
    }).toList();
  }
  return Scaffold(
    backgroundColor: Theme.of(context).primaryColorLight,
    body: Padding(
      padding: const EdgeInsets.only(top: 70.0, bottom: 16.0, right: 16.0, left: 16.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    border: Border.all(
                        width: 2, color: Theme.of(context).dividerColor)),
                child: Icon(
                  Icons.close_outlined,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),
          ),
          Text('الإشعارات',
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'kufi',
              color: Theme.of(context).canvasColor,
            ),
          ),
          SvgPicture.asset(
            'assets/svg/space_line.svg',
            height: 30,
          ),
          SizedBox(
            height: 16.0,
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: loadNotifications(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<Map<String, dynamic>> notifications = snapshot.data!;
                    return ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return Container(
                          height: 70,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 4.0),
                          child: ListTile(
                            title: Text(notification['title'],
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'kufi',
                                color: ThemeProvider.themeOf(context).id == 'dark'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            subtitle: Text(DateFormat('HH:mm').format(notification['timestamp']),
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'kufi',
                                color: ThemeProvider.themeOf(context).id == 'dark'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            trailing: Icon(
                              Icons.notifications_active,
                              size: 28,
                              color: Theme.of(context).dividerColor,
                            ),
                            onTap: () {
                              Navigator.of(navigatorNotificationKey.currentContext!).push(
                                animatNameRoute(
                                  pushName: '/post',
                                  myWidget: PostPage(postId: notification['id']),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget rightPage(BuildContext context, Widget child) {
  return Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(
            right: 4.0, top: 16.0, bottom: 16.0),
        child: Container(
            decoration: BoxDecoration(
            color: ThemeProvider.themeOf(context).id == 'dark'
                ? Theme.of(context).primaryColorDark.withOpacity(.5)
                : Theme.of(context).dividerColor.withOpacity(.5),

        borderRadius: const BorderRadius.only(
        topRight: Radius.circular(12),
        bottomRight: Radius.circular(12))),
          child: child,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
            right: 8.0, top: 16.0, bottom: 16.0),
        child: Container(
            decoration: BoxDecoration(
            color: ThemeProvider.themeOf(context).id == 'dark'
                ? Theme.of(context).primaryColorDark.withOpacity(.7)
                : Theme.of(context).dividerColor.withOpacity(.7),
        borderRadius: const BorderRadius.only(
        topRight: Radius.circular(12),
        bottomRight: Radius.circular(12))),
          child: child,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
            right: 12.0, top: 16.0, bottom: 16.0),
        child: Container(
            decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.only(
        topRight: Radius.circular(12),
        bottomRight: Radius.circular(12))),
          child: child,
        ),
      ),
    ],
  );
}

Widget leftPage(BuildContext context, Widget child) {
  return Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(
            left: 4.0, top: 16.0, bottom: 16.0),
        child: Container(
            decoration: BoxDecoration(
            color: ThemeProvider.themeOf(context).id == 'dark'
                ? Theme.of(context).primaryColorDark.withOpacity(.5)
                : Theme.of(context).dividerColor.withOpacity(.5),

        borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        bottomLeft: Radius.circular(12))),
          child: child,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
            left: 8.0, top: 16.0, bottom: 16.0),
        child: Container(
            decoration: BoxDecoration(
            color: ThemeProvider.themeOf(context).id == 'dark'
                ? Theme.of(context).primaryColorDark.withOpacity(.7)
                : Theme.of(context).dividerColor.withOpacity(.7),
        borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        bottomLeft: Radius.circular(12))),
          child: child,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
            left: 12.0, top: 16.0, bottom: 16.0),
        child: Container(
            decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        bottomLeft: Radius.circular(12))),
          child: child,
        ),
      ),
    ],
  );
}

arabicNumber(BuildContext context, var number) {
  ArabicNumbers arabicNumber = ArabicNumbers();
  AppLocalizations.of(context)!.appLang == "App Language"
  ? number
      : arabicNumber.convert(number);
}

quarters(int index) {
  if (index == 1){
    return SvgPicture.asset(
      'assets/svg/quarter/quarter_1.svg',
      height: 20,
    );
  } else if (index == 2){
    return SvgPicture.asset(
      'assets/svg/quarter/quarter_2.svg',
      height: 20,
    );
  } else if (index == 3){
    return SvgPicture.asset(
      'assets/svg/quarter/quarter_3.svg',
      height: 20,
    );
  } else if (index == 4){
    return SvgPicture.asset(
      'assets/svg/quarter/quarter_4.svg',
      height: 20,
    );
  }
}

modalBottomSheet(BuildContext context, double height, width, Widget child) {
  double hei = MediaQuery.of(context).size.height;
  double wid = MediaQuery.of(context).size.width;
  showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(
        maxWidth:  platformView(orientation(context,
            width, wid / 1/2),
            wid / 1/2),
        maxHeight: orientation(context, hei / 1/2,
            platformView(height, hei / 1/2))
      ),
      elevation: 0.0,
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(8.0),
        topRight: Radius.circular(8.0),
      ),
  ),
  backgroundColor: Theme.of(context).colorScheme.background,
  isScrollControlled: true,
  builder: (BuildContext context) {
        return child;
  }
  );
}