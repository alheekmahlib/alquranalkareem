part of 'prayers.dart';

class PrayerBuild extends StatelessWidget {
  PrayerBuild({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdhanController>(builder: (adhanCtrl) {
      return SizedBox(
        height: 300,
        child: Wrap(
          children: List.generate(adhanCtrl.prayerNameList.length, (index) {
            final prayerList = adhanCtrl.prayerNameList.toList();
            final prayerTitle = prayerList[index]['title'];
            final String prayerTime = prayerList[index]['time'];
            return GestureDetector(
              onTap: () => Get.bottomSheet(
                  PrayerDetails(
                    index: index,
                    prayerName: prayerTitle,
                  ),
                  isScrollControlled: true),
              child: Container(
                height: 50,
                width: Get.width,
                margin:
                    const EdgeInsets.symmetric(horizontal: 32.0, vertical: 4.0),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                    border: Border.all(
                      color: adhanCtrl.getCurrentSelectedPrayer(index).value
                          ? context.theme.colorScheme.surface
                          : Theme.of(context).canvasColor,
                      width: adhanCtrl.getCurrentSelectedPrayer(index).value
                          ? 2
                          : 1,
                      strokeAlign: BorderSide.strokeAlignInside,
                    )),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: Get.width * .7,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6.0, vertical: 2.0),
                      margin: const EdgeInsets.symmetric(horizontal: 6.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor.withOpacity(.2),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Icon(
                              adhanCtrl.prayerNameList[index]['icon'],
                              size: 20,
                              color: adhanCtrl
                                      .getCurrentSelectedPrayer(index)
                                      .value
                                  ? context.theme.colorScheme.surface
                                  : context.theme.canvasColor,
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${prayerTitle}'.tr,
                                style: TextStyle(
                                  fontFamily: 'kufi',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).canvasColor,
                                ),
                              ),
                            ),
                          ),
                          const Gap(32),
                          Expanded(
                            flex: 4,
                            child: Text(
                              prayerTime.toString(),
                              style: TextStyle(
                                fontFamily: 'kufi',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).canvasColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    index == 5 || index == 6
                        ? const SizedBox.shrink()
                        : IconButton(
                            onPressed: () => Get.bottomSheet(
                                activePrayerWidget(context, index),
                                isScrollControlled: true),
                            icon: Icon(
                              adhanCtrl.getIsAlarmed(prayerTitle).value
                                  ? Icons.alarm_off_outlined
                                  : Icons.alarm_on_outlined,
                              size: 24,
                            ),
                            color: adhanCtrl.getIsAlarmed(prayerTitle).value
                                ? Theme.of(context).canvasColor.withOpacity(.2)
                                : Theme.of(context).canvasColor,
                          )
                  ],
                ),
              ),
            );
          }),
        ),
      );
    });
  }

  Widget activePrayerWidget(BuildContext context, int index) {
    return GetBuilder<AdhanController>(builder: (adhanCtrl) {
      return Container(
        height: 290,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Container(
              height: 40,
              width: Get.width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.theme.focusColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'notificationOptions'.tr,
                style: TextStyle(
                  fontFamily: 'kufi',
                  fontSize: 20,
                  color: Theme.of(context).canvasColor,
                ),
              ),
            ),
            const Gap(16),
            Column(
              children: List.generate(
                notificationOptions.length,
                (i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: GestureDetector(
                    onTap: () => adhanCtrl.notificationOptionsOnTap(i, index),
                    child: Row(
                      children: [
                        Icon(
                          notificationOptions[i]['icon'],
                          size: 28,
                          color: context.theme.canvasColor,
                        ),
                        const Gap(16),
                        Text(
                          notificationOptions[i]['title'],
                          style: TextStyle(
                            fontFamily: 'kufi',
                            fontSize: 24,
                            color: Theme.of(context).canvasColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
