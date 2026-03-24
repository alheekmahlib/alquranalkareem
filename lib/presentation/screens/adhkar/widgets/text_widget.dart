import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:quran_library/quran_library.dart';

import '/core/utils/helpers/app_text_styles.dart';
import '../../../../core/widgets/title_widget.dart';
import '../../../../database/bookmark_db/bookmark_database.dart';
import '../controller/adhkar_controller.dart';

class TextWidget extends StatelessWidget {
  final AdhkarData zekr;
  TextWidget({super.key, required this.zekr});

  @override
  Widget build(BuildContext context) {
    final azkarCtrl = AzkarController.instance;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: .1),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                width: double.infinity,
                child: RichText(
                  text: TextSpan(
                    children: azkarCtrl.buildTextSpans(zekr.zekr),
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      height: 1.4,
                      fontFamily: 'naskh',
                      fontSize: TafsirCtrl.instance.fontSizeArabic.value,
                    ),
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            TitleWidget(
              title: zekr.reference,
              textStyle: AppTextStyles.titleSmall(
                fontSize: TafsirCtrl.instance.fontSizeArabic.value - 8,
                color: context.theme.primaryColorLight.withValues(alpha: .8),
              ),
            ),
            zekr.description.isEmpty
                ? const SizedBox.shrink()
                : TitleWidget(
                    title: zekr.description,
                    textStyle: AppTextStyles.titleSmall(
                      fontSize: TafsirCtrl.instance.fontSizeArabic.value - 8,
                      color: context.theme.primaryColorLight.withValues(
                        alpha: .8,
                      ),
                    ),
                  ),
            const Gap(8.0),
            Container(
              height: 3,
              width: Get.width,
              margin: const EdgeInsets.symmetric(horizontal: 54.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
