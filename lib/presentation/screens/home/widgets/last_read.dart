import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../controllers/general_controller.dart';
import '/core/utils/constants/extensions.dart';

class LastRead extends StatelessWidget {
  const LastRead({super.key});

  @override
  Widget build(BuildContext context) {
    final generalCtrl = sl<GeneralController>();
    return Container(
      height: 125,
      width: 380,
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Container(
              height: 125,
              width: 380,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withOpacity(.15),
                  borderRadius: const BorderRadius.all(Radius.circular(4))),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: SvgPicture.asset(
                      'assets/svg/surah_name/00${generalCtrl.soMName.value}.svg',
                      height: 60,
                      colorFilter: ColorFilter.mode(
                          Get.theme.cardColor, BlendMode.srcIn),
                    ),
                  ),
                  context.vDivider(height: 50),
                  Expanded(
                    flex: 7,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1)),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4))),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 2.0, vertical: 2.0),
                        child: Text(
                          '${'pageNo'.tr} ${generalCtrl.currentPage.value}',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'naskh',
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.secondary,
                              height: 1.5),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(100, -45),
            child: Container(
              height: 32,
              width: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(4))),
              child: Text(
                'lastRead'.tr,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'kufi',
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
