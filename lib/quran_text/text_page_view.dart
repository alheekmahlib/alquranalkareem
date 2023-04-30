import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/handler_animation.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
<<<<<<< Updated upstream
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
=======
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
>>>>>>> Stashed changes
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';
import '../cubit/cubit.dart';
<<<<<<< Updated upstream
import '../cubit/states.dart';
import '../shared/widgets/widgets.dart';
=======
import '../cubit/translateDataCubit/_cubit.dart';
import '../cubit/translateDataCubit/translateDataState.dart';
import '../l10n/app_localizations.dart';
import '../quran_page/data/model/ayat.dart';
import '../shared/widgets/widgets.dart';
import 'Widgets/audio_text_widget.dart';
import 'Widgets/show_text_tafseer.dart';
import 'Widgets/text_overflow_detector.dart';
import 'cubit/quran_text_cubit.dart';
>>>>>>> Stashed changes
import 'model/QuranModel.dart';

var lastAyah;
var lastAyahInPage;

class TextPageView extends StatefulWidget {
<<<<<<< Updated upstream
  SurahText surah;
  int nomPageF, nomPageL;
=======
  SurahText? surah;
  int? nomPageF, nomPageL, pageNum;
>>>>>>> Stashed changes

  TextPageView(
      {required this.surah, required this.nomPageF, required this.nomPageL});
  static int textCurrentPage = 0;
  static String lastTime = '';
  static String sorahTextName = '';
  static double fontSizeArabic = 24;

  @override
  _TextPageViewState createState() => _TextPageViewState();
}

