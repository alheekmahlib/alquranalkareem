part of '../prayers.dart';

class PrayerProgressWidget extends StatelessWidget {
  PrayerProgressWidget({super.key});

  final prayerPBCtrl = PrayerProgressController.instance;
  final adhanCtrl = AdhanController.instance;

  @override
  Widget build(BuildContext context) {
    final stepTimes = [
      adhanCtrl.state.prayerTimes.fajr,
      adhanCtrl.state.prayerTimes.dhuhr,
      adhanCtrl.state.prayerTimes.asr,
      adhanCtrl.state.prayerTimes.maghrib,
      adhanCtrl.state.prayerTimes.isha,
    ];

    final stepIcons = [
      SolarIconsBold.moonFog,
      SolarIconsBold.sun,
      SolarIconsBold.sun2,
      SolarIconsBold.sunset,
      SolarIconsBold.moon,
    ];
    return Container(
      // width: 40,
      height: 160,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 1,
              offset: const Offset(0, -5)),
        ],
      ),
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.surface,
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      adhanCtrl.prayerNameList[adhanCtrl.currentPrayer + 1]
                          ['icon']!,
                      color: Theme.of(context).canvasColor.withOpacity(.2),
                      size: 70,
                    ),
                    Text(
                      adhanCtrl.getNextPrayerDetails.prayerName.tr,
                      style: TextStyle(
                        fontFamily: 'kufi',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).canvasColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      adhanCtrl.getNextPrayerDetails.prayerDisplayName ??
                          "No Name Available",
                      style: TextStyle(
                        fontFamily: 'kufi',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).canvasColor,
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 30,
                          width: 140,
                          decoration: BoxDecoration(
                              color: Theme.of(Get.context!).colorScheme.surface,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0))),
                        ),
                        Transform.translate(
                          offset: const Offset(0, 2),
                          child: SlideCountdownWidget(fontSize: 22),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const Gap(8),
            Obx(() => Row(
                  children: [
                    VerticalProgressBar(
                      progress: prayerPBCtrl.progress.value,
                      backgroundColor:
                          Theme.of(context).canvasColor.withOpacity(.2),
                      progressColor: Theme.of(context).colorScheme.surface,
                      borderWidth: 3,
                      widthShadow: 6,
                      borderRadius: BorderRadius.circular(8),
                      stepTimes: stepTimes,
                      stepIcons: stepIcons,
                      startTime: prayerPBCtrl.adhanCtrl.state.prayerTimes.fajr
                          .subtract(const Duration(hours: 3)),
                      endTime: prayerPBCtrl.adhanCtrl.state.prayerTimes.isha
                          .add(const Duration(hours: 4)),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
