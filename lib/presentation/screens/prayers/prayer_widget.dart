part of 'prayers.dart';

class PrayerWidget extends StatelessWidget {
  PrayerWidget({super.key});

  // final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdhanController>(builder: (adhanCtrl) {
      return Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 80,
                      color: Theme.of(context).canvasColor.withOpacity(.1),
                    ),
                    Column(
                      children: [
                        Text(
                          Location.instance.city,
                          style: TextStyle(
                            fontFamily: 'kufi',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).canvasColor,
                          ),
                        ),
                        Text(
                          Location.instance.country,
                          style: TextStyle(
                            fontFamily: 'kufi',
                            fontSize: 12,
                            color: Theme.of(context).canvasColor,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Obx(() => ArcProgressBar(
                    percentage: adhanCtrl.state.timeProgress.value,
                    arcThickness: 10,
                    innerPadding: 48,
                    strokeCap: StrokeCap.round,
                    bottomCenterWidget: Column(
                      children: [
                        Text(
                          adhanCtrl.getNextPrayerDetails.prayerName,
                          style: TextStyle(
                            fontFamily: 'kufi',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).canvasColor,
                          ),
                        ),
                        Text(
                          adhanCtrl.getNextPrayerDetails.prayerDisplayName ??
                              "No Name Available",
                          style: TextStyle(
                            fontFamily: 'kufi',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).canvasColor,
                          ),
                        ),
                        SlideCountdownWidget(fontSize: 18),
                      ],
                    ),
                    handleSize: 100,
                    handleWidget: adhanCtrl.LottieWidget,
                    foregroundColor: const Color(0xffa22c08).withOpacity(.6),
                    backgroundColor: Theme.of(context).canvasColor,
                  )),
            ],
          ),
          PrayerBuild(),
        ],
      );
    });
  }
}