class _TextPageViewState extends State<TextPageView>
<<<<<<< Updated upstream
    with WidgetsBindingObserver {
  String? selectedValue;
  double scrollSpeed = 0;
  String? selectedSpeed;
  Color? bColor;
  final ScrollController controller = ScrollController();
=======
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final GlobalKey _scrollKey = GlobalKey();
  Timer? _scrollTimer;
  late QuranTextCubit _quranTextCubit;
  ArabicNumbers arabicNumber = ArabicNumbers();
  String? translateText;
  StreamSubscription? _quranTextCubitSubscription;

  void _toggleScroll() {
    if (QuranTextCubit.get(context).scrolling) {
      // Stop scrolling
      QuranTextCubit.get(context).animationController.stop();
    } else {
      // Calculate the new duration
      double newDuration = ((widget.surah!.ayahs!.length -
              (QuranTextCubit.get(context).animationController.value *
                      widget.surah!.ayahs!.length)
                  .round()) /
          QuranTextCubit.get(context).scrollSpeedNotifier!.value);

      // Check if the calculated value is finite and not NaN
      if (newDuration.isFinite && !newDuration.isNaN) {
        // Start scrolling
        QuranTextCubit.get(context).animationController.duration =
            Duration(seconds: newDuration.round());
        QuranTextCubit.get(context).animationController.forward();
      }
    }
    setState(() {
      QuranTextCubit.get(context).scrolling =
          !QuranTextCubit.get(context).scrolling;

      if (QuranTextCubit.get(context).scrolling) {
        QuranTextCubit.get(context).animationController.addListener(_scroll);
      } else {
        QuranTextCubit.get(context).animationController.removeListener(_scroll);
      }
    });
  }

  void _scroll() {
    QuranTextCubit.get(context).scrollController!.jumpTo(
        QuranTextCubit.get(context).animationController.value *
            (QuranTextCubit.get(context)
                .scrollController!
                .position
                .maxScrollExtent));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _quranTextCubit = QuranTextCubit.get(context);
  }
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
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
=======
    QuranTextCubit.get(context).loadSwitchValue();
    QuranTextCubit.get(context).loadTranslateValue();
    QuranTextCubit.get(context).loadScrollSpeedValue();
    print("trans ${QuranTextCubit.get(context).trans}");
    WidgetsBinding.instance.addPostFrameCallback((_) => jumbToPage());
    // jumbToPage();
    QuranTextCubit.get(context).controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    QuranTextCubit.get(context).offset = Tween<Offset>(
      end: Offset.zero,
      begin: const Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: QuranTextCubit.get(context).controller,
      curve: Curves.easeIn,
    ));
    // QuranTextCubit.get(context).scrollController = AutoScrollController(
    // viewportBoundaryGetter: () =>
    // Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
    // axis: Axis.vertical);
    QuranTextCubit.get(context).animationController = AnimationController(
      vsync: this,
    );
    QuranTextCubit.get(context).animationController.addListener(() {
      _scroll();
    });
    QuranTextCubit.get(context).scrollSpeedNotifier =
        ValueNotifier<double>(QuranTextCubit.get(context).scrollSpeed);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _quranTextCubitSubscription = context
          .read<QuranTextCubit>()
          .stream
          .listen((QuranTextState state) {
        if (!mounted) return; // Check if the widget is still mounted

        final translation = QuranTextCubit.get(context)
            .translateHandleRadioValueChanged(
            QuranTextCubit.get(context).transValue);
        context
            .read<TranslateDataCubit>()
            .fetchSura(context, translation, '${widget.surah!.number!}');
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _quranTextCubit.animationController.dispose();
    _quranTextCubitSubscription!.cancel();
    super.dispose();
  }

  jumbToPage() async {
    if (widget.pageNum! == 0 ||
        widget.pageNum! == 1 ||
        widget.pageNum! == 585 ||
        widget.pageNum! == 586 ||
        widget.pageNum! == 587 ||
        widget.pageNum! == 589 ||
        widget.pageNum! == 590 ||
        widget.pageNum! == 591 ||
        widget.pageNum! == 592 ||
        widget.pageNum! == 593 ||
        widget.pageNum! == 594 ||
        widget.pageNum! == 595 ||
        widget.pageNum! == 596 ||
        widget.pageNum! == 597 ||
        widget.pageNum! == 598 ||
        widget.pageNum! == 599 ||
        widget.pageNum! == 600 ||
        widget.pageNum! == 601 ||
        widget.pageNum! == 602 ||
        widget.pageNum! == 603 ||
        widget.pageNum! == 604) {
    } else {
      await QuranTextCubit.get(context).itemScrollController.scrollTo(
          index: (QuranTextCubit.get(context).value == 1
              ? widget.pageNum!
              : widget.pageNum! - 1),
          // widget.pageNum! - 1,
          // 40,
          // preferPosition: AutoScrollPosition.begin,
          // duration: Duration(milliseconds: 500), // Adjust the animation duration to your preference
          duration: const Duration(seconds: 1),
          curve: Curves.easeOut);
      setState(() {
        QuranTextCubit.get(context).isSelected =
            QuranTextCubit.get(context).value == 1
                ? widget.pageNum!
                : widget.pageNum! - 1;
      });
    }
  }

  // Future<Uint8List> createVerseImage(String surahName, int verseNumber, String verseText) async {
  //   final textPainter = TextPainter(
  //     text: TextSpan(
  //       text: 'Surah: $surahName\nVerse: $verseNumber\n$verseText',
  //       style: TextStyle(
  //         fontSize: 20,
  //         fontWeight:
  //         FontWeight.normal,
  //         fontFamily:
  //         'uthmanic2'),
  //     ),
  //     textDirection: TextDirection.rtl,
  //   );
  //   textPainter.layout(maxWidth: 300);
  //
  //   final pictureRecorder = ui.PictureRecorder();
  //   final canvas = Canvas(pictureRecorder);
  //   canvas.drawRect(Rect.fromLTWH(0, 0, textPainter.width, textPainter.height), Paint()..color = const Color(0xfff3efdf));
  //   textPainter.paint(canvas, Offset.zero);
  //
  //   final picture = pictureRecorder.endRecording();
  //   final img = await picture.toImage(textPainter.width.toInt(), textPainter.height.toInt());
  //   final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
  //   return pngBytes!.buffer.asUint8List();
>>>>>>> Stashed changes
  // }

  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
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
=======
    Color backColor = Theme.of(context).colorScheme.surface;

    return BlocConsumer<QuranTextCubit, QuranTextState>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, state) {
        QuranTextCubit TextCubit = QuranTextCubit.get(context);
        final List<dynamic>? translateData =
            context.watch<TranslateDataCubit>().state.data;
>>>>>>> Stashed changes
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 16.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: orientation(
                          context,
                          Container(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              sorahName(
                                widget.surah!.number.toString(),
                                context,
                                Theme.of(context).canvasColor,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: fontSizeDropDown(context),
                              ),
                              Spacer(),
                              // scrollDropDown(context),
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              //   child: GestureDetector(
                              //     child: Container(
                              //       height: 25,
                              //       width: 25,
                              //       decoration: BoxDecoration(
                              //           color: TextCubit.scrolling == true
                              //               ? Theme.of(context).colorScheme.surface
                              //               : Theme.of(context).colorScheme.background,
                              //           borderRadius: BorderRadius.all(
                              //             Radius.circular(8),
                              //           ),
                              //           border: Border.all(
                              //               width: 1,
                              //               color: Theme.of(context).colorScheme.surface
                              //           )
                              //       ),
                              //       child: Icon(
                              //         Icons.speed_outlined,
                              //         color: TextCubit.scrolling == true
                              //             ? Theme.of(context).canvasColor
                              //             : Theme.of(context).colorScheme.surface,
                              //         size: 20,
                              //       ),
                              //     ),
                              //     onTap: _toggleScroll,
                              //   ),
                              // ),
                              SizedBox(
                                width: 70,
                                child: AnimatedToggleSwitch<int>.rolling(
                                  current: TextCubit.value,
                                  values: const [0, 1],
                                  onChanged: (i) {
                                    setState(() {
                                      TextCubit.value = i;
                                      TextCubit.saveSwitchValue(
                                          TextCubit.value);
                                    });
                                  },
                                  iconBuilder: rollingIconBuilder,
                                  borderWidth: 1,
                                  indicatorColor:
                                      Theme.of(context).colorScheme.surface,
                                  innerColor: Theme.of(context).canvasColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  height: 25,
                                  dif: 2.0,
                                  borderColor:
                                      Theme.of(context).colorScheme.surface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: orientation(
                        context,
                        const EdgeInsets.only(top: 70.0),
                        const EdgeInsets.only(top: 32.0),
                      ),
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
<<<<<<< Updated upstream
=======
                          Padding(
                            padding: EdgeInsets.only(
                                top: 32.0, right: 16.0, left: 16.0),
                            child: orientation(
                                context,
                                Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          sorahName(
                                            widget.surah!.number.toString(),
                                            context,
                                            ThemeProvider.themeOf(context).id ==
                                                    'dark'
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          fontSizeDropDown(context),
                                          // scrollDropDown(context),
                                          // GestureDetector(
                                          //   child: Container(
                                          //       height: 25,
                                          //       width: 25,
                                          //       decoration: BoxDecoration(
                                          //         color: TextCubit.scrolling == true
                                          //             ? Theme.of(context).colorScheme.surface
                                          //             : Theme.of(context).colorScheme.background,
                                          //           borderRadius: BorderRadius.all(
                                          //             Radius.circular(8),
                                          //           ),
                                          //           border: Border.all(
                                          //               width: 1,
                                          //               color: Theme.of(context).colorScheme.surface
                                          //           )
                                          //       ),
                                          //       child: Icon(
                                          //           Icons.speed_outlined,
                                          //           color: TextCubit.scrolling == true
                                          //               ? Theme.of(context).canvasColor
                                          //               : Theme.of(context).colorScheme.surface,
                                          //           size: 20,
                                          //         ),
                                          //       ),
                                          //   onTap: _toggleScroll,
                                          // ),
                                          SizedBox(
                                            width: 70,
                                            child: AnimatedToggleSwitch<
                                                int>.rolling(
                                              current: TextCubit.value,
                                              values: const [0, 1],
                                              onChanged: (i) {
                                                setState(() {
                                                  TextCubit.value = i;
                                                  TextCubit.saveSwitchValue(
                                                      TextCubit.value);
                                                });
                                              },
                                              iconBuilder: rollingIconBuilder,
                                              borderWidth: 1,
                                              indicatorColor: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              innerColor:
                                                  Theme.of(context).canvasColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                              height: 25,
                                              dif: 2.0,
                                              borderColor: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      height: 5,
                                      thickness: 2,
                                    ),
                                  ],
                                ),
                                Container()),
                          ),
>>>>>>> Stashed changes
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Padding(
                        padding: orientation(
                            context,
                            EdgeInsets.only(top: 155.0, bottom: 16.0),
                            EdgeInsets.only(
                                top: 68.0,
                                bottom: 16.0,
                                right: 40.0,
<<<<<<< Updated upstream
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
=======
                                left: 40.0)),
                        child: AnimatedBuilder(
                            animation:
                                QuranTextCubit.get(context).animationController,
                            builder: (BuildContext context, Widget? child) {
                              if (QuranTextCubit.get(context)
                                  .scrollController!
                                  .hasClients) {
                                QuranTextCubit.get(context)
                                    .scrollController!
                                    .jumpTo(QuranTextCubit.get(context)
                                            .animationController
                                            .value *
                                        (QuranTextCubit.get(context)
                                            .scrollController!
                                            .position
                                            .maxScrollExtent));
                              }
                              return ScrollablePositionedList.builder(
                                key: _scrollKey,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                addAutomaticKeepAlives: true,
                                // controller: TextCubit.scrollController,
                                itemScrollController:
                                    TextCubit.itemScrollController,
                                itemPositionsListener:
                                    TextCubit.itemPositionsListener,
                                itemCount: TextCubit.value == 1
                                    ? widget.surah!.ayahs!.length
                                    : (widget.nomPageL! - widget.nomPageF!) + 1,
                                itemBuilder: (context, index) {
                                  List<InlineSpan> text = [];
                                  int ayahLenght = widget.surah!.ayahs!.length;
                                  if (TextCubit.value == 1) {
                                    for (int index = 0;
                                        index < ayahLenght;
                                        index++) {
                                      if (widget.surah!.ayahs![index].text!
                                              .length >
                                          1) {
                                        TextCubit.sajda2 =
                                            widget.surah!.ayahs![index].sajda;
                                      }
                                    }
                                  } else {
                                    for (int b = 0; b < ayahLenght; b++) {
                                      if (widget.surah!.ayahs![b].text!.length >
                                          1) {
                                        if (widget.surah!.ayahs![b].page ==
                                            (index + widget.nomPageF!)) {
                                          TextCubit.juz = widget
                                              .surah!.ayahs![b].juz
                                              .toString();
                                          TextCubit.sajda =
                                              widget.surah!.ayahs![b].sajda;
                                          text.add(TextSpan(children: [
                                            TextSpan(
                                                text: widget
                                                    .surah!.ayahs![b].text!,
                                                style: TextStyle(
                                                  fontSize: TextPageView
                                                      .fontSizeArabic,
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: 'uthmanic2',
                                                  color: ThemeProvider.themeOf(
                                                                  context)
                                                              .id ==
                                                          'dark'
                                                      ? Colors.white
                                                      : Colors.black,
                                                  background: Paint()
                                                    ..color = b ==
                                                            TextCubit.isSelected
                                                        ? backColor
                                                        : Colors.transparent
                                                    ..color = b ==
                                                            TextCubit.isSelected
                                                        ? backColor
                                                        : Colors.transparent
                                                    ..strokeJoin =
                                                        StrokeJoin.round
                                                    ..strokeCap =
                                                        StrokeCap.round
                                                    ..style =
                                                        PaintingStyle.fill,
                                                ),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTapDown =
                                                          (TapDownDetails
                                                              details) {
                                                        lastAyah = widget.surah!
                                                            .ayahs!.length;
                                                        lastAyahInPage = widget
                                                            .surah!
                                                            .ayahs![b]
                                                            .numberInSurah;
                                                        var cancel = BotToast
                                                            .showAttachedWidget(
                                                          target: details
                                                              .globalPosition,
                                                          verticalOffset:
                                                              TextCubit
                                                                  .verticalOffset,
                                                          horizontalOffset:
                                                              TextCubit
                                                                  .horizontalOffset,
                                                          preferDirection:
                                                              TextCubit
                                                                  .preferDirection,
                                                          animationDuration:
                                                              Duration(
                                                                  microseconds:
                                                                      700),
                                                          animationReverseDuration:
                                                              Duration(
                                                                  microseconds:
                                                                      700),
                                                          attachedBuilder:
                                                              (cancel) => Card(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .surface,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10.0,
                                                                  vertical:
                                                                      6.0),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Container(
                                                                    height: 40,
                                                                    width: 40,
                                                                    decoration: BoxDecoration(
                                                                        color: Color(
                                                                            0xfff3efdf),
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(50))),
                                                                    child: FutureBuilder<
                                                                            List<
                                                                                Ayat>>(
                                                                        future: QuranCubit.get(context).handleRadioValueChanged(QuranCubit.get(context).radioValue).getAyahTranslate((widget
                                                                            .surah!
                                                                            .number)),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          if (snapshot.connectionState ==
                                                                              ConnectionState.done) {
                                                                            List<Ayat>?
                                                                                ayat =
                                                                                snapshot.data;
                                                                            Ayat
                                                                                aya =
                                                                                ayat![b];
                                                                            return IconButton(
                                                                              icon: Icon(
                                                                                Icons.text_snippet_outlined,
                                                                                size: 24,
                                                                                color: Color(0x99f5410a),
                                                                              ),
                                                                              onPressed: () {
                                                                                TextCubit.translateAyah = "${aya.ayatext}";
                                                                                TextCubit.translate = "${aya.translate}";
                                                                                // showModalBottomSheet<void>(
                                                                                //   context: context,
                                                                                //   builder: (BuildContext context) {
                                                                                //     return ShowTextTafseer();
                                                                                //   },
                                                                                // );
                                                                                if (TextCubit.isShowBottomSheet) {
                                                                                  Navigator.pop(context);
                                                                                } else {
                                                                                  TPageScaffoldKey.currentState?.showBottomSheet(
                                                                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
                                                                                      backgroundColor: Colors.transparent,
                                                                                      (context) => Align(
                                                                                            alignment: Alignment.bottomCenter,
                                                                                            child: Padding(
                                                                                              padding: orientation(context, const EdgeInsets.symmetric(horizontal: 16.0), const EdgeInsets.symmetric(horizontal: 64.0)),
                                                                                              child: Container(
                                                                                                height: orientation(context, MediaQuery.of(context).size.height * 1 / 2, platformView(MediaQuery.of(context).size.height, MediaQuery.of(context).size.height * 3/4)),
                                                                                                width: MediaQuery.of(context).size.width,
                                                                                                decoration: BoxDecoration(
                                                                                                  borderRadius: const BorderRadius.only(topRight: Radius.circular(12.0), topLeft: Radius.circular(12.0)),
                                                                                                  color: Theme.of(context).colorScheme.background,
                                                                                                ),
                                                                                                child: ShowTextTafseer(),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                      elevation: 100);
                                                                                }
                                                                                // quranTextTafseer(context, TPageScaffoldKey,
                                                                                //     MediaQuery.of(context).size.width);
                                                                                cancel();
                                                                              },
                                                                            );
                                                                          } else {
                                                                            return Center(child: Lottie.asset('assets/lottie/search.json', width: 100, height: 40));
                                                                          }
                                                                        }),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 8.0,
                                                                  ),
                                                                  Container(
                                                                    height: 40,
                                                                    width: 40,
                                                                    decoration: BoxDecoration(
                                                                        color: Color(
                                                                            0xfff3efdf),
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(50))),
                                                                    child:
                                                                        IconButton(
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .bookmark_border,
                                                                        size:
                                                                            24,
                                                                        color: Color(
                                                                            0x99f5410a),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        print(
                                                                            'ayah no ${widget.surah!.ayahs![b].numberInSurah}');
                                                                        TextCubit.addBookmarkText(
                                                                                widget.surah!.name!,
                                                                                widget.surah!.number!,
                                                                                index == 0 ? index + 1 : index + 2,
                                                                                // widget.surah!.ayahs![b].page,
                                                                                widget.nomPageF,
                                                                                widget.nomPageL,
                                                                                TextCubit.lastRead)
                                                                            .then((value) => customSnackBar(context, AppLocalizations.of(context)!.addBookmark));
                                                                        cancel();
                                                                      },
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 8.0,
                                                                  ),
                                                                  Container(
                                                                    height: 40,
                                                                    width: 40,
                                                                    decoration: BoxDecoration(
                                                                        color: Color(
                                                                            0xfff3efdf),
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(50))),
                                                                    child:
                                                                        IconButton(
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .copy_outlined,
                                                                        size:
                                                                            24,
                                                                        color: Color(
                                                                            0x99f5410a),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        FlutterClipboard
                                                                            .copy(
                                                                          '﴿${widget.surah!.ayahs![b].text}﴾ '
                                                                          '[${widget.surah!.name}-'
                                                                          '${arabicNumber.convert(widget.surah!.ayahs![b].numberInSurah.toString())}]',
                                                                        ).then((value) => customSnackBar(
                                                                            context,
                                                                            AppLocalizations.of(context)!.copyAyah));
                                                                        cancel();
                                                                      },
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 8.0,
                                                                  ),
                                                                  Container(
                                                                    height: 40,
                                                                    width: 40,
                                                                    decoration: BoxDecoration(
                                                                        color: Color(
                                                                            0xfff3efdf),
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(50))),
                                                                    child:
                                                                        IconButton(
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .play_arrow_outlined,
                                                                        size:
                                                                            24,
                                                                        color: Color(
                                                                            0x99f5410a),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        switch (TextCubit
                                                                            .controller
                                                                            .status) {
                                                                          case AnimationStatus
                                                                              .dismissed:
                                                                            TextCubit.controller.forward();
                                                                            break;
                                                                          case AnimationStatus
                                                                              .completed:
                                                                            TextCubit.controller.reverse();
                                                                            break;
                                                                          default:
                                                                        }
                                                                        cancel();
                                                                      },
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 8.0,
                                                                  ),
                                                                  Container(
                                                                    height: 40,
                                                                    width: 40,
                                                                    decoration: BoxDecoration(
                                                                        color: Color(
                                                                            0xfff3efdf),
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(50))),
                                                                    child:
                                                                        IconButton(
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .share_outlined,
                                                                        size:
                                                                            23,
                                                                        color: Color(
                                                                            0x99f5410a),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                            final verseNumber = widget.surah!.ayahs![b].numberInSurah!;
                                                                            final translation = translateData?[verseNumber - 1]['text'];
                                                                            QuranCubit.get(context).showVerseOptionsBottomSheet(context, verseNumber, widget.surah!.number, "${widget.surah!.ayahs![b].text}", translation ?? '', widget.surah!.name);
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
                                                        );
                                                        print(
                                                            '${widget.surah!.name!}');
                                                        print(
                                                            '${widget.surah!.number!}');
                                                        print(
                                                            '${widget.surah!.ayahs![b].numberInSurah}');
                                                        print(
                                                            '${widget.nomPageF}');
                                                        print(
                                                            '${widget.nomPageL}');
                                                        setState(() {
                                                          backColor = Colors
                                                              .transparent;
                                                          TextCubit.sorahName =
                                                              widget.surah!
                                                                  .number!
                                                                  .toString();
                                                          TextCubit.ayahNum =
                                                              widget
                                                                  .surah!
                                                                  .ayahs![b]
                                                                  .numberInSurah
                                                                  .toString();
                                                          TextCubit
                                                              .isSelected = widget
                                                                  .surah!
                                                                  .ayahs![b]
                                                                  .numberInSurah! -
                                                              1;
                                                        });
                                                      })
                                          ]));
                                          text.add(
                                            TextSpan(children: [
                                              TextSpan(
                                                text:
                                                    ' ${arabicNumber.convert(widget.surah!.ayahs![b].numberInSurah.toString())} ',
                                                style: TextStyle(
                                                  fontSize: TextPageView
                                                          .fontSizeArabic +
                                                      5,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'uthmanic2',
                                                  color: ThemeProvider
                                                                  .themeOf(
                                                                      context)
                                                              .id ==
                                                          'dark'
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .surface
                                                      : Theme.of(context)
                                                          .primaryColorLight,
                                                ),
                                              )
                                            ]),
                                          );
                                        }
                                      }
                                    }
                                  }
                                  return TextCubit.value == 1
                                      ? Stack(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                TextCubit.controller.reverse();
                                                setState(() {
                                                  backColor =
                                                      Colors.transparent;
                                                });
                                              },
                                              // child: AutoScrollTag(
                                              //   key: ValueKey(index),
                                              //   controller: TextCubit.scrollController!,
                                              //   index: index,
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 4),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .background,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                4))),
                                                child: Column(
                                                  children: [
                                                    Center(
                                                      child: SizedBox(
                                                          height: 50,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              1 /
                                                              2,
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/svg/space_line.svg',
                                                          )),
                                                    ),
                                                    widget.surah!.number == 9
                                                        ? Container()
                                                        : widget
                                                                    .surah!
                                                                    .ayahs![
                                                                        index]
                                                                    .numberInSurah ==
                                                                1
                                                            ? SvgPicture.asset(
                                                                'assets/svg/besmAllah.svg',
                                                                width: 200,
                                                                colorFilter: ColorFilter.mode(
                                                                    Theme.of(
                                                                            context)
                                                                        .cardColor
                                                                        .withOpacity(
                                                                            .8),
                                                                    BlendMode
                                                                        .srcIn),
                                                              )
                                                            : Container(),
                                                    Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 32),
                                                      child:
                                                          SelectableText.rich(
                                                        showCursor: true,
                                                        cursorWidth: 3,
                                                        cursorColor:
                                                            Theme.of(context)
                                                                .dividerColor,
                                                        cursorRadius:
                                                            const Radius
                                                                .circular(5),
                                                        scrollPhysics:
                                                            const ClampingScrollPhysics(),
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        textAlign:
                                                            TextAlign.justify,
                                                        TextSpan(children: [
                                                          TextSpan(
                                                              text: widget
                                                                  .surah!
                                                                  .ayahs![index]
                                                                  .text!,
                                                              style: TextStyle(
                                                                fontSize:
                                                                    TextPageView
                                                                        .fontSizeArabic,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontFamily:
                                                                    'uthmanic2',
                                                                color: ThemeProvider.themeOf(context)
                                                                            .id ==
                                                                        'dark'
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                                background:
                                                                    Paint()
                                                                      ..color = index ==
                                                                              TextCubit.isSelected
                                                                          ? backColor
                                                                          : Colors.transparent
                                                                      ..strokeJoin =
                                                                          StrokeJoin
                                                                              .round
                                                                      ..strokeCap =
                                                                          StrokeCap
                                                                              .round
                                                                      ..style =
                                                                          PaintingStyle
                                                                              .fill,
                                                              ),
                                                              recognizer:
                                                                  TapGestureRecognizer()
                                                                    ..onTapDown =
                                                                        (TapDownDetails
                                                                            details) {
                                                                      setState(
                                                                          () {
                                                                        backColor =
                                                                            Colors.transparent;
                                                                        TextCubit.sorahName = widget
                                                                            .surah!
                                                                            .number!
                                                                            .toString();
                                                                        TextCubit.ayahNum = widget
                                                                            .surah!
                                                                            .ayahs![index]
                                                                            .numberInSurah
                                                                            .toString();
                                                                        TextCubit.isSelected =
                                                                            index;
                                                                      });
                                                                      var cancel =
                                                                          BotToast
                                                                              .showAttachedWidget(
                                                                        target:
                                                                            details.globalPosition,
                                                                        verticalOffset:
                                                                            TextCubit.verticalOffset,
                                                                        horizontalOffset:
                                                                            TextCubit.horizontalOffset,
                                                                        preferDirection:
                                                                            TextCubit.preferDirection,
                                                                        animationDuration:
                                                                            Duration(microseconds: 700),
                                                                        animationReverseDuration:
                                                                            Duration(microseconds: 700),
                                                                        attachedBuilder:
                                                                            (cancel) =>
                                                                                Card(
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .surface,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                Container(
                                                                                  height: 40,
                                                                                  width: 40,
                                                                                  decoration: BoxDecoration(color: Color(0xfff3efdf), borderRadius: BorderRadius.all(Radius.circular(50))),
                                                                                  child: FutureBuilder<List<Ayat>>(
                                                                                      future: QuranCubit.get(context).handleRadioValueChanged(QuranCubit.get(context).radioValue).getAyahTranslate((widget.surah!.number)),
                                                                                      builder: (context, snapshot) {
                                                                                        if (snapshot.connectionState == ConnectionState.done) {
                                                                                          List<Ayat>? ayat = snapshot.data;
                                                                                          Ayat aya = ayat![index];
                                                                                          return IconButton(
                                                                                            icon: Icon(
                                                                                              Icons.text_snippet_outlined,
                                                                                              size: 24,
                                                                                              color: Color(0x99f5410a),
                                                                                            ),
                                                                                            onPressed: () {
                                                                                              TextCubit.translateAyah = "${aya.ayatext}";
                                                                                              TextCubit.translate = "${aya.translate}";
                                                                                              // showModalBottomSheet<void>(
                                                                                              //   context: context,
                                                                                              //   builder: (BuildContext context) {
                                                                                              //     return ShowTextTafseer();
                                                                                              //   },
                                                                                              // );
                                                                                              if (TextCubit.isShowBottomSheet) {
                                                                                                Navigator.pop(context);
                                                                                              } else {
                                                                                                TPageScaffoldKey.currentState?.showBottomSheet(
                                                                                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
                                                                                                    backgroundColor: Colors.transparent,
                                                                                                    (context) => Align(
                                                                                                          alignment: Alignment.bottomCenter,
                                                                                                          child: Padding(
                                                                                                            padding: orientation(context, const EdgeInsets.symmetric(horizontal: 16.0), const EdgeInsets.symmetric(horizontal: 64.0)),
                                                                                                            child: Container(
                                                                                                              height: orientation(context, MediaQuery.of(context).size.height * 1 / 2, platformView(MediaQuery.of(context).size.height, MediaQuery.of(context).size.height * 3/4)),
                                                                                                              width: MediaQuery.of(context).size.width,
                                                                                                              decoration: BoxDecoration(
                                                                                                                borderRadius: const BorderRadius.only(topRight: Radius.circular(12.0), topLeft: Radius.circular(12.0)),
                                                                                                                color: Theme.of(context).colorScheme.background,
                                                                                                              ),
                                                                                                              child: const ShowTextTafseer(),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                    elevation: 100);
                                                                                              }
                                                                                              // quranTextTafseer(context, TPageScaffoldKey,
                                                                                              //     MediaQuery.of(context).size.width);
                                                                                              cancel();
                                                                                            },
                                                                                          );
                                                                                        } else {
                                                                                          return Center(child: Lottie.asset('assets/lottie/search.json', width: 100, height: 40));
                                                                                        }
                                                                                      }),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 8.0,
                                                                                ),
                                                                                Container(
                                                                                  height: 40,
                                                                                  width: 40,
                                                                                  decoration: BoxDecoration(color: Color(0xfff3efdf), borderRadius: BorderRadius.all(Radius.circular(50))),
                                                                                  child: IconButton(
                                                                                    icon: Icon(
                                                                                      Icons.bookmark_border,
                                                                                      size: 24,
                                                                                      color: Color(0x99f5410a),
                                                                                    ),
                                                                                    onPressed: () {
                                                                                      TextCubit.addBookmarkText(
                                                                                              widget.surah!.name!,
                                                                                              widget.surah!.number!,
                                                                                              widget.surah!.ayahs![index].numberInSurah,
                                                                                              // widget.surah!.ayahs![b].page,
                                                                                              widget.nomPageF,
                                                                                              widget.nomPageL,
                                                                                              TextCubit.lastRead)
                                                                                          .then((value) => customSnackBar(context, AppLocalizations.of(context)!.addBookmark));
                                                                                      cancel();
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 8.0,
                                                                                ),
                                                                                Container(
                                                                                  height: 40,
                                                                                  width: 40,
                                                                                  decoration: BoxDecoration(color: Color(0xfff3efdf), borderRadius: BorderRadius.all(Radius.circular(50))),
                                                                                  child: IconButton(
                                                                                    icon: Icon(
                                                                                      Icons.copy_outlined,
                                                                                      size: 24,
                                                                                      color: Color(0x99f5410a),
                                                                                    ),
                                                                                    onPressed: () {
                                                                                      FlutterClipboard.copy(
                                                                                        '﴿${widget.surah!.ayahs![index].text}﴾ '
                                                                                        '[${widget.surah!.name}-'
                                                                                        '${arabicNumber.convert(widget.surah!.ayahs![index].numberInSurah.toString())}]',
                                                                                      ).then((value) => customSnackBar(context, AppLocalizations.of(context)!.copyAyah));
                                                                                      cancel();
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 8.0,
                                                                                ),
                                                                                Container(
                                                                                  height: 40,
                                                                                  width: 40,
                                                                                  decoration: BoxDecoration(color: Color(0xfff3efdf), borderRadius: BorderRadius.all(Radius.circular(50))),
                                                                                  child: IconButton(
                                                                                    icon: Icon(
                                                                                      Icons.play_arrow_outlined,
                                                                                      size: 24,
                                                                                      color: Color(0x99f5410a),
                                                                                    ),
                                                                                    onPressed: () {
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
                                                                                SizedBox(
                                                                                  width: 8.0,
                                                                                ),
                                                                                Container(
                                                                                  height: 40,
                                                                                  width: 40,
                                                                                  decoration: BoxDecoration(color: Color(0xfff3efdf), borderRadius: BorderRadius.all(Radius.circular(50))),
                                                                                  child: IconButton(
                                                                                    icon: Icon(
                                                                                      Icons.share_outlined,
                                                                                      size: 23,
                                                                                      color: Color(0x99f5410a),
                                                                                    ),
                                                                                    onPressed: () {
                                                                                      setState(() {});
                                                                                      final verseNumber = widget.surah!.ayahs![index].numberInSurah!;
                                                                                      final translation = translateData?[verseNumber - 1]['text'];
                                                                                      QuranCubit.get(context).showVerseOptionsBottomSheet(context, verseNumber, widget.surah!.number, "${widget.surah!.ayahs![index].text}", translation ?? '', widget.surah!.name);
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
                                                                      );
                                                                      print(
                                                                          '${widget.surah!.name!}');
                                                                      print(
                                                                          '${widget.surah!.number!}');
                                                                      print(
                                                                          '${widget.surah!.ayahs![index].numberInSurah}');
                                                                      print(
                                                                          '${widget.nomPageF}');
                                                                      print(
                                                                          '${widget.nomPageL}');
                                                                    }),
                                                          TextSpan(
                                                            text:
                                                                ' ${arabicNumber.convert(widget.surah!.ayahs![index].numberInSurah.toString())}',
                                                            style: TextStyle(
                                                              fontSize: TextPageView
                                                                      .fontSizeArabic +
                                                                  5,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  'uthmanic2',
                                                              color: ThemeProvider.themeOf(
                                                                              context)
                                                                          .id ==
                                                                      'dark'
                                                                  ? Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .surface
                                                                  : Theme.of(
                                                                          context)
                                                                      .primaryColorLight,
                                                            ),
                                                          )
                                                        ]),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 16),
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            Align(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child:
                                                                    translateDropDown(
                                                                        context)),
                                                            SizedBox(
                                                                height: 40,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    1 /
                                                                    2,
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  'assets/svg/space_line.svg',
                                                                )),
                                                            Align(
                                                              alignment: Alignment
                                                                  .bottomLeft,
                                                              child: juzNumEn(
                                                                'Part\n${widget.surah!.ayahs![index].juz}',
                                                                context,
                                                                ThemeProvider.themeOf(context)
                                                                            .id ==
                                                                        'dark'
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 16.0,
                                                              right: 32.0,
                                                              left: 32.0),
                                                      child: BlocBuilder<
                                                          TranslateDataCubit,
                                                          TranslateDataState>(
                                                        builder:
                                                            (context, state) {
                                                          if (state.isLoading) {
                                                            // Display a loading indicator while the translation data is being fetched
                                                            return Lottie.asset(
                                                                'assets/lottie/search.json',
                                                                width: 50);
                                                          } else {
                                                            final translateData =
                                                                state.data;
                                                            if (translateData !=
                                                                    null &&
                                                                translateData
                                                                    .isNotEmpty) {
                                                              // Use the translation variable in your widget tree
                                                              return ReadMoreLess(
                                                                text: translateData![
                                                                            index]
                                                                        [
                                                                        'text'] ??
                                                                    '',
                                                                textStyle:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      TextPageView
                                                                              .fontSizeArabic -
                                                                          10,
                                                                  fontFamily:
                                                                      'kufi',
                                                                  color: ThemeProvider.themeOf(context)
                                                                              .id ==
                                                                          'dark'
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .justify,
                                                                readMoreText:
                                                                    AppLocalizations.of(
                                                                            context)!
                                                                        .readMore,
                                                                readLessText:
                                                                    AppLocalizations.of(
                                                                            context)!
                                                                        .readLess,
                                                                buttonTextStyle:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      'kufi',
                                                                  color: ThemeProvider.themeOf(context)
                                                                              .id ==
                                                                          'dark'
                                                                      ? Colors
                                                                          .white
                                                                      : Theme.of(
                                                                              context)
                                                                          .primaryColorLight,
                                                                ),
                                                                iconColor: ThemeProvider.themeOf(context)
                                                                            .id ==
                                                                        'dark'
                                                                    ? Colors
                                                                        .white
                                                                    : Theme.of(
                                                                            context)
                                                                        .primaryColorLight,
                                                              ); // Replace this with your actual widget
                                                            } else {
                                                              // Display a placeholder widget if there's no translation data
                                                              return Text(
                                                                  'No translation available');
                                                            }
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // ),
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: juzNum(
                                                  '${widget.surah!.ayahs![index].juz}',
                                                  context,
                                                  ThemeProvider.themeOf(context)
                                                              .id ==
                                                          'dark'
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Stack(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                TextCubit.controller.reverse();
                                                setState(() {
                                                  backColor =
                                                      Colors.transparent;
                                                });
                                              },
                                              // child: AutoScrollTag(
                                              //   key: ValueKey(index),
                                              //   controller: TextCubit.scrollController!,
                                              //   index: index,
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 16),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .background,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
                                                child: Column(
                                                  children: [
                                                    Center(
                                                      child: SizedBox(
                                                          height: 50,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              1 /
                                                              2,
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/svg/space_line.svg',
                                                          )),
                                                    ),
                                                    widget.surah!.number == 9
                                                        ? Container()
                                                        : widget
                                                                    .surah!
                                                                    .ayahs![
                                                                        index]
                                                                    .numberInSurah ==
                                                                1
                                                            ? SvgPicture.asset(
                                                                'assets/svg/besmAllah.svg',
                                                                width: 200,
                                                                colorFilter: ColorFilter.mode(
                                                                    Theme.of(
                                                                            context)
                                                                        .cardColor
                                                                        .withOpacity(
                                                                            .8),
                                                                    BlendMode
                                                                        .srcIn),
                                                              )
                                                            : Container(),
                                                    Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 32),
                                                      child:
                                                          SelectableText.rich(
                                                        showCursor: true,
                                                        cursorWidth: 3,
                                                        cursorColor:
                                                            Theme.of(context)
                                                                .dividerColor,
                                                        cursorRadius:
                                                            const Radius
                                                                .circular(5),
                                                        scrollPhysics:
                                                            const ClampingScrollPhysics(),
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        textAlign:
                                                            TextAlign.justify,
                                                        TextSpan(
                                                          style: TextStyle(
                                                              fontSize: TextPageView
                                                                  .fontSizeArabic,
                                                              backgroundColor: TextCubit
                                                                      .bColor ??
                                                                  Colors
                                                                      .transparent,
                                                              fontFamily:
                                                                  'uthmanic2'),
                                                          children:
                                                              text.map((e) {
                                                            return e;
                                                          }).toList(),
                                                        ),
                                                      ),
                                                    ),
                                                    Center(
                                                      child: SizedBox(
                                                          height: 50,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              1 /
                                                              2,
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/svg/space_line.svg',
                                                          )),
                                                    ),
                                                    Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: pageNumber(
                                                          arabicNumber
                                                              .convert(widget
                                                                      .nomPageF! +
                                                                  index)
                                                              .toString(),
                                                          context,
                                                          Theme.of(context)
                                                              .primaryColor),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // ),
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20.0,
                                                        vertical: 25.0),
                                                child: juzNum(
                                                  '${TextCubit.juz}',
                                                  context,
                                                  ThemeProvider.themeOf(context)
                                                              .id ==
                                                          'dark'
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            )
                                          ],
                                        );
                                },
                              );
                            }),
>>>>>>> Stashed changes
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
            max: 60,
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
<<<<<<< Updated upstream
      customButton: Icon(
        Icons.format_size,
        color: Theme.of(context).bottomAppBarColor,
      ),
      iconSize: 24,
=======
      customButton: Container(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              border: Border.all(
                  width: 1, color: Theme.of(context).colorScheme.surface)),
          child: Icon(
            Icons.format_size,
            size: 20,
            color: Theme.of(context).colorScheme.surface,
          )),
      iconSize: 20,
>>>>>>> Stashed changes
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

  Widget rollingIconBuilder(int value, Size iconSize, bool foreground) {
    IconData data = Icons.textsms_outlined;
    if (value.isEven) data = Icons.text_snippet_outlined;
    return Icon(
      data,
      size: 20,
    );
  }

  Widget scrollDropDown(BuildContext context) {
    return DropdownButton2(
      isExpanded: true,
      items: [
        DropdownMenuItem<String>(
<<<<<<< Updated upstream
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
=======
          child: StatefulBuilder(builder: (BuildContext context, setState) {
            return Slider(
              value: textCubit.scrollSpeed,
              min: .05,
              max: .10,
              onChanged: (double value) {
                setState(() {
                  textCubit.scrollSpeedNotifier!.value = value;
                  print(textCubit.scrollSpeedNotifier!.value);
                  textCubit.scrollSpeed = value;
                  print(textCubit.scrollSpeed);
                  if (textCubit.scrolling) {
                    _toggleScroll(); // Stop the scrolling with the old speed
                    _toggleScroll(); // Restart the scrolling with the new speed
                  }
                });
              },
            );
          }),
          // child: FlutterSlider(
          //   values: [_scrollSpeed],
          //   max: 2.0,
          //   min: .05,
          //   rtl: true,
          //   trackBar: FlutterSliderTrackBar(
          //     inactiveTrackBarHeight: 5,
          //     activeTrackBarHeight: 5,
          //     inactiveTrackBar: BoxDecoration(
          //       borderRadius: BorderRadius.circular(8),
          //       color: Theme.of(context).colorScheme.surface,
          //     ),
          //     activeTrackBar: BoxDecoration(
          //         borderRadius: BorderRadius.circular(4),
          //         color: Theme.of(context).colorScheme.background),
          //   ),
          //   handlerAnimation: const FlutterSliderHandlerAnimation(
          //       curve: Curves.elasticOut,
          //       reverseCurve: null,
          //       duration: Duration(milliseconds: 700),
          //       scale: 1.4),
          //   onDragging: (handlerIndex, lowerValue, upperValue) {
          //     setState(() {
          //       _scrollSpeedNotifier!.value = lowerValue;
          //       print(_scrollSpeedNotifier!.value);
          //       // lowerValue = lowerValue;
          //       // upperValue = upperValue;
          //       _scrollSpeed = lowerValue;
          //       print(_scrollSpeed);
          //       if (_scrolling) {
          //         _toggleScroll(); // Stop the scrolling with the old speed
          //         _toggleScroll(); // Restart the scrolling with the new speed
          //       }
          //     });
          //   },
          //   handler: FlutterSliderHandler(
          //     decoration: const BoxDecoration(),
          //     child: Material(
          //       type: MaterialType.circle,
          //       color: Colors.transparent,
          //       elevation: 3,
          //       child: SvgPicture.asset('assets/svg/slider_ic.svg'),
          //     ),
          //   ),
          // ),
        )
      ],
      // value: textCubit.scrollSpeed,
      onChanged: (value) {
        setState(() {
          textCubit.scrollSpeed = value as double;
        });
      },
      customButton: Container(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              border: Border.all(
                  width: 1, color: Theme.of(context).colorScheme.surface)),
          child: Icon(
            Icons.format_size,
            size: 20,
            color: Theme.of(context).colorScheme.surface,
          )),
      iconSize: 20,
>>>>>>> Stashed changes
      buttonHeight: 50,
      buttonWidth: 50,
      buttonElevation: 0,
      itemHeight: 35,
      dropdownDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(.9),
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

  Widget translateDropDown(BuildContext context) {
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
      iconSize: 24,
      buttonHeight: 50,
      buttonWidth: 50,
      buttonElevation: 0,
      itemHeight: 110.0,
      dropdownDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(.97),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      dropdownMaxHeight: orientation(context, 230.0, 125.0),
      dropdownWidth: 200,
      dropdownPadding: null,
      dropdownElevation: 0,
      scrollbarRadius: const Radius.circular(8),
      scrollbarThickness: 6,
      scrollbarAlwaysShow: true,
      offset: const Offset(0, 0),
    );
  }
}
