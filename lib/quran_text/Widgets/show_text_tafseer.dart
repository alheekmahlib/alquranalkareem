import 'package:alquranalkareem/cubit/cubit.dart';
import 'package:alquranalkareem/notes/cubit/note_cubit.dart';
import 'package:alquranalkareem/quran_page/cubit/audio/cubit.dart';
import 'package:alquranalkareem/shared/controller/general_controller.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/controller/ayat_controller.dart';
import '../../shared/widgets/show_tafseer.dart';
import '../../shared/widgets/widgets.dart';
import '../cubit/quran_text_cubit.dart';
import '../text_page_view.dart';

class ShowTextTafseer extends StatefulWidget {
  const ShowTextTafseer({Key? key}) : super(key: key);

  @override
  State<ShowTextTafseer> createState() => _ShowTextTafseerState();
}

class _ShowTextTafseerState extends State<ShowTextTafseer> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<_ShowTextTafseerState> _selectableTextKey =
      GlobalKey<_ShowTextTafseerState>();
  late final AyatController ayatController = Get.put(AyatController());
  late final GeneralController generalController = Get.put(GeneralController());
  ArabicNumbers arabicNumber = ArabicNumbers();
  int pageNum = 0;
  int radioValue = 0;
  double lowerValue = 18;
  double upperValue = 40;
  String? selectedValue;
  double? sliderValue;

  @override
  void initState() {
    sliderValue = 0;
    AudioCubit.get(context).loadQuranReader();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    QuranCubit cubit = QuranCubit.get(context);
    NotesCubit notesCubit = NotesCubit.get(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            )),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            color: Theme.of(context).colorScheme.surface,
                            width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff91a57d).withOpacity(.2),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(
                                -1, -1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Icon(Icons.book,
                          size: 24,
                          color: Theme.of(context).colorScheme.surface),
                    ),
                    onTap: () {
                      if (SlidingUpPanelStatus.hidden ==
                          generalController.panelTextController.status) {
                        generalController.panelTextController.expand();
                      } else {
                        generalController.panelTextController.hide();
                      }
                      tafseerDropDown(context);
                    },
                  ),
                  customTextClose(context),
                  Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            color: Theme.of(context).colorScheme.surface,
                            width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff91a57d).withOpacity(.2),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(
                                -1, -1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(Icons.format_size,
                              size: 24,
                              color: Theme.of(context).colorScheme.surface),
                          fontSizeDropDown(context),
                        ],
                      )),
                ],
              ),
            ),
            const Divider(
              height: 0,
              thickness: 3,
            ),
            const SizedBox(
              height: 8,
            ),
            Flexible(
              flex: 4,
              child: Container(
                height: MediaQuery.of(context).size.height / 1 / 2 * 1.5,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).colorScheme.background,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height,
                    ),
                    child: Scrollbar(
                      controller: _scrollController,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Obx(() {
                          if (ayatController.currentPageLoading.value) {
                            return CircularProgressIndicator();
                          } else if (ayatController.currentText.value != null) {
                            allText =
                                '﴿${ayatController.currentText.value!.translateAyah}﴾\n\n' +
                                    ayatController.currentText.value!.translate;
                            allTitle =
                                '﴿${ayatController.currentText.value!.translateAyah}﴾';
                            return SelectableText.rich(
                              key: _selectableTextKey,
                              TextSpan(
                                children: <InlineSpan>[
                                  TextSpan(
                                    text:
                                        '﴿${ayatController.currentText.value!.translateAyah}﴾\n\n',
                                    style: TextStyle(
                                        color:
                                            ThemeProvider.themeOf(context).id ==
                                                    'dark'
                                                ? Colors.white
                                                : Colors.black,
                                        fontWeight: FontWeight.w100,
                                        height: 1.5,
                                        fontFamily: 'uthmanic2',
                                        fontSize: generalController
                                            .fontSizeArabic.value),
                                  ),
                                  WidgetSpan(
                                    child: Center(
                                      child: SizedBox(
                                        height: 50,
                                        child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1 /
                                                2,
                                            child: SvgPicture.asset(
                                              'assets/svg/space_line.svg',
                                            )),
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                    text: ayatController
                                        .currentText.value!.translate,
                                    style: TextStyle(
                                        color:
                                            ThemeProvider.themeOf(context).id ==
                                                    'dark'
                                                ? Colors.white
                                                : Colors.black,
                                        height: 1.5,
                                        fontSize: generalController
                                            .fontSizeArabic.value),
                                  ),
                                  WidgetSpan(
                                    child: Center(
                                      child: SizedBox(
                                        height: 50,
                                        child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1 /
                                                2,
                                            child: SvgPicture.asset(
                                              'assets/svg/space_line.svg',
                                            )),
                                      ),
                                    ),
                                  )
                                  // TextSpan(text: 'world', style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                              showCursor: true,
                              cursorWidth: 3,
                              cursorColor: Theme.of(context).dividerColor,
                              cursorRadius: const Radius.circular(5),
                              scrollPhysics: const ClampingScrollPhysics(),
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.justify,
                              contextMenuBuilder:
                                  buildMyContextMenu(notesCubit),
                              onSelectionChanged: handleSelectionChanged,
                            );
                          } else {
                            return Text(
                                'Error: ${ayatController.currentPageError.value}');
                          }
                        }),
                        // child: BlocBuilder<QuranTextCubit, QuranTextState>(
                        //   builder: (context, state) {
                        //     if (state is TextTextUpdated) {
                        //       allText = '﴿${state.translateAyah}﴾\n\n' +
                        //           state.translate;
                        //       allTitle = '﴿${state.translateAyah}﴾';
                        //       return Obx(() {
                        //         return SelectableText.rich(
                        //           key: _selectableTextKey,
                        //           TextSpan(
                        //             children: <InlineSpan>[
                        //               TextSpan(
                        //                 text: '﴿${state.translateAyah}﴾\n\n',
                        //                 style: TextStyle(
                        //                     color:
                        //                         ThemeProvider.themeOf(context)
                        //                                     .id ==
                        //                                 'dark'
                        //                             ? Colors.white
                        //                             : Colors.black,
                        //                     fontWeight: FontWeight.w100,
                        //                     height: 1.5,
                        //                     fontFamily: 'uthmanic2',
                        //                     fontSize: generalController
                        //                         .fontSizeArabic.value),
                        //               ),
                        //               WidgetSpan(
                        //                 child: Center(
                        //                   child: SizedBox(
                        //                     height: 50,
                        //                     child: SizedBox(
                        //                         width: MediaQuery.of(context)
                        //                                 .size
                        //                                 .width /
                        //                             1 /
                        //                             2,
                        //                         child: SvgPicture.asset(
                        //                           'assets/svg/space_line.svg',
                        //                         )),
                        //                   ),
                        //                 ),
                        //               ),
                        //               TextSpan(
                        //                 text: state.translate,
                        //                 style: TextStyle(
                        //                     color:
                        //                         ThemeProvider.themeOf(context)
                        //                                     .id ==
                        //                                 'dark'
                        //                             ? Colors.white
                        //                             : Colors.black,
                        //                     height: 1.5,
                        //                     fontSize: generalController
                        //                         .fontSizeArabic.value),
                        //               ),
                        //               WidgetSpan(
                        //                 child: Center(
                        //                   child: SizedBox(
                        //                     height: 50,
                        //                     child: SizedBox(
                        //                         width: MediaQuery.of(context)
                        //                                 .size
                        //                                 .width /
                        //                             1 /
                        //                             2,
                        //                         child: SvgPicture.asset(
                        //                           'assets/svg/space_line.svg',
                        //                         )),
                        //                   ),
                        //                 ),
                        //               )
                        //               // TextSpan(text: 'world', style: TextStyle(fontWeight: FontWeight.bold)),
                        //             ],
                        //           ),
                        //           showCursor: true,
                        //           cursorWidth: 3,
                        //           cursorColor: Theme.of(context).dividerColor,
                        //           cursorRadius: const Radius.circular(5),
                        //           scrollPhysics: const ClampingScrollPhysics(),
                        //           textDirection: TextDirection.rtl,
                        //           textAlign: TextAlign.justify,
                        //           contextMenuBuilder:
                        //               buildMyContextMenu(notesCubit),
                        //           onSelectionChanged: handleSelectionChanged,
                        //         );
                        //       });
                        //     } else {
                        //       return const SizedBox
                        //           .shrink(); // Or some other fallback widget
                        //     }
                        //   },
                        // ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Divider(
              height: 0,
            )
          ],
        ),
      ),
    );
  }

  tafseerDropDown(BuildContext context) {
    QuranCubit cubit = QuranCubit.get(context);
    QuranTextCubit TextCubit = QuranTextCubit.get(context);
    List<String> tafName = <String>[
      '${AppLocalizations.of(context)?.tafIbnkatheerN}',
      '${AppLocalizations.of(context)?.tafBaghawyN}',
      '${AppLocalizations.of(context)?.tafQurtubiN}',
      '${AppLocalizations.of(context)?.tafSaadiN}',
      '${AppLocalizations.of(context)?.tafTabariN}',
    ];
    List<String> tafD = <String>[
      '${AppLocalizations.of(context)?.tafIbnkatheerD}',
      '${AppLocalizations.of(context)?.tafBaghawyD}',
      '${AppLocalizations.of(context)?.tafQurtubiD}',
      '${AppLocalizations.of(context)?.tafSaadiD}',
      '${AppLocalizations.of(context)?.tafTabariD}',
    ];
    dropDownModalBottomSheet(
      context,
      MediaQuery.of(context).size.height / 1 / 2,
      MediaQuery.of(context).size.width,
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  if (SlidingUpPanelStatus.hidden ==
                      generalController.panelTextController.status) {
                    generalController.panelTextController.expand();
                  } else {
                    generalController.panelTextController.hide();
                  }
                },
                child: Container(
                  height: 30,
                  width: 30,
                  margin: const EdgeInsets.all(16.0),
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
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: SvgPicture.asset(
                    'assets/svg/tafseer.svg',
                    height: 50,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 90.0),
              child: ListView.builder(
                itemCount: tafName.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                        child: ListTile(
                          title: Text(
                            tafName[index],
                            style: TextStyle(
                                color: ayatController.radioValue == index
                                    ? Theme.of(context).primaryColorLight
                                    : const Color(0xffcdba72),
                                fontSize: 14,
                                fontFamily: 'kufi'),
                          ),
                          subtitle: Text(
                            tafD[index],
                            style: TextStyle(
                                color: ayatController.radioValue == index
                                    ? Theme.of(context).primaryColorLight
                                    : const Color(0xffcdba72),
                                fontSize: 12,
                                fontFamily: 'kufi'),
                          ),
                          trailing: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(2.0)),
                              border: Border.all(
                                  color: ayatController.radioValue == index
                                      ? Theme.of(context).primaryColorLight
                                      : const Color(0xffcdba72),
                                  width: 2),
                              color: const Color(0xff39412a),
                            ),
                            child: ayatController.radioValue == index
                                ? const Icon(Icons.done,
                                    size: 14, color: Color(0xfffcbb76))
                                : null,
                          ),
                          onTap: () {
                            print("IconButton pressed, calling updateTextText");
                            ayatController.handleRadioValueChanged(index);
                            ayatController.saveTafseer(index);
                            // Get new translation and update state
                            ayatController.getNewTranslationAndNotify(
                                context,
                                int.parse(ayatController.sorahTextNumber!),
                                int.parse(ayatController.ayahTextNumber!));
                            print("lastAyahInPage $lastAyahInPage");
                            if (SlidingUpPanelStatus.hidden ==
                                generalController.panelTextController.status) {
                              generalController.panelTextController.expand();
                            } else {
                              generalController.panelTextController.hide();
                            }
                            Navigator.pop(context);
                            setState(() {});
                          },
                          leading: Container(
                              height: 85.0,
                              width: 41.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4.0)),
                                  border: Border.all(
                                      color: Theme.of(context).dividerColor,
                                      width: 2)),
                              child: SvgPicture.asset(
                                'assets/svg/tafseer_book.svg',
                                colorFilter: ayatController.radioValue == index
                                    ? null
                                    : ColorFilter.mode(
                                        Theme.of(context)
                                            .canvasColor
                                            .withOpacity(.4),
                                        BlendMode.lighten),
                              )),
                        ),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                            border: Border.all(
                                color: Theme.of(context).dividerColor,
                                width: 1)),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 4.0),
                      ),
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
}
