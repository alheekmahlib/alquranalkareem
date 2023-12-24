import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../../../core/services/l10n/app_localizations.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../../core/utils/constants/shared_pref_services.dart';
import '../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../../../core/utils/constants/svg_picture.dart';
import '../../../../core/widgets/share/ayah_to_images.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../presentation/controllers/share_controller.dart';
import '../../../controllers/ayat_controller.dart';
import '../../../controllers/general_controller.dart';
import 'ayah_tafseer_list.dart';

String? surahName;

class ShowTafseer extends StatelessWidget {
  ShowTafseer({Key? key}) : super(key: key);

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 50,
                      // width: 250,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Theme.of(context).dividerColor.withOpacity(.2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).dividerColor.withOpacity(.4),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  child: Semantics(
                                    button: true,
                                    enabled: true,
                                    label:
                                        AppLocalizations.of(context)!.tafseer,
                                    child: Icon(Icons.book,
                                        size: 24,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface),
                                  ),
                                  onTap: () => tafseerDropDown(context),
                                ),
                                const Gap(8),
                                SizedBox(
                                    width: 30,
                                    child: fontSizeDropDown(context)),
                                const Gap(8),
                                GestureDetector(
                                  child: Semantics(
                                    button: true,
                                    enabled: true,
                                    label: AppLocalizations.of(context)!.copy,
                                    child: Icon(
                                      Icons.copy_outlined,
                                      size: 24,
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                    ),
                                  ),
                                  onTap: () async {
                                    if (sl<AyatController>().ayahNumber.value ==
                                        -1) {
                                      customErrorSnackBar(
                                          context,
                                          AppLocalizations.of(context)!
                                              .choiceAyah);
                                    } else {
                                      await Clipboard.setData(ClipboardData(
                                              text:
                                                  '﴿${sl<AyatController>().currentText.value!.translateAyah}﴾\n\n${sl<AyatController>().currentText.value!.translate}'))
                                          .then((value) => customSnackBar(
                                              context,
                                              AppLocalizations.of(context)!
                                                  .copyTafseer));
                                    }
                                  },
                                ),
                                const Gap(8),
                                GestureDetector(
                                  child: Semantics(
                                    button: true,
                                    enabled: true,
                                    label: AppLocalizations.of(context)!.copy,
                                    child: Icon(
                                      Icons.share_outlined,
                                      size: 24,
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                    ),
                                  ),
                                  onTap: () {
                                    sl<GeneralController>()
                                        .shareTafseerValue
                                        .value = 1;
                                    if (sl<AyatController>().ayahNumber.value ==
                                        -1) {
                                      customErrorSnackBar(
                                          context,
                                          AppLocalizations.of(context)!
                                              .choiceAyah);
                                    } else {
                                      sl<ShareController>().changeTafseer(
                                          context,
                                          sl<AyatController>()
                                              .ayahUQNumber
                                              .value,
                                          sl<AyatController>()
                                              .surahNumber
                                              .value,
                                          sl<AyatController>()
                                              .ayahNumber
                                              .value);
                                      showVerseOptionsBottomSheet(
                                          context,
                                          sl<AyatController>().ayahNumber.value,
                                          sl<AyatController>()
                                              .ayahUQNumber
                                              .value,
                                          sl<AyatController>()
                                              .surahNumber
                                              .value,
                                          sl<AyatController>()
                                              .currentText
                                              .value!
                                              .translateAyah,
                                          sl<AyatController>()
                                              .currentText
                                              .value!
                                              .translate,
                                          surahName!);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gap(8),
                  Expanded(
                      flex: 7,
                      child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .dividerColor
                                  .withOpacity(.2),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8))),
                          child: AyahTafseerList(
                            svgHeight: 35.0,
                            svgWidth: 35.0,
                          ))),
                ],
              ),
            ),
            Flexible(
              flex: 4,
              child: Container(
                height: MediaQuery.sizeOf(context).height / 1 / 2 * 1.3,
                width: MediaQuery.sizeOf(context).width,
                color: Theme.of(context).colorScheme.background,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.sizeOf(context).height,
                    ),
                    child: Scrollbar(
                      controller: _scrollController,
                      child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Obx(() {
                            if (sl<AyatController>().currentPageLoading.value) {
                              return loadingLottie(150.0, 150.0);
                            } else if (sl<AyatController>().currentText.value !=
                                null) {
                              allText = sl<AyatController>()
                                      .currentText
                                      .value!
                                      .translateAyah +
                                  sl<AyatController>()
                                      .currentText
                                      .value!
                                      .translate;
                              allTitle = sl<AyatController>()
                                  .currentText
                                  .value!
                                  .translateAyah;
                              return SelectableText.rich(
                                TextSpan(
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text:
                                          '﴿${sl<AyatController>().currentText.value!.translateAyah}﴾\n\n',
                                      style: TextStyle(
                                          color: ThemeProvider.themeOf(context)
                                                      .id ==
                                                  'dark'
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w100,
                                          height: 1.5,
                                          fontFamily: 'uthmanic2',
                                          fontSize: sl<GeneralController>()
                                              .fontSizeArabic
                                              .value),
                                    ),
                                    WidgetSpan(
                                      child: Center(
                                        child: spaceLine(
                                            25,
                                            MediaQuery.sizeOf(context).width /
                                                1 /
                                                2),
                                      ),
                                    ),
                                    TextSpan(
                                      text: sl<AyatController>()
                                          .currentText
                                          .value!
                                          .translate,
                                      style: TextStyle(
                                          color: ThemeProvider.themeOf(context)
                                                      .id ==
                                                  'dark'
                                              ? Colors.white
                                              : Colors.black,
                                          height: 1.5,
                                          fontSize: sl<GeneralController>()
                                              .fontSizeArabic
                                              .value),
                                    ),
                                    WidgetSpan(
                                      child: Center(
                                        child: spaceLine(
                                            25,
                                            MediaQuery.sizeOf(context).width /
                                                1 /
                                                2),
                                      ),
                                    ),
                                  ],
                                ),
                                showCursor: true,
                                cursorWidth: 3,
                                cursorColor: Theme.of(context).dividerColor,
                                cursorRadius: const Radius.circular(5),
                                scrollPhysics: const ClampingScrollPhysics(),
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.justify,
                                contextMenuBuilder: buildMyContextMenu(),
                                onSelectionChanged: handleSelectionChanged,
                              );
                            } else {
                              return hand(300.0, 300.0);
                            }
                          })),
                    ),
                  ),
                ),
              ),
            ),
            const Divider(
              height: 0,
            )
          ],
        ),
      ),
    );
  }

  tafseerDropDown(BuildContext context) {
    List tafseerInfo = [
      {
        'name': '${AppLocalizations.of(context)!.tafIbnkatheerN}',
        'bookName': '${AppLocalizations.of(context)!.tafIbnkatheerD}',
        'dbName': 'ibnkatheer',
      },
      {
        'name': '${AppLocalizations.of(context)!.tafBaghawyN}',
        'bookName': '${AppLocalizations.of(context)!.tafBaghawyD}',
        'dbName': 'baghawy',
      },
      {
        'name': '${AppLocalizations.of(context)!.tafQurtubiN}',
        'bookName': '${AppLocalizations.of(context)!.tafQurtubiD}',
        'dbName': 'qurtubi',
      },
      {
        'name': '${AppLocalizations.of(context)!.tafSaadiN}',
        'bookName': '${AppLocalizations.of(context)!.tafSaadiD}',
        'dbName': 'saadi',
      },
      {
        'name': '${AppLocalizations.of(context)!.tafTabariN}',
        'bookName': '${AppLocalizations.of(context)!.tafTabariD}',
        'dbName': 'tabari',
      },
    ];
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
                  child: SvgPicture.asset(
                    'assets/svg/tafseer.svg',
                    height: 50,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 90.0),
              child: ListView.builder(
                itemCount: tafseerInfo.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                        child: ListTile(
                          title: Text(
                            tafseerInfo[index]['name'],
                            style: TextStyle(
                                color: sl<AyatController>().radioValue.value ==
                                        index
                                    ? Theme.of(context).primaryColorLight
                                    : const Color(0xffcdba72),
                                fontSize: 14,
                                fontFamily: 'kufi'),
                          ),
                          subtitle: Text(
                            tafseerInfo[index]['bookName'],
                            style: TextStyle(
                                color: sl<AyatController>().radioValue.value ==
                                        index
                                    ? Theme.of(context).primaryColorLight
                                    : const Color(0xffcdba72),
                                fontSize: 12,
                                fontFamily: 'kufi'),
                          ),
                          trailing: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(2.0)),
                              border: Border.all(
                                  color:
                                      sl<AyatController>().radioValue.value ==
                                              index
                                          ? Theme.of(context).primaryColorLight
                                          : const Color(0xffcdba72),
                                  width: 2),
                              color: const Color(0xff39412a),
                            ),
                            child:
                                sl<AyatController>().radioValue.value == index
                                    ? const Icon(Icons.done,
                                        size: 14, color: Color(0xfffcbb76))
                                    : null,
                          ),
                          onTap: () async {
                            // TafseerDataBaseClient.getTableName(
                            //     tafseerInfo[index]['dbName']);
                            await sl<SharedPrefServices>()
                                .saveInteger(TAFSEER_VAL, index);
                            sl<AyatController>().handleRadioValueChanged(index);
                            sl<AyatController>().getNewTranslationAndNotify(
                                sl<AyatController>().surahNumber.value,
                                sl<AyatController>().ayahNumber.value);
                            sl<AyatController>().fetchTafseerPage(
                                sl<GeneralController>().currentPage.value);
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
                                opacity:
                                    sl<AyatController>().radioValue.value ==
                                            index
                                        ? 1
                                        : .4,
                                child: SvgPicture.asset(
                                  'assets/svg/tafseer_book.svg',
                                ),
                              )),
                        ),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                            border: Border.all(
                                color: Theme.of(context).dividerColor,
                                width: 1)),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 4.0),
                      ),
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
}

String allText = '';
String allTitle = '';
String? selectedTextED;

// void handleSelectionChanged(
//     TextSelection selection, SelectionChangedCause? cause) {
//   if (cause == SelectionChangedCause.longPress) {
//     final characters = allText.characters;
//     final start = characters.take(selection.start).length;
//     final end = characters.take(selection.end).length;
//
//     final adjustedStart = start > 0 ? start - 1 : start;
//     final adjustedEnd = end > 0 ? end - 1 : end;
//
//     final selectedText = allText.substring(adjustedStart, adjustedEnd);
//
//     selectedTextED = selectedText;
//     print("selectedText: $selectedText");
//   }
// }

void handleSelectionChanged(
    TextSelection selection, SelectionChangedCause? cause) {
  if (cause == SelectionChangedCause.longPress) {
    final characters = allText.characters;
    final start = characters.take(selection.start).length;
    final end = characters.take(selection.end).length;
    final selectedText = allText.substring(start - 5, end - 5);

    // setState(() {
    selectedTextED = selectedText;
    // });
    print(selectedText);
  }
}
