import 'dart:io' show Platform;

import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../presentation/controllers/general_controller.dart';
import '../../presentation/controllers/notes_controller.dart';
import '../../presentation/screens/notes/notes_list.dart';
import '../../presentation/screens/quran_text/widgets/bookmarks_text_list.dart';
import '../../presentation/screens/quran_text/widgets/quran_text_search.dart';
import '../services/services_locator.dart';
import '/core/utils/constants/extensions.dart';
import 'custom_paint/bg_icon.dart';

double lowerValue = 24;
double upperValue = 50;
String? selectedValue;

Widget quranPageSorahList(BuildContext context, double width) {
  return Semantics(
    button: true,
    enabled: true,
    label: 'surahsList'.tr,
    child: GestureDetector(
        child: iconBg(context, Icons.list_alt_outlined),
        onTap: () {
          sl<GeneralController>().slideOpen();
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
    label: 'notes'.tr,
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
        }
      },
    ),
  );
}

Widget notesListText(BuildContext context, double width) {
  return Semantics(
    button: true,
    enabled: true,
    label: 'notes'.tr,
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
    label: 'bookmarksList'.tr,
    child: GestureDetector(
      child: iconBg(context, Icons.bookmarks_outlined),
      onTap: () {
        sl<GeneralController>().slideOpen();
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
    label: 'bookmarksList'.tr,
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
    label: 'search'.tr,
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
  'appLang'.tr == "لغة التطبيق"
      ? HijriCalendar.setLocal('ar')
      : HijriCalendar.setLocal('en');
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SvgPicture.asset('assets/svg/hijri/${_today.hMonth}.svg',
          height: context.customOrientation(70.0, 100.0),
          colorFilter:
              ColorFilter.mode(Get.theme.colorScheme.surface, BlendMode.srcIn)),
      Text(
        arabicNumber.convert(
            '${_today.hDay} / ${_today.hMonth} / ${_today.hYear} هـ \n ${_today.dayWeName}'),
        style: TextStyle(
          fontSize: context.customOrientation(16.0, 20.0),
          fontFamily: 'kufi',
          color: Get.theme.colorScheme.surface,
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
  'appLang'.tr == "لغة التطبيق"
      ? HijriCalendar.setLocal('ar')
      : HijriCalendar.setLocal('en');
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SvgPicture.asset('assets/svg/hijri/${_today.hMonth}.svg',
          height: context.definePlatform(50.0, 70.0),
          colorFilter: ColorFilter.mode(
              Get.theme.colorScheme.background, BlendMode.srcIn)),
      const SizedBox(
        height: 8.0,
      ),
      Text(
        '${_today.hDay} / ${_today.hMonth} / ${_today.hYear} هـ \n ${_today.dayWeName}',
        style: TextStyle(
          fontSize: context.definePlatform(12.0, 22.0),
          fontFamily: 'kufi',
          color: Get.isDarkMode
              ? Get.theme.canvasColor
              : Get.theme.primaryColorDark,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

Widget iconBg(BuildContext context, var icon) {
  return SizedBox(
    height: 50,
    width: 50,
    child: Get.isDarkMode
        ? CustomPaint(
            painter: BgIcon(),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 35,
                  width: 35,
                  color: Get.theme.colorScheme.background,
                ),
                Icon(
                  icon,
                  color: Get.theme.colorScheme.surface,
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
                  color: Get.theme.colorScheme.background,
                ),
                Icon(
                  icon,
                  color: Get.theme.colorScheme.surface,
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
    backgroundColor: Get.theme.colorScheme.surface,
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

void customErrorSnackBar(String text) {
  BotToast.showCustomNotification(
    enableSlideOff: false,
    toastBuilder: (cancelFunc) {
      return Container(
        height: 60,
        decoration: BoxDecoration(
            color: Get.theme.colorScheme.primary,
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

void customMobileNoteSnackBar(String text) {
  BotToast.showCustomNotification(
    enableSlideOff: false,
    toastBuilder: (cancelFunc) {
      return Container(
        height: 80,
        decoration: BoxDecoration(
            color: Get.theme.colorScheme.surface,
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
                        width: 300,
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

Widget surahNameWidget(String num, Color color, {double? height}) {
  return SvgPicture.asset(
    'assets/svg/surah_name/00$num.svg',
    height: height ?? 33,
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
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
          color: Get.isDarkMode ? Colors.white : Colors.black,
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
            color: Get.theme.colorScheme.surface.withOpacity(.2),
            border: Border.symmetric(
                vertical: BorderSide(
                    color: Get.theme.colorScheme.surface, width: 2))),
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
            color: Get.theme.colorScheme.surface.withOpacity(.8),
            border: Border.symmetric(
                vertical: BorderSide(
                    color: Get.theme.colorScheme.surface, width: 2))),
        child: myWidget,
      ));
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
          maxWidth: context.definePlatform(
              context.customOrientation(width, wid / 1 / 2), wid / 1 / 2),
          maxHeight: context.customOrientation(
              hei / 1 / 2, context.definePlatform(hei, hei / 1 / 2))),
      elevation: 0.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      backgroundColor: Get.theme.colorScheme.background,
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
          maxWidth: context.definePlatform(
              context.customOrientation(width, wid / 1 / 2), wid / 1 / 2),
          maxHeight: context.customOrientation(
              hei * 3 / 4, context.definePlatform(hei, hei * 3 / 4))),
      elevation: 0.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      backgroundColor: Get.theme.colorScheme.background,
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
          maxWidth: context.definePlatform(
              context.customOrientation(width, wid / 1 / 2), wid / 1 / 2),
          maxHeight: context.customOrientation(
              hei * 1 / 2 * 1.8, context.definePlatform(hei, hei * 3 / 4))),
      elevation: 0.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      backgroundColor: Get.theme.colorScheme.background,
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
      child: SvgPicture.asset(
        'asset/svg/close.svg',
        height: 70,
        width: 70,
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
              color: Get.theme.colorScheme.background,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                topLeft: Radius.circular(8),
              ),
              border: Border.all(width: 2, color: Get.theme.dividerColor)),
          child: Icon(
            Icons.close_outlined,
            color: Get.theme.colorScheme.surface,
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
              size: 40, color: Get.theme.colorScheme.surface.withOpacity(.5)),
          Icon(Icons.close_outlined,
              size: 24,
              color: Get.isDarkMode
                  ? Get.theme.canvasColor
                  : Get.theme.primaryColorDark),
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
