part of '../events.dart';

class AllCalculatingEventsWidget extends StatelessWidget {
  final eventsCtrl = EventController.instance;

  AllCalculatingEventsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return
    // Stack(
    //   alignment: Alignment.center,
    //   children: [
    //     customSvgWithColor(
    //       'assets/svg/hijri/${eventsCtrl.hijriNow.hMonth}.svg',
    //       width: Get.width,
    //       color: context.theme.primaryColorLight.withValues(alpha: .01),
    //     ),
    Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const Gap(8),
        context.customOrientation(
          context.customArrowDown(close: () {}),
          const SizedBox.shrink(),
        ),
        const Gap(8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            height: context.customOrientation(
              Get.height * .57,
              Get.height * .9,
            ),
            child: ListView(
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: eventsCtrl.isNewHadith
                            ? monthHadithsList[eventsCtrl.hijriNow.hMonth -
                                  1]['hadithPart1']
                            : monthHadithsList[1]['hadithPart1'],
                        style: AppTextStyles.titleMedium(),
                      ),
                      TextSpan(
                        text: eventsCtrl.isNewHadith
                            ? monthHadithsList[eventsCtrl.hijriNow.hMonth -
                                  1]['hadithPart2']
                            : monthHadithsList[1]['hadithPart2'],
                        style: AppTextStyles.titleMedium(),
                      ),
                      TextSpan(
                        text: eventsCtrl.isNewHadith
                            ? monthHadithsList[1]['bookName']
                            : monthHadithsList[eventsCtrl.hijriNow.hMonth -
                                  1]['bookName'],
                        style: AppTextStyles.titleMedium().copyWith(
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.justify,
                ),
                const Gap(8.0),
                context.hDivider(width: Get.width),
                const Gap(8.0),
                Column(
                  children: [
                    Obx(() {
                      if (eventsCtrl.events.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: eventsCtrl.events.length,
                          itemBuilder: (context, i) =>
                              !eventsCtrl.notReminderIndex.contains(
                                eventsCtrl.events[i].id,
                              )
                              ? const SizedBox.shrink()
                              : CalculatingDateEventsWidget(
                                  name: eventsCtrl.events[i].title.tr,
                                  year: eventsCtrl.hijriNow.hYear,
                                  month: eventsCtrl.events[i].month,
                                  day: eventsCtrl.events[i].day.first,
                                ),
                        );
                      }
                    }),
                    context.hDivider(width: Get.width),
                    const Gap(16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'hijriNote'.tr,
                        style: AppTextStyles.titleMedium().copyWith(
                          fontSize: 14.0,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const Gap(16.0),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
      //   ),
      // ],
    );
  }
}
