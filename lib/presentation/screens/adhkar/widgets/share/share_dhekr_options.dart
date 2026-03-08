import 'package:alquranalkareem/core/widgets/custom_button.dart';
import 'package:alquranalkareem/core/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/extensions/bottom_sheet_extension.dart';
import '../../../../../core/utils/constants/svg_constants.dart';
import '../../../../../core/widgets/container_button.dart';
import '../../controller/adhkar_controller.dart';
import 'share_dhekrToImage.dart';

class ShareDhekrOptions extends StatelessWidget {
  final String zekrText;
  final String category;
  final String reference;
  final String description;
  final String count;
  const ShareDhekrOptions({
    super.key,
    required this.zekrText,
    required this.category,
    required this.reference,
    required this.description,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final shareToImage = AzkarController.instance;

    return CustomButton(
      height: 35,
      width: 35,
      iconSize: 25,
      isCustomSvgColor: true,
      svgPath: SvgPath.svgHomeShare,
      svgColor: context.theme.primaryColorLight,
      onPressed: () {
        customBottomSheet(
          Flexible(
            child: SafeArea(
              child: ListView(
                shrinkWrap: true,
                children: [
                  const TitleWidget(title: 'shareText'),
                  ContainerButton(
                    height: 90,
                    width: Get.width,
                    isButton: true,
                    withArrow: true,
                    horizontalMargin: 16.0,
                    verticalPadding: 8.0,
                    backgroundColor: context.theme.colorScheme.primary
                        .withValues(alpha: .15),
                    child: SizedBox(
                      width: 300,
                      child: Text(
                        zekrText,
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 16,
                          fontFamily: 'uthmanic2',
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    onPressed: () {
                      shareToImage.shareText(
                        zekrText,
                        category,
                        reference,
                        description,
                        count,
                      );
                      Navigator.pop(context);
                    },
                  ),
                  context.hDivider(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const TitleWidget(title: 'shareImage'),
                  GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 8.0,
                      ),
                      margin: const EdgeInsets.only(
                        bottom: 16.0,
                        right: 16.0,
                        left: 16.0,
                      ),
                      decoration: BoxDecoration(
                        color: Get.theme.colorScheme.primary.withValues(
                          alpha: .15,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      child: DhekrImageCreator(
                        zekrText: zekrText,
                        category: category,
                        reference: reference,
                        description: description,
                        count: count,
                      ),
                    ),
                    onTap: () async {
                      await sl<AzkarController>().createAndShowZekrImage();
                      shareToImage.shareZekr();
                      // shareVerse(
                      //     context, verseNumber, surahNumber, verseText);
                      Get.back();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
