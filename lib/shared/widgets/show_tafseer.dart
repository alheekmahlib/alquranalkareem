import 'package:alquranalkareem/cubit/cubit.dart';
import 'package:alquranalkareem/quran_page/cubit/audio/cubit.dart';
import 'package:another_xlider/another_xlider.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:theme_provider/theme_provider.dart';
import '../../l10n/app_localizations.dart';
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
    Orientation orientation = MediaQuery.of(context).orientation;
    return _showTafseer(cubit.cuMPage, orientation);
  }

  Widget _showTafseer(int pageNum, Orientation orientation) {
    QuranCubit cubit = QuranCubit.get(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: FutureBuilder<List<Ayat>>(
          builder: (context, snapshot) {
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
                              child: tafseerDropDown(context),
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
                const SizedBox(
                  height: 8,
                ),
                Flexible(
                  flex: 4,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 1 / 2 * 1.3,
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).backgroundColor,
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
                        cubit.translate;
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
        color: Theme.of(context).bottomAppBarColor,
      ),
      iconSize: 24,
      buttonHeight: 50,
      buttonWidth: 50,
      buttonElevation: 0,
      itemHeight: orientation == Orientation.portrait ? 230 : 125,
      dropdownDecoration: BoxDecoration(
          color: Theme.of(context).bottomAppBarColor.withOpacity(.9),
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
            values: [ShowTafseer.fontSizeArabic],
            max: 40,
            min: 18,
            rtl: true,
            trackBar: FlutterSliderTrackBar(
              inactiveTrackBarHeight: 5,
              activeTrackBarHeight: 5,
              inactiveTrackBar: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).bottomAppBarColor,
              ),
              activeTrackBar: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).backgroundColor),
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
        color: Theme.of(context).bottomAppBarColor,
      ),
      iconSize: 24,
      buttonHeight: 50,
      buttonWidth: 50,
      buttonElevation: 0,
      itemHeight: 35,
      dropdownDecoration: BoxDecoration(
          color: Theme.of(context).bottomAppBarColor.withOpacity(.9),
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

  double? isSelected;
  Widget ayahList(pageNum) {
    QuranCubit cubit = QuranCubit.get(context);
    AudioCubit audioCubit = AudioCubit.get(context);
    return FutureBuilder<List<Ayat>>(
        future: cubit
            .handleRadioValueChanged(cubit.radioValue)
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
                                audioCubit.ayahNum = '${aya.ayaNum!}';
                                audioCubit.sorahName = '${aya.suraNum}';
                                print(aya.suraNum);
                                isSelected = index.toDouble();
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
                                    "${arabicNumber.convert(aya.ayaNum)}",
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
}
