import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/lottie.dart';
import '../../../../core/utils/constants/lottie_constants.dart';
import '../controller/adhkar_controller.dart';
import '../widgets/options_row.dart';
import '../widgets/text_widget.dart';

class AdhkarFav extends StatelessWidget {
  const AdhkarFav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final azkarCtrl = AzkarController.instance;
    azkarCtrl.getAdhkar();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (azkarCtrl.state.adhkarList.isEmpty) {
                return customLottieWithColor(
                    LottieConstants.assetsLottieOpenBook,
                    height: 250.0,
                    width: 250.0);
              } else {
                return AnimationLimiter(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ListView.builder(
                        shrinkWrap: true,
                        controller: azkarCtrl.state.favController,
                        padding: EdgeInsets.zero,
                        itemCount: azkarCtrl.state.adhkarList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var azkar = azkarCtrl.state.adhkarList[index];
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
                                        azkarFav: true,
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
