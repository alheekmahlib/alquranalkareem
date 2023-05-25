import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/handler_animation.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:clipboard/clipboard.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../cubit/cubit.dart';
import '../../l10n/app_localizations.dart';
import '../../quran_page/data/model/ayat.dart';
import '../../shared/widgets/lottie.dart';
import '../../shared/widgets/widgets.dart';
import '../cubit/quran_text_cubit.dart';
import '../text_page_view.dart';

ArabicNumbers arabicNumber = ArabicNumbers();

menu(BuildContext context, int b, index, var details, translateData, widget,
    nomPageF, nomPageL) {
  QuranTextCubit TextCubit = QuranTextCubit.get(context);
  QuranCubit cubit = QuranCubit.get(context);
  bool? selectedValue;
  if (TextCubit.value == 1) {
    selectedValue = true;
  } else if (TextCubit.value == 0) {
    selectedValue = false;
  }

  var cancel = TextCubit.selected == selectedValue!
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
                        future: cubit
                            .handleRadioValueChanged(context, cubit.radioValue)
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
                                  context.read<QuranTextCubit>().updateTextText(
                                      "${aya.ayatext}", "${aya.translate}");
                                  if (SlidingUpPanelStatus.hidden ==
                                      cubit.panelTextController.status) {
                                    cubit.panelTextController.expand();
                                  } else {
                                    cubit.panelTextController.hide();
                                  }
                                  cancel();
                                },
                              );
                            } else {
                              // handle the case where the index is out of range
                              print('Ayat is $ayat');
                              print('Index is $b');
                              return Text(
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
                      onPressed: () {
                        TextCubit.selected = !TextCubit.selected;
                        FlutterClipboard.copy(
                          '﴿${widget.ayahs![b].text}﴾ '
                          '[${widget.name}-'
                          '${arabicNumber.convert(widget.ayahs![b].numberInSurah.toString())}]',
                        ).then((value) => customSnackBar(
                            context, AppLocalizations.of(context)!.copyAyah));
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
                        cubit.transIndex = TextCubit.transValue;
                        final verseNumber = widget.ayahs![b].numberInSurah!;
                        final translation =
                            translateData?[verseNumber - 1]['text'];
                        QuranCubit.get(context).showVerseOptionsBottomSheet(
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

Widget fontSizeDropDown(BuildContext context, var setState) {
  return DropdownButton2(
    isExpanded: true,
    items: [
      DropdownMenuItem<String>(
        child: FlutterSlider(
          values: [TextPageView.fontSizeArabic],
          max: 60,
          min: 18,
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
          onDragging: (handlerIndex, lowerValue, upperValue) {
            lowerValue = lowerValue;
            upperValue = upperValue;
            TextPageView.fontSizeArabic = lowerValue;
            QuranCubit.get(context)
                .saveQuranFontSize(TextPageView.fontSizeArabic);
            setState(() {});
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
      )
    ],
    value: selectedValue,
    onChanged: (value) {
      setState(() {
        selectedValue = value as String;
      });
    },
    customButton: Container(
        height: 25,
        width: 25,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            border: Border.all(
                width: 1, color: Theme.of(context).colorScheme.surface)),
        child: Icon(
          Icons.format_size,
          size: 20,
          color: Theme.of(context).colorScheme.surface,
        )),
    iconStyleData: const IconStyleData(
      iconSize: 20,
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
        padding: const EdgeInsets.only(left: 1, right: 1),
        maxHeight: 230,
        width: 230,
        elevation: 0,
        offset: const Offset(0, 0),
        scrollbarTheme: ScrollbarThemeData(
          radius: const Radius.circular(8),
          thickness: MaterialStateProperty.all(6),
        )),
    menuItemStyleData: const MenuItemStyleData(
      height: 45,
    ),
  );
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

// Widget scrollDropDown(BuildContext context) {
//   QuranTextCubit textCubit = QuranTextCubit.get(context);
//   return DropdownButton2(
//     isExpanded: true,
//     items: [
//       DropdownMenuItem<String>(
//         child: StatefulBuilder(builder: (BuildContext context, setState) {
//           return Slider(
//             value: textCubit.scrollSpeed,
//             min: .05,
//             max: .10,
//             onChanged: (double value) {
//               setState(() {
//                 textCubit.scrollSpeedNotifier!.value = value;
//                 print(textCubit.scrollSpeedNotifier!.value);
//                 textCubit.scrollSpeed = value;
//                 print(textCubit.scrollSpeed);
//                 if (textCubit.scrolling) {
//                   _toggleScroll(); // Stop the scrolling with the old speed
//                   _toggleScroll(); // Restart the scrolling with the new speed
//                 }
//               });
//             },
//           );
//         }),
//         // child: FlutterSlider(
//         //   values: [_scrollSpeed],
//         //   max: 2.0,
//         //   min: .05,
//         //   rtl: true,
//         //   trackBar: FlutterSliderTrackBar(
//         //     inactiveTrackBarHeight: 5,
//         //     activeTrackBarHeight: 5,
//         //     inactiveTrackBar: BoxDecoration(
//         //       borderRadius: BorderRadius.circular(8),
//         //       color: Theme.of(context).colorScheme.surface,
//         //     ),
//         //     activeTrackBar: BoxDecoration(
//         //         borderRadius: BorderRadius.circular(4),
//         //         color: Theme.of(context).colorScheme.background),
//         //   ),
//         //   handlerAnimation: const FlutterSliderHandlerAnimation(
//         //       curve: Curves.elasticOut,
//         //       reverseCurve: null,
//         //       duration: Duration(milliseconds: 700),
//         //       scale: 1.4),
//         //   onDragging: (handlerIndex, lowerValue, upperValue) {
//         //     setState(() {
//         //       _scrollSpeedNotifier!.value = lowerValue;
//         //       print(_scrollSpeedNotifier!.value);
//         //       // lowerValue = lowerValue;
//         //       // upperValue = upperValue;
//         //       _scrollSpeed = lowerValue;
//         //       print(_scrollSpeed);
//         //       if (_scrolling) {
//         //         _toggleScroll(); // Stop the scrolling with the old speed
//         //         _toggleScroll(); // Restart the scrolling with the new speed
//         //       }
//         //     });
//         //   },
//         //   handler: FlutterSliderHandler(
//         //     decoration: const BoxDecoration(),
//         //     child: Material(
//         //       type: MaterialType.circle,
//         //       color: Colors.transparent,
//         //       elevation: 3,
//         //       child: SvgPicture.asset('assets/svg/slider_ic.svg'),
//         //     ),
//         //   ),
//         // ),
//       )
//     ],
//     // value: textCubit.scrollSpeed,
//     onChanged: (value) {
//       setState(() {
//         textCubit.scrollSpeed = value as double;
//       });
//     },
//     customButton: Container(
//         height: 25,
//         width: 25,
//         decoration: BoxDecoration(
//             borderRadius: const BorderRadius.all(
//               Radius.circular(8),
//             ),
//             border: Border.all(
//                 width: 1, color: Theme.of(context).colorScheme.surface)),
//         child: Icon(
//           Icons.format_size,
//           size: 20,
//           color: Theme.of(context).colorScheme.surface,
//         )),
//     iconStyleData: const IconStyleData(
//       iconSize: 20,
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
//         )
//     ),
//     menuItemStyleData: const MenuItemStyleData(
//       height: 35,
//     ),
//   );
// }

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
