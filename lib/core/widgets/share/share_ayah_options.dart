import 'package:alquranalkareem/core/utils/constants/extensions/bottom_sheet_extension.dart';
import 'package:alquranalkareem/core/widgets/container_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:quran_library/quran.dart';

import '../../../presentation/screens/quran_page/quran.dart';
import '../../services/ayah_audio_share_service.dart';
import '../../services/services_locator.dart';
import '../../utils/constants/extensions/extensions.dart';
import '../../utils/constants/svg_constants.dart';
import '../custom_button.dart';
import '../title_widget.dart';
import 'share_ayahToImage.dart';

class ShareAyahOptions extends StatelessWidget {
  final AyahModel ayah;
  final SurahModel surah;
  final int pageNumber;
  final Color? iconColor;
  final bool? withBack;
  ShareAyahOptions({
    super.key,
    required this.ayah,
    required this.surah,
    required this.pageNumber,
    this.iconColor,
    this.withBack = true,
  });

  final shareToImage = ShareController.instance;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      height: 40,
      width: 35,
      iconSize: 35,
      isCustomSvgColor: true,
      svgPath: SvgPath.svgHomeShare,
      svgColor: iconColor ?? context.theme.canvasColor,
      onPressed: () async {
        if (withBack == true) {
          Get.back();
        }
        // await QuranLibrary().fetchTranslation();
        // shareToImage.fetchTafseerSaadi(surahNumber, ayahNumber, ayahUQNumber);
        customBottomSheet(
          backgroundColor: Get.theme.colorScheme.primaryContainer,
          Container(
            // height: MediaQuery.sizeOf(context).height * .9,
            // alignment: Alignment.center,
            // padding: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ayahText(context),
                    const Gap(4),
                    context.hDivider(color: Get.theme.colorScheme.primary),
                    const Gap(4),
                    _ayahAudio(context),
                    const Gap(4),
                    context.hDivider(color: Get.theme.colorScheme.primary),
                    const Gap(4),
                    _ayahToImage(context),
                    // _imageWithTranslation(context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _ayahText(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'shareText'),
        ContainerButton(
          height: 90,
          width: Get.width,
          isButton: true,
          withArrow: true,
          horizontalMargin: 16.0,
          verticalPadding: 8.0,
          backgroundColor: context.theme.colorScheme.primary.withValues(
            alpha: .15,
          ),
          child: SizedBox(
            width: 300,
            child: Text(
              "﴿ ${ayah.text} ﴾",
              style: TextStyle(
                color: Get.theme.hintColor,
                fontSize: 18,
                fontFamily: 'uthmanic2',
              ),
              overflow: TextOverflow.fade,
              textDirection: TextDirection.rtl,
            ),
          ),
          onPressed: () {
            shareToImage.shareText(
              ayah.text,
              surah.arabicName,
              ayah.ayahNumber,
              pageNumber + 1,
              ayah.ayahUQNumber,
            );
            Get.back();
          },
        ),
      ],
    );
  }

  Widget _ayahToImage(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'shareImage'),
        GestureDetector(
          child: Container(
            // width: MediaQuery.sizeOf(context).width * .4,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            margin: const EdgeInsets.only(
              top: 4.0,
              bottom: 16.0,
              right: 16.0,
              left: 16.0,
            ),
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.primary.withValues(alpha: .15),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
            // child: Image.memory(
            //   imageData2,
            //   // height: 150,
            //   // width: 150,
            // ),
            child: VerseImageCreator(ayah: ayah, surah: surah),
          ),
          onTap: () async {
            await sl<ShareController>().createAndShowVerseImage();
            shareToImage.shareVerse(
              context,
              ayah.text,
              surah.arabicName,
              ayah.ayahNumber,
              pageNumber + 1,
              ayah.ayahUQNumber,
            );
            // shareVerse(
            //     context, verseNumber, surahNumber, verseText);
            Get.back();
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

  Widget _ayahAudio(BuildContext context) {
    final audioService = sl<AyahAudioShareService>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'shareAudio'),
        Obx(
          () => ContainerButton(
            height: 90,
            width: Get.width,
            isButton: true,
            withArrow: true,
            horizontalMargin: 16.0,
            verticalPadding: 8.0,
            isDownloading: audioService.isDownloading.value,
            downloadProgress: audioService.downloadProgress.value,
            backgroundColor: Get.theme.colorScheme.primary.withValues(
              alpha: .15,
            ),
            svgWithColorPath: SvgPath.svgAudioDownload,
            svgColor: Get.theme.hintColor,
            title: audioService.currentReaderName,
            onPressed: audioService.isDownloading.value
                ? null
                : () async {
                    await shareToImage.shareAudio(
                      surahName: surah.arabicName,
                      verseText: ayah.text,
                      surahNumber: surah.surahNumber,
                      ayahNumber: ayah.ayahNumber,
                      pageNumber: pageNumber + 1,
                      ayahUQNumber: ayah.ayahUQNumber,
                    );
                  },
          ),
        ),
      ],
    );
  }
}
