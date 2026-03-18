part of '../../quran.dart';

class AyahsChoiceWidget extends StatelessWidget {
  AyahsChoiceWidget({super.key});
  final playList = PlayListController.instance;
  final quranCtrl = QuranController.instance;
  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ━━━ سورة البداية + آية البداية ━━━
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Obx(() {
                final surahName = playList.fromSurahName.replaceAll(
                  'سُورَةُ ',
                  '',
                );
                return _surahButton(
                  context,
                  label: '${'from'.tr}: ',
                  surahName: surahName,
                  onTap: () => _showSurahPicker(context, isFrom: true),
                );
              }),
            ),
            const Gap(8),
            Expanded(
              flex: 2,
              child: Obx(() {
                return _ayahPopup(
                  context,
                  label: '${'ayah'.tr}: ',
                  value: playList.startAyah.value,
                  isStartAyah: true,
                  isFromSurah: true,
                );
              }),
            ),
          ],
        ),
        const Gap(8),
        // ━━━ سورة النهاية + آية النهاية ━━━
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Obx(() {
                final surahName = playList.toSurahName.replaceAll(
                  'سُورَةُ ',
                  '',
                );
                return _surahButton(
                  context,
                  label: '${'to'.tr}: ',
                  surahName: surahName,
                  onTap: () => _showSurahPicker(context, isFrom: false),
                );
              }),
            ),
            const Gap(8),
            Expanded(
              flex: 2,
              child: Obx(() {
                return _ayahPopup(
                  context,
                  label: '${'ayah'.tr}: ',
                  value: playList.endAyah.value,
                  isStartAyah: false,
                  isFromSurah: false,
                );
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _surahButton(
    BuildContext context, {
    required String label,
    required String surahName,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: .15),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.titleMedium()),
            Flexible(
              child: Text(
                surahName,
                style: AppTextStyles.titleMedium().copyWith(
                  color: Theme.of(context).primaryColorLight,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            customSvgWithColor(
              SvgPath.svgHomeArrowDown,
              color: Get.theme.colorScheme.surface,
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _ayahPopup(
    BuildContext context, {
    required String label,
    required int value,
    required bool isStartAyah,
    required bool isFromSurah,
  }) {
    return PopupMenuButton(
      position: PopupMenuPosition.under,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Container(
        height: 45,
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: .15),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(label, style: AppTextStyles.titleMedium()),
            Text(
              generalCtrl.state.arabicNumber.convert(value),
              style: AppTextStyles.titleMedium().copyWith(
                color: Theme.of(context).primaryColorLight,
              ),
            ),
            customSvgWithColor(
              SvgPath.svgHomeArrowDown,
              color: Get.theme.colorScheme.surface,
              height: 10,
            ),
          ],
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: PlayListAyatBuild(
            isStartAyah: isStartAyah,
            isFromSurah: isFromSurah,
          ),
        ),
      ],
    );
  }

  void _showSurahPicker(BuildContext context, {required bool isFrom}) {
    Get.bottomSheet(
      Container(
        height: MediaQuery.sizeOf(context).height * .6,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: Column(
          children: [
            const Gap(8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha: .3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Gap(8),
            Text(
              isFrom
                  ? '${'from'.tr} - ${'chooseSurah'.tr}'
                  : '${'to'.tr} - ${'chooseSurah'.tr}',
              style: AppTextStyles.titleMedium(),
            ),
            const Gap(8),
            Expanded(child: PlayListSurahPicker(isFrom: isFrom)),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
