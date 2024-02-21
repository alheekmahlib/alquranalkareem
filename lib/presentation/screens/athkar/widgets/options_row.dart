import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/svg_picture.dart';
import '../../../controllers/azkar_controller.dart';
import '../models/zeker_model.dart';
import '/core/utils/constants/extensions/custom_error_snackBar.dart';

class OptionsRow extends StatelessWidget {
  var zekr;
  OptionsRow({super.key, this.zekr});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(.15),
          borderRadius: const BorderRadius.all(Radius.circular(4))),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 2, child: slider_ic2(height: 25)),
          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Share.share('${zekr.category}\n\n'
                        '${zekr.zekr}\n\n'
                        '| ${zekr.description}. | (التكرار: ${zekr.count})');
                  },
                  child: Semantics(
                    button: true,
                    enabled: true,
                    label: 'share'.tr,
                    child: Icon(
                      Icons.share,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ),
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
                    child: Icon(
                      Icons.copy,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await sl<AzkarController>()
                        .addAzkar(Zekr(
                            id: zekr.id,
                            category: zekr.category,
                            count: zekr.count,
                            description: zekr.description,
                            reference: zekr.reference,
                            zekr: zekr.zekr))
                        .then((value) => context
                            .showCustomErrorSnackBar('addZekrBookmark'.tr));
                  },
                  child: Semantics(
                    button: true,
                    enabled: true,
                    label: 'addToBookmark'.tr,
                    child: Icon(
                      Icons.bookmark_add,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ),
                ),
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
                            : Theme.of(context).colorScheme.background,
                        fontSize: 14,
                        fontFamily: 'kufi',
                        fontStyle: FontStyle.italic),
                  ),
                  const Gap(5),
                  Icon(
                    Icons.repeat,
                    color: Get.isDarkMode
                        ? Colors.white
                        : Theme.of(context).colorScheme.background,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
