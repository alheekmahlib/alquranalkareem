import 'package:alquranalkareem/core/utils/helpers/app_text_styles.dart';
import 'package:alquranalkareem/core/widgets/title_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../../../core/utils/constants/svg_constants.dart';
import '../../controller/adhkar_controller.dart';

class DhekrImageCreator extends StatelessWidget {
  final String zekrText;
  final String category;
  final String reference;
  final String description;
  final String count;

  final zekrToImage = AzkarController.instance;
  DhekrImageCreator({
    super.key,
    required this.zekrText,
    required this.category,
    required this.reference,
    required this.description,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Screenshot(
          controller: zekrToImage.state.dhekrScreenController,
          child: buildVerseImageWidget(
            context: context,
            zekrText: zekrText,
            category: category,
            reference: reference,
            description: description,
            count: count,
          ),
        ),
        // if (ayahToImage.ayahToImageBytes != null)
        //   Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Image.memory(ayahToImage.ayahToImageBytes!),
        //   ),
      ],
    );
  }

  Widget buildVerseImageWidget({
    required BuildContext context,
    required zekrText,
    required category,
    required reference,
    required description,
    required count,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: 960.0,
        decoration: BoxDecoration(color: context.theme.colorScheme.primary),
        child: Column(
          children: [
            const Gap(8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.primaryContainer,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Column(
                  children: [
                    const Gap(8),
                    Text(
                      category,
                      style: AppTextStyles.titleLarge(
                        color: context.theme.colorScheme.surface,
                      ),
                    ),
                    context.hDivider(
                      width: MediaQuery.sizeOf(context).width,
                      height: 1,
                    ),
                    const Gap(8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: SizedBox(
                        width: 928.0,
                        child: RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                children: zekrToImage.shareTextSpans(zekrText),
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontFamily: 'naskh',
                                  color: Color(0xff161f07),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Gap(4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TitleWidget(
                        title: reference,
                        textStyle: AppTextStyles.titleSmall(
                          fontSize: 12,
                          color: context.theme.colorScheme.surface,
                        ),
                      ),
                    ),
                    context.hDivider(
                      width: MediaQuery.sizeOf(context).width,
                      height: 1,
                    ),
                    TitleWidget(
                      title: description,
                      textStyle: AppTextStyles.titleSmall(
                        fontSize: 12,
                        color: context.theme.colorScheme.surface,
                      ),
                    ),
                    const Gap(4),
                  ],
                ),
              ),
            ),
            const Gap(4),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                customSvg(SvgPath.svgSplashIconW, height: 30),
                context.vDivider(),
                Text(
                  'القرآن الكريـم - مكتبة الحكمة',
                  style: AppTextStyles.titleSmall(
                    fontSize: 10,
                    color: context.theme.canvasColor,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
            const Gap(4),
          ],
        ),
      ),
    );
  }
}
