import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:spring/spring.dart';
import 'package:theme_provider/theme_provider.dart';

import '../quran_page/widget/sliding_up.dart';
import '../shared/widgets/controllers_put.dart';
import '../shared/widgets/widgets.dart';
import 'Widgets/audio_text_widget.dart';
import 'Widgets/scrollable_list.dart';
import 'Widgets/show_text_tafseer.dart';
import 'Widgets/widgets.dart';
import 'model/QuranModel.dart';

int? lastAyah;
int? lastAyahInPage;
int? lastAyahInPageA;
int pageN = 1;
int? textSurahNum;

// ignore: must_be_immutable
class TextPageView extends StatelessWidget {
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

  ArabicNumbers arabicNumber = ArabicNumbers();
  String? translateText;

  @override
  Widget build(BuildContext context) {
    quranTextController.loadSwitchValue();
    springController = SpringController(initialAnim: Motion.play);

    WidgetsBinding.instance
        .addPostFrameCallback((_) => quranTextController.jumbToPage(pageNum));
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
                            surah!.number.toString(),
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
                                        surah!.number.toString(),
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
                            top: 68.0, bottom: 16.0, right: 40.0, left: 40.0)),
                    child: AnimatedBuilder(
                        animation: quranTextController.animationController,
                        builder: (BuildContext context, Widget? child) {
                          if (quranTextController.scrollController.hasClients) {
                            quranTextController.scrollController.jumpTo(
                                quranTextController.animationController.value *
                                    (quranTextController.scrollController
                                        .position.maxScrollExtent));
                          }
                          return ScrollableList(
                            surah: surah,
                            nomPageF: nomPageF!,
                            nomPageL: nomPageL!,
                          );
                        }),
                  ),
                ),
                Spring.slide(
                    springController: springController,
                    slideType: SlideType.slide_in_left,
                    delay: const Duration(milliseconds: 0),
                    animDuration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    extend: -500,
                    withFade: false,
                    child: AudioTextWidget()),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: TextSliding(
                      myWidget1: ShowTextTafseer(),
                      cHeight: 110.0,
                    )),
              ],
            ),
          )),
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
