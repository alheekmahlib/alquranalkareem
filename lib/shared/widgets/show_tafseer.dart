import 'package:alquranalkareem/cubit/cubit.dart';
import 'package:alquranalkareem/quran_page/cubit/audio/cubit.dart';
import 'package:alquranalkareem/shared/widgets/widgets.dart';
import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/handler_animation.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:theme_provider/theme_provider.dart';
import '../../cubit/translateRepositoryCubit2/translate_repository2_cubit.dart';
import '../../l10n/app_localizations.dart';
import '../../notes/note_controller.dart';
import '../../notes/textSelectionControls.dart';
import '../../quran_page/data/model/ayat.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class ShowTafseer extends StatefulWidget {
  const ShowTafseer({Key? key}) : super(key: key);

  static double fontSizeArabic = 18;

  @override
  State<ShowTafseer> createState() => _ShowTafseerState();
}

class _ShowTafseerState extends State<ShowTafseer> {
  final ScrollController _scrollController = ScrollController();
  ArabicNumbers arabicNumber = ArabicNumbers();
  int pageNum = 0;
  int radioValue = 0;
  double lowerValue = 18;
  double upperValue = 40;
  String? selectedValue;
  double? sliderValue;
  double? isSelected;
  int? ayahSelected, ayahNumber, surahNumber;
  String? surahName;
  final NoteController _noteController = Get.put(NoteController());

  @override
  void initState() {
    QuranCubit.get(context).loadFontSize();

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
    return _showTafseer(cubit.cuMPage);
  }

