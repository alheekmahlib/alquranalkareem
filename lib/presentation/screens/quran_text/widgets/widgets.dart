import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/presentation/screens/quran_text/data/models/QuranModel.dart';
import '../../../../core/services/l10n/app_localizations.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lists.dart';
import '../../../../core/utils/constants/shared_pref_services.dart';
import '../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../../../core/widgets/share/ayah_to_images.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/audio_controller.dart';
import '../../../controllers/ayat_controller.dart';
import '../../../controllers/bookmarksText_controller.dart';
import '../../../controllers/general_controller.dart';
import '../../../controllers/quranText_controller.dart';
import '../../../controllers/translate_controller.dart';

ArabicNumbers arabicNumber = ArabicNumbers();

menu(BuildContext context, int b, int index, translateData, SurahText widget,
    nomPageF, nomPageL,
    {var details}) {
  bool? selectedValue;
  if (sl<QuranTextController>().value == 1) {
    selectedValue = true;
  } else if (sl<QuranTextController>().value == 0) {
    selectedValue = false;
  }
  sl<AyatController>()
      .fetchTafseerPage(sl<GeneralController>().currentPage.value);
  sl<AyatController>().fetchAyatPage(sl<GeneralController>().currentPage.value);
  sl<QuranTextController>().selected.value == selectedValue!
      ? BotToast.showAttachedWidget(
          target: details.globalPosition,
          verticalOffset: sl<QuranTextController>().verticalOffset,
          horizontalOffset: sl<QuranTextController>().horizontalOffset,
          preferDirection: sl<QuranTextController>().preferDirection,
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
                    child: IconButton(
                      icon: Semantics(
                        button: true,
                        enabled: true,
                        label: 'Show Tafseer',
                        child: const Icon(
                          Icons.text_snippet_outlined,
                          size: 24,
                          color: Color(0x99f5410a),
                        ),
                      ),
                      onPressed: () {
                        sl<AyatController>().tafseerAyah =
                            widget.ayahs![b].text!;
                        sl<AyatController>().numberOfAyahText.value =
                            widget.ayahs![b].numberInSurah!;
                        sl<AyatController>().surahNumber.value = widget.number!;
                        sl<AyatController>().ayahTextNumber.value =
                            widget.ayahs![b].numberInSurah.toString();
                        sl<QuranTextController>().selected.value =
                            !sl<QuranTextController>().selected.value;

                        if (SlidingUpPanelStatus.hidden ==
                            sl<GeneralController>()
                                .panelTextController
                                .status) {
                          sl<GeneralController>().panelTextController.expand();
                        } else {
                          sl<GeneralController>().panelTextController.hide();
                        }
                        cancel();
                      },
                    ),
                  ),
                  const Gap(8),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                        color: Color(0xfff3efdf),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: IconButton(
                      icon: Semantics(
                        button: true,
                        enabled: true,
                        label: 'Add Bookmark',
                        child: Icon(
                          sl<BookmarksTextController>()
                                  .hasBookmark(widget.number!,
                                      widget.ayahs![b].numberInSurah!)
                                  .value
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          size: 24,
                          color: const Color(0x99f5410a),
                        ),
                      ),
                      onPressed: () {
                        sl<QuranTextController>().selected.value =
                            !sl<QuranTextController>().selected.value;
                        if (sl<BookmarksTextController>()
                            .hasBookmark(
                                widget.number!, widget.ayahs![b].numberInSurah!)
                            .value) {
                          sl<BookmarksTextController>().deleteBookmarksText(
                              widget.ayahs![b].numberInSurah!, context);
                        } else {
                          sl<QuranTextController>()
                              .addBookmarkText(
                                  widget.name!,
                                  widget.number!,
                                  index == 0 ? index + 1 : index + 2,
                                  widget.ayahs![b].numberInSurah,
                                  // widget.surah!.ayahs![b].page,
                                  nomPageF,
                                  nomPageL,
                                  sl<GeneralController>().timeNow.lastRead)
                              .then((value) => customSnackBar(context,
                                  AppLocalizations.of(context)!.addBookmark));
                        }
                        // sl<QuranTextController>()
                        //     .addBookmarkText(
                        //         widget.name!,
                        //         widget.number!,
                        //         index == 0 ? index + 1 : index + 2,
                        //         widget.ayahs![b].numberInSurah,
                        //         // widget.surah!.ayahs![b].page,
                        //         nomPageF,
                        //         nomPageL,
                        //         sl<GeneralController>().timeNow.lastRead)
                        //     .then((value) => customSnackBar(context,
                        //         AppLocalizations.of(context)!.addBookmark));
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
                      icon: Semantics(
                        button: true,
                        enabled: true,
                        label: 'Copy Ayah',
                        child: const Icon(
                          Icons.copy_outlined,
                          size: 24,
                          color: Color(0x99f5410a),
                        ),
                      ),
                      onPressed: () async {
                        sl<QuranTextController>().selected.value =
                            !sl<QuranTextController>().selected.value;
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
                      icon: Semantics(
                        button: true,
                        enabled: true,
                        label: 'Play Ayah',
                        child: const Icon(
                          Icons.play_arrow_outlined,
                          size: 24,
                          color: Color(0x99f5410a),
                        ),
                      ),
                      onPressed: () {
                        sl<GeneralController>().textWidgetPosition.value = 0.0;
                        sl<QuranTextController>().selected.value =
                            !sl<QuranTextController>().selected.value;
                        // sl<GeneralController>().sliderIsShow();
                        // springController.play(motion: Motion.play);
                        // switch (sl<QuranTextController>().controller.status) {
                        //   case AnimationStatus.dismissed:
                        //     sl<QuranTextController>().controller.forward();
                        //     break;
                        //   case AnimationStatus.completed:
                        //     sl<QuranTextController>().controller.reverse();
                        //     break;
                        //   default:
                        // }
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
                      icon: Semantics(
                        button: true,
                        enabled: true,
                        label: 'Share Ayah',
                        child: const Icon(
                          Icons.share_outlined,
                          size: 23,
                          color: Color(0x99f5410a),
                        ),
                      ),
                      onPressed: () {
                        sl<GeneralController>().shareTafseerValue.value = 2;
                        sl<QuranTextController>().selected.value =
                            !sl<QuranTextController>().selected.value;
                        sl<AyatController>().getNewTranslationAndNotify(
                            int.parse(
                                sl<AyatController>().surahTextNumber.value),
                            int.parse(
                                sl<AyatController>().ayahTextNumber.value));
                        final verseNumber = widget.ayahs![b].number!;
                        final translation =
                            translateData?[verseNumber - 1]['text'];
                        showVerseOptionsBottomSheet(
                            context,
                            widget.ayahs![b].numberInSurah!,
                            widget.ayahs![b].number!,
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

singleAyahMenu(BuildContext context, int b, index, translateData, widget,
    nomPageF, nomPageL,
    {var details}) {
  // sl<AyatController>().fetchAyat(sl<GeneralController>().currentPage.value);
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: const BoxDecoration(
              color: Color(0xfff3efdf),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: IconButton(
            icon: Semantics(
              button: true,
              enabled: true,
              label: 'Show Tafseer',
              child: const Icon(
                Icons.text_snippet_outlined,
                size: 24,
                color: Color(0x99f5410a),
              ),
            ),
            onPressed: () {
              sl<AyatController>().ayahTextNumber.value =
                  (index + 1).toString();
              sl<AyatController>().tafseerAyah = widget.ayahs![index].text;
              sl<AyatController>().numberOfAyahText.value =
                  widget.ayahs![index].numberInSurah;
              sl<QuranTextController>().selected.value =
                  !sl<QuranTextController>().selected.value;
              sl<AyatController>().surahNumber.value = widget.number!;
              // sl<AyatController>().ayahNumber.value = aya.pageNum!;
              // sl<AyatController>().ayahUQNumber.value = aya.ayaId!;
              // sl<AyatController>().updateText(
              //     "${aya.ayatext}", "${aya.translate}");
              if (SlidingUpPanelStatus.hidden ==
                  sl<GeneralController>().panelTextController.status) {
                sl<GeneralController>().panelTextController.expand();
              } else {
                sl<GeneralController>().panelTextController.hide();
              }
            },
          ),
          // child: Obx(() {
          //   final ayat = sl<AyatController>().ayatList;
          //   if (ayat != null && ayat.length > b) {
          //     Ayat aya = ayat[index];
          //     return IconButton(
          //       icon: Semantics(
          //         button: true,
          //         enabled: true,
          //         label: 'Show Tafseer',
          //         child: const Icon(
          //           Icons.text_snippet_outlined,
          //           size: 24,
          //           color: Color(0x99f5410a),
          //         ),
          //       ),
          //       onPressed: () {
          //         sl<AyatController>().ayahTextNumber.value = (index + 1).toString();
          //         sl<AyatController>().numberOfAyahText.value = index + 1;
          //         sl<QuranTextController>().selected.value =
          //             !sl<QuranTextController>().selected.value;
          //         // sl<AyatController>().surahNumber.value,
          //         sl<AyatController>().ayahNumber.value = aya.pageNum!;
          //         // sl<AyatController>().ayahUQNumber.value = aya.ayaId!;
          //         // sl<AyatController>().updateText(
          //         //     "${aya.ayatext}", "${aya.translate}");
          //         if (SlidingUpPanelStatus.hidden ==
          //             sl<GeneralController>().panelTextController.status) {
          //           sl<GeneralController>().panelTextController.expand();
          //         } else {
          //           sl<GeneralController>().panelTextController.hide();
          //         }
          //       },
          //     );
          //   } else {
          //     // handle the case where the index is out of range
          //     print('Ayat is $ayat');
          //     print('Index is $b');
          //     return const Text(
          //         'Ayat not found'); // Or another widget to indicate an error or empty state.
          //   }
          // }),
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
          child: Obx(
            () => IconButton(
              icon: Semantics(
                button: true,
                enabled: true,
                label: 'Add Bookmark',
                child: Icon(
                  sl<BookmarksTextController>()
                          .hasBookmark(widget.number!,
                              widget.ayahs![index].numberInSurah!)
                          .value
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                  size: 24,
                  color: const Color(0x99f5410a),
                ),
              ),
              onPressed: () {
                sl<QuranTextController>().selected.value =
                    !sl<QuranTextController>().selected.value;
                if (sl<BookmarksTextController>()
                    .hasBookmark(
                        widget.number!, widget.ayahs![index].numberInSurah!)
                    .value) {
                  sl<BookmarksTextController>().deleteBookmarksText(
                      widget.ayahs![index].numberInSurah!, context);
                } else {
                  sl<QuranTextController>()
                      .addBookmarkText(
                          widget.name!,
                          widget.number!,
                          index == 0 ? index + 1 : index + 2,
                          widget.ayahs![b].numberInSurah,
                          // widget.surah!.ayahs![b].page,
                          nomPageF,
                          nomPageL,
                          sl<GeneralController>().timeNow.lastRead)
                      .then((value) => customSnackBar(
                          context, AppLocalizations.of(context)!.addBookmark));
                }
                print(widget.name!);
                print(widget.number!);
                print(nomPageF);
                print(nomPageL);
              },
            ),
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
            icon: Semantics(
              button: true,
              enabled: true,
              label: 'Copy Ayah',
              child: const Icon(
                Icons.copy_outlined,
                size: 24,
                color: Color(0x99f5410a),
              ),
            ),
            onPressed: () async {
              sl<QuranTextController>().selected.value =
                  !sl<QuranTextController>().selected.value;
              await Clipboard.setData(ClipboardData(
                      text:
                          '﴿${widget.ayahs![b].text}﴾ [${widget.name}-${arabicNumber.convert(widget.ayahs![b].numberInSurah.toString())}]'))
                  .then((value) => customSnackBar(
                      context, AppLocalizations.of(context)!.copyAyah));
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
            icon: Semantics(
              button: true,
              enabled: true,
              label: 'Play Ayah',
              child: const Icon(
                Icons.play_arrow_outlined,
                size: 24,
                color: Color(0x99f5410a),
              ),
            ),
            onPressed: () {
              sl<AyatController>().ayahTextNumber.value =
                  (index + 1).toString();
              print(
                  'sl<AyatController>().ayahTextNumber.value ${sl<AyatController>().ayahTextNumber.value}');
              sl<AyatController>().surahTextNumber.value =
                  widget.number!.toString();
              sl<GeneralController>().textWidgetPosition.value = 0.0;
              sl<QuranTextController>().selected.value =
                  !sl<QuranTextController>().selected.value;
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
            icon: Semantics(
              button: true,
              enabled: true,
              label: 'Share Ayah',
              child: const Icon(
                Icons.share_outlined,
                size: 23,
                color: Color(0x99f5410a),
              ),
            ),
            onPressed: () {
              sl<GeneralController>().shareTafseerValue.value = 2;
              sl<QuranTextController>().selected.value =
                  !sl<QuranTextController>().selected.value;
              sl<AyatController>().getNewTranslationAndNotify(
                  widget.number!, widget.ayahs![b].numberInSurah!);
              final verseNumber = widget.ayahs![b].number!;
              final translation = translateData?[verseNumber - 1]['text'];
              showVerseOptionsBottomSheet(
                  context,
                  widget.ayahs![b].numberInSurah!,
                  verseNumber,
                  widget.number,
                  "${widget.ayahs![b].text}",
                  translation ?? '',
                  widget.name);
              print("Verse Number: $verseNumber");
              print("Translation: $translation");
            },
          ),
        ),
      ],
    ),
  );
}

Widget animatedToggleSwitch(BuildContext context) {
  return GetX<QuranTextController>(
    builder: (controller) {
      return AnimatedToggleSwitch<int>.rolling(
        current: controller.value.value,
        values: const [0, 1],
        onChanged: (i) async {
          controller.value.value = i;
          await sl<SharedPrefServices>().saveInteger(SWITCH_VALUE, i);
          sl<AudioController>().cancelDownload();
          sl<GeneralController>().textWidgetPosition.value = -240.0;
          controller.selected.value = false;
          controller.update();
        },
        iconBuilder: rollingIconBuilder,
        borderWidth: 1,
        style: ToggleStyle(
          indicatorColor: Theme.of(context).colorScheme.surface,
          backgroundColor: Theme.of(context).canvasColor,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          // dif: 2.0,
          borderColor: Theme.of(context).colorScheme.surface,
        ),
        height: 25,
      );
    },
  );
}

Widget rollingIconBuilder(int value, bool foreground) {
  IconData data = Icons.textsms_outlined;
  if (value.isEven) data = Icons.text_snippet_outlined;
  return Semantics(
    button: true,
    enabled: true,
    label:
        'Changing from presenting the Qur’an in the form of pages and in the form of verses',
    child: Icon(
      data,
      size: 20,
      color: const Color(0xff161f07),
    ),
  );
}

translateDropDown(BuildContext context) {
  dropDownModalBottomSheet(
    context,
    MediaQuery.sizeOf(context).height / 1 / 2,
    MediaQuery.sizeOf(context).width,
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
                child: Semantics(
                  button: true,
                  enabled: true,
                  label: 'Close',
                  child: Icon(
                    Icons.close_outlined,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Semantics(
                button: true,
                enabled: true,
                label: 'Translate',
                child: Text(
                  AppLocalizations.of(context)!.translation,
                  style: TextStyle(
                      color: Theme.of(context).dividerColor,
                      fontSize: 22,
                      fontFamily: "kufi"),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: ListView.builder(
              itemCount: translateName.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Container(
                      child: Obx(
                        () => Semantics(
                          button: true,
                          enabled: true,
                          excludeSemantics: true,
                          label: semanticsTranslateName[index],
                          child: ListTile(
                            title: Text(
                              translateName[index],
                              style: TextStyle(
                                  color: sl<TranslateDataController>()
                                              .transValue
                                              .value ==
                                          index
                                      ? Theme.of(context).primaryColorLight
                                      : const Color(0xffcdba72),
                                  fontSize: 14,
                                  fontFamily: "kufi"),
                            ),
                            trailing: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(2.0)),
                                border: Border.all(
                                    color: sl<TranslateDataController>()
                                                .transValue
                                                .value ==
                                            index
                                        ? Theme.of(context).primaryColorLight
                                        : const Color(0xffcdba72),
                                    width: 2),
                                color: const Color(0xff39412a),
                              ),
                              child: sl<TranslateDataController>()
                                          .transValue
                                          .value ==
                                      index
                                  ? const Icon(Icons.done,
                                      size: 14, color: Color(0xffcdba72))
                                  : null,
                            ),
                            onTap: () async {
                              sl<TranslateDataController>().transValue.value ==
                                  index;
                              await sl<SharedPrefServices>()
                                  .saveInteger(TRANSLATE_VALUE, index);
                              sl<TranslateDataController>()
                                  .translateHandleRadioValueChanged(index);
                              sl<TranslateDataController>()
                                  .fetchTranslate(context);
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
                                child: Opacity(
                                  opacity: sl<TranslateDataController>()
                                              .transValue
                                              .value ==
                                          index
                                      ? 1
                                      : .4,
                                  child: SvgPicture.asset(
                                    'assets/svg/tafseer_book.svg',
                                  ),
                                )),
                          ),
                        ),
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
      '| ${sl<GeneralController>().greeting.value} |',
      style: TextStyle(
        fontSize: 16.0,
        fontFamily: 'kufi',
        color: Theme.of(context).colorScheme.surface,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

Widget buttonContainer(BuildContext context, Widget myWidget) {
  return Container(
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Theme.of(context).dividerColor.withOpacity(.2),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            color: Theme.of(context).dividerColor.withOpacity(.4),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: myWidget,
      ));
}
