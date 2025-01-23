import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/handler_animation.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '/core/utils/constants/svg_constants.dart';
import '../../../../presentation/controllers/general/general_controller.dart';
import '../../../services/services_locator.dart';
import '../shared_preferences_constants.dart';

extension FontSizeExtension on Widget {
  Widget fontSizeDropDown({double? height, Color? color}) {
    final box = GetStorage();
    return PopupMenuButton(
      position: PopupMenuPosition.under,
      icon: Semantics(
        button: true,
        enabled: true,
        label: 'Change Font Size',
        child: Transform.translate(
          offset: const Offset(0, -5),
          child: customSvgWithColor(SvgPath.svgFontSize,
              height: height, color: color ?? Get.theme.colorScheme.surface),
        ),
      ),
      color: Get.theme.colorScheme.primary.withValues(alpha: .8),
      iconSize: height ?? 35.0,
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Obx(
            () => SizedBox(
              height: 30,
              width: MediaQuery.sizeOf(context).width,
              child: FlutterSlider(
                values: [sl<GeneralController>().state.fontSizeArabic.value],
                max: 50,
                min: 20,
                rtl: true,
                trackBar: FlutterSliderTrackBar(
                  inactiveTrackBarHeight: 5,
                  activeTrackBarHeight: 5,
                  inactiveTrackBar: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Get.theme.colorScheme.surface,
                  ),
                  activeTrackBar: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Get.theme.colorScheme.primaryContainer),
                ),
                handlerAnimation: const FlutterSliderHandlerAnimation(
                    curve: Curves.elasticOut,
                    reverseCurve: null,
                    duration: Duration(milliseconds: 700),
                    scale: 1.4),
                onDragging: (handlerIndex, lowerValue, upperValue) async {
                  lowerValue = lowerValue;
                  upperValue = upperValue;
                  sl<GeneralController>().state.fontSizeArabic.value =
                      lowerValue;

                  box.write(FONT_SIZE, lowerValue);
                },
                handler: FlutterSliderHandler(
                  decoration: const BoxDecoration(),
                  child: Material(
                    type: MaterialType.circle,
                    color: Colors.transparent,
                    elevation: 3,
                    child: SvgPicture.asset('assets/svg/slider_ic.svg'),
                  ),
                ),
              ),
            ),
          ),
          height: 30,
        ),
      ],
    );
  }
}