  Widget _showTafseer(int pageNum) {
    QuranCubit cubit = QuranCubit.get(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: FutureBuilder<List<Ayat>>(
          builder: (context, snapshot) {
            List<Ayat>? ayat = snapshot.data;
            _allText = '﴿${cubit.translateAyah}﴾\n\n' + cubit.translate;
            _allTitle = '﴿${cubit.translateAyah}﴾';
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                icon: Icon(Icons.book,
                                    size: 24,
                                    color: Theme.of(context).colorScheme.surface),
                                onPressed: () => tafseerDropDown(context),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              flex: 1,
                              child: fontSizeDropDown(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(flex: 7, child: ayahList(pageNum)),
                  ],
                ),
                const Divider(
                  height: 0,
                  thickness: 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (ayahNumber == null) {
                          customErrorSnackBar(
                              context,
                              AppLocalizations.of(context)!
                                  .choiceAyah);
                        } else {
                          FlutterClipboard.copy(
                            '﴿${cubit.translateAyah}﴾\n\n'
                                '${cubit.translate}',
                          ).then((value) =>
                              customSnackBar(
                                  context,
                                  AppLocalizations.of(
                                      context)!
                                      .copyTafseer));
                        }
                      },
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .background,
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                              border: Border.all(
                                  width: 2,
                                  color: Theme.of(context).dividerColor)),
                          child: Icon(
                            Icons.copy_outlined,
                            size: 18,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        // cubit.radioValue == 3;
                        if (ayahNumber == null) {
                          customErrorSnackBar(
                              context,
                              AppLocalizations.of(context)!
                                  .choiceAyah);
                        } else if (cubit.radioValue == 3) {
                        cubit.showVerseOptionsBottomSheet(
                            context,
                            0,
                            surahNumber!,
                            cubit.translateAyah,
                            cubit.translate ?? '',
                            surahName!);
                        } else {
                          cubit.showVerseOptionsBottomSheet(
                              context,
                              0,
                              surahNumber!,
                              cubit.translateAyah,
                              '',
                              surahName!);
                        }
                      },
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .background,
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                              border: Border.all(
                                  width: 2,
                                  color: Theme.of(context).dividerColor)),
                          child: Icon(
                            Icons.share_outlined,
                            size: 18,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Flexible(
                  flex: 4,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 1 / 2 * 1.3,
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).colorScheme.background,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height,
                        ),
                        child: Scrollbar(
                          controller: _scrollController,
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: SelectableText.rich(
                              key: _selectableTextKey,
                              TextSpan(
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: '﴿${cubit.translateAyah}﴾\n\n',
                                    // cubit.translateAyah,
                                    style: TextStyle(
                                        color:
                                            ThemeProvider.themeOf(context).id ==
                                                    'dark'
                                                ? Colors.white
                                                : Colors.black,
                                        fontWeight: FontWeight.w100,
                                        height: 1.5,
                                        fontFamily: 'uthmanic2',
                                        fontSize: ShowTafseer.fontSizeArabic),
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
                                    text: cubit.translate,
                                    style: TextStyle(
                                        color:
                                            ThemeProvider.themeOf(context).id ==
                                                    'dark'
                                                ? Colors.white
                                                : Colors.black,
                                        height: 1.5,
                                        fontSize: ShowTafseer.fontSizeArabic
                                        // fontSizeArabic
                                        ),
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
                              contextMenuBuilder: (BuildContext context,
                                  EditableTextState editableTextState) {
                                final List<ContextMenuButtonItem> buttonItems =
                                    editableTextState.contextMenuButtonItems;
                                buttonItems.insert(
                                  0,
                                  ContextMenuButtonItem(
                                    label: 'Add Note',
                                    onPressed: () {
                                      ContextMenuController.removeAny();
                                      _addNote();
                                    },
                                  ),
                                );

                                return AdaptiveTextSelectionToolbar.buttonItems(
                                  anchors: editableTextState.contextMenuAnchors,
                                  buttonItems: buttonItems,
                                );
                              },
                              onSelectionChanged: _handleSelectionChanged,
                              // selectionControls: MyTextSelectionControls(
                              //   textEditingController: textEditingController,
                              //   addNote: () {
                              //     _addNote();
                              //   },
                              // ),
                              // onSelectionChanged: (TextSelection selection, SelectionChangedCause? cause) {
                              //   if (selection.isValid) {
                              //     String selectedText = selection.textInside(cubit.translate);
                              //     _noteController.addSelectedTextAsNote(selectedText);
                              //   }
                              // },
                            ),
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
            );
          },
        ),
      ),
    );
  }

  final GlobalKey<_ShowTafseerState> _selectableTextKey = GlobalKey<_ShowTafseerState>();

  void _handleSelectionChanged(TextSelection selection, SelectionChangedCause? cause) {
    if (cause == SelectionChangedCause.longPress) {
      // final title = _allTitle;
      final text = _allText;
      final start = selection.start;
      final end = selection.end;

      setState(() {
        // selectedTitle = title.substring(start, end);
        _selectedText = text.substring(start, end);
      });
    }
  }

  String _allText = '';
  String _allTitle = '';


  String _getSelectedText(String text) {
    TextSelection selection = textEditingController.selection;

    // Check if the selection is valid
    if (selection.start >= 0 && selection.end <= text.length) {
      return selection.textInside(text);
    }

    // Return an empty string if the selection is invalid
    return '';
  }

  void _updateSelectedText() {
    TextSelection selection = textEditingController.selection;

    // Check if the selection is valid
    if (selection.start >= 0 && selection.end >= 0) {
      selectedTextNotifier.value = selection.textInside(textEditingController.text);
    } else {
      selectedTextNotifier.value = '';
    }
  }

  String? _selectedText;
  String? selectedTitle;

  void _addNote() {
    if (_selectedText != null && _selectedText!.isNotEmpty) {
      _noteController.addSelectedTextAsNote(_selectedText!, _allTitle);
      // Clear the selected text after saving it as a note
      setState(() {
        _selectedText = null;
      });
    }
  }

  final TextEditingController textEditingController = TextEditingController();
  final ValueNotifier<String> selectedTextNotifier = ValueNotifier<String>('');


  tafseerDropDown(BuildContext context) {
    QuranCubit cubit = QuranCubit.get(context);
    List<String> tafName = <String>[
      '${AppLocalizations.of(context)!.tafIbnkatheerN}',
      '${AppLocalizations.of(context)!.tafBaghawyN}',
      '${AppLocalizations.of(context)!.tafQurtubiN}',
      '${AppLocalizations.of(context)!.tafSaadiN}',
      '${AppLocalizations.of(context)!.tafTabariN}',
    ];
    List<String> tafD = <String>[
      '${AppLocalizations.of(context)!.tafIbnkatheerD}',
      '${AppLocalizations.of(context)!.tafBaghawyD}',
      '${AppLocalizations.of(context)!.tafQurtubiD}',
      '${AppLocalizations.of(context)!.tafSaadiD}',
      '${AppLocalizations.of(context)!.tafTabariD}',
    ];

    dropDownModalBottomSheet(context,
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
                child: SvgPicture.asset(
                  'assets/svg/tafseer.svg',
                  height: 50,
                )
              ),
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
                                color: cubit.radioValue == index
                                    ? Theme.of(context).primaryColorLight
                                    : const Color(0xffcdba72),
                                fontSize: 14,
                                fontFamily: 'kufi'
                            ),
                          ),
                          subtitle: Text(
                            tafD[index],
                            style: TextStyle(
                                color: cubit.radioValue == index
                                    ? Theme.of(context).primaryColorLight
                                    : const Color(0xffcdba72),
                                fontSize: 12,
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
                                  color: cubit.radioValue == index
                                      ? Theme.of(context).primaryColorLight
                                      : const Color(0xffcdba72),
                                  width: 2),
                              color: const Color(0xff39412a),
                            ),
                            child: cubit.radioValue == index
                                ? const Icon(Icons.done,
                                size: 14, color: Color(0xfffcbb76))
                                : null,
                          ),
                          onTap: () {
                            cubit.handleRadioValueChanged(context, index);
                            cubit.saveTafseer(index);
                            Navigator.pop(context);
                          },
                          leading: Container(
                            height: 85.0,
                            width: 41.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                border: Border.all(
                                    color: Theme.of(context).dividerColor,
                                    width: 2
                                )
                            ),
                            child: SvgPicture.asset(
                                'assets/svg/tafseer_book.svg',
                            colorFilter: cubit.radioValue == index
                                  ? null
                                  : ColorFilter.mode(
                                  Theme.of(context).canvasColor.withOpacity(.4),
                                  BlendMode.lighten),
                            )
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

  Widget fontSizeDropDown(BuildContext context) {
    return DropdownButton2(
      isExpanded: true,
      items: [
        DropdownMenuItem<String>(
          child: FlutterSlider(
            values: [ShowTafseer.fontSizeArabic],
            max: 40,
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
              ShowTafseer.fontSizeArabic = lowerValue;
              QuranCubit.get(context).saveFontSize(ShowTafseer.fontSizeArabic);
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
      customButton: Icon(
        Icons.format_size,
        color: Theme.of(context).colorScheme.surface,
      ),
      iconSize: 24,
      buttonHeight: 50,
      buttonWidth: 50,
      buttonElevation: 0,
      itemHeight: 35,
      dropdownDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(.9),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      itemPadding: const EdgeInsets.only(left: 14, right: 14),
      dropdownMaxHeight: 230,
      dropdownWidth: 230,
      dropdownPadding: null,
      dropdownElevation: 0,
      scrollbarRadius: const Radius.circular(8),
      scrollbarThickness: 6,
      scrollbarAlwaysShow: true,
      offset: const Offset(0, 0),
    );
  }

  Widget ayahList(pageNum) {
    QuranCubit cubit = QuranCubit.get(context);
    AudioCubit audioCubit = AudioCubit.get(context);
    return ValueListenableBuilder<int>(
        valueListenable: cubit.selectedTafseerIndex,
        builder: (context, index, child) {
        return FutureBuilder<List<Ayat>>(
            future: cubit
                .handleRadioValueChanged(context, cubit.radioValue)
                .getPageTranslate(pageNum),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<Ayat>? ayat = snapshot.data;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: Theme.of(context).dividerColor.withOpacity(.2),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            topLeft: Radius.circular(8),
                          ),
                          border: Border.all(
                              color: Theme.of(context).dividerColor, width: 2)),
                      child: Center(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          scrollDirection: Axis.horizontal,
                          itemCount: ayat!.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, index) {
                            Ayat aya = ayat[index];
                            return Opacity(
                              opacity: isSelected == index ? 1.0 : .5,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    cubit.translateAyah = "${aya.ayatext}";
                                    cubit.translate = "${aya.translate}";
                                    audioCubit.ayahNum = '${aya.ayaNum}';
                                    audioCubit.sorahName = '${aya.suraNum}';
                                    print(aya.suraNum);
                                    isSelected = index.toDouble();
                                    ayahSelected = index;
                                    ayahNumber = aya.suraNum;
                                    surahNumber = aya.suraNum;
                                    surahName = aya.sura_name_ar;
                                  });
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Center(
                                      child: SvgPicture.asset(
                                        'assets/svg/ayah_no.svg',
                                        width: 35,
                                        height: 35,
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        "${arabicNumber.convert(aya!.ayaNum)}",
                                        // "1",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontFamily: 'kufi',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 11),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                    child: Lottie.asset('assets/lottie/search.json',
                        width: 100, height: 40));
              }
            });
      }
    );
  }
}
