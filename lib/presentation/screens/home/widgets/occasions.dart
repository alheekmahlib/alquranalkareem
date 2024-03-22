import 'package:alquranalkareem/core/utils/constants/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lists.dart';
import '/presentation/controllers/general_controller.dart';
import 'occasion_widget.dart';

class OccasionsWidget extends StatelessWidget {
  OccasionsWidget({super.key});

  final generalCtrl = sl<GeneralController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * .94,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset('assets/svg/hijri/${generalCtrl.today.hMonth}.svg',
              width: Get.width,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).canvasColor.withOpacity(.05),
                  BlendMode.srcIn)),
          context.customOrientation(
              Column(
                children: [
                  const Gap(16.0),
                  context.customClose(),
                  const Gap(16.0),
                  Flexible(
                    child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          SvgPicture.asset(
                              'assets/svg/hijri/${generalCtrl.today.hMonth}.svg',
                              width: 150,
                              colorFilter: ColorFilter.mode(
                                  Theme.of(context).canvasColor,
                                  BlendMode.srcIn)),
                          const Gap(16.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Column(
                              children: [
                                Text.rich(
                                  TextSpan(children: [
                                    TextSpan(
                                      text:
                                          ' كَانَ أَصْحَابُ رَسُولِ اللهِ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ، يَتَعَلَّمُونَ هَذَا الدُّعَاءَ كَمَا يَتَعَلَّمُونَ القُرآنَ إِذَا دَخَل الشَّهْرُ أَوِ السَّنَةُ: ',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontFamily: 'kufi',
                                        height: 1.9,
                                        color: Theme.of(context)
                                            .canvasColor
                                            .withOpacity(.7),
                                      ),
                                    ),
                                    const TextSpan(
                                      text:
                                          'اللَّهُمَّ أَدْخِلْهُ عَلَيْنَا بِالْأَمْنِ، وَالْإِيمَانِ، وَالسَّلَامَةِ، وَالْإِسْلَامِ، وَجوار مِنَ الشَّيْطَانِ، وَرِضْوَانٍ مِنَ الرَّحْمَنِ ".\n\n',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontFamily: 'kufi',
                                        height: 1.9,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          'صححه الحافظ ابن حجر في "الإصابة" (6 / 407 - 408)',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: 'kufi',
                                        height: 1.7,
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
                            '${generalCtrl.convertNumbers('${generalCtrl.today.hYear}')} ${'AH'.tr}',
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
                                month: occasionList[i]['month'],
                                day: occasionList[i]['day'],
                              ),
                            ),
                          ),
                          context.hDivider(width: Get.width),
                          const Gap(16.0),
                          Text(
                            '${generalCtrl.convertNumbers('${generalCtrl.today.hYear + 1}')} ${'AH'.tr}',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontFamily: 'kufi',
                              color: Theme.of(context).canvasColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Column(
                            children: List.generate(
                              occasionList.length,
                              (i) => OccasionNextWidget(
                                name: '${occasionList[i]['title']}'.tr,
                                month: occasionList[i]['month'],
                                day: occasionList[i]['day'],
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Column(
                              children: [
                                const Gap(16.0),
                                context.hDivider(width: Get.width),
                                const Gap(16.0),
                                Text(
                                  'hijriNote'.tr,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'kufi',
                                    height: 1.7,
                                    color: Theme.of(context)
                                        .canvasColor
                                        .withOpacity(.7),
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 4,
                      child: ListView(
                        children: [
                          const Gap(16.0),
                          context.customClose(),
                          const Gap(16.0),
                          SvgPicture.asset(
                              'assets/svg/hijri/${generalCtrl.today.hMonth}.svg',
                              width: 150,
                              colorFilter: ColorFilter.mode(
                                  Theme.of(context).canvasColor,
                                  BlendMode.srcIn)),
                          const Gap(16.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Column(
                              children: [
                                Text.rich(
                                  TextSpan(children: [
                                    TextSpan(
                                      text:
                                          ' كَانَ أَصْحَابُ رَسُولِ اللهِ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ، يَتَعَلَّمُونَ هَذَا الدُّعَاءَ كَمَا يَتَعَلَّمُونَ القُرآنَ إِذَا دَخَل الشَّهْرُ أَوِ السَّنَةُ: ',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontFamily: 'kufi',
                                        height: 1.9,
                                        color: Theme.of(context)
                                            .canvasColor
                                            .withOpacity(.7),
                                      ),
                                    ),
                                    const TextSpan(
                                      text:
                                          'اللَّهُمَّ أَدْخِلْهُ عَلَيْنَا بِالْأَمْنِ، وَالْإِيمَانِ، وَالسَّلَامَةِ، وَالْإِسْلَامِ، وَجوار مِنَ الشَّيْطَانِ، وَرِضْوَانٍ مِنَ الرَّحْمَنِ ".\n\n',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontFamily: 'kufi',
                                        height: 1.9,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          'صححه الحافظ ابن حجر في "الإصابة" (6 / 407 - 408)',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: 'kufi',
                                        height: 1.7,
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
                        ],
                      )),
                  Expanded(
                    flex: 4,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        const Gap(16.0),
                        Column(
                          children: List.generate(
                            occasionList.length,
                            (i) => OccasionWidget(
                              name: '${occasionList[i]['title']}'.tr,
                              month: occasionList[i]['month'],
                              day: occasionList[i]['day'],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Column(
                            children: [
                              const Gap(16.0),
                              context.hDivider(width: Get.width),
                              const Gap(16.0),
                              Text(
                                'hijriNote'.tr,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'kufi',
                                  height: 1.7,
                                  color: Theme.of(context)
                                      .canvasColor
                                      .withOpacity(.7),
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
