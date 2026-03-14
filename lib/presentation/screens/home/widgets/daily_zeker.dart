import 'package:alquranalkareem/core/utils/helpers/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '/presentation/screens/adhkar/controller/extensions/adhkar_getters.dart';
import '../../../../core/utils/constants/svg_constants.dart';
import '../../../../core/widgets/buttom_with_line.dart';
import '../../../../database/bookmark_db/bookmark_database.dart';
import '../../adhkar/controller/adhkar_controller.dart';
import '../../adhkar/screens/adhkar_view.dart';

class DailyZeker extends StatelessWidget {
  DailyZeker({super.key});
  final azkarCtrl = AzkarController.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.theme.primaryColorLight.withValues(alpha: .01),
            context.theme.primaryColorLight.withValues(alpha: .05),
            context.theme.primaryColorLight.withValues(alpha: .1),
            context.theme.primaryColorLight.withValues(alpha: .15),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.4, 0.8, 1.0],
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: FutureBuilder<AdhkarData>(
        future: azkarCtrl.getDailyDhekr(),
        builder: (context, snapshot) {
          return snapshot.data != null && azkarCtrl.state.dhekrOfTheDay != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32.0,
                                      vertical: 4.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: context.theme.colorScheme.surface
                                          .withValues(alpha: .4),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'dailyZeker'.tr,
                                      style: AppTextStyles.titleMedium(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const Gap(4),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: Text(
                                      azkarCtrl.state.dhekrOfTheDay!.category,
                                      style: AppTextStyles.titleSmall(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ButtomWithLine(
                            isRtl: false,
                            svgPath: SvgPath.svgAthkarAthkar,
                            onTap: () => Get.to(
                              () => const AdhkarView(),
                              transition: Transition.downToUp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    context.hDivider(
                      width: Get.width,
                      color: context.theme.colorScheme.surface,
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text(
                        '${azkarCtrl.state.dhekrOfTheDay!.zekr}',
                        style: AppTextStyles.titleMedium(),
                        textAlign: TextAlign.justify,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    context.hDivider(
                      width: Get.width,
                      color: context.theme.colorScheme.surface,
                    ),
                  ],
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }
}
