import 'dart:io' show Platform;

import 'package:alquranalkareem/presentation/screens/quran_page/widgets/quran_search.dart';
import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/handler_animation.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../presentation/controllers/general_controller.dart';
import '../../presentation/controllers/notes_controller.dart';
import '../../presentation/screens/notes/notes_list.dart';
import '../../presentation/screens/quran_text/widgets/bookmarks_text_list.dart';
import '../../presentation/screens/quran_text/widgets/quran_text_search.dart';
import '../services/l10n/app_localizations.dart';
import '../services/services_locator.dart';
import '../utils/constants/shared_pref_services.dart';
import '../utils/constants/shared_preferences_constants.dart';
import 'custom_paint/bg_icon.dart';

double lowerValue = 24;
double upperValue = 50;
String? selectedValue;

Widget quranPageSearch(BuildContext context, double width) {
  return Semantics(
    button: true,
    enabled: true,
    label: AppLocalizations.of(context)!.search,
    child: GestureDetector(
      child: iconBg(context, Icons.search_outlined),
      onTap: () {
        if (Platform.isIOS || Platform.isAndroid || Platform.isFuchsia) {
          fullModalBottomSheet(
            context,
            MediaQuery.sizeOf(context).height * .75,
            MediaQuery.sizeOf(context).width,
            QuranSearch(),
          );
        } else {
          sl<GeneralController>().slideOpen();
          sl<GeneralController>().slideWidgetSwitch(1);
        }
      },
    ),
  );
}

Widget quranPageSorahList(BuildContext context, double width) {
  return Semantics(
    button: true,
    enabled: true,
    label: AppLocalizations.of(context)!.surahsList,
    child: GestureDetector(
        child: iconBg(context, Icons.list_alt_outlined),
        onTap: () {
          sl<GeneralController>().slideOpen();
          sl<GeneralController>().slideWidgetSwitch(2);
          // allModalBottomSheet(
          //     context,
          //     MediaQuery.sizeOf(context).height / 1 / 2,
          //     MediaQuery.sizeOf(context).width,
          //     SurahJuzList());
        }),
  );
}

Widget notesList(BuildContext context, double width) {
  return Semantics(
    button: true,
    enabled: true,
    label: AppLocalizations.of(context)!.notes,
    child: GestureDetector(
      child: iconBg(context, Icons.add_comment_outlined),
      onTap: () {
        if (Platform.isIOS || Platform.isAndroid || Platform.isFuchsia) {
          fullModalBottomSheet(
            context,
            MediaQuery.sizeOf(context).height * .75,
            MediaQuery.sizeOf(context).width,
            NotesList(),
          );
        } else {
          sl<GeneralController>().slideOpen();
          sl<GeneralController>().slideWidgetSwitch(3);
        }
      },
    ),
  );
}

Widget notesListText(BuildContext context, double width) {
  return Semantics(
    button: true,
    enabled: true,
    label: AppLocalizations.of(context)!.notes,
    child: GestureDetector(
      child: iconBg(context, Icons.add_comment_outlined),
      onTap: () {
        fullModalBottomSheet(context, MediaQuery.sizeOf(context).height / 1 / 2,
            MediaQuery.sizeOf(context).width, NotesList());
      },
    ),
  );
}

Widget bookmarksList(BuildContext context, double width) {
  return Semantics(
    button: true,
    enabled: true,
    label: AppLocalizations.of(context)!.bookmarksList,
    child: GestureDetector(
      child: iconBg(context, Icons.bookmarks_outlined),
      onTap: () {
        sl<GeneralController>().slideOpen();
        sl<GeneralController>().slideWidgetSwitch(4);
        // allModalBottomSheet(
        //   context,
        //   MediaQuery.sizeOf(context).height / 1 / 2,
        //   MediaQuery.sizeOf(context).width,
        //   const BookmarksList(),
        // );
      },
    ),
  );
}

Widget bookmarksTextList(BuildContext context, double width) {
  return Semantics(
    button: true,
    enabled: true,
    label: AppLocalizations.of(context)!.bookmarksList,
    child: GestureDetector(
      child: iconBg(context, Icons.bookmarks_outlined),
      onTap: () {
        allModalBottomSheet(
          context,
          MediaQuery.sizeOf(context).height / 1 / 2,
          MediaQuery.sizeOf(context).width,
          const BookmarksTextList(),
        );
      },
    ),
  );
}

