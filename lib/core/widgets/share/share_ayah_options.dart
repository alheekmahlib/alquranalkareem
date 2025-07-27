import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_library/quran.dart';

import '../../../presentation/screens/quran_page/quran.dart';
import '../../services/services_locator.dart';
import '../../utils/constants/extensions/extensions.dart';
import '../../utils/constants/lottie.dart';
import '../../utils/constants/lottie_constants.dart';
import '../../utils/constants/svg_constants.dart';
import '../custom_button.dart';
import 'share_ayahToImage.dart';

class ShareAyahOptions extends StatelessWidget {
  final int ayahNumber;
  final int ayahUQNumber;
  final int surahNumber;
  final String ayahText;
  final String surahName;
  final String ayahTextNormal;
  final Function? cancel;
  final int pageNumber;
  ShareAyahOptions({
    super.key,
    required this.ayahNumber,
    required this.ayahUQNumber,
    required this.surahNumber,
    required this.ayahText,
    required this.surahName,
    required this.ayahTextNormal,
    this.cancel,
    required this.pageNumber,
  });

  final shareToImage = ShareController.instance;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      height: 25,
      width: 30,
      iconSize: 30,
      svgPath: SvgPath.svgShareIcon,
      svgColor: context.theme.canvasColor,
      onPressed: () async {
        await QuranLibrary().fetchTranslation();
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
                          _ayahText(context),
                          context.hDivider(
                              color: Get.theme.colorScheme.primary),
                          _ayahToImage(context),
                          // _imageWithTranslation(context),
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

  Widget _ayahText(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                top: 4.0, bottom: 16.0, right: 16.0, left: 16.0),
            decoration: BoxDecoration(
                color: Get.theme.colorScheme.primary.withValues(alpha: .15),
                borderRadius: const BorderRadius.all(Radius.circular(4))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    "﴿ $ayahText ﴾",
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
            shareToImage.shareText(ayahText, surahName, ayahNumber);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _ayahToImage(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            margin: const EdgeInsets.only(
                top: 4.0, bottom: 16.0, right: 16.0, left: 16.0),
            decoration: BoxDecoration(
                color: Get.theme.colorScheme.primary.withValues(alpha: .15),
                borderRadius: const BorderRadius.all(Radius.circular(4))),
            // child: Image.memory(
            //   imageData2,
            //   // height: 150,
            //   // width: 150,
            // ),
            child: VerseImageCreator(
                verseNumber: ayahNumber,
                surahNumber: surahNumber,
                verseText: ayahText),
          ),
          onTap: () async {
            await sl<ShareController>().createAndShowVerseImage();
            shareToImage.shareVerse(context);
            // shareVerse(
            //     context, verseNumber, surahNumber, verseText);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  // Widget _imageWithTranslation(BuildContext context) {
  //   return Column(
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Expanded(
  //               flex: 6,
  //               child: Text(
  //                 'shareImageWTrans'.tr,
  //                 style: TextStyle(
  //                     color: Get.theme.hintColor,
  //                     fontSize: 16,
  //                     fontFamily: 'kufi'),
  //               ),
  //             ),
  //             Expanded(
  //               flex: 5,
  //               child: PopupMenuButton(
  //                 position: PopupMenuPosition.under,
  //                 color: Get.theme.colorScheme.primaryContainer,
  //                 child: Container(
  //                   // width: 140,
  //                   padding: const EdgeInsets.all(8.0),
  //                   decoration: BoxDecoration(
  //                     color: Get.theme.dividerColor.withValues(alpha: .4),
  //                     borderRadius: const BorderRadius.all(Radius.circular(8)),
  //                   ),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       SizedBox(
  //                         width: 100,
  //                         child: FittedBox(
  //                           fit: BoxFit.scaleDown,
  //                           child: Obx(
  //                             () => Text(
  //                               shareToImage.currentTranslate.value,
  //                               style: TextStyle(
  //                                 fontFamily: 'kufi',
  //                                 fontSize: 14,
  //                                 color: Get.theme.hintColor,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       Icon(
  //                         Icons.keyboard_arrow_down_rounded,
  //                         size: 20,
  //                         color: Get.theme.colorScheme.primary,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 itemBuilder: (context) =>
  //                     List<PopupMenuItem<dynamic>>.generate(
  //                   translateNames.length,
  //                   (i) => PopupMenuItem<Widget>(
  //                     value: Text(
  //                       translateNames[i].name,
  //                       style: TextStyle(
  //                         fontFamily: 'kufi',
  //                         fontSize: 18,
  //                         color: Theme.of(context).hintColor,
  //                       ),
  //                     ),
  //                     child: Obx(
  //                       () => GestureDetector(
  //                         onTap: QuranLibrary().getTafsirDownloaded(i)
  //                             ? () async {
  //                                 await shareToImage.shareButtonOnTap(
  //                                   context,
  //                                   i,
  //                                   ayahUQNumber,
  //                                   surahNumber,
  //                                   ayahNumber,
  //                                   pageNumber,
  //                                 );
  //                               }
  //                             : null,
  //                         child: SizedBox(
  //                           width: MediaQuery.sizeOf(context).width,
  //                           child: Text(
  //                             translateNames[i].name,
  //                             style: TextStyle(
  //                               fontFamily: 'kufi',
  //                               fontSize: 18,
  //                               color: QuranLibrary().getTafsirDownloaded(i)
  //                                   ? Theme.of(context).hintColor
  //                                   : Theme.of(context)
  //                                       .colorScheme
  //                                       .surface
  //                                       .withValues(alpha: .4),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //       GestureDetector(
  //         child: Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
  //           margin: const EdgeInsets.only(
  //               top: 4.0, bottom: 16.0, right: 16.0, left: 16.0),
  //           decoration: BoxDecoration(
  //               color: Get.theme.colorScheme.primary.withValues(alpha: .15),
  //               borderRadius: const BorderRadius.all(Radius.circular(4))),
  //           child: TafseerImageCreator(
  //             verseNumber: ayahNumber,
  //             verseUQNumber: ayahUQNumber,
  //             surahNumber: surahNumber,
  //             verseText: ayahTextNormal,
  //           ),
  //         ),
  //         onTap: () async {
  //           await shareToImage.createAndShowTafseerImage();
  //           shareToImage.shareVerseWithTranslate(context);
  //           Navigator.pop(context);
  //         },
  //       ),
  //     ],
  //   );
  // }
}
