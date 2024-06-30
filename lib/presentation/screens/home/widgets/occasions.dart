import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/core/utils/constants/extensions/extensions.dart';
import '../../../../core/utils/constants/lists.dart';
import '../../../controllers/count_down_controller.dart';
import 'occasion_widget.dart';

class OccasionsWidget extends StatelessWidget {
  OccasionsWidget({super.key});

  final countdownCtrl = CountdownController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SafeArea(
        child: Container(
          color: Theme.of(context).colorScheme.primary,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                  'assets/svg/hijri/${countdownCtrl.hijriNow.hMonth}.svg',
                  width: Get.width,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).canvasColor.withOpacity(.05),
                      BlendMode.srcIn)),
              ListView(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    SvgPicture.asset(
                        'assets/svg/hijri/${countdownCtrl.hijriNow.hMonth}.svg',
                        width: 150,
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).canvasColor, BlendMode.srcIn)),
                    const Gap(16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        children: [
                          Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                text: countdownCtrl.isNewHadith
                                    ? monthHadithsList[
                                            countdownCtrl.hijriNow.hMonth - 1]
                                        ['hadithPart1']
                                    : monthHadithsList[1]['hadithPart1'],
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: 'naskh',
                                  height: 1.9,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .canvasColor
                                      .withOpacity(.7),
                                ),
                              ),
                              TextSpan(
                                text: countdownCtrl.isNewHadith
                                    ? monthHadithsList[
                                            countdownCtrl.hijriNow.hMonth - 1]
                                        ['hadithPart2']
                                    : monthHadithsList[1]['hadithPart2'],
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: 'naskh',
                                  height: 1.9,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffffffff),
                                ),
                              ),
                              TextSpan(
                                text: countdownCtrl.isNewHadith
                                    ? monthHadithsList[
                                            countdownCtrl.hijriNow.hMonth - 1]
                                        ['bookName']
                                    : monthHadithsList[1]['bookName'],
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'naskh',
                                  height: 1.7,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .canvasColor
                                      .withOpacity(.7),
                                ),
                              ),
                            ]),
                            textAlign: TextAlign.justify,
                          ),
                          const Gap(16.0),
                          context.hDivider(width: Get.width),
                        ],
                      ),
                    ),
                    const Gap(16.0),
                    Text(
                      '${'${countdownCtrl.hijriNow.hYear}'.convertNumbers()} ${'AH'.tr}',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontFamily: 'kufi',
                        color: Theme.of(context).canvasColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(16.0),
                    Column(
                      children: List.generate(
                        occasionList.length,
                        (i) => OccasionWidget(
                          name: '${occasionList[i]['title']}'.tr,
                          year: countdownCtrl.hijriNow.hYear,
                          month: occasionList[i]['month'],
                          day: occasionList[i]['day'],
                        ),
                      ),
                    ),
                    context.hDivider(width: Get.width),
                    const Gap(16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        'hijriNote'.tr,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'kufi',
                          height: 1.7,
                          color: Theme.of(context).canvasColor.withOpacity(.7),
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}
