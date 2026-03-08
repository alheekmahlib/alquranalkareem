import 'package:alquranalkareem/core/utils/helpers/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/services/services_locator.dart';
import '../../../../core/widgets/title_widget.dart';
import '../../../../database/bookmark_db/bookmark_database.dart';
import '../../../controllers/general/general_controller.dart';
import '../controller/adhkar_controller.dart';

class TextWidget extends StatelessWidget {
  final AdhkarData zekr;
  TextWidget({super.key, required this.zekr});

  @override
  Widget build(BuildContext context) {
    final azkarCtrl = AzkarController.instance;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
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
              child: Obx(() {
                return RichText(
                  text: TextSpan(
                    children: azkarCtrl.buildTextSpans(zekr.zekr),
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      height: 1.4,
                      fontFamily: 'naskh',
                      fontSize:
                          sl<GeneralController>().state.fontSizeArabic.value,
                    ),
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.justify,
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TitleWidget(
              title: zekr.reference,
              textStyle: AppTextStyles.titleSmall(
                color: context.theme.primaryColorLight.withValues(alpha: .8),
              ),
            ),
          ),
          zekr.description.isEmpty
              ? const SizedBox.shrink()
              : TitleWidget(
                  title: zekr.description,
                  textStyle: AppTextStyles.titleSmall(
                    color: context.theme.primaryColorLight.withValues(
                      alpha: .8,
                    ),
                  ),
                ),
          const Gap(8.0),
          Container(
            height: 8,
            width: Get.width,
            margin: const EdgeInsets.symmetric(horizontal: 54.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).primaryColorLight,
            ),
          ),
        ],
      ),
    );
  }
}
