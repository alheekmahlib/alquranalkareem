import 'package:alquranalkareem/notes/cubit/note_cubit.dart';
import 'package:alquranalkareem/quran_text/Widgets/text_overflow_detector.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../l10n/app_localizations.dart';
import '../../quran_page/data/model/ayat.dart';
import '../../shared/controller/ayat_controller.dart';
import '../../shared/controller/general_controller.dart';
import '../../shared/controller/quranText_controller.dart';
import '../../shared/controller/translate_controller.dart';
import '../../shared/share/ayah_to_images.dart';
import '../../shared/widgets/lottie.dart';
import '../../shared/widgets/show_tafseer.dart';
import '../../shared/widgets/svg_picture.dart';
import '../../shared/widgets/widgets.dart';
import '../text_page_view.dart';

ArabicNumbers arabicNumber = ArabicNumbers();
late final AyatController ayatController = Get.put(AyatController());
late final GeneralController generalController = Get.put(GeneralController());
late final TranslateDataController translateController =
    Get.put(TranslateDataController());
late final QuranTextController quranTextController =
    Get.put(QuranTextController());

menu(BuildContext context, int b, index, var details, translateData, widget,
    nomPageF, nomPageL) {
  bool? selectedValue;
  if (quranTextController.value == 1) {
    selectedValue = true;
  } else if (quranTextController.value == 0) {
    selectedValue = false;
  }

  quranTextController.selected == selectedValue!
      ? BotToast.showAttachedWidget(
          target: details.globalPosition,
          verticalOffset: quranTextController.verticalOffset,
          horizontalOffset: quranTextController.horizontalOffset,
          preferDirection: quranTextController.preferDirection,
          animationDuration: const Duration(microseconds: 700),
          animationReverseDuration: const Duration(microseconds: 700),
          attachedBuilder: (cancel) => Card(
            color: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                        color: Color(0xfff3efdf),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: FutureBuilder<List<Ayat>>(
                        future: ayatController
                            .handleRadioValueChanged(ayatController.radioValue)
                            .getAyahTranslate(widget.number),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            List<Ayat>? ayat = snapshot.data;
                            if (ayat != null && ayat.length > b) {
                              Ayat aya = ayat[b];
                              return IconButton(
                                icon: const Icon(
                                  Icons.text_snippet_outlined,
                                  size: 24,
                                  color: Color(0x99f5410a),
                                ),
                                onPressed: () {
                                  quranTextController.selected =
                                      !quranTextController.selected;
                                  ayatController.updateText(
                                      "${aya.ayatext}", "${aya.translate}");
                                  if (SlidingUpPanelStatus.hidden ==
                                      generalController
                                          .panelTextController.status) {
                                    generalController.panelTextController
                                        .expand();
                                  } else {
                                    generalController.panelTextController
                                        .hide();
                                  }
                                  cancel();
                                },
                              );
                            } else {
                              // handle the case where the index is out of range
                              print('Ayat is $ayat');
                              print('Index is $b');
                              return const Text(
                                  'Ayat not found'); // Or another widget to indicate an error or empty state.
                            }
                          } else {
                            return Center(
                              child: search(100.0, 40.0),
                            );
                          }
                        }),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                        color: Color(0xfff3efdf),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: IconButton(
                      icon: const Icon(
                        Icons.bookmark_border,
                        size: 24,
                        color: Color(0x99f5410a),
                      ),
                      onPressed: () {
                        quranTextController.selected =
                            !quranTextController.selected;
                        quranTextController
                            .addBookmarkText(
                                widget.name!,
                                widget.number!,
                                index == 0 ? index + 1 : index + 2,
                                // widget.surah!.ayahs![b].page,
                                nomPageF,
                                nomPageL,
                                quranTextController.lastRead)
                            .then((value) => customSnackBar(context,
                                AppLocalizations.of(context)!.addBookmark));
                        print(widget.name!);
                        print(widget.number!);
                        print(nomPageF);
                        print(nomPageL);
                        cancel();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                        color: Color(0xfff3efdf),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: IconButton(
                      icon: const Icon(
                        Icons.copy_outlined,
                        size: 24,
                        color: Color(0x99f5410a),
                      ),
                      onPressed: () async {
                        quranTextController.selected =
                            !quranTextController.selected;
                        await Clipboard.setData(ClipboardData(
                                text:
                                    '﴿${widget.ayahs![b].text}﴾ [${widget.name}-${arabicNumber.convert(widget.ayahs![b].numberInSurah.toString())}]'))
                            .then((value) => customSnackBar(context,
                                AppLocalizations.of(context)!.copyAyah));
                        cancel();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                        color: Color(0xfff3efdf),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: IconButton(
                      icon: const Icon(
                        Icons.play_arrow_outlined,
                        size: 24,
                        color: Color(0x99f5410a),
                      ),
                      onPressed: () {
                        quranTextController.selected =
                            !quranTextController.selected;
                        switch (quranTextController.controller.status) {
                          case AnimationStatus.dismissed:
                            quranTextController.controller.forward();
                            break;
                          case AnimationStatus.completed:
                            quranTextController.controller.reverse();
                            break;
                          default:
                        }
                        cancel();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                        color: Color(0xfff3efdf),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: IconButton(
                      icon: const Icon(
                        Icons.share_outlined,
                        size: 23,
                        color: Color(0x99f5410a),
                      ),
                      onPressed: () {
                        quranTextController.selected =
                            !quranTextController.selected;
                        ayatController.translateIndex =
                            translateController.transValue.value;
                        final verseNumber = widget.ayahs![b].number!;
                        final translation =
                            translateData?[verseNumber - 1]['text'];
                        showVerseOptionsBottomSheet(
                            context,
                            verseNumber,
                            widget.number,
                            "${widget.ayahs![b].text}",
                            translation ?? '',
                            widget.name);
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
        )
      : null;
}

Widget animatedToggleSwitch(BuildContext context) {
  return GetX<QuranTextController>(
    builder: (controller) {
      return AnimatedToggleSwitch<int>.rolling(
        current: controller.value.value,
        values: const [0, 1],
        onChanged: (i) {
          controller.value.value = i;
          controller.saveSwitchValue(i);
        },
        iconBuilder: rollingIconBuilder,
        borderWidth: 1,
        indicatorColor: Theme.of(context).colorScheme.surface,
        innerColor: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        height: 25,
        dif: 2.0,
        borderColor: Theme.of(context).colorScheme.surface,
      );
    },
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

translateDropDown(BuildContext context) {
  List<String> transName = <String>['English', 'Spanish', 'bengali', 'Urdu'];
  dropDownModalBottomSheet(
    context,
    MediaQuery.of(context).size.height / 1 / 2,
    MediaQuery.of(context).size.width,
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                height: 30,
                width: 30,
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    border: Border.all(
                        width: 2, color: Theme.of(context).dividerColor)),
                child: Icon(
                  Icons.close_outlined,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Text(
                AppLocalizations.of(context)!.select_player,
                style: TextStyle(
                    color: Theme.of(context).dividerColor,
                    fontSize: 22,
                    fontFamily: "kufi"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: ListView.builder(
              itemCount: transName.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Container(
                      child: ListTile(
                        title: Text(
                          transName[index],
                          style: TextStyle(
                              color:
                                  translateController.transValue.value == index
                                      ? Theme.of(context).primaryColorLight
                                      : const Color(0xffcdba72),
                              fontSize: 14,
                              fontFamily: "kufi"),
                        ),
                        trailing: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(2.0)),
                            border: Border.all(
                                color: translateController.transValue.value ==
                                        index
                                    ? Theme.of(context).primaryColorLight
                                    : const Color(0xffcdba72),
                                width: 2),
                            color: const Color(0xff39412a),
                          ),
                          child: translateController.transValue.value == index
                              ? const Icon(Icons.done,
                                  size: 14, color: Color(0xffcdba72))
                              : null,
                        ),
                        onTap: () {
                          translateController.transValue.value == index;
                          translateController.saveTranslateValue(index);
                          translateController
                              .translateHandleRadioValueChanged(index);
                          translateController.fetchSura(context);
                          Navigator.pop(context);
                        },
                        leading: Container(
                            height: 85.0,
                            width: 41.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(4.0)),
                                border: Border.all(
                                    color: Theme.of(context).dividerColor,
                                    width: 2)),
                            child: SvgPicture.asset(
                              'assets/svg/tafseer_book.svg',
                              colorFilter:
                                  translateController.transValue.value == index
                                      ? null
                                      : ColorFilter.mode(
                                          Theme.of(context)
                                              .canvasColor
                                              .withOpacity(.4),
                                          BlendMode.lighten),
                            )),
                      ),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                          border: Border.all(
                              color: Theme.of(context).dividerColor, width: 1)),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 4.0),
                    ),
                    // const Divider(
                    //   endIndent: 16,
                    //   indent: 16,
                    //   height: 3,
                    // ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

Widget greeting(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Text(
      '| ${generalController.greeting.value} |',
      style: TextStyle(
        fontSize: 16.0,
        fontFamily: 'kufi',
        color: Theme.of(context).colorScheme.surface,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

Widget singleAyah(BuildContext context, var setState, widget, int index) {
  NotesCubit notesCubit = NotesCubit.get(context);
  Color backColor = Theme.of(context).colorScheme.surface.withOpacity(0.4);
  return Stack(
    children: [
      GestureDetector(
        onTap: () {
          quranTextController.controller.reverse();
          setState(() {
            backColor = Colors.transparent;
          });
        },
        // child: AutoScrollTag(
        //   key: ValueKey(index),
        //   controller: quranTextController.scrollController!,
        //   index: index,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.all(Radius.circular(4))),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: spaceLine(
                    20,
                    MediaQuery.of(context).size.width / 1 / 2,
                  ),
                ),
              ),
              widget.surah!.number == 9
                  ? const SizedBox.shrink()
                  : widget.surah!.ayahs![index].numberInSurah == 1
                      ? besmAllah(context)
                      : const SizedBox.shrink(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SelectableText.rich(
                  showCursor: true,
                  cursorWidth: 3,
                  cursorColor: Theme.of(context).dividerColor,
                  cursorRadius: const Radius.circular(5),
                  scrollPhysics: const ClampingScrollPhysics(),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.justify,
                  TextSpan(children: [
                    TextSpan(
                        text: widget.surah!.ayahs![index].text!,
                        style: TextStyle(
                          fontSize: generalController.fontSizeArabic.value,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'uthmanic2',
                          color: ThemeProvider.themeOf(context).id == 'dark'
                              ? Colors.white
                              : Colors.black,
                          background: Paint()
                            ..color = index == audioController.ayahSelected
                                ? quranTextController.selected
                                    ? backColor
                                    : Colors.transparent
                                : Colors.transparent
                            ..strokeJoin = StrokeJoin.round
                            ..strokeCap = StrokeCap.round
                            ..style = PaintingStyle.fill,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTapDown = (TapDownDetails details) {
                            setState(() {
                              quranTextController.selected =
                                  !quranTextController.selected;
                              lastAyahInPage =
                                  widget.surah!.ayahs![index].numberInSurah;
                              textSurahNum = widget.surah!.number;
                              backColor = Colors.transparent;
                              ayatController.sorahTextNumber =
                                  widget.surah!.number!.toString();
                              ayatController.ayahTextNumber = widget
                                  .surah!.ayahs![index].numberInSurah
                                  .toString();
                              audioController.ayahSelected = index;
                            });
                            menu(
                                context,
                                index,
                                index,
                                details,
                                translateController.data,
                                widget.surah,
                                widget.nomPageF,
                                widget.nomPageL);
                          }),
                    TextSpan(
                      text:
                          ' ${arabicNumber.convert(widget.surah!.ayahs![index].numberInSurah.toString())}',
                      style: TextStyle(
                        fontSize: generalController.fontSizeArabic.value + 5,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'uthmanic2',
                        color: ThemeProvider.themeOf(context).id == 'dark'
                            ? Theme.of(context).colorScheme.surface
                            : Theme.of(context).primaryColorLight,
                      ),
                    )
                  ]),
                  contextMenuBuilder: buildMyContextMenuText(notesCubit),
                  onSelectionChanged: handleSelectionChanged,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.translate_rounded,
                              color: Theme.of(context).colorScheme.surface,
                              size: 24,
                            ),
                            onPressed: () => translateDropDown(context),
                          )),
                      spaceLine(
                        20,
                        MediaQuery.of(context).size.width / 1 / 2,
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: juzNumEn(
                          'Part\n${widget.surah!.ayahs![index].juz}',
                          context,
                          ThemeProvider.themeOf(context).id == 'dark'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 16.0, right: 32.0, left: 32.0),
                child: Obx(
                  () {
                    if (translateController.isLoading.value) {
                      return search(50.0, 50.0);
                    }
                    return ReadMoreLess(
                      text: (widget.surah!.ayahs!.length > index &&
                              translateController.data.length >
                                  widget.surah!.ayahs![index].number - 1)
                          ? translateController.data[
                                      widget.surah!.ayahs![index].number - 1]
                                  ['text'] ??
                              ''
                          : '',
                      textStyle: TextStyle(
                        fontSize: generalController.fontSizeArabic.value - 10,
                        fontFamily: 'kufi',
                        color: ThemeProvider.themeOf(context).id == 'dark'
                            ? Colors.white
                            : Colors.black,
                      ),
                      textAlign: TextAlign.center,
                      readMoreText: AppLocalizations.of(context)!.readMore,
                      readLessText: AppLocalizations.of(context)!.readLess,
                      buttonTextStyle: TextStyle(
                        fontSize: 12,
                        fontFamily: 'kufi',
                        color: ThemeProvider.themeOf(context).id == 'dark'
                            ? Colors.white
                            : Theme.of(context).primaryColorLight,
                      ),
                      iconColor: ThemeProvider.themeOf(context).id == 'dark'
                          ? Colors.white
                          : Theme.of(context).primaryColorLight,
                    );
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
          padding: const EdgeInsets.all(20.0),
          child: juzNum(
              '${widget.surah!.ayahs![index].juz}',
              context,
              ThemeProvider.themeOf(context).id == 'dark'
                  ? Colors.white
                  : Colors.black,
              25),
        ),
      ),
    ],
  );
}

Widget pageAyah(BuildContext context, var setState, widget,
    List<InlineSpan> text, int index) {
  NotesCubit notesCubit = NotesCubit.get(context);
  return Stack(
    children: [
      GestureDetector(
        onTap: () {
          quranTextController.controller.reverse();
        },
        // child: AutoScrollTag(
        //   key: ValueKey(index),
        //   controller: quranTextController.scrollController!,
        //   index: index,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.all(Radius.circular(8))),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: spaceLine(
                    20,
                    MediaQuery.of(context).size.width / 1 / 2,
                  ),
                ),
              ),
              widget.surah!.number == 9
                  ? const SizedBox.shrink()
                  : widget.surah!.ayahs![index].numberInSurah == 1
                      ? besmAllah(context)
                      : const SizedBox.shrink(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SelectableText.rich(
                  showCursor: true,
                  cursorWidth: 3,
                  cursorColor: Theme.of(context).dividerColor,
                  cursorRadius: const Radius.circular(5),
                  scrollPhysics: const ClampingScrollPhysics(),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.justify,
                  TextSpan(
                    style: TextStyle(
                        fontSize: generalController.fontSizeArabic.value,
                        fontFamily: 'uthmanic2'),
                    children: text.map((e) {
                      return e;
                    }).toList(),
                  ),
                  contextMenuBuilder: buildMyContextMenuText(notesCubit),
                  onSelectionChanged: handleSelectionChangedText,
                ),
              ),
              Center(
                child: spaceLine(
                  20,
                  MediaQuery.of(context).size.width / 1 / 2,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: pageNumber(
                    arabicNumber.convert(widget.nomPageF! + index).toString(),
                    context,
                    Theme.of(context).primaryColor),
              ),
            ],
          ),
        ),
        // ),
      ),
      Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
          child: juzNum(
              '${quranTextController.juz}',
              context,
              ThemeProvider.themeOf(context).id == 'dark'
                  ? Colors.white
                  : Colors.black,
              25),
        ),
      )
    ],
  );
}
