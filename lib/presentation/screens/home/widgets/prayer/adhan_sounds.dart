import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../controllers/notification_controller.dart';
import '../../data/model/adhan_data.dart';
import '/core/utils/constants/extensions/extensions.dart';
import 'play_button.dart';

class AdhanSounds extends StatelessWidget {
  AdhanSounds({super.key});

  final notificationCtrl = sl<NotificationController>();

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
                future: notificationCtrl.adhanData,
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Stack(
                      children: [
                        context.customClose(),
                        Padding(
                          padding: const EdgeInsets.only(top: 55),
                          child: ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        'محمل',
                                        style: TextStyle(
                                          color: Theme.of(context).canvasColor,
                                          fontSize: 18,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: context.hDivider(width: Get.width),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: List.generate(
                                    snapshot.data!.length,
                                    (index) => Obx(() => notificationCtrl
                                            .adhanDownloadIndex
                                            .contains(index)
                                        ? adhanListBuild(context, index)
                                        : const SizedBox.shrink())),
                              ),
                              const Gap(32),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        'غير محملة',
                                        style: TextStyle(
                                          color: Theme.of(context).canvasColor,
                                          fontSize: 18,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: context.hDivider(width: Get.width),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: List.generate(
                                    snapshot.data!.length,
                                    (index) => Obx(() => notificationCtrl
                                            .adhanDownloadIndex
                                            .contains(index)
                                        ? const SizedBox.shrink()
                                        : adhanListBuild(context, index))),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
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
              'أصوات الأذان',
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
    final notificationCtrl = sl<NotificationController>();
    return FutureBuilder<List<AdhanData>>(
        future: notificationCtrl.adhanData,
        builder: (context, snapshot) {
          if (snapshot.data!.isNotEmpty &&
              snapshot.connectionState == ConnectionState.done) {
            final adhanData = snapshot.data![index];
            return Obx(() => Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                      border: Border.all(
                          color: notificationCtrl.adhanSoundSelect.value ==
                                  index
                              ? Theme.of(context).canvasColor
                              : Theme.of(context).canvasColor.withOpacity(.5),
                          width:
                              notificationCtrl.adhanSoundSelect.value == index
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
                                  adhanData.adhan.first.partOfAdhanName,
                                  style: TextStyle(
                                      color: Theme.of(context).canvasColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'kufi'),
                                  textAlign: TextAlign.center,
                                ),
                                PlayButton(
                                  adhanData: adhanData,
                                  index: index + 1,
                                ),
                              ],
                            ),
                            // leading: PlayButton(),
                            onTap: () {},
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
                          bool isDownloading =
                              notificationCtrl.adhanDownloadStatus.value[
                                      adhanData.adhan.first.partOfAdhanName] ??
                                  false;
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
                                                    .downloadIndex.value
                                            ? notificationCtrl
                                                    .onDownloading.value
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : Colors.transparent
                                            : Colors.transparent,
                                        progress:
                                            notificationCtrl.progress.value,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.cloud_download_outlined,
                                          size: 22,
                                          color: Theme.of(context).canvasColor),
                                      onPressed: () async {
                                        notificationCtrl.downloadIndex.value =
                                            index;
                                        await notificationCtrl
                                            .adhanDownload(index);
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
