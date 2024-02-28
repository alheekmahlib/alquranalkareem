import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/lottie.dart';
import '../../../../../core/utils/constants/svg_picture.dart';
import '../../../../controllers/azkar_controller.dart';
import '/core/utils/constants/extensions/extensions.dart';
import 'share_zekrToImage.dart';

class ShareZekrOptions extends StatelessWidget {
  final String zekrText;
  final String category;
  final String reference;
  final String description;
  final String count;
  const ShareZekrOptions({
    super.key,
    required this.zekrText,
    required this.category,
    required this.reference,
    required this.description,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final shareToImage = sl<AzkarController>();

    return GestureDetector(
      child: Semantics(
        button: true,
        enabled: true,
        label: 'share'.tr,
        child: share_icon(height: 20.0),
      ),
      onTap: () {
        Get.bottomSheet(
            Container(
              height: MediaQuery.sizeOf(context).height * .9,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
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
                      child: shareLottie(width: 120.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 70.0),
                      child: ListView(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'shareText'.tr,
                              style: TextStyle(
                                  color: Get.isDarkMode
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.primary,
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
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
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
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      size: 24,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: Text(
                                      zekrText,
                                      style: TextStyle(
                                          color: Theme.of(context).hintColor,
                                          fontSize: 16,
                                          fontFamily: 'uthmanic2'),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              shareToImage.shareText(zekrText, category,
                                  reference, description, count);
                              Navigator.pop(context);
                            },
                          ),
                          context.hDivider(
                              color: Theme.of(context).colorScheme.primary),
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
                                              color:
                                                  Theme.of(context).hintColor,
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(.15),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4))),
                                      // child: Image.memory(
                                      //   imageData2,
                                      //   // height: 150,
                                      //   // width: 150,
                                      // ),
                                      child: VerseImageCreator(
                                        zekrText: zekrText,
                                        category: category,
                                        reference: reference,
                                        description: description,
                                        count: count,
                                      ),
                                    ),
                                    onTap: () async {
                                      await sl<AzkarController>()
                                          .createAndShowZekrImage();
                                      shareToImage.shareZekr(context);
                                      // shareVerse(
                                      //     context, verseNumber, surahNumber, verseText);
                                      Navigator.pop(context);
                                    },
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
