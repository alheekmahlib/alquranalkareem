part of '../../quran.dart';

/// واجهة مؤقت النوم
class PlayListSleepTimerWidget extends StatelessWidget {
  PlayListSleepTimerWidget({super.key});
  final playList = PlayListController.instance;

  static const _presets = [
    Duration(minutes: 15),
    Duration(minutes: 30),
    Duration(minutes: 45),
    Duration(hours: 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isActive = playList.sleepTimerDuration.value != null;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton(
            onPressed: () => isActive
                ? playList.cancelSleepTimer()
                : _showTimerDialog(context),
            svgPath: SvgPath.svgAthkarAlarm,
            height: 30,
            width: 30,
            iconSize: 22,
            isCustomSvgColor: true,
            svgColor: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surface,
          ),
          if (isActive)
            Obx(
              () => Text(
                playList
                    .formatDuration(playList.sleepTimerRemaining.value)
                    .convertNumbersToCurrentLang(),
                style: AppTextStyles.titleSmall(fontSize: 14),
              ),
            ),
        ],
      );
    });
  }

  void _showTimerDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: TitleWidget(title: 'sleepTimer'.tr, horizontalPadding: 0.0),
        titlePadding: const EdgeInsets.all(8),
        contentPadding: const EdgeInsets.all(8),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _presets.map((duration) {
            final label = duration.inMinutes >= 60
                ? '${'hour'.tr}'
                : '${duration.inMinutes} ${'minutes'.tr}';
            return ChoiceChip(
              selectedColor: context.theme.primaryColorLight.withValues(
                alpha: .4,
              ),
              backgroundColor: context.theme.primaryColorLight.withValues(
                alpha: .2,
              ),
              checkmarkColor: context.theme.colorScheme.primary,
              label: Text(label, style: AppTextStyles.titleSmall()),
              selected: playList.sleepTimerDuration.value == duration,
              onSelected: (_) {
                playList.startSleepTimer(duration);
                Get.back();
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
