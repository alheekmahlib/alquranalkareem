import 'package:alquranalkareem/core/utils/constants/extensions/svg_extensions.dart';
import 'package:alquranalkareem/core/utils/constants/svg_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/core/utils/constants/extensions/extensions.dart';
import '/presentation/controllers/general_controller.dart';
import '../../../../core/utils/constants/lists.dart';
import 'occasion_widget.dart';
import 'prayer/prayer_settings.dart';
import 'prayer/prayer_widget.dart';

class OccasionsWidget extends StatelessWidget {
  OccasionsWidget({super.key});

  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          GestureDetector(
            onTap: () =>
                Get.bottomSheet(PrayerSettings(), isScrollControlled: true),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: customSvgWithColor(SvgPath.svgOptions,
                  height: 30.0,
                  width: 30.0,
                  color: Get.theme.colorScheme.secondary),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          color: Theme.of(context).colorScheme.primary,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                  'assets/svg/hijri/${generalCtrl.today.hMonth}.svg',
                  width: Get.width,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).canvasColor.withOpacity(.05),
                      BlendMode.srcIn)),
              context.customOrientation(
                  ListView(
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Obx(
                          () => !generalCtrl.activeLocation.value
                              ? Container(
                                  height: 80,
                                  width: Get.width,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .canvasColor
                                        .withOpacity(.1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Text(
                                          'يرجى تفعيل تحديد الموقع لتفعيل أوقات الصلاة',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontFamily: 'naskh',
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .canvasColor
                                                .withOpacity(.7),
                                          ),
                                        ),
                                      ),
                                      const Gap(32),
                                      Expanded(
                                        flex: 2,
                                        child: Switch(
                                          value:
                                              generalCtrl.activeLocation.value,
                                          activeColor: Colors.red,
                                          inactiveTrackColor: Theme.of(context)
                                              .colorScheme
                                              .surface
                                              .withOpacity(.5),
                                          onChanged: (bool value) => generalCtrl
                                              .toggleLocationService(),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : PrayerWidget(),
                        ),
                        SvgPicture.asset(
                            'assets/svg/hijri/${generalCtrl.today.hMonth}.svg',
                            width: 150,
                            colorFilter: ColorFilter.mode(
                                Theme.of(context).canvasColor,
                                BlendMode.srcIn)),
                        const Gap(16.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Column(
                            children: [
                              Text.rich(
                                TextSpan(children: [
                                  TextSpan(
                                    text: generalCtrl.isNewHadith
                                        ? monthHadithsList[generalCtrl
                                            .today.hMonth]['hadithPart1']
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
                                    text: generalCtrl.isNewHadith
                                        ? monthHadithsList[generalCtrl
                                            .today.hMonth]['hadithPart2']
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
                                    text: generalCtrl.isNewHadith
                                        ? monthHadithsList[generalCtrl
                                            .today.hMonth]['bookName']
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
                          '${'${generalCtrl.today.hYear}'.convertNumbers()} ${'AH'.tr}',
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
                          '${'${generalCtrl.today.hYear + 1}'.convertNumbers()} ${'AH'.tr}',
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
                            (i) => OccasionNextWidget(
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
                      ]),
                  Row(
                    children: [
                      Expanded(
                          flex: 4,
                          child: ListView(
                            children: [
                              const Gap(16.0),
                              Obx(
                                () => !generalCtrl.activeLocation.value
                                    ? Container(
                                        height: 80,
                                        width: Get.width,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 16.0),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 16.0),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .canvasColor
                                              .withOpacity(.1),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 7,
                                              child: Text(
                                                'يرجى تفعيل تحديد الموقع لتفعيل أوقات الصلاة',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontFamily: 'naskh',
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                      .canvasColor
                                                      .withOpacity(.7),
                                                ),
                                              ),
                                            ),
                                            const Gap(32),
                                            Expanded(
                                              flex: 2,
                                              child: Switch(
                                                value: generalCtrl
                                                    .activeLocation.value,
                                                activeColor: Colors.red,
                                                inactiveTrackColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .surface
                                                        .withOpacity(.5),
                                                onChanged: (bool value) =>
                                                    generalCtrl
                                                        .toggleLocationService(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : PrayerWidget(),
                              ),
                            ],
                          )),
                      Expanded(
                        flex: 4,
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
                                        text: generalCtrl.isNewHadith
                                            ? monthHadithsList[generalCtrl
                                                .today.hMonth]['hadithPart1']
                                            : monthHadithsList[1]
                                                ['hadithPart1'],
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontFamily: 'kufi',
                                          height: 1.9,
                                          color: Theme.of(context)
                                              .canvasColor
                                              .withOpacity(.7),
                                        ),
                                      ),
                                      TextSpan(
                                        text: generalCtrl.isNewHadith
                                            ? monthHadithsList[generalCtrl
                                                .today.hMonth]['hadithPart2']
                                            : monthHadithsList[1]
                                                ['hadithPart2'],
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          fontFamily: 'kufi',
                                          height: 1.9,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                      TextSpan(
                                        text: generalCtrl.isNewHadith
                                            ? monthHadithsList[generalCtrl
                                                .today.hMonth]['bookName']
                                            : monthHadithsList[1]['bookName'],
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
                              '${'${generalCtrl.today.hYear + 1}'.convertNumbers()} ${'AH'.tr}',
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
                          ],
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