Widget quranTextSearch(BuildContext context, double width) {
  return Semantics(
    button: true,
    enabled: true,
    label: AppLocalizations.of(context)!.search,
    child: GestureDetector(
      child: iconBg(context, Icons.search_outlined),
      onTap: () {
        fullModalBottomSheet(
          context,
          MediaQuery.sizeOf(context).height / 1 / 2,
          MediaQuery.sizeOf(context).width,
          QuranTextSearch(),
        );
      },
    ),
  );
}

Widget hijriDate(BuildContext context) {
  ArabicNumbers arabicNumber = ArabicNumbers();
  var _today = HijriCalendar.now();
  AppLocalizations.of(context)!.appLang == "لغة التطبيق"
      ? HijriCalendar.setLocal('ar')
      : HijriCalendar.setLocal('en');
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SvgPicture.asset('assets/svg/hijri/${_today.hMonth}.svg',
          height: orientation(context, 70.0, 100.0),
          colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.surface, BlendMode.srcIn)),
      Text(
        arabicNumber.convert(
            '${_today.hDay} / ${_today.hMonth} / ${_today.hYear} هـ \n ${_today.dayWeName}'),
        style: TextStyle(
          fontSize: orientation(context, 16.0, 20.0),
          fontFamily: 'kufi',
          color: Theme.of(context).colorScheme.surface,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(
        height: 8.0,
      ),
    ],
  );
}

Widget hijriDate2(BuildContext context) {
  var _today = HijriCalendar.now();
  AppLocalizations.of(context)!.appLang == "لغة التطبيق"
      ? HijriCalendar.setLocal('ar')
      : HijriCalendar.setLocal('en');
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SvgPicture.asset('assets/svg/hijri/${_today.hMonth}.svg',
          height: platformView(50.0, 70.0),
          colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.background, BlendMode.srcIn)),
      const SizedBox(
        height: 8.0,
      ),
      Text(
        '${_today.hDay} / ${_today.hMonth} / ${_today.hYear} هـ \n ${_today.dayWeName}',
        style: TextStyle(
          fontSize: platformView(12.0, 22.0),
          fontFamily: 'kufi',
          color: ThemeProvider.themeOf(context).id == 'dark'
              ? Theme.of(context).canvasColor
              : Theme.of(context).primaryColorDark,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

Widget topBar(BuildContext context) {
  return SizedBox(
    height: orientation(context, 130.0, platformView(40.0, 130.0)),
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
          width: MediaQuery.sizeOf(context).width / 1 / 2,
        ),
        Align(
          alignment: Alignment.topRight,
          child: customClose(context),
        ),
      ],
    ),
  );
}

