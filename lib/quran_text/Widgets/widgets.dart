import 'package:alquranalkareem/notes/cubit/note_cubit.dart';
import 'package:alquranalkareem/quran_text/Widgets/text_overflow_detector.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../cubit/translateDataCubit/_cubit.dart';
import '../../cubit/translateDataCubit/translateDataState.dart';
import '../../l10n/app_localizations.dart';
import '../../quran_page/data/model/ayat.dart';
import '../../shared/controller/ayat_controller.dart';
import '../../shared/controller/general_controller.dart';
import '../../shared/share/ayah_to_images.dart';
import '../../shared/widgets/lottie.dart';
import '../../shared/widgets/show_tafseer.dart';
import '../../shared/widgets/svg_picture.dart';
import '../../shared/widgets/widgets.dart';
import '../cubit/quran_text_cubit.dart';
import '../text_page_view.dart';

ArabicNumbers arabicNumber = ArabicNumbers();
late final AyatController ayatController = Get.put(AyatController());
late final GeneralController generalController = Get.put(GeneralController());

menu(BuildContext context, int b, index, var details, translateData, widget,
    nomPageF, nomPageL) {
  QuranTextCubit TextCubit = QuranTextCubit.get(context);

  bool? selectedValue;
  if (TextCubit.value == 1) {
    selectedValue = true;
  } else if (TextCubit.value == 0) {
    selectedValue = false;
  }

  TextCubit.selected == selectedValue!
      ? BotToast.showAttachedWidget(
          target: details.globalPosition,
          verticalOffset: TextCubit.verticalOffset,
          horizontalOffset: TextCubit.horizontalOffset,
          preferDirection: TextCubit.preferDirection,
          animationDuration: const Duration(microseconds: 700),
          animationReverseDuration: const Duration(microseconds: 700),
          attachedBuilder: (cancel) => Card(
            color: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                        color: Color(0xfff3efdf),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: FutureBuilder<List<Ayat>>(
                        future: ayatController
                            .handleRadioValueChanged(ayatController.radioValue)
                            .getAyahTranslate(widget.number),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            List<Ayat>? ayat = snapshot.data;
                            if (ayat != null && ayat.length > b) {
                              Ayat aya = ayat[b];
                              return IconButton(
                                icon: const Icon(
                                  Icons.text_snippet_outlined,
                                  size: 24,
                                  color: Color(0x99f5410a),
                                ),
                                onPressed: () {
                                  TextCubit.selected = !TextCubit.selected;
                                  ayatController.updateText(
                                      "${aya.ayatext}", "${aya.translate}");
                                  if (SlidingUpPanelStatus.hidden ==
                                      generalController
                                          .panelTextController.status) {
                                    generalController.panelTextController
                                        .expand();
                                  } else {
                                    generalController.panelTextController
                                        .hide();
                                  }
                                  cancel();
                                },
                              );
                            } else {
                              // handle the case where the index is out of range
                              print('Ayat is $ayat');
                              print('Index is $b');
                              return const Text(
                                  'Ayat not found'); // Or another widget to indicate an error or empty state.
                            }
                          } else {
                            return Center(
                              child: search(100.0, 40.0),
                            );
                          }
                        }),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                        color: Color(0xfff3efdf),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: IconButton(
                      icon: const Icon(
                        Icons.bookmark_border,
                        size: 24,
                        color: Color(0x99f5410a),
                      ),
                      onPressed: () {
                        TextCubit.selected = !TextCubit.selected;
                        TextCubit.addBookmarkText(
                                widget.name!,
                                widget.number!,
                                index == 0 ? index + 1 : index + 2,
                                // widget.surah!.ayahs![b].page,
                                nomPageF,
                                nomPageL,
                                TextCubit.lastRead)
                            .then((value) => customSnackBar(context,
                                AppLocalizations.of(context)!.addBookmark));
                        print(widget.name!);
                        print(widget.number!);
                        print(nomPageF);
                        print(nomPageL);
                        cancel();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                        color: Color(0xfff3efdf),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: IconButton(
                      icon: const Icon(
                        Icons.copy_outlined,
                        size: 24,
                        color: Color(0x99f5410a),
                      ),
                      onPressed: () async {
                        TextCubit.selected = !TextCubit.selected;
                        await Clipboard.setData(ClipboardData(
                                text:
                                    '﴿${widget.ayahs![b].text}﴾ [${widget.name}-${arabicNumber.convert(widget.ayahs![b].numberInSurah.toString())}]'))
                            .then((value) => customSnackBar(context,
                                AppLocalizations.of(context)!.copyAyah));
                        cancel();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                        color: Color(0xfff3efdf),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: IconButton(
                      icon: const Icon(
                        Icons.play_arrow_outlined,
                        size: 24,
                        color: Color(0x99f5410a),
                      ),
                      onPressed: () {
                        TextCubit.selected = !TextCubit.selected;
                        switch (TextCubit.controller.status) {
                          case AnimationStatus.dismissed:
                            TextCubit.controller.forward();
                            break;
                          case AnimationStatus.completed:
                            TextCubit.controller.reverse();
                            break;
                          default:
                        }
                        cancel();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                        color: Color(0xfff3efdf),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: IconButton(
                      icon: const Icon(
                        Icons.share_outlined,
                        size: 23,
                        color: Color(0x99f5410a),
                      ),
                      onPressed: () {
                        TextCubit.selected = !TextCubit.selected;
                        ayatController.translateIndex = TextCubit.transValue;
                        final verseNumber = widget.ayahs![b].numberInSurah!;
                        final translation =
                            translateData?[verseNumber - 1]['text'];
                        showVerseOptionsBottomSheet(
                            context,
                            verseNumber,
                            widget.number,
                            "${widget.ayahs![b].text}",
                            translation ?? '',
                            widget.name);
                        print("Verse Number: $verseNumber");
                        print("Translation: translation");
                        cancel();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      : null;
}

Widget animatedToggleSwitch(BuildContext context, var setState) {
  QuranTextCubit TextCubit = QuranTextCubit.get(context);
  return AnimatedToggleSwitch<int>.rolling(
    current: TextCubit.value,
    values: const [0, 1],
    onChanged: (i) {
      setState(() {
        TextCubit.value = i;
        TextCubit.saveSwitchValue(TextCubit.value);
      });
    },
    iconBuilder: rollingIconBuilder,
    borderWidth: 1,
    indicatorColor: Theme.of(context).colorScheme.surface,
    innerColor: Theme.of(context).canvasColor,
    borderRadius: const BorderRadius.all(Radius.circular(8)),
    height: 25,
    dif: 2.0,
    borderColor: Theme.of(context).colorScheme.surface,
  );
}

Widget rollingIconBuilder(int value, Size iconSize, bool foreground) {
  IconData data = Icons.textsms_outlined;
  if (value.isEven) data = Icons.text_snippet_outlined;
  return Icon(
    data,
    size: 20,
  );
}

Widget translateDropDown(BuildContext context, var setState) {
  QuranTextCubit quranTextCubit = QuranTextCubit.get(context);
  List<String> transName = <String>[
    'English',
    'Spanish',
  ];
  return DropdownButton2(
    isExpanded: true,
    items: [
      DropdownMenuItem<String>(
        child: ListView.builder(
          itemCount: transName.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                ListTile(
                  title: Text(
                    transName[index],
                    style: TextStyle(
                        color: quranTextCubit.transValue == index
                            ? const Color(0xfffcbb76)
                            : Theme.of(context).canvasColor,
                        fontSize: 16,
                        fontFamily: 'kufi'),
                  ),
                  leading: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(2.0)),
                      border: Border.all(
                          color: quranTextCubit.transValue == index
                              ? const Color(0xfffcbb76)
                              : Theme.of(context).canvasColor,
                          width: 2),
                      color: const Color(0xff39412a),
                    ),
                    child: quranTextCubit.transValue == index
                        ? const Icon(Icons.done,
                            size: 14, color: Color(0xfffcbb76))
                        : null,
                  ),
                  onTap: () {
                    setState(() {
                      // cubit.translate = '${aya!.translate}';
                      // print(cubit.translate);

                      quranTextCubit.saveTranslateValue(index);
                      quranTextCubit.translateHandleRadioValueChanged(index);
                    });
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
      )
    ],
    value: selectedValue,
    onChanged: (value) {
      setState(() {
        selectedValue = value as String;
      });
    },
    customButton: Icon(
      Icons.translate_outlined,
      color: Theme.of(context).colorScheme.surface,
    ),
    iconStyleData: const IconStyleData(
      iconSize: 24,
    ),
    buttonStyleData: const ButtonStyleData(
      height: 50,
      width: 50,
      elevation: 0,
    ),
    dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(.9),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        padding: const EdgeInsets.only(left: 14, right: 14),
        maxHeight: 230,
        width: 230,
        elevation: 0,
        offset: const Offset(0, 0),
        scrollbarTheme: ScrollbarThemeData(
          radius: const Radius.circular(8),
          thickness: MaterialStateProperty.all(6),
        )),
    menuItemStyleData: const MenuItemStyleData(
      height: 115,
    ),
  );
}

Widget greeting(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Text(
      '| ${generalController.greeting.value} |',
      style: TextStyle(
        fontSize: 16.0,
        fontFamily: 'kufi',
        color: Theme.of(context).colorScheme.surface,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

Widget singleAyah(
    BuildContext context, var setState, widget, translateData, int index) {
  QuranTextCubit TextCubit = QuranTextCubit.get(context);
  NotesCubit notesCubit = NotesCubit.get(context);
  Color backColor = Theme.of(context).colorScheme.surface.withOpacity(0.4);
  return Stack(
    children: [
      GestureDetector(
        onTap: () {
          TextCubit.controller.reverse();
          setState(() {
            backColor = Colors.transparent;
          });
        },
        // child: AutoScrollTag(
        //   key: ValueKey(index),
        //   controller: TextCubit.scrollController!,
        //   index: index,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.all(Radius.circular(4))),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: spaceLine(
                    20,
                    MediaQuery.of(context).size.width / 1 / 2,
                  ),
                ),
              ),
              widget.surah!.number == 9
                  ? const SizedBox.shrink()
                  : widget.surah!.ayahs![index].numberInSurah == 1
                      ? besmAllah(context)
                      : const SizedBox.shrink(),
              // WordSelectableText(
              //     selectable:  true,
              //     highlight:  true,
              //
              //     text: widget.surah!.ayahs![index].text!,
              //     onWordTapped: (word, index) {},
              //     style: TextStyle(
              //       fontSize:
              //       TextPageView
              //           .fontSizeArabic.value,
              //       fontWeight:
              //       FontWeight
              //           .normal,
              //       fontFamily:
              //       'uthmanic2',
              //       color: ThemeProvider.themeOf(context)
              //           .id ==
              //           'dark'
              //           ? Colors
              //           .white
              //           : Colors
              //           .black,
              //       background:
              //       Paint()
              //         ..color = index ==
              //             TextCubit.isSelected
              //             ? backColor
              //             : Colors.transparent
              //         ..strokeJoin =
              //             StrokeJoin
              //                 .round
              //         ..strokeCap =
              //             StrokeCap
              //                 .round
              //         ..style =
              //             PaintingStyle
              //                 .fill,
              //     ),),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SelectableText.rich(
                  showCursor: true,
                  cursorWidth: 3,
                  cursorColor: Theme.of(context).dividerColor,
                  cursorRadius: const Radius.circular(5),
                  scrollPhysics: const ClampingScrollPhysics(),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.justify,
                  TextSpan(children: [
                    TextSpan(
                        text: widget.surah!.ayahs![index].text!,
                        style: TextStyle(
                          fontSize: generalController.fontSizeArabic.value,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'uthmanic2',
                          color: ThemeProvider.themeOf(context).id == 'dark'
                              ? Colors.white
                              : Colors.black,
                          background: Paint()
                            ..color = index == audioController.ayahSelected
                                ? TextCubit.selected
                                    ? backColor
                                    : Colors.transparent
                                : Colors.transparent
                            ..strokeJoin = StrokeJoin.round
                            ..strokeCap = StrokeCap.round
                            ..style = PaintingStyle.fill,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTapDown = (TapDownDetails details) {
                            setState(() {
                              TextCubit.selected = !TextCubit.selected;
                              lastAyahInPage =
                                  widget.surah!.ayahs![index].numberInSurah;
                              textSurahNum = widget.surah!.number;
                              backColor = Colors.transparent;
                              ayatController.sorahTextNumber =
                                  widget.surah!.number!.toString();
                              ayatController.ayahTextNumber = widget
                                  .surah!.ayahs![index].numberInSurah
                                  .toString();
                              audioController.ayahSelected = index;
                            });
                            menu(context, index, index, details, translateData,
                                widget.surah, widget.nomPageF, widget.nomPageL);
                          }),
                    TextSpan(
                      text:
                          ' ${arabicNumber.convert(widget.surah!.ayahs![index].numberInSurah.toString())}',
                      style: TextStyle(
                        fontSize: generalController.fontSizeArabic.value + 5,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'uthmanic2',
                        color: ThemeProvider.themeOf(context).id == 'dark'
                            ? Theme.of(context).colorScheme.surface
                            : Theme.of(context).primaryColorLight,
                      ),
                    )
                  ]),
                  contextMenuBuilder: buildMyContextMenuText(notesCubit),
                  onSelectionChanged: handleSelectionChanged,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                          alignment: Alignment.centerRight,
                          child: translateDropDown(context, setState)),
                      spaceLine(
                        20,
                        MediaQuery.of(context).size.width / 1 / 2,
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: juzNumEn(
                          'Part\n${widget.surah!.ayahs![index].juz}',
                          context,
                          ThemeProvider.themeOf(context).id == 'dark'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 16.0, right: 32.0, left: 32.0),
                child: BlocBuilder<TranslateDataCubit, TranslateDataState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      // Display a loading indicator while the translation data is being fetched
                      return search(50.0, 50.0);
                    } else {
                      final translateData = state.data;
                      if (translateData != null && translateData.isNotEmpty) {
                        // Use the translation variable in your widget tree
                        return ReadMoreLess(
                          text: translateData[index]['text'] ?? '',
                          textStyle: TextStyle(
                            fontSize:
                                generalController.fontSizeArabic.value - 10,
                            fontFamily: 'kufi',
                            color: ThemeProvider.themeOf(context).id == 'dark'
                                ? Colors.white
                                : Colors.black,
                          ),
                          textAlign: TextAlign.justify,
                          readMoreText: AppLocalizations.of(context)!.readMore,
                          readLessText: AppLocalizations.of(context)!.readLess,
                          buttonTextStyle: TextStyle(
                            fontSize: 12,
                            fontFamily: 'kufi',
                            color: ThemeProvider.themeOf(context).id == 'dark'
                                ? Colors.white
                                : Theme.of(context).primaryColorLight,
                          ),
                          iconColor: ThemeProvider.themeOf(context).id == 'dark'
                              ? Colors.white
                              : Theme.of(context).primaryColorLight,
                        ); // Replace this with your actual widget
                      } else {
                        // Display a placeholder widget if there's no translation data
                        return const Text('No translation available');
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: juzNum(
              '${widget.surah!.ayahs![index].juz}',
              context,
              ThemeProvider.themeOf(context).id == 'dark'
                  ? Colors.white
                  : Colors.black,
              25),
        ),
      ),
    ],
  );
}

Widget pageAyah(BuildContext context, var setState, widget,
    List<InlineSpan> text, int index) {
  QuranTextCubit TextCubit = QuranTextCubit.get(context);
  NotesCubit notesCubit = NotesCubit.get(context);
  return Stack(
    children: [
      GestureDetector(
        onTap: () {
          TextCubit.controller.reverse();
        },
        // child: AutoScrollTag(
        //   key: ValueKey(index),
        //   controller: TextCubit.scrollController!,
        //   index: index,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.all(Radius.circular(8))),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: spaceLine(
                    20,
                    MediaQuery.of(context).size.width / 1 / 2,
                  ),
                ),
              ),
              widget.surah!.number == 9
                  ? const SizedBox.shrink()
                  : widget.surah!.ayahs![index].numberInSurah == 1
                      ? besmAllah(context)
                      : const SizedBox.shrink(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SelectableText.rich(
                  showCursor: true,
                  cursorWidth: 3,
                  cursorColor: Theme.of(context).dividerColor,
                  cursorRadius: const Radius.circular(5),
                  scrollPhysics: const ClampingScrollPhysics(),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.justify,
                  TextSpan(
                    style: TextStyle(
                        fontSize: generalController.fontSizeArabic.value,
                        fontFamily: 'uthmanic2'),
                    children: text.map((e) {
                      return e;
                    }).toList(),
                  ),
                  contextMenuBuilder: buildMyContextMenuText(notesCubit),
                  onSelectionChanged: handleSelectionChangedText,
                ),
              ),
              Center(
                child: spaceLine(
                  20,
                  MediaQuery.of(context).size.width / 1 / 2,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: pageNumber(
                    arabicNumber.convert(widget.nomPageF! + index).toString(),
                    context,
                    Theme.of(context).primaryColor),
              ),
            ],
          ),
        ),
        // ),
      ),
      Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
          child: juzNum(
              '${TextCubit.juz}',
              context,
              ThemeProvider.themeOf(context).id == 'dark'
                  ? Colors.white
                  : Colors.black,
              25),
        ),
      )
    ],
  );
}
