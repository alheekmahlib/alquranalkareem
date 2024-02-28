import 'dart:io';

import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/handler_animation.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../presentation/controllers/general_controller.dart';
import '../../../services/services_locator.dart';
import '../shared_preferences_constants.dart';
import '../svg_picture.dart';

extension ContextExtensions on BuildContext {
  dynamic customOrientation(var n1, var n2) {
    Orientation orientation = MediaQuery.orientationOf(this);
    return orientation == Orientation.portrait ? n1 : n2;
  }

  dynamic definePlatform(var p1, var p2) =>
      (Platform.isIOS || Platform.isAndroid || Platform.isFuchsia) ? p1 : p2;

  Widget vDivider({double? height, Color? color}) {
    return Container(
      height: height ?? 20,
      width: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      color: color ?? Get.theme.colorScheme.surface,
    );
  }

  Widget hDivider({double? width, double? height, Color? color}) {
    return Container(
      height: height ?? 2,
      width: width ?? MediaQuery.sizeOf(this).width,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      color: color ?? Get.theme.colorScheme.surface,
    );
  }

  Widget customClose({var close, double? height}) {
    return Semantics(
      button: true,
      label: 'Close',
      child: GestureDetector(
        child: SvgPicture.asset(
          'assets/svg/close.svg',
          height: height ?? 30,
          width: 30,
        ),
        onTap: close ??
            () {
              Get.back();
            },
      ),
    );
  }

  Widget fontSizeDropDown({double? height}) {
    return PopupMenuButton(
      position: PopupMenuPosition.under,
      icon: Semantics(
        button: true,
        enabled: true,
        label: 'Change Font Size',
        child: font_size(height: height, color: Get.theme.colorScheme.surface),
      ),
      color: Get.theme.colorScheme.primary.withOpacity(.8),
      iconSize: height ?? 35.0,
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Obx(
            () => SizedBox(
              height: 30,
              width: MediaQuery.sizeOf(this).width,
              child: FlutterSlider(
                values: [sl<GeneralController>().fontSizeArabic.value],
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
                      color: Get.theme.colorScheme.background),
                ),
                handlerAnimation: const FlutterSliderHandlerAnimation(
                    curve: Curves.elasticOut,
                    reverseCurve: null,
                    duration: Duration(milliseconds: 700),
                    scale: 1.4),
                onDragging: (handlerIndex, lowerValue, upperValue) async {
                  lowerValue = lowerValue;
                  upperValue = upperValue;
                  sl<GeneralController>().fontSizeArabic.value = lowerValue;
                  await sl<SharedPreferences>()
                      .setDouble(FONT_SIZE, lowerValue);
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
