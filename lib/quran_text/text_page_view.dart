import 'dart:async';
import 'package:alquranalkareem/notes/cubit/note_cubit.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';
import '../cubit/cubit.dart';
import '../cubit/translateDataCubit/_cubit.dart';
import '../cubit/translateDataCubit/translateDataState.dart';
import '../l10n/app_localizations.dart';
import '../quran_page/widget/sliding_up.dart';
import '../shared/widgets/lottie.dart';
import '../shared/widgets/show_tafseer.dart';
import '../shared/widgets/svg_picture.dart';
import '../shared/widgets/widgets.dart';
import '../shared/word_selectable_text.dart';
import 'Widgets/audio_text_widget.dart';
import 'Widgets/show_text_tafseer.dart';
import 'Widgets/text_overflow_detector.dart';
import 'Widgets/widgets.dart';
import 'cubit/quran_text_cubit.dart';
import 'model/QuranModel.dart';

var lastAyah;
var lastAyahInPage;
int? textSurahNum;

class TextPageView extends StatefulWidget {
  SurahText? surah;
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
    QuranTextCubit.get(context).scrollController.jumpTo(
        QuranTextCubit.get(context).animationController.value *
            (QuranTextCubit.get(context)
                .scrollController
                .position
                .maxScrollExtent));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _quranTextCubit = QuranTextCubit.get(context);
    _quranCubit = QuranCubit.get(context);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    TextPageView.textCurrentPage = widget.nomPageF!;
    TextPageView.sorahTextName = widget.surah!.name!;
    QuranTextCubit.get(context).loadTextCurrentPage();
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _quranTextCubitSubscription =
          context.read<QuranTextCubit>().stream.listen((QuranTextState state) {
        if (!mounted) return; // Check if the widget is still mounted

        final translation = QuranTextCubit.get(context)
            .translateHandleRadioValueChanged(
                QuranTextCubit.get(context).transValue);
        context
            .read<TranslateDataCubit>()
            .fetchSura(context, translation, '${widget.surah!.number!}');
      });
    });
    QuranCubit.get(context).screenController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    QuranCubit.get(context).screenAnimation = Tween<double>(begin: 1, end: 0.95)
        .animate(QuranCubit.get(context).screenController!);
    QuranCubit.get(context).panelController = SlidingUpPanelController();
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

  jumbToPage() async {
    int pageNum = widget.pageNum ??
        0; // Use the null coalescing operator to ensure pageNum is not null

    if (pageNum == 0 ||
        pageNum == 1 ||
        pageNum == 585 ||
        pageNum == 586 ||
        pageNum == 587 ||
        pageNum == 589 ||
        pageNum == 590 ||
        pageNum == 591 ||
        pageNum == 592 ||
        pageNum == 593 ||
        pageNum == 594 ||
        pageNum == 595 ||
        pageNum == 596 ||
        pageNum == 597 ||
        pageNum == 598 ||
        pageNum == 599 ||
        pageNum == 600 ||
        pageNum == 601 ||
        pageNum == 602 ||
        pageNum == 603 ||
        pageNum == 604) {
    } else {
      await QuranTextCubit.get(context).itemScrollController.scrollTo(
          index:
              (QuranTextCubit.get(context).value == 1 ? pageNum : pageNum - 1),
          duration: const Duration(seconds: 1),
          curve: Curves.easeOut);
      setState(() {
        QuranTextCubit.get(context).isSelected =
            QuranTextCubit.get(context).value == 1 ? pageNum : pageNum - 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color backColor = Theme.of(context).colorScheme.surface.withOpacity(0.4);

    return BlocConsumer<QuranTextCubit, QuranTextState>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, state) {
        QuranTextCubit TextCubit = QuranTextCubit.get(context);
        QuranCubit cubit = QuranCubit.get(context);
        NotesCubit notesCubit = NotesCubit.get(context);
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
                                        ? Stack(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  TextCubit.controller
                                                      .reverse();
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
                                                  margin: const EdgeInsets
                                                          .symmetric(
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
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  4))),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 16.0),
                                                        child: Center(
                                                          child: spaceLine(
                                                            20,
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                1 /
                                                                2,
                                                          ),
                                                        ),
                                                      ),
                                                      widget.surah!.number == 9
                                                          ? Container()
                                                          : widget
                                                                      .surah!
                                                                      .ayahs![
                                                                          index]
                                                                      .numberInSurah ==
                                                                  1
                                                              ? besmAllah(
                                                                  context)
                                                              : Container(),
                                                      // WordSelectableText(
                                                      //     selectable:  true,
                                                      //     highlight:  true,
                                                      //
                                                      //     text: widget.surah!.ayahs![index].text!,
                                                      //     onWordTapped: (word, index) {},
                                                      //     style: TextStyle(
                                                      //       fontSize:
                                                      //       TextPageView
                                                      //           .fontSizeArabic,
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
                                                        padding:
                                                            const EdgeInsets
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
                                                                    .ayahs![
                                                                        index]
                                                                    .text!,
                                                                style:
                                                                    TextStyle(
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
                                                                            ? TextCubit.selected
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
                                                                        setState(
                                                                            () {
                                                                          TextCubit.selected =
                                                                              !TextCubit.selected;
                                                                          lastAyahInPage = widget
                                                                              .surah!
                                                                              .ayahs![index]
                                                                              .numberInSurah;
                                                                          textSurahNum = widget
                                                                              .surah!
                                                                              .number;
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
                                                                        menu(
                                                                            context,
                                                                            index,
                                                                            index,
                                                                            details,
                                                                            translateData,
                                                                            widget.surah,
                                                                            widget.nomPageF,
                                                                            widget.nomPageL);
                                                                      }),
                                                            TextSpan(
                                                              text:
                                                                  ' ${arabicNumber.convert(widget.surah!.ayahs![index].numberInSurah.toString())}',
                                                              style: TextStyle(
                                                                fontSize:
                                                                    TextPageView
                                                                            .fontSizeArabic +
                                                                        5,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    'uthmanic2',
                                                                color: ThemeProvider.themeOf(context)
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
                                                          contextMenuBuilder:
                                                              buildMyContextMenuText(
                                                                  notesCubit),
                                                          onSelectionChanged:
                                                              handleSelectionChanged,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 16),
                                                        child: SizedBox(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: Stack(
                                                            alignment: Alignment
                                                                .center,
                                                            children: [
                                                              Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  child: translateDropDown(
                                                                      context,
                                                                      setState)),
                                                              spaceLine(
                                                                20,
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    1 /
                                                                    2,
                                                              ),
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
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 16.0,
                                                                right: 32.0,
                                                                left: 32.0),
                                                        child: BlocBuilder<
                                                            TranslateDataCubit,
                                                            TranslateDataState>(
                                                          builder:
                                                              (context, state) {
                                                            if (state
                                                                .isLoading) {
                                                              // Display a loading indicator while the translation data is being fetched
                                                              return search(
                                                                  50.0, 50.0);
                                                            } else {
                                                              final translateData =
                                                                  state.data;
                                                              if (translateData !=
                                                                      null &&
                                                                  translateData
                                                                      .isNotEmpty) {
                                                                // Use the translation variable in your widget tree
                                                                return ReadMoreLess(
                                                                  text: translateData[
                                                                              index]
                                                                          [
                                                                          'text'] ??
                                                                      '',
                                                                  textStyle:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        TextPageView.fontSizeArabic -
                                                                            10,
                                                                    fontFamily:
                                                                        'kufi',
                                                                    color: ThemeProvider.themeOf(context).id ==
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
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        'kufi',
                                                                    color: ThemeProvider.themeOf(context).id ==
                                                                            'dark'
                                                                        ? Colors
                                                                            .white
                                                                        : Theme.of(context)
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
                                                                return const Text(
                                                                    'No translation available');
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
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: juzNum(
                                                      '${widget.surah!.ayahs![index].juz}',
                                                      context,
                                                      ThemeProvider.themeOf(
                                                                      context)
                                                                  .id ==
                                                              'dark'
                                                          ? Colors.white
                                                          : Colors.black,
                                                      25),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Stack(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  TextCubit.controller
                                                      .reverse();
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
                                                  margin: const EdgeInsets
                                                          .symmetric(
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
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  8))),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 16.0),
                                                        child: Center(
                                                          child: spaceLine(
                                                            20,
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                1 /
                                                                2,
                                                          ),
                                                        ),
                                                      ),
                                                      widget.surah!.number == 9
                                                          ? Container()
                                                          : widget
                                                                      .surah!
                                                                      .ayahs![
                                                                          index]
                                                                      .numberInSurah ==
                                                                  1
                                                              ? besmAllah(
                                                                  context)
                                                              : Container(),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 32),
                                                        // child: WordSelectableText(
                                                        //     selectable:  true,
                                                        //     highlight:  true,
                                                        //
                                                        //     text: text.map((e) {
                                                        //       return e;
                                                        //     }).toList(),
                                                        //     onWordTapped: (word, index) {},
                                                        //     style: TextStyle(
                                                        //       fontSize:
                                                        //       TextPageView
                                                        //           .fontSizeArabic,
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
                                                                fontSize:
                                                                    TextPageView
                                                                        .fontSizeArabic,
                                                                backgroundColor:
                                                                    TextCubit
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
                                                          contextMenuBuilder:
                                                              buildMyContextMenuText(
                                                                  notesCubit),
                                                          onSelectionChanged:
                                                              handleSelectionChangedText,
                                                        ),
                                                      ),
                                                      Center(
                                                        child: spaceLine(
                                                          20,
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1 /
                                                              2,
                                                        ),
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
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 25.0),
                                                  child: juzNum(
                                                      '${TextCubit.juz}',
                                                      context,
                                                      ThemeProvider.themeOf(
                                                                      context)
                                                                  .id ==
                                                              'dark'
                                                          ? Colors.white
                                                          : Colors.black,
                                                      25),
                                                ),
                                              )
                                            ],
                                          );
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
