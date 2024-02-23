import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../controllers/azkar_controller.dart';
import '../widgets/options_row.dart';
import '../widgets/text_widget.dart';

class AzkarFav extends StatelessWidget {
  const AzkarFav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final azkarCtrl = sl<AzkarController>();
    azkarCtrl.getAzkar();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (azkarCtrl.azkarList.isEmpty) {
                return open_book(height: 250.0, width: 250.0);
              } else {
                return AnimationLimiter(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ListView.builder(
                        shrinkWrap: true,
                        controller: azkarCtrl.favController,
                        padding: EdgeInsets.zero,
                        itemCount: azkarCtrl.azkarList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var azkar = azkarCtrl.azkarList[index];
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 450),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Gap(32),
                                      OptionsRow(
                                        zekr: azkar,
                                      ),
                                      TextWidget(
                                        zekr: azkar,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                );
              }
            }),
          )
        ],
      ),
    );
  }
}
