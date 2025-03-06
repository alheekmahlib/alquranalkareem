import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/custom_error_snackBar.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../../core/utils/constants/svg_constants.dart';
import '../../../../database/bookmark_db/bookmark_database.dart';
import '../controller/adhkar_controller.dart';
import 'share/share_dhekr_options.dart';

class OptionsRow extends StatelessWidget {
  final AdhkarData zekr;
  final bool azkarFav;

  OptionsRow({super.key, required this.zekr, required this.azkarFav});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AzkarController>(builder: (azkarCtrl) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: .15),
            borderRadius: const BorderRadius.all(Radius.circular(4))),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: customSvgWithColor(
                SvgPath.svgSliderIc2,
                height: 25,
              ),
            ),
            Expanded(
              flex: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ShareDhekrOptions(
                    zekrText: zekr.zekr,
                    category: zekr.category,
                    reference: zekr.reference,
                    description: zekr.description,
                    count: zekr.count,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Clipboard.setData(ClipboardData(
                              text:
                                  '${zekr.category}\n\n${zekr.zekr}\n\n| ${zekr.description}. | (التكرار: ${zekr.count})'))
                          .then((value) => context
                              .showCustomErrorSnackBar('copyAzkarText'.tr));
                    },
                    child: Semantics(
                      button: true,
                      enabled: true,
                      label: 'copy'.tr,
                      child: customSvgWithColor(
                        SvgPath.svgCopyIcon,
                        height: 20,
                      ),
                    ),
                  ),
                  Obx(() => GestureDetector(
                        onTap: () async {
                          azkarCtrl.hasBookmark(zekr.category, zekr.zekr).value
                              ? azkarCtrl.deleteAdhkar(zekr)
                              : await azkarCtrl.addAdhkar(AdhkarData(
                                  id: zekr.id,
                                  category: zekr.category,
                                  count: zekr.count,
                                  description: zekr.description,
                                  reference: zekr.reference,
                                  zekr: zekr.zekr));
                        },
                        child: Semantics(
                          button: true,
                          enabled: true,
                          label: 'addToBookmark'.tr,
                          child: azkarCtrl
                                  .hasBookmark(zekr.category, zekr.zekr)
                                  .value
                              ? customSvg(
                                  SvgPath.svgBookmarkIcon2,
                                  height: 23,
                                )
                              : customSvg(
                                  SvgPath.svgBookmarkIcon,
                                  height: 20,
                                ),
                        ),
                      )),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Row(
                  children: [
                    Text(
                      zekr.count,
                      style: TextStyle(
                          color: Get.isDarkMode
                              ? Colors.white
                              : Theme.of(context).colorScheme.primaryContainer,
                          fontSize: 14,
                          fontFamily: 'kufi',
                          fontStyle: FontStyle.italic),
                    ),
                    const Gap(5),
                    Icon(
                      Icons.repeat,
                      color: Get.isDarkMode
                          ? Colors.white
                          : Theme.of(context).colorScheme.primaryContainer,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
