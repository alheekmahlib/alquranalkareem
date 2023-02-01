import 'package:alquranalkareem/cubit/cubit.dart';
import 'package:alquranalkareem/notes/cubit/note_cubit.dart';
import 'package:alquranalkareem/quran_page/cubit/bookmarks/bookmarks_cubit.dart';
import 'package:alquranalkareem/shared/widgets/bookmarks_list.dart';
import 'package:alquranalkareem/shared/widgets/quran_search.dart';
import 'package:alquranalkareem/shared/widgets/sorah_juz_list.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:theme_provider/theme_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../notes/screens/notes_list.dart';
import '../../quran_page/cubit/audio/cubit.dart';
import '../../quran_text/Widgets/bookmarks_text_list.dart';
import '../../quran_text/cubit/quran_text_cubit.dart';
import '../custom_paint/bg_icon.dart';

var mScaffoldKey = GlobalKey<ScaffoldState>();
var dScaffoldKey = GlobalKey<ScaffoldState>();
var TScaffoldKey = GlobalKey<ScaffoldState>();
var TPageScaffoldKey = GlobalKey<ScaffoldState>();
var SorahPlayScaffoldKey = GlobalKey<ScaffoldState>();
String? selectedValue;

Widget quranPageSearch(
    BuildContext context, GlobalKey<ScaffoldState> searchKey, double width) {
  Orientation orientation = MediaQuery.of(context).orientation;
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
                    color: Theme.of(context).colorScheme.background,
                  ),
                  Icon(
                    cubit.searchFabIcon,
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
                    cubit.searchFabIcon,
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
                          height: orientation == Orientation.portrait
                              ? MediaQuery.of(context).size.height * 3 / 4
                              : MediaQuery.of(context).size.height,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(12.0),
                                topLeft: Radius.circular(12.0)),
                            color: Theme.of(context).colorScheme.background,
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
  Orientation orientation = MediaQuery.of(context).orientation;
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
                    color: Theme.of(context).colorScheme.background,
                  ),
                  Icon(
                    cubit.sorahFabIcon,
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
                    cubit.sorahFabIcon,
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
                          height: orientation == Orientation.portrait
                              ? MediaQuery.of(context).size.height * 3 / 4
                              : MediaQuery.of(context).size.height,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(12.0),
                                topLeft: Radius.circular(12.0)),
                            color: Theme.of(context).colorScheme.background,
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
  Orientation orientation = MediaQuery.of(context).orientation;
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
                    color: Theme.of(context).colorScheme.background,
                  ),
                  Icon(
                    notesCubit.notesFabIcon,
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
                    notesCubit.notesFabIcon,
                    color: Theme.of(context).colorScheme.surface,
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
                          height: orientation == Orientation.portrait
                              ? MediaQuery.of(context).size.height * 3 / 4
                              : MediaQuery.of(context).size.height,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(12.0),
                                topLeft: Radius.circular(12.0)),
                            color: Theme.of(context).colorScheme.background,
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
  Orientation orientation = MediaQuery.of(context).orientation;
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
                          height: orientation == Orientation.portrait
                              ? MediaQuery.of(context).size.height * 3 / 4
                              : MediaQuery.of(context).size.height,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(12.0),
                                topLeft: Radius.circular(12.0)),
                            color: Theme.of(context).colorScheme.background,
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

