import 'dart:async';

import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/handler_animation.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:theme_provider/theme_provider.dart';

import '../quran_page/widget/sliding_up.dart';
import '../shared/controller/audio_controller.dart';
import '../shared/controller/general_controller.dart';
import '../shared/controller/quranText_controller.dart';
import '../shared/controller/translate_controller.dart';
import '../shared/widgets/widgets.dart';
import 'Widgets/audio_text_widget.dart';
import 'Widgets/show_text_tafseer.dart';
import 'Widgets/widgets.dart';
import 'model/QuranModel.dart';

int? lastAyah;
int? lastAyahInPage;
int? lastAyahInPageA;
int pageN = 1;
int? textSurahNum;

// ignore: must_be_immutable
class TextPageView extends StatefulWidget {
  final SurahText? surah;
  int? nomPageF, nomPageL, pageNum = 1;

  TextPageView({
    Key? key,
    this.nomPageF,
    this.nomPageL,
    this.pageNum,
    this.surah,
  });
  static int textCurrentPage = 0;
  static String lastTime = '';
  static String sorahTextName = '';

  @override
  _TextPageViewState createState() => _TextPageViewState();
}

class _TextPageViewState extends State<TextPageView>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final GlobalKey _scrollKey = GlobalKey();
  Timer? _scrollTimer;
  ArabicNumbers arabicNumber = ArabicNumbers();
  String? translateText;
  final AudioController aCtrl = Get.put(AudioController());
  late final GeneralController generalController = Get.put(GeneralController());
  late final TranslateDataController translateController =
      Get.put(TranslateDataController());
  late final QuranTextController quranTextController =
      Get.put(QuranTextController());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    TextPageView.textCurrentPage = widget.nomPageF!;
    TextPageView.sorahTextName = widget.surah!.name!;

    print("trans ${translateController.trans}");
    WidgetsBinding.instance
        .addPostFrameCallback((_) => quranTextController.jumbToPage(widget));
    // jumbToPage();
    quranTextController.controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    quranTextController.offset = Tween<Offset>(
      end: Offset.zero,
      begin: const Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: quranTextController.controller,
      curve: Curves.easeIn,
    ));
    // quranTextController.scrollController = AutoScrollController(
    // viewportBoundaryGetter: () =>
    // Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
    // axis: Axis.vertical);
    quranTextController.animationController = AnimationController(
      vsync: this,
    );
    // quranTextController.animationController.addListener(() {
    //   quranTextController.scroll();
    // });
    quranTextController.scrollSpeedNotifier =
        ValueNotifier<double>(quranTextController.scrollSpeed);

    generalController.screenController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    generalController.screenAnimation = Tween<double>(begin: 1, end: 0.95)
        .animate(generalController.screenController!);
    generalController.panelController = SlidingUpPanelController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color backColor = Theme.of(context).colorScheme.surface.withOpacity(0.4);
    return SafeArea(
      top: false,
      bottom: false,
      right: false,
      left: false,
      child: Scaffold(
          key: TPageScaffoldKey,
          resizeToAvoidBottomInset: false,
          body: AnimatedBuilder(
            animation: generalController.screenAnimation!,
            builder: (context, child) {
              return Transform.scale(
                scale: generalController.screenAnimation!.value,
                child: child,
              );
            },
            child: Directionality(
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
                        const SizedBox.shrink(),
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
                            const Spacer(),
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
                              child: animatedToggleSwitch(context),
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
                        customClose2(context),
                        const Divider(
                          height: 58,
                          thickness: 2,
                          endIndent: 16,
                          indent: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
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
                                    padding: const EdgeInsets.symmetric(
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
                                          child: animatedToggleSwitch(context),
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
                              const SizedBox.shrink()),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Padding(
                      padding: orientation(
                          context,
                          const EdgeInsets.only(top: 155.0, bottom: 16.0),
                          const EdgeInsets.only(
                              top: 68.0,
                              bottom: 16.0,
                              right: 40.0,
                              left: 40.0)),
                      child: AnimatedBuilder(
                          animation: quranTextController.animationController,
                          builder: (BuildContext context, Widget? child) {
                            if (quranTextController
                                .scrollController.hasClients) {
                              quranTextController.scrollController.jumpTo(
                                  quranTextController
                                          .animationController.value *
                                      (quranTextController.scrollController
                                          .position.maxScrollExtent));
                            }
                            return Obx(
                              () => ScrollablePositionedList.builder(
                                key: _scrollKey,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                addAutomaticKeepAlives: true,
                                // controller: TextCubit.scrollController,
                                itemScrollController:
                                    quranTextController.itemScrollController,
                                itemPositionsListener:
                                    quranTextController.itemPositionsListener,
                                itemCount: quranTextController.value == 1
                                    ? widget.surah!.ayahs!.length
                                    : (widget.nomPageL! - widget.nomPageF!) + 1,
                                itemBuilder: (context, index) {
                                  List<InlineSpan> text = [];
                                  int ayahLenght = widget.surah!.ayahs!.length;
                                  if (quranTextController.value == 1) {
                                    for (int index = 0;
                                        index < ayahLenght;
                                        index++) {
                                      if (widget.surah!.ayahs![index].text!
                                              .length >
                                          1) {
                                        quranTextController.sajda2 =
                                            widget.surah!.ayahs![index].sajda;
                                        lastAyah = widget
                                            .surah!.ayahs!.last.numberInSurah;
                                      }
                                    }
                                  } else {
                                    for (int b = 0; b < ayahLenght; b++) {
                                      if (widget.surah!.ayahs![b].text!.length >
                                          1) {
                                        if (widget.surah!.ayahs![b].page ==
                                            (index + widget.nomPageF!)) {
                                          quranTextController.juz = widget
                                              .surah!.ayahs![b].juz
                                              .toString();
                                          quranTextController.sajda =
                                              widget.surah!.ayahs![b].sajda;
                                          // text2 = widget.surah!.ayahs![b].text! as List<String>;
                                          text.add(TextSpan(children: [
                                            TextSpan(
                                                text: widget
                                                    .surah!.ayahs![b].text!,
                                                style: TextStyle(
                                                  fontSize: generalController
                                                      .fontSizeArabic.value,
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
                                                            audioController
                                                                .ayahSelected
                                                        ? quranTextController
                                                                .selected
                                                            ? backColor
                                                            : Colors.transparent
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
                                                        textText = text
                                                            .map((e) => e)
                                                            .toString();
                                                        textTitle = text
                                                            .map((e) => e)
                                                            .toString();
                                                        aCtrl.lastAyahInPage
                                                                .value =
                                                            widget
                                                                .surah!
                                                                .ayahs![b]
                                                                .numberInSurah!;
                                                        pageN = widget
                                                                .surah!
                                                                .ayahs![b]
                                                                .pageInSurah! -
                                                            1;
                                                        textSurahNum = widget
                                                            .surah!.number;
                                                        menu(
                                                            context,
                                                            b,
                                                            index,
                                                            details,
                                                            translateController
                                                                .data,
                                                            widget.surah!,
                                                            widget.nomPageF,
                                                            widget.nomPageL);
                                                        setState(() {
                                                          quranTextController
                                                                  .selected =
                                                              !quranTextController
                                                                  .selected;
                                                          backColor = Colors
                                                              .transparent;
                                                          ayatController
                                                                  .sorahTextNumber =
                                                              widget.surah!
                                                                  .number!
                                                                  .toString();
                                                          ayatController
                                                                  .ayahTextNumber =
                                                              widget
                                                                  .surah!
                                                                  .ayahs![b]
                                                                  .numberInSurah
                                                                  .toString();
                                                          audioController
                                                              .ayahSelected = widget
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
                                                  fontSize: generalController
                                                          .fontSizeArabic
                                                          .value +
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
                                  return quranTextController.value == 1
                                      ? singleAyah(
                                          context, setState, widget, index)
                                      : pageAyah(context, setState, widget,
                                          text, index);
                                },
                              ),
                            );
                          }),
                    ),
                  ),
                  SlideTransition(
                      position: quranTextController.offset,
                      child: AudioTextWidget()),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: TextSliding(
                        myWidget1: const ShowTextTafseer(),
                        cHeight: 110.0,
                      )),
                ],
              ),
            ),
          )),
    );
  }

  Widget fontSizeDropDown(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Icons.format_size,
        color: Theme.of(context).colorScheme.surface,
      ),
      color: Theme.of(context).colorScheme.surface.withOpacity(.8),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Obx(
            () => SizedBox(
              height: 30,
              width: MediaQuery.sizeOf(context).width,
              child: FlutterSlider(
                values: [generalController.fontSizeArabic.value],
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
                  generalController.fontSizeArabic.value = lowerValue;
                  generalController
                      .saveFontSize(generalController.fontSizeArabic.value);
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
            ),
          ),
          height: 30,
        ),
      ],
    );
  }
}

String textText = '';
String textTitle = '';
String? selectedTextT;

void handleSelectionChangedText(
    TextSelection selection, SelectionChangedCause? cause) {
  if (cause == SelectionChangedCause.longPress) {
    final characters = textText.characters;
    final start = characters.take(selection.start).length;
    final end = characters.take(selection.end).length;
    final selectedText = textText.substring(start - 1, end - 1);

    // setState(() {
    selectedTextT = selectedText;
    // });
    print(selectedText);
  }
}
