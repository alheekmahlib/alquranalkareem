import 'package:another_xlider/another_xlider.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
<<<<<<< HEAD
import 'package:bot_toast/bot_toast.dart';
import 'package:clipboard/clipboard.dart';
=======
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
=======
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';
import '../cubit/cubit.dart';
<<<<<<< HEAD
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
=======
import '../cubit/states.dart';
import '../shared/widgets/widgets.dart';
import 'model/QuranModel.dart';

class TextPageView extends StatefulWidget {
  SurahText surah;
  int nomPageF, nomPageL;

  TextPageView(
      {required this.surah, required this.nomPageF, required this.nomPageL});
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
  static int textCurrentPage = 0;
  static String lastTime = '';
  static String sorahTextName = '';
  static double fontSizeArabic = 18;

  @override
  _TextPageViewState createState() => _TextPageViewState();
}

class _TextPageViewState extends State<TextPageView>
<<<<<<< HEAD
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  String? juz;
  bool? sajda;
=======
    with WidgetsBindingObserver {
  String? selectedValue;
  double scrollSpeed = 0;
  String? selectedSpeed;
  Color? bColor;
  final ScrollController controller = ScrollController();
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee

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
<<<<<<< HEAD
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
=======
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
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
        return SafeArea(
          top: false,
          bottom: false,
          right: false,
          left: false,
          child: Scaffold(
<<<<<<< HEAD
              key: TPageScaffoldKey,
=======
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
              resizeToAvoidBottomInset: false,
              body: Directionality(
                textDirection: TextDirection.rtl,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 64.0),
                      child: Stack(
                        children: [
<<<<<<< HEAD
=======
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
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
<<<<<<< HEAD
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
=======
                                    color: Theme.of(context).backgroundColor,
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      topLeft: Radius.circular(8),
                                    ),
                                    border: Border.all(
                                        width: 2,
                                        color: Theme.of(context).dividerColor)),
                                child: Icon(
                                  Icons.close_outlined,
<<<<<<< HEAD
                                  color: Theme.of(context).colorScheme.surface,
=======
                                  color: Theme.of(context).bottomAppBarColor,
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
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
<<<<<<< HEAD
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
=======
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
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
<<<<<<< HEAD
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
=======
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
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
                                          color: ThemeProvider.themeOf(context)
                                                      .id ==
                                                  'dark'
                                              ? Colors.white
                                              : Colors.black,
<<<<<<< HEAD
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
=======
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
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
                                          })
                                  ]));
                                  text.add(
                                    TextSpan(children: [
                                      TextSpan(
<<<<<<< HEAD
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
=======
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
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
                                    ]),
                                  );
                                }
                              }
                            }
                            return Stack(
                              children: [
<<<<<<< HEAD
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
=======
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
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
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
<<<<<<< HEAD
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
=======
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
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
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
<<<<<<< HEAD
                                              arabicNumber
                                                  .convert(
                                                      widget.nomPageF! + index)
=======
                                              (widget.nomPageF + index)
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
                                                  .toString(),
                                              context,
                                              Theme.of(context).primaryColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
<<<<<<< HEAD
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
=======
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
                              ],
                            );
                          },
                        ),
                      ),
                    ),
<<<<<<< HEAD
                    SlideTransition(
                        position: TextCubit.offset, child: AudioTextWidget()),
=======
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
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
<<<<<<< HEAD
                color: Theme.of(context).colorScheme.surface,
              ),
              activeTrackBar: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).colorScheme.background),
=======
                color: Theme.of(context).bottomAppBarColor,
              ),
              activeTrackBar: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).backgroundColor),
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
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
<<<<<<< HEAD
        color: Theme.of(context).colorScheme.surface,
=======
        color: Theme.of(context).bottomAppBarColor,
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
      ),
      iconSize: 24,
      buttonHeight: 50,
      buttonWidth: 50,
      buttonElevation: 0,
      itemHeight: 35,
      dropdownDecoration: BoxDecoration(
<<<<<<< HEAD
          color: Theme.of(context).colorScheme.surface.withOpacity(.9),
=======
          color: Theme.of(context).bottomAppBarColor.withOpacity(.9),
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
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
<<<<<<< HEAD
    QuranTextCubit textCubit = QuranTextCubit.get(context);
=======
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
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
<<<<<<< HEAD
                color: Theme.of(context).colorScheme.surface,
              ),
              activeTrackBar: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).colorScheme.background),
=======
                color: Theme.of(context).bottomAppBarColor,
              ),
              activeTrackBar: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).backgroundColor),
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
            ),
            handlerAnimation: const FlutterSliderHandlerAnimation(
                curve: Curves.elasticOut,
                reverseCurve: null,
                duration: Duration(milliseconds: 700),
                scale: 1.4),
            onDragging: (handlerIndex, lowerValue, upperValue) {
              lowerValue = lowerValue;
              upperValue = upperValue;
<<<<<<< HEAD
              textCubit.scrollSpeed = lowerValue;
              setState(() {
                print(textCubit.scrollSpeed);
=======
              scrollSpeed = lowerValue;
              setState(() {
                print(scrollSpeed);
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
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
<<<<<<< HEAD
      value: textCubit.selectedSpeed,
      onChanged: (value) {
        setState(() {
          textCubit.selectedSpeed = value as String;
=======
      value: selectedSpeed,
      onChanged: (value) {
        setState(() {
          selectedSpeed = value as String;
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
        });
      },
      customButton: Icon(
        Icons.format_size,
<<<<<<< HEAD
        color: Theme.of(context).colorScheme.surface,
=======
        color: Theme.of(context).bottomAppBarColor,
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
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
