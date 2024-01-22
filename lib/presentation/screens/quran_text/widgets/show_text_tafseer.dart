import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/shared_pref_services.dart';
import '../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/ayat_controller.dart';
import '../../../controllers/general_controller.dart';
import '../../quran_page/data/model/aya.dart';
import '../../quran_page/widgets/show_tafseer.dart';

class ShowTextTafseer extends StatelessWidget {
  ShowTextTafseer({Key? key}) : super(key: key);

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      sl<AyatController>().getNewTranslationAndNotify(
          sl<AyatController>().surahNumber.value,
          sl<AyatController>().numberOfAyahText.value);
      final ayat = sl<AyatController>().ayatList;
      if (ayat != null &&
          ayat.length > sl<AyatController>().numberOfAyahText.value) {
        Aya aya = ayat[sl<AyatController>().numberOfAyahText.value];
        // sl<AyatController>().updateText("${aya.text}", "${aya.translate}");
        print('numberOfAyahText${aya.ayaNum}');
      }
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: BoxDecoration(
              color: Get.theme.colorScheme.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              )),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                              color: Get.theme.colorScheme.surface, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff91a57d).withOpacity(.2),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: const Offset(
                                  -1, -1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Icon(Icons.book,
                            size: 24, color: Get.theme.colorScheme.surface),
                      ),
                      onTap: () {
                        if (SlidingUpPanelStatus.hidden ==
                            sl<GeneralController>()
                                .panelTextController
                                .status) {
                          sl<GeneralController>().panelTextController.expand();
                        } else {
                          sl<GeneralController>().panelTextController.hide();
                        }
                        tafseerDropDown(context);
                      },
                    ),
                    customTextClose(context),
                    Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                              color: Get.theme.colorScheme.surface, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff91a57d).withOpacity(.2),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: const Offset(
                                  -1, -1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(Icons.format_size,
                                size: 24, color: Get.theme.colorScheme.surface),
                            fontSizeDropDown(context),
                          ],
                        )),
                  ],
                ),
              ),
              const Divider(
                height: 0,
                thickness: 3,
              ),
              const SizedBox(
                height: 8,
              ),
              Flexible(
                flex: 4,
                child: Container(
                  height: MediaQuery.sizeOf(context).height / 1 / 2 * 1.5,
                  width: MediaQuery.sizeOf(context).width,
                  color: Get.theme.colorScheme.background,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.sizeOf(context).height,
                      ),
                      child: Scrollbar(
                        controller: _scrollController,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Obx(() {
                            if (ayat != null &&
                                ayat.length >
                                    sl<AyatController>()
                                        .numberOfAyahText
                                        .value) {}
                            if (sl<AyatController>().currentText.value !=
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
                            }
                            if (sl<AyatController>().currentPageLoading.value) {
                              return const CircularProgressIndicator();
                            } else if (sl<AyatController>().currentText.value !=
                                null) {
                              allText =
                                  '﴿${sl<AyatController>().currentText.value!.translateAyah}﴾\n\n' +
                                      sl<AyatController>()
                                          .currentText
                                          .value!
                                          .translate;
                              allTitle =
                                  '﴿${sl<AyatController>().currentText.value!.translateAyah}﴾';
                              return SelectableText.rich(
                                TextSpan(
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text:
                                          '﴿${sl<AyatController>().currentText.value!.translateAyah}﴾\n\n',
                                      style: TextStyle(
                                          color: Get.isDarkMode
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
                                        child: SizedBox(
                                          height: 50,
                                          child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1 /
                                                  2,
                                              child: SvgPicture.asset(
                                                'assets/svg/space_line.svg',
                                              )),
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                      text: sl<AyatController>()
                                          .currentText
                                          .value!
                                          .translate,
                                      style: TextStyle(
                                          color: Get.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          height: 1.5,
                                          fontSize: sl<GeneralController>()
                                              .fontSizeArabic
                                              .value),
                                    ),
                                    WidgetSpan(
                                      child: Center(
                                        child: SizedBox(
                                          height: 50,
                                          child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1 /
                                                  2,
                                              child: SvgPicture.asset(
                                                'assets/svg/space_line.svg',
                                              )),
                                        ),
                                      ),
                                    )
                                    // TextSpan(text: 'world', style: TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                showCursor: true,
                                cursorWidth: 3,
                                cursorColor: Get.theme.dividerColor,
                                cursorRadius: const Radius.circular(5),
                                scrollPhysics: const ClampingScrollPhysics(),
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.justify,
                                contextMenuBuilder: buildMyContextMenu(),
                                onSelectionChanged: handleSelectionChanged,
                              );
                            } else {
                              return Text(
                                  'Error: ${sl<AyatController>().currentPageError.value}');
                            }
                          }),
                        ),
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
    });
  }

  tafseerDropDown(BuildContext context) {
    List<String> tafName = <String>[
      '${'tafIbnkatheerN'.tr}',
      '${'tafBaghawyN'.tr}',
      '${'tafQurtubiN'.tr}',
      '${'tafSaadiN'.tr}',
      '${'tafTabariN'.tr}',
    ];
    List<String> tafD = <String>[
      '${'tafIbnkatheerD'.tr}',
      '${'tafBaghawyD'.tr}',
      '${'tafQurtubiD'.tr}',
      '${'tafSaadiD'.tr}',
      '${'tafTabariD'.tr}',
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
                onTap: () {
                  Navigator.pop(context);
                  if (SlidingUpPanelStatus.hidden ==
                      sl<GeneralController>().panelTextController.status) {
                    sl<GeneralController>().panelTextController.expand();
                  } else {
                    sl<GeneralController>().panelTextController.hide();
                  }
                },
                child: Container(
                  height: 30,
                  width: 30,
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: Get.theme.colorScheme.background,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      border:
                          Border.all(width: 2, color: Get.theme.dividerColor)),
                  child: Icon(
                    Icons.close_outlined,
                    color: Get.theme.colorScheme.surface,
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
                itemCount: tafName.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                        child: ListTile(
                          title: Text(
                            tafName[index],
                            style: TextStyle(
                                color: sl<AyatController>().radioValue.value ==
                                        index
                                    ? Get.theme.primaryColorLight
                                    : const Color(0xffcdba72),
                                fontSize: 14,
                                fontFamily: 'kufi'),
                          ),
                          subtitle: Text(
                            tafD[index],
                            style: TextStyle(
                                color: sl<AyatController>().radioValue.value ==
                                        index
                                    ? Get.theme.primaryColorLight
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
                                          ? Get.theme.primaryColorLight
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
                            print("IconButton pressed, calling updateTextText");
                            sl<AyatController>().handleRadioValueChanged(index);
                            await sl<SharedPrefServices>()
                                .saveInteger(TAFSEER_VAL, index);
                            // Get new translation and update state
                            sl<AyatController>().getNewTranslationAndNotify(
                                int.parse(
                                    sl<AyatController>().surahTextNumber.value),
                                int.parse(
                                    sl<AyatController>().ayahTextNumber.value));
                            // print("lastAyahInPage $lastAyahInPage");
                            if (SlidingUpPanelStatus.hidden ==
                                sl<GeneralController>()
                                    .panelTextController
                                    .status) {
                              sl<GeneralController>()
                                  .panelTextController
                                  .expand();
                            } else {
                              sl<GeneralController>()
                                  .panelTextController
                                  .hide();
                            }
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
                                      color: Get.theme.dividerColor, width: 2)),
                              child: Opacity(
                                child: SvgPicture.asset(
                                  'assets/svg/tafseer_book.svg',
                                ),
                                opacity:
                                    sl<AyatController>().radioValue.value ==
                                            index
                                        ? 1
                                        : .4,
                              )),
                        ),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                            border: Border.all(
                                color: Get.theme.dividerColor, width: 1)),
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
