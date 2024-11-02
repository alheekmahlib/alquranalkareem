part of '../../prayers.dart';

class AdhanSounds extends StatelessWidget {
  AdhanSounds({super.key});

  final notificationCtrl = PrayersNotificationsCtrl.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.bottomSheet(
          Container(
            width: context.customOrientation(Get.width, Get.width / 1 / 2),
            height:
                context.customOrientation(Get.height * .9, Get.height / 1 / 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
            child: FutureBuilder<List<AdhanData>>(
                future: notificationCtrl.state.adhanData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: context.customClose(height: 40),
                              ),
                              context.vDivider(height: 30),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(
                                  'adhanSounds'.tr,
                                  style: TextStyle(
                                    fontFamily: 'kufi',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).canvasColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Flexible(
                            child: ListView(
                              children: List.generate(
                                snapshot.data!.length,
                                (index) => adhanListBuild(context, index),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  }
                }),
          ),
          isScrollControlled: true),
      child: Container(
        height: 60,
        width: Get.width,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor.withOpacity(.1),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'adhanSounds'.tr,
              style: TextStyle(
                fontFamily: 'kufi',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).canvasColor,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              size: 24,
              color: Theme.of(context).canvasColor,
            )
          ],
        ),
      ),
    );
  }

  Widget adhanListBuild(BuildContext context, int index) {
    final notificationCtrl = sl<PrayersNotificationsCtrl>();
    return FutureBuilder<List<AdhanData>>(
        future: notificationCtrl.state.adhanData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<AdhanData> adhans = snapshot.data!;
            return Obx(() => Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                      border: Border.all(
                          color: notificationCtrl
                                      .state.selectedAdhanPath.value ==
                                  notificationCtrl.state.downloadedAdhanData
                                      .firstWhereOrNull((e) => e.index == index)
                                      ?.path
                              ? Theme.of(context).colorScheme.surface
                              : Theme.of(context).canvasColor.withOpacity(.5),
                          width: notificationCtrl
                                      .state.selectedAdhanPath.value ==
                                  notificationCtrl.state.downloadedAdhanData
                                      .firstWhereOrNull((e) => e.index == index)
                                      ?.path
                              ? 2
                              : 1)),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 10,
                        child: Container(
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  adhans[index].adhanName,
                                  style: TextStyle(
                                      color: Theme.of(context).canvasColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'kufi'),
                                  textAlign: TextAlign.center,
                                ),
                                PlayButton(
                                  adhanData: adhans,
                                  index: index,
                                ),
                              ],
                            ),
                            // leading: PlayButton(),
                            onTap: () => notificationCtrl
                                .selectAdhanOnTap(adhans[index].index),
                          ),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).canvasColor.withOpacity(.2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Obx(() {
                          bool isDownloading = notificationCtrl
                              .isAdhanDownloadedByIndex(index)
                              .value;
                          return isDownloading
                              ? Icon(Icons.done,
                                  size: 22,
                                  color: Theme.of(context).colorScheme.primary)
                              : Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Obx(
                                      () => SquarePercentIndicator(
                                        width: 40,
                                        height: 40,
                                        borderRadius: 4,
                                        shadowWidth: 1.5,
                                        progressWidth: 2,
                                        shadowColor: Colors.transparent,
                                        progressColor: index ==
                                                notificationCtrl
                                                    .state.downloadIndex.value
                                            ? notificationCtrl
                                                    .state.isDownloading.value
                                                ? Theme.of(context).canvasColor
                                                : Colors.transparent
                                            : Colors.transparent,
                                        progress: notificationCtrl
                                            .state.progress.value,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                          // notificationCtrl.adhanDownloadIndex
                                          //         .contains(index)
                                          //     ? Icons.check
                                          //     :
                                          Icons.cloud_download_outlined,
                                          size: 22,
                                          color: Theme.of(context).canvasColor),
                                      onPressed: () async {
                                        await notificationCtrl
                                            .adhanDownload(adhans[index]);
                                      },
                                    ),
                                  ],
                                );
                        }),
                      ),
                    ],
                  ),
                ));
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        });
  }
}
