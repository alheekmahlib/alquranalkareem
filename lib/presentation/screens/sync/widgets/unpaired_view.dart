part of '../sync.dart';

class _UnpairedView extends StatelessWidget {
  const _UnpairedView();

  Future<void> _join(
    BuildContext context,
    SyncController syncCtrl,
    String code,
  ) async {
    final ok = await syncCtrl.joinGroup(code);
    if (!context.mounted) return;
    if (ok) {
      // تطبيق بيانات الجهاز الآخر فورًا على الواجهات.
      Get.forceAppUpdate();
      context.showCustomErrorSnackBar('syncCompleted'.tr, isDone: true);
    } else {
      final error = syncCtrl.lastError.value ?? '';
      String message = 'syncJoinFailed'.tr;
      if (error == 'invalidSyncCode') {
        message = 'invalidSyncCode'.tr;
      } else if (error == '403') {
        message = 'syncRoomFull'.tr;
      } else if (error == '404') {
        message = 'syncRoomNotFound'.tr;
      }
      context.showCustomErrorSnackBar(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final syncCtrl = SyncController.instance;
    final codeController = TextEditingController();

    return ListView(
      children: [
        const Gap(24),
        customSvgWithCustomColor(
          SvgPath.svgHomeQuranLogo,
          height: 110,
          color: Theme.of(context).primaryColorLight,
        ),
        const Gap(16),
        Text(
          'deviceSyncDesc'.tr,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium(),
        ),
        const Gap(24),
        Obx(
          () => ContainerButton(
            onPressed: syncCtrl.isPairing.value
                ? null
                : () async {
                    final ok = await syncCtrl.createGroup();
                    if (!context.mounted) return;
                    if (ok) {
                      context.showCustomErrorSnackBar(
                        'syncCompleted'.tr,
                        isDone: true,
                      );
                    } else {
                      context.showCustomErrorSnackBar('syncCreateError'.tr);
                    }
                  },
            isPreparingDownload: syncCtrl.isPairing.value,
            withArrow: true,
            width: double.infinity,
            title: 'createSyncGroup',
            horizontalPadding: 8.0,
            verticalPadding: 12.0,
            horizontalMargin: 8.0,
          ),
        ),
        const Gap(8),
        Obx(
          () => ContainerButton(
            onPressed: syncCtrl.isPairing.value
                ? null
                : () async {
                    final scanned = await Get.to<String?>(
                      () => const SyncScannerScreen(),
                      transition: Transition.downToUp,
                    );
                    if (scanned != null && scanned.isNotEmpty) {
                      await _join(context, syncCtrl, scanned);
                    }
                  },
            isPreparingDownload: syncCtrl.isPairing.value,
            withArrow: true,
            width: double.infinity,
            title: 'joinSyncGroup',
            horizontalPadding: 8.0,
            verticalPadding: 12.0,
            horizontalMargin: 8.0,
          ),
        ),
        const Gap(24),
        Text(
          'enterSyncCodeManually'.tr,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySmall(),
        ),
        const Gap(8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: codeController,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium(),
                decoration: InputDecoration(
                  hintText: 'syncCodeHint'.tr,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const Gap(8),
            Obx(
              () => ContainerButton(
                onPressed: syncCtrl.isPairing.value
                    ? null
                    : () {
                        final code = codeController.text.trim();
                        if (code.isNotEmpty) {
                          _join(context, syncCtrl, code);
                        }
                      },
                isPreparingDownload: syncCtrl.isPairing.value,
                title: 'joinWithCode',
                horizontalPadding: 16.0,
                verticalPadding: 12.0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
