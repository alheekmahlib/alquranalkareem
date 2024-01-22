import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../presentation/controllers/share_controller.dart';
import '../../../presentation/controllers/translate_controller.dart';
import '../../services/services_locator.dart';
import '../../utils/constants/lottie.dart';
import '../../utils/constants/shared_pref_services.dart';
import '../../utils/constants/shared_preferences_constants.dart';
import '../widgets.dart';
import '/core/utils/constants/extensions.dart';
import 'share_ayahToImage.dart';
import 'share_tafseerToImage.dart';

void showVerseOptionsBottomSheet(
    BuildContext context,
    int verseNumber,
    int verseUQNumber,
    surahNumber,
    String verseText,
    textTranslate,
    surahName) async {
  final shareToImage = sl<ShareController>();
  // shareToImage.changeTafseer(context, verseUQNumber);
  List<String> translateName = <String>[
    'English',
    'Español',
    'বাংলা',
    'اردو',
    'Soomaali',
    'bahasa Indonesia',
    'کوردی',
    'Türkçe',
    'تفسير السعدي'
  ];
  allModalBottomSheet(
    context,
    MediaQuery.sizeOf(context).height / 1 / 2,
    MediaQuery.sizeOf(context).width,
    SafeArea(
      child: Container(
        alignment: Alignment.center,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: customClose(context),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: shareLottie(width: 120.0),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70.0),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'shareText'.tr,
                      style: TextStyle(
                          color: Get.isDarkMode
                              ? Get.theme.colorScheme.surface
                              : Get.theme.primaryColorDark,
                          fontSize: 16,
                          fontFamily: 'kufi'),
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      // height: 60,
                      width: MediaQuery.sizeOf(context).width,
                      padding: const EdgeInsets.all(16.0),
                      margin: const EdgeInsets.only(
                          top: 4.0, bottom: 16.0, right: 16.0, left: 16.0),
                      decoration: BoxDecoration(
                          color: const Color(0xffcdba72).withOpacity(.3),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4))),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.text_fields,
                            color: Color(0xff91a57d),
                            size: 24,
                          ),
                          SizedBox(
                            width: context.customOrientation(
                                MediaQuery.sizeOf(context).width * .7,
                                MediaQuery.sizeOf(context).width / 1 / 3),
                            child: Text(
                              "﴿ $verseText ﴾",
                              style: TextStyle(
                                  color: Get.isDarkMode
                                      ? Get.theme.canvasColor
                                      : Get.theme.primaryColorDark,
                                  fontSize: 16,
                                  fontFamily: 'uthmanic2'),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      shareToImage.shareText(verseText, surahName, verseNumber);
                      Navigator.pop(context);
                    },
                  ),
                  Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16.0),
                    width: MediaQuery.sizeOf(context).width * .3,
                    color: const Color(0xffcdba72),
                  ),
                  Column(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'shareImage'.tr,
                                  style: TextStyle(
                                      color: Get.isDarkMode
                                          ? Get.theme.colorScheme.surface
                                          : Get.theme.primaryColorDark,
                                      fontSize: 16,
                                      fontFamily: 'kufi'),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            child: Container(
                              // width: MediaQuery.sizeOf(context).width * .4,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 8.0),
                              margin: const EdgeInsets.only(
                                  top: 4.0,
                                  bottom: 16.0,
                                  right: 16.0,
                                  left: 16.0),
                              decoration: BoxDecoration(
                                  color:
                                      const Color(0xffcdba72).withOpacity(.3),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4))),
                              // child: Image.memory(
                              //   imageData2,
                              //   // height: 150,
                              //   // width: 150,
                              // ),
                              child: VerseImageCreator(
                                  verseNumber: verseNumber,
                                  surahNumber: surahNumber,
                                  verseText: verseText),
                            ),
                            onTap: () async {
                              await sl<ShareController>()
                                  .createAndShowVerseImage();
                              shareToImage.shareVerse(context);
                              // shareVerse(
                              //     context, verseNumber, surahNumber, verseText);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Text(
                                    'shareImageWTrans'.tr,
                                    style: TextStyle(
                                        color: Get.isDarkMode
                                            ? Get.theme.colorScheme.surface
                                            : Get.theme.primaryColorDark,
                                        fontSize: 16,
                                        fontFamily: 'kufi'),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: [
                                      PopupMenuButton(
                                        position: PopupMenuPosition.under,
                                        color: Get.theme.colorScheme.background,
                                        child: Container(
                                          // width: 140,
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color: Get.theme.dividerColor
                                                .withOpacity(.4),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Obx(
                                                () => Text(
                                                  shareToImage
                                                      .currentTranslate.value,
                                                  style: TextStyle(
                                                    fontFamily: 'kufi',
                                                    fontSize: 16,
                                                    color: Get.isDarkMode
                                                        ? Colors.white
                                                        : Get
                                                            .theme.primaryColor,
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                size: 20,
                                                color: Get
                                                    .theme.colorScheme.surface,
                                              ),
                                            ],
                                          ),
                                        ),
                                        itemBuilder: (context) =>
                                            translateName.map(
                                          (e) {
                                            int selectedIndex = 0;
                                            translateName
                                                .asMap()
                                                .forEach((index, item) {
                                              if (item == e) {
                                                selectedIndex = index;
                                              }
                                            });
                                            return PopupMenuItem<Widget>(
                                              value: Text(
                                                e,
                                              ),
                                              child: Obx(
                                                () => GestureDetector(
                                                  child: SizedBox(
                                                    width: MediaQuery.sizeOf(
                                                            context)
                                                        .width,
                                                    child: Text(
                                                      e,
                                                      style: TextStyle(
                                                        fontFamily: 'kufi',
                                                        fontSize: 18,
                                                        color: sl<TranslateDataController>()
                                                                    .shareTransValue
                                                                    .value ==
                                                                selectedIndex
                                                            ? Get.theme
                                                                .primaryColorLight
                                                            : const Color(
                                                                0xffcdba72),
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    sl<ShareController>()
                                                        .changeTafseer(
                                                            context,
                                                            verseUQNumber,
                                                            surahNumber,
                                                            verseNumber);
                                                    sl<TranslateDataController>()
                                                            .shareTransValue
                                                            .value ==
                                                        selectedIndex;
                                                    sl<SharedPrefServices>()
                                                        .saveInteger(
                                                            TRANSLATE_VALUE,
                                                            selectedIndex);
                                                    sl<SharedPrefServices>()
                                                        .saveString(
                                                            CURRENT_TRANSLATE,
                                                            translateName[
                                                                selectedIndex]);

                                                    shareToImage
                                                            .currentTranslate
                                                            .value =
                                                        translateName[
                                                            selectedIndex];

                                                    sl<TranslateDataController>()
                                                        .shareTranslateHandleRadioValue(
                                                            selectedIndex);
                                                    sl<TranslateDataController>()
                                                        .fetchTranslate(
                                                            context);
                                                    sl<TranslateDataController>()
                                                        .update();
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        ).toList(),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 8.0),
                              margin: const EdgeInsets.only(
                                  top: 4.0,
                                  bottom: 16.0,
                                  right: 16.0,
                                  left: 16.0),
                              decoration: BoxDecoration(
                                  color:
                                      const Color(0xffcdba72).withOpacity(.3),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4))),
                              child: TafseerImageCreator(
                                verseNumber: verseNumber,
                                verseUQNumber: verseUQNumber,
                                surahNumber: surahNumber,
                                verseText: verseText,
                                tafseerText: textTranslate,
                              ),
                              // child: Image.memory(
                              //   imageData,
                              //   // height: 150,
                              //   // width: 150,
                              // ),
                            ),
                            onTap: () async {
                              await shareToImage.createAndShowTafseerImage();
                              shareToImage.shareVerseWithTranslate(context);
                              Navigator.pop(context);
                            },
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Text(
                              'shareTrans'.tr,
                              style: TextStyle(
                                  color: Get.isDarkMode
                                      ? Get.theme.colorScheme.surface
                                      : Get.theme.primaryColorDark,
                                  fontSize: 14,
                                  fontFamily: 'kufi'),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
