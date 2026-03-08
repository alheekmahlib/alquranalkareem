import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '/core/utils/constants/extensions/alignment_rotated_extension.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/svg_constants.dart';
import '../../../controllers/general/general_controller.dart';
import '../../adhkar/controller/adhkar_controller.dart';
import '../controller/waqf_controller.dart';

class WaqfListBuild extends StatelessWidget {
  WaqfListBuild({super.key});

  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetX<WaqfController>(
      builder: (waqfCtrl) => ScrollablePositionedList.builder(
        scrollDirection: Axis.vertical,
        addAutomaticKeepAlives: true,
        itemScrollController: generalCtrl.state.waqfScrollController,
        itemCount: waqfCtrl.waqfList.length,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemBuilder: (context, index) {
          final waqf = waqfCtrl.waqfList[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: .15),
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: .06),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Gap(16),
                  customSvgWithColor(waqf.image, height: 60, width: 60),
                  const Gap(4),
                  customSvgWithCustomColor(
                    SvgPath.svgSplashIcon,
                    height: 50,
                    width: 50,
                    color: theme.colorScheme.surface,
                  ),
                  const Gap(8),
                  Obx(() {
                    return RichText(
                      text: TextSpan(
                        children: sl<AzkarController>().buildTextSpans(
                          waqf.translations.values.first,
                        ),
                        style: TextStyle(
                          fontSize: sl<GeneralController>()
                              .state
                              .fontSizeArabic
                              .value,
                          fontFamily: 'naskh',
                          color: theme.colorScheme.inversePrimary,
                        ),
                      ),
                      textDirection: alignmentLayout(
                        TextDirection.rtl,
                        TextDirection.ltr,
                      ),
                      textAlign: TextAlign.justify,
                    );
                  }),
                  const Gap(8),
                  customSvgWithColor(
                    SvgPath.svgSpaceLine,
                    height: 25,
                    width: MediaQuery.sizeOf(context).width / 4,
                  ),
                  const Gap(12),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