Widget delete(BuildContext context) {
  return Container(
    // height: 55,
    width: MediaQuery.sizeOf(context).width,
    decoration: const BoxDecoration(
        color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(8))),
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

Widget iconBg(BuildContext context, var icon) {
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
                  icon,
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
                  icon,
                  color: Theme.of(context).colorScheme.surface,
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
    backgroundColor: Theme.of(context).colorScheme.surface,
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

void customErrorSnackBar(BuildContext context, String text) {
  BotToast.showCustomNotification(
    enableSlideOff: false,
    toastBuilder: (cancelFunc) {
      return Container(
        height: 60,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            )),
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
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
                    const SizedBox(
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

void customMobileNoteSnackBar(BuildContext context, String text) {
  BotToast.showCustomNotification(
    enableSlideOff: false,
    toastBuilder: (cancelFunc) {
      return Container(
        height: 80,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            )),
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
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
                    const SizedBox(
                      width: 8,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width / 1 / 2,
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
    height: 50,
    child: Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(
          'assets/svg/surah_na.svg',
          width: 150,
        ),
        SvgPicture.asset(
          'assets/svg/surah_name/00$num.svg',
          width: 60,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
      ],
    ),
  );
}

Widget juzNum(String num, context, Color color, double svgWidth) {
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
      SvgPicture.asset('assets/svg/juz/$num.svg',
          width: svgWidth, colorFilter: ColorFilter.mode(color, BlendMode.srcIn)
          // width: 100,
          ),
    ],
  );
}

Widget juzNum2(String num, context, Color color, double svgWidth) {
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
      SvgPicture.asset('assets/svg/juz/$num.svg',
          width: svgWidth, colorFilter: ColorFilter.mode(color, BlendMode.srcIn)
          // width: 100,
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

Widget juzNumEn(String num, context, Color color) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        num,
        style: TextStyle(
          fontSize: 12,
          fontFamily: 'kufi',
          color: ThemeProvider.themeOf(context).id == 'dark'
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

// Widget sorahPageReaderDropDown(BuildContext context) {
//   List<String> readerName = <String>[
//     AppLocalizations.of(context)!.reader1,
//     AppLocalizations.of(context)!.reader2,
//     AppLocalizations.of(context)!.reader3,
//     AppLocalizations.of(context)!.reader4,
//   ];
//
//   List<String> readerD = <String>[
//     "https://server7.mp3quran.net/",
//     "https://server10.mp3quran.net/",
//     "https://server13.mp3quran.net/",
//     "https://server10.mp3quran.net/",
//   ];
//
//   List<String> readerN = <String>[
//     "basit/",
//     "minsh/",
//     "husr/",
//     "ajm/",
//   ];
//
//   return DropdownButton2(
//     isExpanded: true,
//     alignment: Alignment.center,
//     items: [
//       DropdownMenuItem<String>(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0),
//           child: ListView.builder(
//             itemCount: readerName.length,
//             itemBuilder: (BuildContext context, int index) {
//               return Column(
//                 children: [
//                   ListTile(
//                     title: Text(
//                       readerName[index],
//                       style: TextStyle(
//                         color: sl<SurahAudioController>().sorahReaderNameValue ==
//                                 readerN[index]
//                             ? const Color(0xfffcbb76)
//                             : Theme.of(context).canvasColor,
//                         fontSize: 14,
//                       ),
//                     ),
//                     leading: Container(
//                       height: 20,
//                       width: 20,
//                       decoration: BoxDecoration(
//                         borderRadius:
//                             const BorderRadius.all(Radius.circular(2.0)),
//                         border: Border.all(
//                             color: sl<SurahAudioController>().sorahReaderNameValue ==
//                                     readerN[index]
//                                 ? const Color(0xfffcbb76)
//                                 : Theme.of(context).canvasColor,
//                             width: 2),
//                         color: const Color(0xff39412a),
//                       ),
//                       child: sl<SurahAudioController>().sorahReaderNameValue ==
//                               readerN[index]
//                           ? const Icon(Icons.done,
//                               size: 14, color: Color(0xfffcbb76))
//                           : null,
//                     ),
//                     onTap: () {
//                       surahAudioController.sorahReaderValue = readerD[index];
//                       surahAudioController.sorahReaderNameValue =
//                           readerN[index];
//                       surahAudioController.saveSorahReader(
//                           readerD[index], readerN[index]);
//                       Navigator.pop(context);
//                     },
//                   ),
//                   const Divider(
//                     endIndent: 16,
//                     indent: 16,
//                     height: 3,
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     ],
//     value: selectedValue,
//     onChanged: (value) {
//       selectedValue = value as String;
//     },
//     customButton: Icon(
//       Icons.person_search_outlined,
//       color: Theme.of(context).colorScheme.surface,
//     ),
//     iconStyleData: const IconStyleData(
//       iconSize: 24,
//     ),
//     buttonStyleData: const ButtonStyleData(
//       height: 50,
//       width: 50,
//       elevation: 0,
//     ),
//     dropdownStyleData: DropdownStyleData(
//         decoration: BoxDecoration(
//             color: Theme.of(context).colorScheme.surface.withOpacity(.9),
//             borderRadius: const BorderRadius.all(Radius.circular(8))),
//         padding: const EdgeInsets.only(left: 14, right: 14),
//         maxHeight: 230,
//         width: 230,
//         elevation: 0,
//         offset: const Offset(0, 0),
//         scrollbarTheme: ScrollbarThemeData(
//           radius: const Radius.circular(8),
//           thickness: MaterialStateProperty.all(6),
//         )),
//     menuItemStyleData: const MenuItemStyleData(
//       height: 35,
//     ),
//   );
// }

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

orientation(BuildContext context, var n1, var n2) {
  Orientation orientation = MediaQuery.orientationOf(context);
  return orientation == Orientation.portrait ? n1 : n2;
}

platformView(var p1, var p2) {
  return (Platform.isIOS || Platform.isAndroid || Platform.isFuchsia) ? p1 : p2;
}

Widget rightPage(BuildContext context, Widget child) {
  return Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(right: 4.0, top: 16.0, bottom: 16.0),
        child: Container(
          decoration: BoxDecoration(
              color: ThemeProvider.themeOf(context).id == 'dark'
                  ? Theme.of(context).primaryColorDark.withOpacity(.5)
                  : Theme.of(context).dividerColor.withOpacity(.5),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12))),
          // child: child,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 8.0, top: 16.0, bottom: 16.0),
        child: Container(
          decoration: BoxDecoration(
              color: ThemeProvider.themeOf(context).id == 'dark'
                  ? Theme.of(context).primaryColorDark.withOpacity(.7)
                  : Theme.of(context).dividerColor.withOpacity(.7),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12))),
          // child: child,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 12.0, top: 16.0, bottom: 16.0),
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
        padding: const EdgeInsets.only(left: 4.0, top: 16.0, bottom: 16.0),
        child: Container(
          decoration: BoxDecoration(
              color: ThemeProvider.themeOf(context).id == 'dark'
                  ? Theme.of(context).primaryColorDark.withOpacity(.5)
                  : Theme.of(context).dividerColor.withOpacity(.5),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12))),
          // child: child,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 16.0, bottom: 16.0),
        child: Container(
          decoration: BoxDecoration(
              color: ThemeProvider.themeOf(context).id == 'dark'
                  ? Theme.of(context).primaryColorDark.withOpacity(.7)
                  : Theme.of(context).dividerColor.withOpacity(.7),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12))),
          // child: child,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 12.0, top: 16.0, bottom: 16.0),
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

quarters(int index) {
  if (index == 1) {
    return SvgPicture.asset(
      'assets/svg/quarter/quarter_1.svg',
      height: 20,
    );
  } else if (index == 2) {
    return SvgPicture.asset(
      'assets/svg/quarter/quarter_2.svg',
      height: 20,
    );
  } else if (index == 3) {
    return SvgPicture.asset(
      'assets/svg/quarter/quarter_3.svg',
      height: 20,
    );
  } else if (index == 4) {
    return SvgPicture.asset(
      'assets/svg/quarter/quarter_4.svg',
      height: 20,
    );
  }
}

dropDownModalBottomSheet(
    BuildContext context, double height, width, Widget child) {
  double hei = MediaQuery.sizeOf(context).height;
  double wid = MediaQuery.sizeOf(context).width;
  showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(
          maxWidth: platformView(
              orientation(context, width, wid / 1 / 2), wid / 1 / 2),
          maxHeight: orientation(
              context, hei / 1 / 2, platformView(hei, hei / 1 / 2))),
      elevation: 0.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return child;
      });
}

