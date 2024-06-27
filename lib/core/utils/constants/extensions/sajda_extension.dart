import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '/presentation/controllers/quran_controller.dart';
import '../../../services/services_locator.dart';
import '../svg_constants.dart';

extension SajdaExtension on Widget {
  Widget showVerseToast(int pageIndex) {
    log('checking sajda posision');
    sl<QuranController>().getAyahWithSajdaInPage(pageIndex);
    return sl<QuranController>().isSajda.value
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              customSvg(
                SvgPath.svgSajdaIcon,
                height: 15,
              ),
              const Gap(8),
              Text(
                'sajda'.tr,
                style: const TextStyle(
                  color: Color(0xff77554B),
                  fontFamily: 'kufi',
                  fontSize: 16,
                ),
              )
            ],
          )
        : const SizedBox.shrink();
  }
}
