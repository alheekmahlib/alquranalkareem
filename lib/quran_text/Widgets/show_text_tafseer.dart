import 'package:alquranalkareem/cubit/cubit.dart';
import 'package:alquranalkareem/quran_page/cubit/audio/cubit.dart';
import 'package:another_xlider/another_xlider.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:theme_provider/theme_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../quran_page/data/model/ayat.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../cubit/quran_text_cubit.dart';


class ShowTextTafseer extends StatefulWidget {
  const ShowTextTafseer({Key? key}) : super(key: key);

  static double fontSizeArabic = 18;

  @override
  State<ShowTextTafseer> createState() => _ShowTextTafseerState();
}

class _ShowTextTafseerState extends State<ShowTextTafseer> {
  final ScrollController _scrollController = ScrollController();
  ArabicNumbers arabicNumber = ArabicNumbers();
  int pageNum = 0;
  int radioValue = 0;
  double lowerValue = 18;
  double upperValue = 40;
  String? selectedValue;
  double? sliderValue;


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
    Orientation orientation = MediaQuery.of(context).orientation;
    return _showTafseer(orientation);
  }

  Widget _showTafseer(Orientation orientation) {
    QuranTextCubit quranTextCubit = QuranTextCubit.get(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: FutureBuilder<List<Ayat>>(
          builder: (context, snapshot) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: tafseerDropDown(context),
                      ),
                      Expanded(
                        flex: 8,
                        child: IconButton(
                          icon: Icon(Icons.close_outlined,
                              color: ThemeProvider.themeOf(context).id == 'dark'
                                  ? Theme.of(context).canvasColor
                                  : Theme.of(context).primaryColorDark),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: fontSizeDropDown(context),
                      ),
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
                              TextSpan(
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: '﴿${quranTextCubit.translateAyah}﴾\n\n',
                                    // cubit.translateAyah,
                                    style: TextStyle(
                                        color:
                                            ThemeProvider.themeOf(context).id ==
                                                    'dark'
                                                ? Colors.white
                                                : Colors.black,
                                        fontWeight: FontWeight.w100,
                                        height: 1.5,
                                        fontSize: ShowTextTafseer.fontSizeArabic),
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
                                    text: quranTextCubit.translate,
                                    style: TextStyle(
                                        color:
                                            ThemeProvider.themeOf(context).id ==
                                                    'dark'
                                                ? Colors.white
                                                : Colors.black,
                                        height: 1.5,
                                        fontSize: ShowTextTafseer.fontSizeArabic
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
                              toolbarOptions: const ToolbarOptions(
                                  copy: true, selectAll: true),
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.justify,
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

  Widget tafseerDropDown(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    QuranCubit cubit = QuranCubit.get(context);
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
    return DropdownButton2(
      isExpanded: true,
      items: [
        DropdownMenuItem<String>(
          child: ListView.builder(
            itemCount: tafName.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  ListTile(
                    title: Text(
                      tafName[index],
                      style: TextStyle(
                          color: cubit.radioValue == index
                              ? const Color(0xfffcbb76)
                              : Theme.of(context).canvasColor,
                          fontSize: 14,
                          fontFamily: 'kufi'),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        tafD[index],
                        style: TextStyle(
                            color: cubit.radioValue == index
                                ? const Color(0xfffcbb76)
                                : Theme.of(context).canvasColor,
                            fontSize: 10,
                            fontFamily: 'kufi'),
                      ),
                    ),
                    leading: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(2.0)),
                        border: Border.all(
                            color: cubit.radioValue == index
                                ? const Color(0xfffcbb76)
                                : Theme.of(context).canvasColor,
                            width: 2),
                        color: const Color(0xff39412a),
                      ),
                      child: cubit.radioValue == index
                          ? const Icon(Icons.done,
                              size: 14, color: Color(0xfffcbb76))
                          : null,
                    ),
                    onTap: () {
                      setState(() {
                        cubit.handleRadioValueChanged(index);
                        // quranTextCubit.translate = '${TextPageView.aya!.translate}';
                        cubit.saveTafseer(index);
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
        Icons.book,
        color: Theme.of(context).colorScheme.surface,
      ),
      iconSize: 24,
      buttonHeight: 50,
      buttonWidth: 50,
      buttonElevation: 0,
      itemHeight: orientation == Orientation.portrait ? 230 : 125,
      dropdownDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(.9),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      dropdownMaxHeight: orientation == Orientation.portrait ? 230 : 125,
      dropdownWidth: 230,
      dropdownPadding: null,
      dropdownElevation: 0,
      scrollbarRadius: const Radius.circular(8),
      scrollbarThickness: 6,
      scrollbarAlwaysShow: true,
      offset: const Offset(0, 0),
    );
  }

  Widget fontSizeDropDown(BuildContext context) {
    return DropdownButton2(
      isExpanded: true,
      items: [
        DropdownMenuItem<String>(
          child: FlutterSlider(
            values: [ShowTextTafseer.fontSizeArabic],
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
              ShowTextTafseer.fontSizeArabic = lowerValue;
              QuranCubit.get(context).saveFontSize(ShowTextTafseer.fontSizeArabic);
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
}
