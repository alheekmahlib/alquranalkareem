import 'package:alquranalkareem/core/utils/constants/extensions/convert_number_extension.dart';
import 'package:alquranalkareem/core/utils/helpers/app_text_styles.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:quran_library/quran.dart';

import '/core/utils/constants/extensions/bottom_sheet_extension.dart';
import '/core/widgets/container_button.dart';
import '../../../presentation/controllers/general/general_controller.dart';
import '../../../presentation/screens/quran_page/quran.dart';
import '../../services/ayah_audio_share_service.dart';
import '../../services/services_locator.dart';
import '../../utils/constants/extensions/extensions.dart';
import '../../utils/constants/svg_constants.dart';
import '../custom_button.dart';
import '../custom_switch_widget.dart';
import '../expansion_tile_widget.dart';
import '../title_widget.dart';
import 'share_ayahToImage.dart';

/// حالة مؤقتة للآيات المحددة (من/إلى) — تُدار بالكامل عبر Rx.
final RxInt _fromAyah = 1.obs;
final RxInt _toAyah = 1.obs;

class ShareAyahOptions extends StatelessWidget {
  final AyahModel ayah;
  final SurahModel surah;
  final int pageNumber;
  final Color? iconColor;
  final bool? withBack;

  ShareAyahOptions({
    super.key,
    required this.ayah,
    required this.surah,
    required this.pageNumber,
    this.iconColor,
    this.withBack = true,
  });

  final shareToImage = ShareController.instance;

  /// قائمة الآيات المحددة (من/إلى)
  List<AyahModel> get _selectedAyahs {
    final from = _fromAyah.value;
    final to = _toAyah.value;
    final min = from < to ? from : to;
    final max = from > to ? from : to;
    return surah.ayahs.where((a) {
      final n = a.ayahNumber;
      return n >= min && n <= max;
    }).toList();
  }

  /// النص المدمج للآيات المحددة
  String get _selectedText =>
      _selectedAyahs.map((a) => a.text + ' ${a.ayahNumber}').join(' ');
  String get _selectedAyahNumber =>
      '${_selectedAyahs.first.ayahNumber} - ${_selectedAyahs.last.ayahNumber}';

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      height: 40,
      width: 35,
      iconSize: 35,
      isCustomSvgColor: true,
      svgPath: SvgPath.svgHomeShare,
      svgColor: iconColor ?? context.theme.canvasColor,
      onPressed: () async {
        if (withBack == true) Get.back();
        // تهيئة القيم بالآية الحالية
        _fromAyah.value = ayah.ayahNumber;
        _toAyah.value = ayah.ayahNumber;
        customBottomSheet(
          backgroundColor: Get.theme.colorScheme.primaryContainer,
          SafeArea(
            child: SizedBox(
              height: Get.height * .8,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _rangeSelector(),
                    const Gap(4),
                    context.hDivider(color: Get.theme.colorScheme.primary),
                    const Gap(4),
                    _ayahText(context),
                    const Gap(4),
                    context.hDivider(color: Get.theme.colorScheme.primary),
                    const Gap(4),
                    _ayahAudio(context),
                    const Gap(4),
                    context.hDivider(color: Get.theme.colorScheme.primary),
                    const Gap(4),
                    _ayahToImage(context),
                    const Gap(8),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ── محدد «من / إلى» داخل ExpansionTileWidget ───────────────
  Widget _rangeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ExpansionTileWidget<QuranCtrl>(
        name: 'share_range_tile',
        manager: GeneralController.instance.state.expansionManager,
        getxCtrl: QuranCtrl.instance,
        initiallyExpanded: true,
        title: 'shareRange'.tr,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(child: _ayahDropdown('fromAyah'.tr, _fromAyah)),
              const Gap(8),
              Expanded(child: _ayahDropdown('toAyah'.tr, _toAyah)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ayahDropdown(String label, RxInt rxVal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.titleMedium(fontSize: 12)),
        const Gap(4),
        Obx(
          () => CustomDropdown<int>(
            excludeSelected: false,
            initialItem: rxVal.value,
            // سكرول تلقائي للآية الحالية عند فتح القائمة
            itemsScrollController: ScrollController(
              initialScrollOffset: (rxVal.value - 1) * 40.0,
            ),
            decoration: CustomDropdownDecoration(
              closedFillColor: Get.theme.colorScheme.primary.withValues(
                alpha: .15,
              ),
              expandedFillColor: Get.theme.colorScheme.primaryContainer,
              closedBorderRadius: const BorderRadius.all(Radius.circular(8)),
              expandedBorderRadius: const BorderRadius.all(Radius.circular(8)),
              closedBorder: Border.all(color: Colors.transparent),
              expandedBorder: Border.all(color: Colors.transparent),
            ),
            closedHeaderPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            hintBuilder: (_, __, ___) =>
                Text(label, style: AppTextStyles.titleMedium(fontSize: 12)),
            headerBuilder: (_, value, __) =>
                Text('$value', style: AppTextStyles.titleMedium(fontSize: 12)),
            items: surah.ayahs.map((a) => a.ayahNumber).toList(),
            listItemBuilder: (_, value, __, ___) =>
                Text('$value', style: AppTextStyles.titleMedium(fontSize: 12)),
            onChanged: (v) => rxVal.value = v ?? rxVal.value,
          ),
        ),
      ],
    );
  }

  // ── مشاركة كنص ──────────────────────────────────────────────
  Widget _ayahText(BuildContext context) {
    // التقاط الألوان خارج Obx لتجنب deactivated widget ancestor
    final bg = context.theme.colorScheme.primary.withValues(alpha: .15);
    final hint = context.theme.hintColor;
    final width = Get.width;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'shareText'),
        Obx(() {
          final ayahs = _selectedAyahs;
          final isSingle = ayahs.length == 1;
          final text = isSingle
              ? ayah.text
              : _selectedText.convertNumbersToCurrentLang();
          return ContainerButton(
            height: isSingle ? 90 : 120,
            width: width,
            isButton: true,
            withArrow: true,
            horizontalMargin: 16.0,
            verticalPadding: 8.0,
            backgroundColor: bg,
            child: SizedBox(
              width: 300,
              child: Text(
                "﴿ $text ﴾",
                style: TextStyle(
                  color: hint,
                  fontSize: isSingle ? 18 : 16,
                  fontFamily: 'uthmanic2',
                ),
                overflow: TextOverflow.fade,
                maxLines: 3,
                textDirection: TextDirection.rtl,
              ),
            ),
            onPressed: () => shareToImage.shareText(
              text,
              surah.arabicName,
              _selectedAyahNumber.convertNumbersToCurrentLang(),
              pageNumber + 1,
              ayahs.last.ayahUQNumber,
            ),
          );
        }),
      ],
    );
  }

