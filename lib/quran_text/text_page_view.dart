import 'package:another_xlider/another_xlider.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:clipboard/clipboard.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';
import '../cubit/cubit.dart';
import '../l10n/app_localizations.dart';
import '../quran_page/data/model/ayat.dart';
import '../shared/widgets/widgets.dart';
import 'Widgets/audio_text_widget.dart';
import 'Widgets/show_text_tafseer.dart';
import 'cubit/quran_text_cubit.dart';
import 'model/QuranModel.dart';

class TextPageView extends StatefulWidget {
  SurahText? surah;
  int? nomPageF, nomPageL;
  int? pageNum;

  TextPageView({this.nomPageF, this.nomPageL, this.pageNum, this.surah});
  static int textCurrentPage = 0;
  static String lastTime = '';
  static String sorahTextName = '';
  static double fontSizeArabic = 18;

  @override
  _TextPageViewState createState() => _TextPageViewState();
}

class _TextPageViewState extends State<TextPageView>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  String? juz;
  bool? sajda;

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
    TextPageView.textCurrentPage = widget.nomPageF!;
    TextPageView.sorahTextName = widget.surah!.name!;
    loadTextCurrentPage();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   // QuranTextCubit.get(context)
    //   //     .itemScrollController
    //   //     .scrollTo(index: 50, duration: Duration(seconds: 60));
    //   double minScrollExtent1 = QuranTextCubit.get(context).scrollController.position.minScrollExtent;
    //   double maxScrollExtent1 = QuranTextCubit.get(context).scrollController.position.maxScrollExtent;
    //   animateToMaxMin(maxScrollExtent1, minScrollExtent1, maxScrollExtent1,
    //       25, QuranTextCubit.get(context).scrollController);
    // });
    WidgetsBinding.instance.addPostFrameCallback((_) => jumbToPage());
    QuranTextCubit.get(context).controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    QuranTextCubit.get(context).offset = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: QuranTextCubit.get(context).controller,
      curve: Curves.easeIn,
    ));
    super.initState();
  }

  jumbToPage() {
    if (widget.pageNum! == 0 ||
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
      QuranTextCubit.get(context).itemScrollController.scrollTo(
          index: widget.pageNum! - 1,
          duration: const Duration(seconds: 1),
          curve: Curves.easeOut);
      setState(() {
        QuranTextCubit.get(context).isSelected = widget.pageNum! - 1;
      });
    }
  }

  final int _height = 100;

  void _animateToIndex(int index) {
    QuranTextCubit.get(context).itemScrollController.scrollTo(
          index: index * _height,
          duration: Duration(minutes: 2),
          curve: Curves.linear,
        );
  }

  animateToMaxMin(double max, double min, double direction, int seconds,
      ScrollController scrollController) {
    scrollController
        .animateTo(direction,
            duration: Duration(seconds: seconds), curve: Curves.linear)
        .then((value) {
      direction = direction == max ? min : max;
      animateToMaxMin(max, min, direction, seconds, scrollController);
    });
  }

  Future scrollToBottom(ScrollController scrollController) async {
    while (scrollController.position.pixels !=
        scrollController.position.maxScrollExtent) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
      await SchedulerBinding.instance!.endOfFrame;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color backColor = Theme.of(context).colorScheme.surface;
    Orientation orientation = MediaQuery.of(context).orientation;
    return BlocConsumer<QuranTextCubit, QuranTextState>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, state) {
        QuranTextCubit TextCubit = QuranTextCubit.get(context);
        ArabicNumbers arabicNumber = ArabicNumbers();
        return SafeArea(
          top: false,
          bottom: false,
          right: false,
          left: false,
          child: Scaffold(
              key: TPageScaffoldKey,
              resizeToAvoidBottomInset: false,
              body: Directionality(
                textDirection: TextDirection.rtl,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 64.0),
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
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
                                      topRight: Radius.circular(8),
                                      topLeft: Radius.circular(8),
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
                          const Divider(
                            height: 58,
                            thickness: 2,
                            endIndent: 16,
                            indent: 16,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Align(
                                alignment: Alignment.topRight,
                                child: Row(
                                  children: [
                                    fontSizeDropDown(context),
                                    // IconButton(onPressed: () => scrollToBottom(TextCubit.scrollController), icon: Icon(Icons.arrow_downward),)
                                    // scrollDropDown(context)
                                  ],
                                )),
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
                        child: ScrollablePositionedList.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          addAutomaticKeepAlives: true,
                          itemScrollController: TextCubit.itemScrollController,
                          itemPositionsListener:
                              TextCubit.itemPositionsListener,
                          itemCount: (widget.nomPageL! - widget.nomPageF!) + 1,
                          itemBuilder: (context, index) {
                            List<InlineSpan> text = [];
                            int ayahLenght = widget.surah!.ayahs!.length;
                            for (int b = 0; b < ayahLenght; b++) {
                              if (widget.surah!.ayahs![b].text!.length > 1) {
                                if (widget.surah!.ayahs![b].page ==
                                    (index + widget.nomPageF!)) {
                                  juz = widget.surah!.ayahs![b].juz.toString();
                                  sajda = widget.surah!.ayahs![b].sajda;
                                  text.add(TextSpan(children: [
                                    TextSpan(
                                        text: widget.surah!.ayahs![b].text,
                                        style: TextStyle(
                                          fontSize: TextPageView.fontSizeArabic,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'uthmanic2',
                                          color: ThemeProvider.themeOf(context)
                                                      .id ==
                                                  'dark'
                                              ? Colors.white
                                              : Colors.black,
                                          background: Paint()
                                            ..color = b == TextCubit.isSelected
                                                ? backColor
                                                : Colors.transparent
                                            ..strokeJoin = StrokeJoin.round
                                            ..strokeCap = StrokeCap.round
                                            ..style = PaintingStyle.fill,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTapDown =
                                              (TapDownDetails details) {
                                            setState(() {
                                              backColor = Colors.transparent;
                                              TextCubit.sorahName = widget
                                                  .surah!.number!
                                                  .toString();
                                              TextCubit.ayahNum = widget.surah!
                                                  .ayahs![b].numberInSurah
                                                  .toString();
                                              TextCubit.isSelected = b;
                                            });
                                            var cancel =
                                                BotToast.showAttachedWidget(
                                              target: details.globalPosition,
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
                                              attachedBuilder: (cancel) => Card(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 6.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        height: 40,
                                                        width: 40,
                                                        decoration: BoxDecoration(
                                                            color: Color(
                                                                0xfff3efdf),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            50))),
                                                        child: FutureBuilder<
                                                                List<Ayat>>(
                                                            future: QuranCubit
                                                                    .get(
                                                                        context)
                                                                .handleRadioValueChanged(
                                                                    QuranCubit.get(
                                                                            context)
                                                                        .radioValue)
                                                                .getAyahTranslate(
                                                                    (widget
                                                                        .surah!
                                                                        .number)),
                                                            builder: (context,
                                                                snapshot) {
                                                              if (snapshot
                                                                      .connectionState ==
                                                                  ConnectionState
                                                                      .done) {
                                                                List<Ayat>?
                                                                    ayat =
                                                                    snapshot
                                                                        .data;
                                                                Ayat aya =
                                                                    ayat![b];
                                                                return IconButton(
                                                                  icon: Icon(
                                                                    Icons
                                                                        .text_snippet_outlined,
                                                                    size: 24,
                                                                    color: Color(
                                                                        0x99f5410a),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    TextCubit
                                                                            .translateAyah =
                                                                        "${aya.ayatext}";
                                                                    TextCubit
                                                                            .translate =
                                                                        "${aya.translate}";
                                                                    // showModalBottomSheet<void>(
                                                                    //   context: context,
                                                                    //   builder: (BuildContext context) {
                                                                    //     return ShowTextTafseer();
                                                                    //   },
                                                                    // );
                                                                    if (TextCubit
                                                                        .isShowBottomSheet) {
                                                                      Navigator.pop(
                                                                          context);
                                                                    } else {
                                                                      TPageScaffoldKey.currentState?.showBottomSheet(
                                                                          shape: const RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.only(
                                                                                  topLeft: Radius.circular(8),
                                                                                  topRight: Radius.circular(8))),
                                                                          backgroundColor: Colors.transparent,
                                                                          (context) => Align(
                                                                                alignment: Alignment.bottomCenter,
                                                                                child: Padding(
                                                                                  padding: orientation == Orientation.portrait
                                                                                      ? const EdgeInsets.symmetric(horizontal: 16.0)
                                                                                      : const EdgeInsets.symmetric(horizontal: 64.0),
                                                                                  child: Container(
                                                                                    height: orientation == Orientation.portrait
                                                                                        ? MediaQuery.of(context).size.height * 1 / 2
                                                                                        : MediaQuery.of(context).size.height,
                                                                                    width: MediaQuery.of(context).size.width,
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: const BorderRadius.only(
                                                                                          topRight: Radius.circular(12.0),
                                                                                          topLeft: Radius.circular(12.0)),
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
                                                                return Center(
                                                                    child: Lottie.asset(
                                                                        'assets/lottie/search.json',
                                                                        width:
                                                                            100,
                                                                        height:
                                                                            40));
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
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            50))),
                                                        child: IconButton(
                                                          icon: Icon(
                                                            Icons
                                                                .bookmark_border,
                                                            size: 24,
                                                            color: Color(
                                                                0x99f5410a),
                                                          ),
                                                          onPressed: () {
                                                            TextCubit
                                                                    .addBookmarkText(
                                                                        widget
                                                                            .surah!
                                                                            .name!,
                                                                        widget
                                                                            .surah!
                                                                            .number!,
                                                                        index == 0
                                                                            ? index +
                                                                                1
                                                                            : index +
                                                                                2,
                                                                        // widget.surah!.ayahs![b].page,
                                                                        widget
                                                                            .nomPageF,
                                                                        widget
                                                                            .nomPageL,
                                                                        TextCubit
                                                                            .lastRead)
                                                                .then((value) =>
                                                                    customSnackBar(
                                                                        context,
                                                                        AppLocalizations.of(context)!
                                                                            .addBookmark));
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
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            50))),
                                                        child: IconButton(
                                                          icon: Icon(
                                                            Icons.copy_outlined,
                                                            size: 24,
                                                            color: Color(
                                                                0x99f5410a),
                                                          ),
                                                          onPressed: () {
                                                            FlutterClipboard
                                                                .copy(
                                                              '﴿${widget.surah!.ayahs![b].text}﴾ '
                                                              '[${widget.surah!.name}-'
                                                              '${arabicNumber.convert(widget.surah!.ayahs![b].numberInSurah.toString())}]',
                                                            ).then((value) =>
                                                                customSnackBar(
                                                                    context,
                                                                    AppLocalizations.of(
                                                                            context)!
                                                                        .copyAyah));
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
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            50))),
                                                        child: IconButton(
                                                          icon: Icon(
                                                            Icons
                                                                .play_arrow_outlined,
                                                            size: 24,
                                                            color: Color(
                                                                0x99f5410a),
                                                          ),
                                                          onPressed: () {
                                                            switch (TextCubit
                                                                .controller
                                                                .status) {
                                                              case AnimationStatus
                                                                  .dismissed:
                                                                TextCubit
                                                                    .controller
                                                                    .forward();
                                                                break;
                                                              case AnimationStatus
                                                                  .completed:
                                                                TextCubit
                                                                    .controller
                                                                    .reverse();
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
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            50))),
                                                        child: IconButton(
                                                          icon: Icon(
                                                            Icons
                                                                .share_outlined,
                                                            size: 23,
                                                            color: Color(
                                                                0x99f5410a),
                                                          ),
                                                          onPressed: () {
                                                            Share.share(
                                                                '﴿${widget.surah!.ayahs![b].text}﴾ '
                                                                '[${widget.surah!.name}-'
                                                                '${arabicNumber.convert(widget.surah!.ayahs![b].numberInSurah.toString())}]',
                                                                subject:
                                                                    '${widget.surah!.name}');
                                                            cancel();
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                            print('${widget.surah!.name!}');
                                            print('${widget.surah!.number!}');
                                            print(
                                                '${widget.surah!.ayahs![b].numberInSurah}');
                                            print('${widget.nomPageF}');
                                            print('${widget.nomPageL}');
                                          })
                                  ]));
                                  text.add(
                                    TextSpan(children: [
                                      TextSpan(
                                        text:
                                            ' ${arabicNumber.convert(widget.surah!.ayahs![b].numberInSurah.toString())} ',
                                        style: TextStyle(
                                            fontSize:
                                                TextPageView.fontSizeArabic +
                                                    10,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'uthmanic2',
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface),
                                      )
                                    ]),
                                  );
                                }
                              }
                            }
                            return Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    TextCubit.controller.forward();
                                    setState(() {
                                      backColor = Colors.transparent;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 16),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color:
                                            Theme.of(context).colorScheme.background,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Column(
                                      children: [
                                        sorahName(
                                          widget.surah!.number.toString(),
                                          context,
                                          ThemeProvider.themeOf(context).id ==
                                                  'dark'
                                              ? Colors.white
                                              : Colors.black,
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
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 32),
                                          child: SelectableText.rich(
                                            showCursor: true,
                                            cursorWidth: 3,
                                            cursorColor:
                                                Theme.of(context).dividerColor,
                                            cursorRadius:
                                                const Radius.circular(5),
                                            scrollPhysics:
                                                const ClampingScrollPhysics(),
                                            toolbarOptions:
                                                const ToolbarOptions(
                                                    copy: true,
                                                    selectAll: true),
                                            textDirection: TextDirection.rtl,
                                            textAlign: TextAlign.justify,
                                            TextSpan(
                                              style: TextStyle(
                                                  fontSize: TextPageView
                                                      .fontSizeArabic,
                                                  backgroundColor:
                                                      TextCubit.bColor ??
                                                          Colors.transparent,
                                                  fontFamily: 'uthmanic2'),
                                              children: text.map((e) {
                                                return e;
                                              }).toList(),
                                            ),
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
                                              arabicNumber
                                                  .convert(
                                                      widget.nomPageF! + index)
                                                  .toString(),
                                              context,
                                              Theme.of(context).primaryColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: juzNum(
                                      '$juz',
                                      context,
                                      ThemeProvider.themeOf(context).id ==
                                              'dark'
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    SlideTransition(
                        position: TextCubit.offset, child: AudioTextWidget()),
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
    QuranTextCubit textCubit = QuranTextCubit.get(context);
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
              textCubit.scrollSpeed = lowerValue;
              setState(() {
                print(textCubit.scrollSpeed);
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
      value: textCubit.selectedSpeed,
      onChanged: (value) {
        setState(() {
          textCubit.selectedSpeed = value as String;
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
