import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/core/utils/constants/extensions/extensions.dart';
import '../../utils/constants/lists.dart';
import '../app_bar_widget.dart';
import 'calculating_date_events_widget.dart';
import 'controller/event_controller.dart';

class AllCalculatingEventsWidget extends StatelessWidget {
  AllCalculatingEventsWidget({super.key});

  final eventsCtrl = EventController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        isTitled: false,
        title: '',
        isFontSize: false,
        searchButton: const SizedBox.shrink(),
        color: context.theme.colorScheme.primary,
      ),
      body: SafeArea(
        child: Container(
          color: Theme.of(context).colorScheme.primary,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                  'assets/svg/hijri/${eventsCtrl.hijriNow.hMonth}.svg',
                  width: Get.width,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).canvasColor.withOpacity(.05),
                      BlendMode.srcIn)),
              ListView(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    SvgPicture.asset(
                        'assets/svg/hijri/${eventsCtrl.hijriNow.hMonth}.svg',
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
                                text: eventsCtrl.isNewHadith
                                    ? monthHadithsList[
                                            eventsCtrl.hijriNow.hMonth - 1]
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
                                text: eventsCtrl.isNewHadith
                                    ? monthHadithsList[
                                            eventsCtrl.hijriNow.hMonth - 1]
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
                                text: eventsCtrl.isNewHadith
                                    ? monthHadithsList[
                                            eventsCtrl.hijriNow.hMonth - 1]
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
                      '${'${eventsCtrl.hijriNow.hYear}'.convertNumbers()} ${'AH'.tr}',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontFamily: 'kufi',
                        color: Theme.of(context).canvasColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(16.0),
                    Obx(() {
                      if (eventsCtrl.events.isEmpty) {
                        return const Center(
                            child: CircularProgressIndicator.adaptive());
                      } else {
                        return Column(
                          children: List.generate(
                            eventsCtrl.events.length,
                            (i) => CalculatingDateEventsWidget(
                              name: eventsCtrl.events[i].title.tr,
                              year: eventsCtrl.hijriNow.hYear,
                              month: eventsCtrl.events[i].month,
                              day: eventsCtrl.events[i].day.first,
                            ),
                          ),
                        );
                      }
                    }),
                    // Column(
                    //   children: List.generate(
                    //     occasionList.length,
                    //     (i) => CalculatingDateEventsWidget(
                    //       name: '${occasionList[i]['title']}'.tr,
                    //       year: eventsCtrl.hijriNow.hYear,
                    //       month: occasionList[i]['month'],
                    //       day: occasionList[i]['day'],
                    //     ),
                    //   ),
                    // ),
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
