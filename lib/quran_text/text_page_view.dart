import 'package:another_xlider/another_xlider.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../shared/widgets/widgets.dart';
import 'model/QuranModel.dart';

class TextPageView extends StatefulWidget {
  SurahText surah;
  int nomPageF, nomPageL;

  TextPageView(
      {required this.surah, required this.nomPageF, required this.nomPageL});
  static int textCurrentPage = 0;
  static String lastTime = '';
  static String sorahTextName = '';
  static double fontSizeArabic = 18;

  @override
  _TextPageViewState createState() => _TextPageViewState();
}

class _TextPageViewState extends State<TextPageView>
    with WidgetsBindingObserver {
  String? selectedValue;
  double scrollSpeed = 0;
  String? selectedSpeed;
  Color? bColor;
  final ScrollController controller = ScrollController();

  // Save & Load Last Page For Quran Text
  saveTextLastPlace(int textCurrentPage, String lastTime, sorahTextName) async {
    textCurrentPage = TextPageView.textCurrentPage;
    lastTime = TextPageView.lastTime;
    sorahTextName = TextPageView.sorahTextName;
    SharedPreferences prefService = await SharedPreferences.getInstance();
    await prefService.setInt("last_page", textCurrentPage);
    await prefService.setString("last_time", lastTime);
    await prefService.setString("last_sorah_name", sorahTextName);
  }

  loadTextCurrentPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    TextPageView.textCurrentPage = prefs.getInt('last_page') ?? 1;
    TextPageView.lastTime = prefs.getString('last_time') ?? '';
    TextPageView.sorahTextName = prefs.getString('last_sorah_name') ?? '';
    print('get ${prefs.getInt('last_page')}');
  }

  textPageChanged(int textCurrentPage, String lastTime, sorahTextName) {
    saveTextLastPlace(TextPageView.textCurrentPage, TextPageView.lastTime,
        TextPageView.sorahTextName);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    TextPageView.textCurrentPage = widget.nomPageF;
    TextPageView.sorahTextName = widget.surah.name!;
    loadTextCurrentPage();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // double minScrollExtent1 = controller.position.minScrollExtent;
      // double maxScrollExtent1 = controller.position.maxScrollExtent;
      // animateToMaxMin(maxScrollExtent1, minScrollExtent1, maxScrollExtent1,
      //     scrollSpeed.toInt(), controller);
    });

    super.initState();
  }

  // animateToMaxMin(double max, double min, double direction, int seconds,
  //     ScrollController scrollController) {
  //   scrollController
  //       .animateTo(direction,
  //       duration: Duration(seconds: seconds), curve: Curves.linear)
  //       .then((value) {
  //     direction = direction == max ? min : max;
  //     animateToMaxMin(max, min, direction, seconds, scrollController);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return BlocConsumer<QuranCubit, QuranState>(
      listener: (BuildContext context, state) {
        if (state is QuranPageState) {
          print('page');
        } else if (state is SoundPageState) {
          print('sound');
        }
      },
      builder: (BuildContext context, state) {
        QuranCubit cubit = QuranCubit.get(context);
        return SafeArea(
          top: false,
          bottom: false,
          right: false,
          left: false,
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Directionality(
                textDirection: TextDirection.rtl,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 64.0),
                      child: Stack(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Align(
                                alignment: Alignment.topRight,
                                child: Row(
                                  children: [
                                    fontSizeDropDown(context),
                                    // scrollDropDown(context)
                                  ],
                                )),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).backgroundColor,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      topLeft: Radius.circular(8),
                                    ),
                                    border: Border.all(
                                        width: 2,
                                        color: Theme.of(context).dividerColor)),
                                child: Icon(
                                  Icons.close_outlined,
                                  color: Theme.of(context).bottomAppBarColor,
                                ),
                              ),
                            ),
                          ),
                          const Divider(
                            height: 58,
                            thickness: 2,
                            endIndent: 16,
                            indent: 16,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Padding(
                        padding: orientation == Orientation.portrait
                            ? EdgeInsets.only(top: 94.0, bottom: 16.0)
                            : EdgeInsets.only(
                                top: 94.0,
                                bottom: 16.0,
                                right: 40.0,
                                left: 40.0),
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          addAutomaticKeepAlives: true,
                          controller: controller,
                          itemCount: (widget.nomPageL - widget.nomPageF) + 1,
                          itemBuilder: (context, index) {
                            List<InlineSpan> text = [];
                            int ayahLenght = widget.surah.ayahs!.length;
                            for (int b = 0; b < ayahLenght; b++) {
                              if (widget.surah.ayahs![b].text!.length > 1) {
                                if (widget.surah.ayahs![b].page ==
                                    (index + widget.nomPageF)) {
                                  ArabicNumbers arabicNumber = ArabicNumbers();
                                  text.add(TextSpan(children: [
                                    TextSpan(
                                        text: widget.surah.ayahs![b].text,
                                        style: TextStyle(
                                          fontSize: TextPageView.fontSizeArabic,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'naskh',
                                          color: ThemeProvider.themeOf(context)
                                                      .id ==
                                                  'dark'
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Share.share(
                                                '﴿${widget.surah.ayahs![b].text}﴾ '
                                                '[${widget.surah.name}-'
                                                '${arabicNumber.convert(widget.surah.ayahs![b].numberInSurah.toString())}]',
                                                subject:
                                                    '${widget.surah.name}');
                                            cubit.textTranslate =
                                                widget.surah.ayahs![b].text!;
                                            print(cubit.textTranslate);
                                          })
                                  ]));
                                  text.add(
                                    TextSpan(children: [
                                      TextSpan(
                                          text:
                                              ' ${arabicNumber.convert(widget.surah.ayahs![b].numberInSurah.toString())} ',
                                          style: TextStyle(
                                              fontSize:
                                                  TextPageView.fontSizeArabic +
                                                      10,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'uthmanic2',
                                              color: Theme.of(context)
                                                  .bottomAppBarColor),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Share.share(
                                                  '﴿${widget.surah.ayahs![b].text}﴾ '
                                                  '[${widget.surah.name}-'
                                                  '${arabicNumber.convert(widget.surah.ayahs![b].numberInSurah.toString())}]',
                                                  subject:
                                                      '${widget.surah.name}');
                                            })
                                    ]),
                                  );
                                }
                              }
                            }
                            return Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).backgroundColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: sorahName(
                                              widget.surah.name!,
                                              context,
                                              Theme.of(context).primaryColor),
                                        ),
                                        Center(
                                          child: SizedBox(
                                              height: 50,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1 /
                                                  2,
                                              child: SvgPicture.asset(
                                                'assets/svg/space_line.svg',
                                              )),
                                        ),
                                        SelectableText.rich(
                                          showCursor: true,
                                          cursorWidth: 3,
                                          cursorColor:
                                              Theme.of(context).dividerColor,
                                          cursorRadius:
                                              const Radius.circular(5),
                                          scrollPhysics:
                                              const ClampingScrollPhysics(),
                                          toolbarOptions: const ToolbarOptions(
                                              copy: true, selectAll: true),
                                          textDirection: TextDirection.rtl,
                                          textAlign: TextAlign.justify,
                                          TextSpan(
                                            style: TextStyle(
                                                fontSize:
                                                    TextPageView.fontSizeArabic,
                                                backgroundColor: bColor ??
                                                    Colors.transparent,
                                                fontFamily: 'uthmanic2'),
                                            children: text.map((e) {
                                              return e;
                                            }).toList(),
                                          ),
                                        ),
                                        Center(
                                          child: SizedBox(
                                              height: 50,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1 /
                                                  2,
                                              child: SvgPicture.asset(
                                                'assets/svg/space_line.svg',
                                              )),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: pageNumber(
                                              (widget.nomPageF + index)
                                                  .toString(),
                                              context,
                                              Theme.of(context).primaryColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }

  Widget fontSizeDropDown(BuildContext context) {
    return DropdownButton2(
      isExpanded: true,
      items: [
        DropdownMenuItem<String>(
          child: FlutterSlider(
            values: [TextPageView.fontSizeArabic],
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
      dropdownMaxHeight: MediaQuery.of(context).size.height,
      dropdownWidth: 230,
      dropdownPadding: null,
      dropdownElevation: 0,
      scrollbarRadius: const Radius.circular(8),
      scrollbarThickness: 6,
      scrollbarAlwaysShow: true,
      offset: const Offset(-0, 0),
    );
  }

  Widget scrollDropDown(BuildContext context) {
    return DropdownButton2(
      isExpanded: true,
      items: [
        DropdownMenuItem<String>(
          child: FlutterSlider(
            values: const [1000],
            max: 10000,
            min: 1000,
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
              scrollSpeed = lowerValue;
              setState(() {
                print(scrollSpeed);
              });
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
      value: selectedSpeed,
      onChanged: (value) {
        setState(() {
          selectedSpeed = value as String;
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
      itemHeight: 50,
      selectedItemHighlightColor: Theme.of(context).primaryColorDark,
      itemPadding: const EdgeInsets.only(left: 14, right: 14),
      dropdownMaxHeight: MediaQuery.of(context).size.height,
      dropdownWidth: 230,
      dropdownPadding: null,
      dropdownElevation: 0,
      scrollbarRadius: const Radius.circular(8),
      scrollbarThickness: 6,
      scrollbarAlwaysShow: true,
      offset: const Offset(-0, 0),
    );
  }
}
