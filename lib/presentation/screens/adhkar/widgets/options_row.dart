import 'package:alquranalkareem/core/utils/helpers/app_text_styles.dart';
import 'package:alquranalkareem/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hijri_date/convert_number_extension.dart';

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
    return GetBuilder<AzkarController>(
      builder: (azkarCtrl) {
        return Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 35,
                width: 8,
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
              ),
              const Gap(8.0),
              customSvgWithCustomColor(
                SvgPath.svgSliderIc2,
                height: 25,
                color: context.theme.primaryColorLight,
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
                    CustomButton(
                      height: 35,
                      width: 35,
                      iconSize: 25,
                      isCustomSvgColor: true,
                      svgColor: context.theme.primaryColorLight,
                      svgPath: SvgPath.svgQuranCopy,
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(
                            text:
                                '${zekr.category}\n\n${zekr.zekr}\n\n| ${zekr.description}. | (التكرار: ${zekr.count})',
                          ),
                        ).then(
                          (value) => context.showCustomErrorSnackBar(
                            'copyAzkarText'.tr,
                          ),
                        );
                      },
                    ),
                    Obx(
                      () => CustomButton(
                        height: 35,
                        width: 35,
                        iconSize: 25,
                        isCustomSvgColor: true,
                        svgColor:
                            azkarCtrl
                                .hasBookmark(zekr.category, zekr.zekr)
                                .value
                            ? context.theme.primaryColorDark
                            : context.theme.primaryColorLight,
                        svgPath: SvgPath.svgQuranBookmark,
                        onPressed: () async {
                          azkarCtrl.hasBookmark(zekr.category, zekr.zekr).value
                              ? azkarCtrl.deleteAdhkar(zekr)
                              : await azkarCtrl.addAdhkar(
                                  AdhkarData(
                                    id: zekr.id,
                                    category: zekr.category,
                                    count: zekr.count,
                                    description: zekr.description,
                                    reference: zekr.reference,
                                    zekr: zekr.zekr,
                                  ),
                                );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    color: Theme.of(context).primaryColorDark,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        zekr.count.convertNumbers(
                          Get.locale?.languageCode ?? 'ar',
                        ),
                        style: AppTextStyles.titleSmall(
                          height: .9,
                          color: Theme.of(context).canvasColor,
                        ),
                      ),
                      const Gap(5),
                      customSvgWithColor(
                        height: 20,
                        SvgPath.svgAudioLoop,
                        color: Theme.of(context).canvasColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