allModalBottomSheet(
    BuildContext context, double height, double width, Widget child) {
  double hei = MediaQuery.sizeOf(context).height;
  double wid = MediaQuery.sizeOf(context).width;
  showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(
          maxWidth: platformView(
              orientation(context, width, wid / 1 / 2), wid / 1 / 2),
          maxHeight: orientation(
              context, hei * 3 / 4, platformView(hei, hei * 3 / 4))),
      elevation: 0.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return child;
      });
  // .whenComplete(() {
  //   screenSpringController.play(motion: Motion.reverse);
  // });
  // screenSpringController.play(motion: Motion.play);
}

fullModalBottomSheet(BuildContext context, double height, width, Widget child) {
  double hei = MediaQuery.sizeOf(context).height;
  double wid = MediaQuery.sizeOf(context).width;
  showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(
          maxWidth: platformView(
              orientation(context, width, wid / 1 / 2), wid / 1 / 2),
          maxHeight: orientation(
              context, hei * 1 / 2 * 1.8, platformView(hei, hei * 3 / 4))),
      elevation: 0.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return child;
      });
  // .whenComplete(() {
  //   screenSpringController.play(motion: Motion.reverse);
  // });
  // screenSpringController.play(motion: Motion.play);
}

Widget customClose(BuildContext context, {var close}) {
  return Semantics(
    button: true,
    label: 'Close',
    child: GestureDetector(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.close_outlined,
              size: 40,
              color: Theme.of(context).colorScheme.surface.withOpacity(.5)),
          Icon(Icons.close_outlined,
              size: 24,
              color: ThemeProvider.themeOf(context).id == 'dark'
                  ? Theme.of(context).canvasColor
                  : Theme.of(context).primaryColorDark),
        ],
      ),
      onTap: close ??
          () {
            Navigator.of(context).pop();
          },
    ),
  );
}

Widget customClose2(BuildContext context) {
  return Semantics(
    button: true,
    label: 'Close',
    child: GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                topLeft: Radius.circular(8),
              ),
              border:
                  Border.all(width: 2, color: Theme.of(context).dividerColor)),
          child: Icon(
            Icons.close_outlined,
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
      ),
    ),
  );
}

