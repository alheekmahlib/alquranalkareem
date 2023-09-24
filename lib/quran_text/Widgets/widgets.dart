import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../l10n/app_localizations.dart';
import '../../quran_page/data/model/ayat.dart';
import '../../services_locator.dart';
import '../../shared/controller/quranText_controller.dart';
import '../../shared/controller/translate_controller.dart';
import '../../shared/services/controllers_put.dart';
import '../../shared/share/ayah_to_images.dart';
import '../../shared/utils/constants/lists.dart';
import '../../shared/utils/constants/lottie.dart';
import '../../shared/utils/constants/shared_preferences_constants.dart';
import '../../shared/widgets/widgets.dart';

ArabicNumbers arabicNumber = ArabicNumbers();

menu(BuildContext context, int b, index, translateData, widget, nomPageF,
    nomPageL,
    {var details}) {
  bool? selectedValue;
  if (quranTextController.value == 1) {
    selectedValue = true;
  } else if (quranTextController.value == 0) {
    selectedValue = false;
  }

  quranTextController.selected.value == selectedValue!
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
                                  quranTextController.selected.value =
                                      !quranTextController.selected.value;
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
                        quranTextController.selected.value =
                            !quranTextController.selected.value;
                        quranTextController
                            .addBookmarkText(
                                widget.name!,
                                widget.number!,
                                index == 0 ? index + 1 : index + 2,
                                // widget.surah!.ayahs![b].page,
                                nomPageF,
                                nomPageL,
                                generalController.timeNow.lastRead)
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
                        quranTextController.selected.value =
                            !quranTextController.selected.value;
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
                        generalController.textWidgetPosition.value = 0.0;
                        quranTextController.selected.value =
                            !quranTextController.selected.value;
                        // generalController.sliderIsShow();
                        // springController.play(motion: Motion.play);
                        // switch (quranTextController.controller.status) {
                        //   case AnimationStatus.dismissed:
                        //     quranTextController.controller.forward();
                        //     break;
                        //   case AnimationStatus.completed:
                        //     quranTextController.controller.reverse();
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
                      icon: const Icon(
                        Icons.share_outlined,
                        size: 23,
                        color: Color(0x99f5410a),
                      ),
                      onPressed: () {
                        generalController.shareTafseerValue.value = 2;
                        quranTextController.selected.value =
                            !quranTextController.selected.value;
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

singleAyahMenu(BuildContext context, int b, index, translateData, widget,
    nomPageF, nomPageL,
    {var details}) {
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
          child: FutureBuilder<List<Ayat>>(
              future: ayatController
                  .handleRadioValueChanged(ayatController.radioValue)
                  .getAyahTranslate(widget.number),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
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
                        quranTextController.selected.value =
                            !quranTextController.selected.value;
                        ayatController.updateText(
                            "${aya.ayatext}", "${aya.translate}");
                        if (SlidingUpPanelStatus.hidden ==
                            generalController.panelTextController.status) {
                          generalController.panelTextController.expand();
                        } else {
                          generalController.panelTextController.hide();
                        }
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
              quranTextController.selected.value =
                  !quranTextController.selected.value;
              quranTextController
                  .addBookmarkText(
                      widget.name!,
                      widget.number!,
                      index == 0 ? index + 1 : index + 2,
                      // widget.surah!.ayahs![b].page,
                      nomPageF,
                      nomPageL,
                      generalController.timeNow.lastRead)
                  .then((value) => customSnackBar(
                      context, AppLocalizations.of(context)!.addBookmark));
              print(widget.name!);
              print(widget.number!);
              print(nomPageF);
              print(nomPageL);
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
              quranTextController.selected.value =
                  !quranTextController.selected.value;
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
            icon: const Icon(
              Icons.play_arrow_outlined,
              size: 24,
              color: Color(0x99f5410a),
            ),
            onPressed: () {
              ayatController.ayahTextNumber.value = (index + 1).toString();
              print(
                  'ayatController.ayahTextNumber.value ${ayatController.ayahTextNumber.value}');
              ayatController.sorahTextNumber.value = widget.number!.toString();
              generalController.textWidgetPosition.value = 0.0;
              quranTextController.selected.value =
                  !quranTextController.selected.value;
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
              generalController.shareTafseerValue.value = 2;
              quranTextController.selected.value =
                  !quranTextController.selected.value;
              ayatController.translateIndex =
                  translateController.transValue.value;
              final verseNumber = widget.ayahs![b].number!;
              final translation = translateData?[verseNumber - 1]['text'];
              showVerseOptionsBottomSheet(context, verseNumber, widget.number,
                  "${widget.ayahs![b].text}", translation ?? '', widget.name);
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
          await pref.saveInteger(SWITCH_VALUE, i);
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
  return Icon(
    data,
    size: 20,
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
                AppLocalizations.of(context)!.translation,
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
              itemCount: translateName.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Container(
                      child: Obx(
                        () => ListTile(
                          title: Text(
                            translateName[index],
                            style: TextStyle(
                                color: translateController.transValue.value ==
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
                          onTap: () async {
                            translateController.transValue.value == index;
                            await pref.saveInteger(TRANSLATE_VALUE, index);
                            sl<TranslateDataController>()
                                .translateHandleRadioValueChanged(index);
                            sl<TranslateDataController>().fetchSura(context);
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
                                opacity: translateController.transValue.value ==
                                        index
                                    ? 1
                                    : .4,
                                child: SvgPicture.asset(
                                  'assets/svg/tafseer_book.svg',
                                ),
                              )),
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
