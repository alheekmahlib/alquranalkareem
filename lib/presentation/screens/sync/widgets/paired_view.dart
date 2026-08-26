part of '../sync.dart';

class _PairedView extends StatelessWidget {
  const _PairedView();

  String _formatLastSync(int? millis) {
    if (millis == null) return 'neverSynced'.tr;
    final date = DateTime.fromMillisecondsSinceEpoch(millis);
    return DateFormat.yMd(
      Get.locale!.languageCode,
    ).add_jm().format(date).convertNumbersToCurrentLang();
  }

  @override
  Widget build(BuildContext context) {
    final syncCtrl = SyncController.instance;

    return ListView(
      children: [
        const Gap(24),
        Text(
          'pairingQrTitle'.tr,
          textAlign: TextAlign.center,
          style: AppTextStyles.titleMedium(),
        ),
        const Gap(8),
        Text(
          'pairingQrHint'.tr,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySmall(),
        ),
        const Gap(16),
        Center(
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: QrImageView(
              data: SyncConstants.qrPrefix + (syncCtrl.roomId.value ?? ''),
              size: 200,
              gapless: false,
              embeddedImage: const AssetImage('assets/quran_logo_mac.png'),
              embeddedImageStyle: const QrEmbeddedImageStyle(
                size: Size(70, 70),
              ),
            ),
          ),
        ),
        const Gap(8),
        Row(
          children: [
            _InfoCard(
              label: 'devicesConnected'.tr,
              value: '${syncCtrl.deviceCount.value}'
                  .convertNumbersToCurrentLang(),
            ),
            context.vDivider(),
            _InfoCard(
              label: 'lastSync'.tr,
              value: _formatLastSync(syncCtrl.lastSyncAt.value),
            ),
          ],
        ),
        const Gap(16),
        Row(
          children: [
            Expanded(
              child: ContainerButton(
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(
                      text:
                          SyncConstants.qrPrefix +
                          (syncCtrl.roomId.value ?? ''),
                    ),
                  );
                  Get.snackbar('deviceSync'.tr, 'copy'.tr);
                },
                isTitleCentered: true,
                width: double.infinity,
                title: 'copySyncCode',
                horizontalPadding: 8.0,
                verticalPadding: 12.0,
                horizontalMargin: 8.0,
              ),
            ),
            const Gap(8),
            Expanded(
              child: Obx(
                () => ContainerButton(
                  onPressed: syncCtrl.isSyncing.value
                      ? null
                      : () => syncCtrl.syncNow(),
                  isTitleCentered: true,
                  width: double.infinity,
                  title: syncCtrl.isSyncing.value ? 'syncing' : 'syncNow',
                  horizontalPadding: 8.0,
                  verticalPadding: 12.0,
                  horizontalMargin: 8.0,
                ),
              ),
            ),
          ],
        ),
        const Gap(8),
        ContainerButton(
          onPressed: () {
            customBottomSheet(
              Container(
                height: 250,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisSize: .min,
                  children: [
                    TitleWidget(title: 'resetSync'.tr, horizontalPadding: 0.0),
                    const Gap(8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'resetSyncConfirm'.tr,
                        style: AppTextStyles.titleMedium(),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: ContainerButton(
                            onPressed: () async {
                              Get.back(result: true);
                              await syncCtrl.resetSync();
                            },
                            isTitleCentered: true,
                            title: 'confirm'.tr,
                            horizontalPadding: 16.0,
                            verticalPadding: 4.0,
                            horizontalMargin: 8.0,
                          ),
                        ),
                        ContainerButton(
                          onPressed: () => Get.back(result: false),
                          isTitleCentered: true,
                          title: 'cancel'.tr,
                          horizontalPadding: 16.0,
                          verticalPadding: 4.0,
                          horizontalMargin: 8.0,
                          backgroundColor: context.theme.primaryColorDark,
                        ),
                      ],
                    ),
                    const Gap(16),
                  ],
                ),
              ),
            );
            // if (confirmed == true) {
            //   await syncCtrl.resetSync();
            // }
            // final confirmed = await Get.defaultDialog<bool>(
            //   title: 'resetSync'.tr,
            //   middleText: 'resetSyncConfirm'.tr,
            //   textConfirm: 'confirm'.tr,
            //   textCancel: 'cancel'.tr,
            //   onConfirm: () => Get.back(result: true),
            //   onCancel: () => Get.back(result: false),
            // );
            // if (confirmed == true) {
            //   await syncCtrl.resetSync();
            // }
          },
          isTitleCentered: true,
          width: double.infinity,
          title: 'resetSync',
          titleColor: Theme.of(context).canvasColor,
          backgroundColor: context.theme.primaryColorDark,
          horizontalPadding: 8.0,
          verticalPadding: 12.0,
          horizontalMargin: 8.0,
        ),
        const Gap(24),
      ],
    );
  }
}