Widget bookmarksTextList(BuildContext context,
    GlobalKey<ScaffoldState> bookmarksTextListKey, double width) {
  Orientation orientation = MediaQuery.of(context).orientation;
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
                          height: orientation == Orientation.portrait
                              ? MediaQuery.of(context).size.height * 1 / 2
                              : MediaQuery.of(context).size.height,
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

Widget hijriDate(BuildContext context) {
  Orientation orientation = MediaQuery.of(context).orientation;
  var _today = HijriCalendar.now();
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SvgPicture.asset(
        'assets/svg/hijri/${_today.hMonth}.svg',
        height: orientation == Orientation.portrait ? 50 : 100,
        color: Theme.of(context).colorScheme.surface,
      ),
      Text(
        '${_today.hDay} / ${_today.hYear}',
        style: TextStyle(
          fontSize: orientation == Orientation.portrait ? 14 : 20,
          fontFamily: 'kufi',
          color: Theme.of(context).colorScheme.surface,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

Widget hijriDateLand(BuildContext context) {
  var _today = HijriCalendar.now();
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
        color: Theme.of(context).colorScheme.surface,
      ),
      const VerticalDivider(
        width: 2,
        thickness: 1,
        endIndent: 40,
        indent: 40,
      ),
      Text(
        '${_today.hDay} / ${_today.hYear}',
        style: TextStyle(
          fontSize: 14,
          fontFamily: 'kufi',
          color: Theme.of(context).colorScheme.surface,
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
  Orientation orientation = MediaQuery.of(context).orientation;
  return SizedBox(
    height: orientation == Orientation.portrait ? 130 : 30,
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

Widget audioSorahtopBar(BuildContext context, String sorahNum) {
  Orientation orientation = MediaQuery.of(context).orientation;
  return SizedBox(
    height: orientation == Orientation.portrait ? 130 : 30,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: .1,
          child: SvgPicture.asset('assets/svg/surah_name/00$sorahNum.svg',
            color: Theme.of(context).colorScheme.surface,
            width: MediaQuery.of(context).size.width,
          ),
        ),
        SvgPicture.asset(
          'assets/svg/surah_name/00$sorahNum.svg',
          height: 100,
          color: Theme.of(context).colorScheme.surface,
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
                  color: Theme.of(context).colorScheme.background,
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
                  color: Theme.of(context).colorScheme.background,
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

void customSnackBar(BuildContext context, String text) {
  final snackBar = SnackBar(
    duration: const Duration(milliseconds: 3000),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Theme.of(context).colorScheme.surface,
    content: SizedBox(
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: SvgPicture.asset(
              'assets/svg/line.svg',
            ),
          ),
          Container(
            width: 32,
          ),
          Expanded(
            flex: 7,
            child: Text(
              text,
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'kufi',
                  fontStyle: FontStyle.italic,
                  fontSize: 18),
            ),
          ),
          Expanded(
            flex: 1,
            child: SvgPicture.asset(
              'assets/svg/line2.svg',
            ),
          ),
        ],
      ),
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Widget pageNumber(String num, context, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: SvgPicture.asset(
            'assets/svg/page_no_bg.svg',
            height: 50,
            width: 50,
          ),
        ),
        Text(
          num,
          style: TextStyle(
              fontSize: 16,
              fontFamily: 'kufi',
              fontWeight: FontWeight.bold,
              color: color),
        ),
      ],
    ),
  );
}

Widget sorahName(String num, context, Color color) {
  return SizedBox(
    height: 100,
    // width: 110,
    child: Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(
          'assets/svg/surah_na.svg',
          // height: 100,
          width: 200,
        ),
        SvgPicture.asset(
          'assets/svg/surah_name/00$num.svg',
          // height: 90,
          width: 80,
          color: color,
        ),
      ],
    ),
  );
}

Widget juzNum(String num, context, Color color) {
  return Column(
    // alignment: Alignment.center,
    children: [
      SvgPicture.asset(
        'assets/svg/juz.svg',
        // height: 100,
        width: 30,
      ),
      SvgPicture.asset(
        'assets/svg/juz/$num.svg',
        width: 30,
        color: color,
        // width: 100,
      ),
    ],
  );
}

Widget readerDropDown(BuildContext context) {
  Orientation orientation = MediaQuery.of(context).orientation;
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
                        color: audioCubit.readerValue == readerD[index]
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
                            color: audioCubit.readerValue == readerD[index]
                                ? const Color(0xfffcbb76)
                                : Theme.of(context).canvasColor,
                            width: 2),
                        color: const Color(0xff39412a),
                      ),
                      child: audioCubit.readerValue == readerD[index]
                          ? const Icon(Icons.done,
                              size: 14, color: Color(0xfffcbb76))
                          : null,
                    ),
                    onTap: () {
                      audioCubit.readerValue = readerD[index];
                      audioCubit.saveQuranReader(readerD[index]);
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
      color: Theme.of(context).canvasColor,
    ),
    iconSize: 24,
    buttonHeight: 50,
    buttonWidth: 50,
    buttonElevation: 0,
    itemHeight: orientation == Orientation.portrait ? 270 : 125,
    dropdownDecoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(.9),
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

Widget sorahReaderDropDown(BuildContext context) {
  Orientation orientation = MediaQuery.of(context).orientation;
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
    iconSize: 24,
    buttonHeight: 50,
    buttonWidth: 50,
    buttonElevation: 0,
    itemHeight: orientation == Orientation.portrait ? 270 : 125,
    dropdownDecoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(.9),
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

Widget sorahPageReaderDropDown(BuildContext context) {
  Orientation orientation = MediaQuery.of(context).orientation;
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
    iconSize: 24,
    buttonHeight: 50,
    buttonWidth: 50,
    buttonElevation: 0,
    itemHeight: orientation == Orientation.portrait ? 270 : 125,
    dropdownDecoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(.9),
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

Widget customContainer(BuildContext context, Widget myWidget) {
  return ClipPath(
      clipper: const ShapeBorderClipper(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)))),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(.2),
            border: Border.symmetric(
                vertical: BorderSide(
                    color: Theme.of(context).colorScheme.surface, width: 2))),
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
            color: Theme.of(context).colorScheme.surface.withOpacity(.8),
            border: Border.symmetric(
                vertical: BorderSide(
                    color: Theme.of(context).colorScheme.surface, width: 2))),
        child: myWidget,
      ));
}
