import 'dart:async';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:theme_provider/theme_provider.dart';
import '../cubit/cubit.dart';
import '../cubit/translateDataCubit/_cubit.dart';
import '../quran_page/widget/sliding_up.dart';
import '../shared/widgets/widgets.dart';
import 'Widgets/audio_text_widget.dart';
import 'Widgets/show_text_tafseer.dart';
import 'Widgets/widgets.dart';
import 'cubit/quran_text_cubit.dart';
import 'model/QuranModel.dart';

var lastAyah;
var lastAyahInPage;
int? textSurahNum;

class TextPageView extends StatefulWidget {
  final SurahText? surah;
  int? nomPageF, nomPageL, pageNum = 1;

  TextPageView({this.nomPageF, this.nomPageL, this.pageNum, this.surah});
  static int textCurrentPage = 0;
  static String lastTime = '';
  static String sorahTextName = '';
  static double fontSizeArabic = 24;

  @override
  _TextPageViewState createState() => _TextPageViewState();
}

class _TextPageViewState extends State<TextPageView>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final GlobalKey _scrollKey = GlobalKey();
  Timer? _scrollTimer;
  late QuranTextCubit _quranTextCubit;
  ArabicNumbers arabicNumber = ArabicNumbers();
  String? translateText;
  StreamSubscription? _quranTextCubitSubscription;
  QuranCubit? _quranCubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _quranTextCubit = QuranTextCubit.get(context);
    _quranCubit = QuranCubit.get(context);
  }

  @override
  void initState() {
    QuranTextCubit textCubit = QuranTextCubit.get(context);
    QuranCubit cubit = QuranCubit.get(context);
    WidgetsBinding.instance.addObserver(this);
    TextPageView.textCurrentPage = widget.nomPageF!;
    TextPageView.sorahTextName = widget.surah!.name!;
    textCubit.loadTextCurrentPage();
    textCubit.loadSwitchValue();
    textCubit.loadTranslateValue();
    textCubit.loadScrollSpeedValue();
    print("trans ${textCubit.trans}");
    WidgetsBinding.instance
        .addPostFrameCallback((_) => textCubit.jumbToPage(widget));
    // jumbToPage();
    textCubit.controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    textCubit.offset = Tween<Offset>(
      end: Offset.zero,
      begin: const Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: textCubit.controller,
      curve: Curves.easeIn,
    ));
    // textCubit.scrollController = AutoScrollController(
    // viewportBoundaryGetter: () =>
    // Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
    // axis: Axis.vertical);
    textCubit.animationController = AnimationController(
      vsync: this,
    );
    // textCubit.animationController.addListener(() {
    //   textCubit.scroll();
    // });
    textCubit.scrollSpeedNotifier =
        ValueNotifier<double>(textCubit.scrollSpeed);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _quranTextCubitSubscription =
          context.read<QuranTextCubit>().stream.listen((QuranTextState state) {
        if (!mounted) return; // Check if the widget is still mounted

        final translation =
            textCubit.translateHandleRadioValueChanged(textCubit.transValue);
        context
            .read<TranslateDataCubit>()
            .fetchSura(context, translation, '${widget.surah!.number!}');
      });
    });
    cubit.screenController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    cubit.screenAnimation =
        Tween<double>(begin: 1, end: 0.95).animate(cubit.screenController!);
    cubit.panelController = SlidingUpPanelController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _quranTextCubit.animationController.dispose();
    _quranTextCubitSubscription!.cancel();
    // QuranCubit.get(context).panelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color backColor = Theme.of(context).colorScheme.surface.withOpacity(0.4);
    return BlocConsumer<QuranTextCubit, QuranTextState>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, state) {
        QuranTextCubit TextCubit = QuranTextCubit.get(context);
        QuranCubit cubit = QuranCubit.get(context);
        final List<dynamic>? translateData =
            context.watch<TranslateDataCubit>().state.data;
        return SafeArea(
          top: false,
          bottom: false,
          right: false,
          left: false,
          child: Scaffold(
              key: TPageScaffoldKey,
              resizeToAvoidBottomInset: false,
              body: AnimatedBuilder(
                animation: cubit.screenAnimation!,
                builder: (context, child) {
                  return Transform.scale(
                    scale: cubit.screenAnimation!.value,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: fontSizeDropDown(context, setState),
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
                                  child:
                                      animatedToggleSwitch(context, setState),
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
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                              ThemeProvider.themeOf(context)
                                                          .id ==
                                                      'dark'
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            fontSizeDropDown(context, setState),
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
                                              child: animatedToggleSwitch(
                                                  context, setState),
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
                              animation: QuranTextCubit.get(context)
                                  .animationController,
                              builder: (BuildContext context, Widget? child) {
                                if (QuranTextCubit.get(context)
                                    .scrollController
                                    .hasClients) {
                                  QuranTextCubit.get(context)
                                      .scrollController
                                      .jumpTo(QuranTextCubit.get(context)
                                              .animationController
                                              .value *
                                          (QuranTextCubit.get(context)
                                              .scrollController
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
                                      : (widget.nomPageL! - widget.nomPageF!) +
                                          1,
                                  itemBuilder: (context, index) {
                                    List<InlineSpan> text = [];
                                    int ayahLenght =
                                        widget.surah!.ayahs!.length;
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
                                        if (widget
                                                .surah!.ayahs![b].text!.length >
                                            1) {
                                          if (widget.surah!.ayahs![b].page ==
                                              (index + widget.nomPageF!)) {
                                            TextCubit.juz = widget
                                                .surah!.ayahs![b].juz
                                                .toString();
                                            TextCubit.sajda =
                                                widget.surah!.ayahs![b].sajda;
                                            // text2 = widget.surah!.ayahs![b].text! as List<String>;
                                            text.add(TextSpan(children: [
                                              TextSpan(
                                                  text: widget
                                                      .surah!.ayahs![b].text!,
                                                  style: TextStyle(
                                                    fontSize: TextPageView
                                                        .fontSizeArabic,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontFamily: 'uthmanic2',
                                                    color:
                                                        ThemeProvider.themeOf(
                                                                        context)
                                                                    .id ==
                                                                'dark'
                                                            ? Colors.white
                                                            : Colors.black,
                                                    background: Paint()
                                                      ..color = b ==
                                                              TextCubit
                                                                  .isSelected
                                                          ? backColor
                                                          : Colors.transparent
                                                      ..color = b ==
                                                              TextCubit
                                                                  .isSelected
                                                          ? TextCubit.selected
                                                              ? backColor
                                                              : Colors
                                                                  .transparent
                                                          : Colors.transparent
                                                      // ..color = TextCubit.selected
                                                      //     ? backColor
                                                      //     : Colors.transparent
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
                                                          lastAyah = widget
                                                              .surah!
                                                              .ayahs!
                                                              .length;
                                                          lastAyahInPage = widget
                                                              .surah!
                                                              .ayahs![b]
                                                              .numberInSurah;
                                                          textSurahNum = widget
                                                              .surah!.number;
                                                          menu(
                                                              context,
                                                              b,
                                                              index,
                                                              details,
                                                              translateData,
                                                              widget.surah!,
                                                              widget.nomPageF,
                                                              widget.nomPageL);
                                                          setState(() {
                                                            TextCubit.selected =
                                                                !TextCubit
                                                                    .selected;
                                                            backColor = Colors
                                                                .transparent;
                                                            TextCubit
                                                                    .sorahName =
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
                                        ? singleAyah(context, setState, widget,
                                            translateData, index)
                                        : pageAyah(context, setState, widget,
                                            text, index);
                                  },
                                );
                              }),
                        ),
                      ),
                      SlideTransition(
                          position: TextCubit.offset, child: AudioTextWidget()),
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
      },
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
