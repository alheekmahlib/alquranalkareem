import 'package:alquranalkareem/core/utils/constants/svg_constants.dart';
import 'package:alquranalkareem/core/utils/helpers/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants/extensions/svg_extensions.dart';

class DeleteWidget extends StatelessWidget {
  const DeleteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: const BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              customSvgWithColor(
                height: 18,
                SvgPath.svgHomeRemove,
                color: Colors.white,
              ),
              Text(
                'delete'.tr,
                style: AppTextStyles.titleMedium(color: Colors.white),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              customSvgWithColor(
                height: 18,
                SvgPath.svgHomeRemove,
                color: Colors.white,
              ),
              Text(
                'delete'.tr,
                style: AppTextStyles.titleMedium(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
