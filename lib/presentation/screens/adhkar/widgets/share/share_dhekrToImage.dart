import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '/core/utils/helpers/app_text_styles.dart';
import '/core/widgets/title_widget.dart';
import '../../../../../core/utils/constants/svg_constants.dart';
import '../../controller/adhkar_controller.dart';

/// معاينة صورة الذكر داخل الورقة — بدون [Screenshot]؛
/// الالتقاط يتم عبر captureFromWidget لأن family_bottom_sheet يركّب
/// محتوى الورقة مرتين فلا يصح GlobalKey داخلها.
class DhekrImageCreator extends StatelessWidget {
  final String zekrText;
  final String category;
  final String reference;
  final String description;
  final String count;

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
    return buildZekrShareImage(
      context: context,
      zekrText: zekrText,
      category: category,
      reference: reference,
      description: description,
      count: count,
    );
  }
}

/// قالب صورة المشاركة — يُستخدم للمعاينة وللالتقاط معًا.
Widget buildZekrShareImage({
  required BuildContext context,
  required String zekrText,
  required String category,
  required String reference,
  required String description,
  required String count,
}) {
  final zekrToImage = AzkarController.instance;
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
              const SizedBox().customSvg(SvgPath.svgHomeQuranLogo, height: 30),
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
