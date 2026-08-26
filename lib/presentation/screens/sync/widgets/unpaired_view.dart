part of '../sync.dart';

class _UnpairedView extends StatelessWidget {
  const _UnpairedView();

  Future<void> _join(
    BuildContext context,
    SyncController syncCtrl,
    String code,
  ) async {
    final ok = await syncCtrl.joinGroup(code);
    if (!ok && context.mounted) {
      final error = syncCtrl.lastError.value ?? '';
      String message = 'syncJoinFailed'.tr;
      if (error == 'invalidSyncCode') {
        message = 'invalidSyncCode'.tr;
      } else if (error == '403') {
        message = 'syncRoomFull'.tr;
      } else if (error == '404') {
        message = 'syncRoomNotFound'.tr;
      }
      Get.snackbar('deviceSync'.tr, message);
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
        ContainerButton(
          onPressed: () async {
            final ok = await syncCtrl.createGroup();
            if (!ok) {
              Get.snackbar('deviceSync'.tr, 'syncCreateError'.tr);
            }
          },
          withArrow: true,
          width: double.infinity,
          title: 'createSyncGroup',
          horizontalPadding: 8.0,
          verticalPadding: 12.0,
          horizontalMargin: 8.0,
        ),
        const Gap(8),
        ContainerButton(
          onPressed: () async {
            final scanned = await Get.to<String?>(
              () => const SyncScannerScreen(),
              transition: Transition.downToUp,
            );
            if (scanned != null && scanned.isNotEmpty) {
              await _join(context, syncCtrl, scanned);
            }
          },
          withArrow: true,
          width: double.infinity,
          title: 'joinSyncGroup',
          horizontalPadding: 8.0,
          verticalPadding: 12.0,
          horizontalMargin: 8.0,
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
            ContainerButton(
              onPressed: () {
                final code = codeController.text.trim();
                if (code.isNotEmpty) {
                  _join(context, syncCtrl, code);
                }
              },
              title: 'joinWithCode',
              horizontalPadding: 16.0,
              verticalPadding: 12.0,
            ),
          ],
        ),
      ],
    );
  }
}
