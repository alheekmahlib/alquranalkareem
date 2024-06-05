import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '/presentation/controllers/quran_controller.dart';
import '../../../presentation/controllers/ayat_controller.dart';
import '../../../presentation/controllers/share_controller.dart';
import '../../../presentation/controllers/translate_controller.dart';
import '../../services/services_locator.dart';
import '../../utils/constants/extensions/extensions.dart';
import '../../utils/constants/extensions/text_span_extension.dart';
import '../../utils/constants/lists.dart';
import '../../utils/constants/lottie.dart';
import '../../utils/constants/lottie_constants.dart';
import '../../utils/constants/svg_constants.dart';
import 'share_ayahToImage.dart';
import 'share_tafseerToImage.dart';

class ShareAyahOptions extends StatelessWidget {
  final int ayahNumber;
  final int ayahUQNumber;
  final int surahNumber;
  final String ayahText;
  final String surahName;
  final String ayahTextNormal;
  final Function? cancel;
  const ShareAyahOptions({
    super.key,
    required this.ayahNumber,
    required this.ayahUQNumber,
    required this.surahNumber,
    required this.ayahText,
    required this.surahName,
    required this.ayahTextNormal,
    this.cancel,
  });

  @override
  Widget build(BuildContext context) {
    final shareToImage = ShareController.instance;

    return GestureDetector(
      child: Semantics(
        button: true,
        enabled: true,
        label: 'share'.tr,
        child: customSvg(
          SvgPath.svgShareIcon,
          height: 20,
        ),
      ),
      onTap: () {
        shareToImage.fetchTafseerSaadi(surahNumber, ayahNumber, ayahUQNumber);
        Get.bottomSheet(
            Container(
              height: MediaQuery.sizeOf(context).height * .9,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  color: Get.theme.colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  )),
              child: SafeArea(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: context.customClose(),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: customLottie(LottieConstants.assetsLottieShare,
                          width: 120.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 70.0),
                      child: ListView(
                        physics: const ClampingScrollPhysics(),
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'shareText'.tr,
                              style: TextStyle(
                                  color: Get.isDarkMode
                                      ? Get.theme.colorScheme.primary
                                      : Get.theme.colorScheme.primary,
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
                                  top: 4.0,
                                  bottom: 16.0,
                                  right: 16.0,
                                  left: 16.0),
                              decoration: BoxDecoration(
                                  color: Get.theme.colorScheme.primary
                                      .withOpacity(.15),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4))),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Icon(
                                      Icons.text_fields,
                                      color: Get.theme.colorScheme.surface,
                                      size: 24,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: Text(
                                      "﴿ $ayahTextNormal ﴾",
                                      style: TextStyle(
                                          color: Get.theme.hintColor,
                                          fontSize: 16,
                                          fontFamily: 'uthmanic2'),
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              shareToImage.shareText(
                                  ayahTextNormal, surahName, ayahNumber);
                              Navigator.pop(context);
                            },
                          ),
                          context.hDivider(
                              color: Get.theme.colorScheme.primary),
                          Column(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'shareImage'.tr,
                                          style: TextStyle(
                                              color: Get.theme.hintColor,
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
                                          color: Get.theme.colorScheme.primary
                                              .withOpacity(.15),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4))),
                                      // child: Image.memory(
                                      //   imageData2,
                                      //   // height: 150,
                                      //   // width: 150,
                                      // ),
                                      child: VerseImageCreator(
                                          verseNumber: ayahNumber,
                                          surahNumber: surahNumber,
                                          verseText: ayahTextNormal),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: Text(
                                            'shareImageWTrans'.tr,
                                            style: TextStyle(
                                                color: Get.theme.hintColor,
                                                fontSize: 16,
                                                fontFamily: 'kufi'),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: PopupMenuButton(
                                            position: PopupMenuPosition.under,
                                            color: Get.theme.colorScheme
                                                .primaryContainer,
                                            child: Container(
                                              // width: 140,
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                color: Get.theme.dividerColor
                                                    .withOpacity(.4),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(8)),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: 100,
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Obx(
                                                        () => Text(
                                                          shareToImage
                                                              .currentTranslate
                                                              .value,
                                                          style: TextStyle(
                                                            fontFamily: 'kufi',
                                                            fontSize: 14,
                                                            color: Get.theme
                                                                .hintColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .keyboard_arrow_down_rounded,
                                                    size: 20,
                                                    color: Get.theme.colorScheme
                                                        .primary,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            itemBuilder: (context) =>
                                                shareTranslateName.map(
                                              (e) {
                                                int selectedIndex = 0;
                                                shareTranslateName
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
                                                        width:
                                                            MediaQuery.sizeOf(
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
                                                                ? Theme.of(
                                                                        context)
                                                                    .hintColor
                                                                : Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .surface,
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        shareToImage
                                                            .shareButtonOnTap(
                                                                context,
                                                                selectedIndex,
                                                                ayahUQNumber,
                                                                surahNumber,
                                                                ayahNumber);
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                            ).toList(),
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
                                          color: Get.theme.colorScheme.primary
                                              .withOpacity(.15),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4))),
                                      child: FutureBuilder(
                                          future: sl<AyatController>()
                                              .getTafsir(
                                                  ayahUQNumber,
                                                  sl<QuranController>()
                                                      .getSurahDataByAyahUQ(
                                                          ayahUQNumber)
                                                      .surahNumber),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              return TafseerImageCreator(
                                                verseNumber: ayahNumber,
                                                verseUQNumber: ayahUQNumber,
                                                surahNumber: surahNumber,
                                                verseText: ayahTextNormal,
                                                tafseerText:
                                                    sl<AyatController>()
                                                        .selectedTafsir!
                                                        .text
                                                        .buildTextSpans(),
                                              );
                                            } else {
                                              return const CircularProgressIndicator
                                                  .adaptive();
                                            }
                                          }),
                                    ),
                                    onTap: () async {
                                      await shareToImage
                                          .createAndShowTafseerImage();
                                      shareToImage
                                          .shareVerseWithTranslate(context);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32.0),
                                    child: Text(
                                      'shareTrans'.tr,
                                      style: TextStyle(
                                          color: Get.isDarkMode
                                              ? Get.theme.colorScheme.primary
                                              : Get.theme.colorScheme.primary,
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
            isScrollControlled: true);
      },
    );
  }
}