  // ── مشاركة كصورة ────────────────────────────────────────────
  Widget _ayahToImage(BuildContext context) {
    final bg = Get.theme.colorScheme.primary.withValues(alpha: .15);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'shareImage'),
        GetBuilder<QuranCtrl>(
          builder: (quran) {
            return CustomSwitchListTile(
              contentMargin: const EdgeInsets.symmetric(horizontal: 16.0),
              title: 'tajweed'.tr,
              value: quran.state.isTajweedEnabled.value,
              onChanged: (_) {
                quran.state.isTajweedEnabled.toggle();
                QuranController.instance.state.box.write(
                  'isTajweed',
                  quran.state.isTajweedEnabled.value,
                );
                Get.forceAppUpdate();
              },
            );
          },
        ),
        Obx(() {
          final ayahs = _selectedAyahs;
          final isSingle = ayahs.length == 1;
          return GestureDetector(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              margin: const EdgeInsets.only(
                top: 4.0,
                bottom: 16.0,
                right: 16.0,
                left: 16.0,
              ),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              child: VerseImageCreator(
                ayah: ayahs.first,
                surah: surah,
                extraAyahs: isSingle ? null : ayahs.sublist(1),
              ),
            ),
            onTap: () async {
              await sl<ShareController>().createAndShowVerseImage();
              await shareToImage.shareVerse(
                context,
                _selectedText,
                surah.arabicName,
                ayahs.last.ayahNumber,
                pageNumber + 1,
                ayahs.last.ayahUQNumber,
              );
              Get.back();
            },
          );
        }),
      ],
    );
  }

  // ── مشاركة كصوت ─────────────────────────────────────────────
  Widget _ayahAudio(BuildContext context) {
    final audioService = sl<AyahAudioShareService>();
    // التقاط الألوان خارج Obx
    final bg = context.theme.colorScheme.primary.withValues(alpha: .15);
    final hint = context.theme.hintColor;
    final width = Get.width;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'shareAudio'),
        Obx(() {
          final ayahs = _selectedAyahs;
          final isSingle = ayahs.length == 1;
          return ContainerButton(
            height: 90,
            width: width,
            isButton: true,
            withArrow: true,
            horizontalMargin: 16.0,
            verticalPadding: 8.0,
            isDownloading: audioService.isDownloading.value,
            downloadProgress: audioService.downloadProgress.value,
            backgroundColor: bg,
            svgWithColorPath: SvgPath.svgAudioDownload,
            svgColor: hint,
            title: audioService.currentReaderName,
            onPressed: audioService.isDownloading.value
                ? null
                : () async {
                    if (isSingle) {
                      await shareToImage.shareAudio(
                        surahName: surah.arabicName,
                        verseText: ayahs.first.text,
                        surahNumber: surah.surahNumber,
                        ayahNumber: ayahs.first.ayahNumber,
                        pageNumber: pageNumber + 1,
                        ayahUQNumber: ayahs.first.ayahUQNumber,
                      );
                    } else {
                      await shareToImage.shareAudioRange(
                        ayahs: ayahs,
                        surahName: surah.arabicName,
                        surahNumber: surah.surahNumber,
                        pageNumber: pageNumber + 1,
                      );
                    }
                  },
          );
        }),
      ],
    );
  }
}
