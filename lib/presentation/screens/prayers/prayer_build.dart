part of 'prayers.dart';

class PrayerBuild extends StatelessWidget {
  PrayerBuild({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdhanController>(builder: (adhanCtrl) {
      return SizedBox(
        height: 300,
        child: Wrap(
          children: List.generate(
              adhanCtrl.prayerNameList.length,
              (index) => GestureDetector(
                    onTap: () => Get.bottomSheet(
                        PrayerDetails(
                          index: index,
                          prayerName: adhanCtrl.prayerNameList[index]['title'],
                        ),
                        isScrollControlled: true),
                    child: Container(
                      width: Get.width,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 4.0),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                          border: Border.all(
                            color:
                                adhanCtrl.getCurrentSelectedPrayer(index).value
                                    ? const Color(0xfff16938)
                                    : Theme.of(context).canvasColor,
                            width: 1,
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
                              color:
                                  Theme.of(context).canvasColor.withOpacity(.2),
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
                                        ? const Color(0xfff16938)
                                        : context.theme.canvasColor,
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      '${adhanCtrl.prayerNameList[index]['title']}'
                                          .tr,
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
                                    adhanCtrl.prayerNameList[index]['time']!
                                        .toString(),
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
                          IconButton(
                            onPressed: () => adhanCtrl.prayerAlarmSwitch(index),
                            icon: Icon(
                              adhanCtrl.getPrayerSelected(
                                  index,
                                  Icons.alarm_on_outlined,
                                  Icons.alarm_off_outlined),
                              size: 24,
                            ),
                            color: adhanCtrl.getPrayerSelected(
                                index,
                                Theme.of(context).canvasColor,
                                Theme.of(context).canvasColor.withOpacity(.2)),
                          )
                        ],
                      ),
                    ),
                  )),
        ),
      );
    });
  }
}