Widget customTextClose(BuildContext context) {
  return Semantics(
    button: true,
    label: 'Close',
    child: GestureDetector(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.close_outlined,
              size: 40,
              color: Theme.of(context).colorScheme.surface.withOpacity(.5)),
          Icon(Icons.close_outlined,
              size: 24,
              color: ThemeProvider.themeOf(context).id == 'dark'
                  ? Theme.of(context).canvasColor
                  : Theme.of(context).primaryColorDark),
        ],
      ),
      onTap: () {
        if (SlidingUpPanelStatus.hidden ==
            sl<GeneralController>().panelTextController.status) {
          sl<GeneralController>().panelTextController.collapse();
        } else {
          sl<GeneralController>().panelTextController.hide();
        }
      },
    ),
  );
}

Widget Function(BuildContext, EditableTextState) buildMyContextMenu() {
  return (BuildContext context, EditableTextState editableTextState) {
    final List<ContextMenuButtonItem> buttonItems =
        editableTextState.contextMenuButtonItems;
    buttonItems.insert(
      0,
      ContextMenuButtonItem(
        label: 'Add Note',
        onPressed: () {
          ContextMenuController.removeAny();
          sl<NotesController>().addTafseerToNote();
        },
      ),
    );

    return AdaptiveTextSelectionToolbar.buttonItems(
      anchors: editableTextState.contextMenuAnchors,
      buttonItems: buttonItems,
    );
  };
}

Widget Function(BuildContext, EditableTextState) buildMyContextMenuText() {
  return (BuildContext context, EditableTextState editableTextState) {
    final List<ContextMenuButtonItem> buttonItems =
        editableTextState.contextMenuButtonItems;
    buttonItems.insert(
      0,
      ContextMenuButtonItem(
        label: 'Add Note',
        onPressed: () {
          ContextMenuController.removeAny();
          sl<NotesController>().addTafseerTextToNote();
        },
      ),
    );

    return AdaptiveTextSelectionToolbar.buttonItems(
      anchors: editableTextState.contextMenuAnchors,
      buttonItems: buttonItems,
    );
  };
}

Widget fontSizeDropDown(BuildContext context) {
  return PopupMenuButton(
    position: PopupMenuPosition.under,
    icon: Semantics(
      button: true,
      enabled: true,
      label: 'Change Font Size',
      child: Icon(
        Icons.format_size,
        color: Theme.of(context).colorScheme.surface,
      ),
    ),
    color: Theme.of(context).colorScheme.surface.withOpacity(.8),
    itemBuilder: (context) => [
      PopupMenuItem(
        child: Obx(
          () => SizedBox(
            height: 30,
            width: MediaQuery.sizeOf(context).width,
            child: FlutterSlider(
              values: [sl<GeneralController>().fontSizeArabic.value],
              max: 50,
              min: 20,
              rtl: true,
              trackBar: FlutterSliderTrackBar(
                inactiveTrackBarHeight: 5,
                activeTrackBarHeight: 5,
                inactiveTrackBar: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.surface,
                ),
                activeTrackBar: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Theme.of(context).colorScheme.background),
              ),
              handlerAnimation: const FlutterSliderHandlerAnimation(
                  curve: Curves.elasticOut,
                  reverseCurve: null,
                  duration: Duration(milliseconds: 700),
                  scale: 1.4),
              onDragging: (handlerIndex, lowerValue, upperValue) async {
                lowerValue = lowerValue;
                upperValue = upperValue;
                sl<GeneralController>().fontSizeArabic.value = lowerValue;
                await sl<SharedPrefServices>()
                    .saveDouble(FONT_SIZE, lowerValue);
              },
              handler: FlutterSliderHandler(
                decoration: const BoxDecoration(),
                child: Material(
                  type: MaterialType.circle,
                  color: Colors.transparent,
                  elevation: 3,
                  child: SvgPicture.asset('assets/svg/slider_ic.svg'),
                ),
              ),
            ),
          ),
        ),
        height: 30,
      ),
    ],
  );
}

Widget audioContainer(BuildContext context, Widget myWidget,
    {double? height,
    double? width,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? margin2,
    EdgeInsetsGeometry? padding,
    Color? color}) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Container(
        alignment: Alignment.topCenter,
        height: height ?? 124,
        width: width ?? 400,
        margin: margin ??
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        padding: padding ?? const EdgeInsets.symmetric(vertical: 2.0),
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).dividerColor,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          // boxShadow: [
          //   BoxShadow(
          //     offset: const Offset(0, -2),
          //     blurRadius: 10,
          //     color: Theme.of(context).colorScheme.surface,
          //   ),
          // ],
        ),
        child: Container(
          margin: margin2 ?? const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: color ?? Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: myWidget,
        )),
  );
}
