import 'package:alquranalkareem/core/utils/constants/extensions/convert_number_extension.dart';
import 'package:alquranalkareem/core/utils/constants/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/services/sync/sync_controller.dart';
import '../../../core/utils/constants/extensions/svg_extensions.dart';
import '../../../core/utils/constants/svg_constants.dart';
import '../../../core/utils/constants/sync_constants.dart';
import '../../../core/utils/helpers/app_text_styles.dart';
import '../../../core/widgets/app_bar_widget.dart';
import '../../../core/widgets/container_button.dart';
import 'sync_scanner_screen.dart';

/// شاشة مزامنة الأجهزة عبر QR — حالة "بلا غرفة" (إنشاء/انضمام)
/// وحالة "مُقرن" (QR للإقران، الحالة، تحديث يدوي، إلغاء المزامنة).
class SyncScreen extends StatelessWidget {
  const SyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final syncCtrl = SyncController.instance;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBarWidget(
        isBooks: false,
        isTitled: false,
        isNotifi: false,
        isFontSize: false,
        searchButton: const SizedBox.shrink(),
        centerChild: Text('deviceSync'.tr, style: AppTextStyles.titleLarge()),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Obx(
            () => syncCtrl.roomId.value == null
                ? const _UnpairedView()
                : const _PairedView(),
          ),
        ),
      ),
    );
  }
}

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
          onPressed: () async {
            final confirmed = await Get.defaultDialog<bool>(
              title: 'resetSync'.tr,
              middleText: 'resetSyncConfirm'.tr,
              textConfirm: 'confirm'.tr,
              textCancel: 'cancel'.tr,
              onConfirm: () => Get.back(result: true),
              onCancel: () => Get.back(result: false),
            );
            if (confirmed == true) {
              await syncCtrl.resetSync();
            }
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

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(label, style: AppTextStyles.bodyMedium()),
          ),
          const Gap(8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.bodyMedium().copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
