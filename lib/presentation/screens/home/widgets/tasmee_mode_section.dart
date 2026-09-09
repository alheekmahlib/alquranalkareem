import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:quran_library/quran_library.dart';

import '../../../../core/utils/constants/extensions/svg_extensions.dart';
import '../../../../core/utils/constants/svg_constants.dart';
import '../../../../core/utils/helpers/app_text_styles.dart';
import '../../quran_page/quran.dart';

class TasmeeModeSection extends StatelessWidget {
  TasmeeModeSection({super.key});

  final quranCtrl = QuranController.instance;
  final tasmee = TasmeeCtrl.instance;

  @override
  Widget build(BuildContext context) {
    final lastReadPage = quranCtrl.state.box.read('last_page') ?? 1;
    return IntrinsicHeight(
      child: GestureDetector(
        onTap: () async {
          tasmee.state.showAllWords.value = false;
          await tasmee.enterTasmeeMode();
          Get.to(
            () => QuranHome(isTasmeeMode: true),
            transition: Transition.downToUp,
          );
          Future.delayed(const Duration(milliseconds: 300), () {
            quranCtrl.changeSurahListOnTap(lastReadPage);
          });
        },
        child: Row(
          children: [
            Container(
              width: 8,
              decoration: BoxDecoration(
                color: context.theme.primaryColorLight,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Expanded(
              child: Container(
                height: 55,
                width: Get.width,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: context.theme.primaryColorLight.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: Get.width,
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          color: context.theme.primaryColorLight.withValues(
                            alpha: .1,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          'midadWelcome'.tr,
                          style: AppTextStyles.titleSmall(
                            color: context.theme.colorScheme.inversePrimary,
                          ),
                          textAlign: .center,
                          maxLines: 1,
                          // overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const Gap(8),
                    // Leading Midad icon
                    customSvgWithCustomColor(
                      SvgPath.svgHomeQuranLogo,
                      height: 32,
                      width: 22,
                      color: context.theme.primaryColorLight,
                    ),
                    const Gap(8),
                    Expanded(
                      child: Container(
                        width: Get.width,
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          color: context.theme.primaryColorLight.withValues(
                            alpha: .1,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          'midadWelcome'.tr,
                          style: AppTextStyles.titleSmall(
                            color: context.theme.colorScheme.inversePrimary,
                          ),
                          textAlign: .center,
                          maxLines: 1,
                          // overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 8,
              decoration: BoxDecoration(
                color: context.theme.primaryColorLight,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
