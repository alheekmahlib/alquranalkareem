part of '../../quran.dart';

/// أزرار التحكم في التكرار (Loop Mode)
class PlayListRepeatWidget extends StatelessWidget {
  PlayListRepeatWidget({super.key});
  final playList = PlayListController.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LoopMode>(
      stream: playList.playlistAudioPlayer.loopModeStream,
      builder: (context, snapshot) {
        final loopMode = snapshot.data ?? LoopMode.off;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              onPressed: playList.cycleLoopMode,
              svgPath: SvgPath.svgAudioLoop,
              height: 30,
              width: 30,
              iconSize: 22,
              isCustomSvgColor: true,
              svgColor: loopMode == LoopMode.off
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(context).colorScheme.primary,
            ),
            if (loopMode != LoopMode.off)
              Obx(() {
                final count = playList.repeatCount.value;
                return GestureDetector(
                  onTap: () => _showRepeatCountDialog(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: context.theme.primaryColorLight.withValues(
                        alpha: .2,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      count == 0
                          ? '∞'
                          : count.toString().convertNumbersToCurrentLang(),
                      style: AppTextStyles.titleSmall(fontSize: 16),
                    ),
                  ),
                );
              }),
          ],
        );
      },
    );
  }

  void _showRepeatCountDialog(BuildContext context) {
    final counts = [0, 2, 3, 5, 7, 10, 20, 50];
    Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: TitleWidget(title: 'repeatCount'.tr, horizontalPadding: 0.0),
        titlePadding: const EdgeInsets.all(8),
        contentPadding: const EdgeInsets.all(8),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: counts.map((c) {
            return Obx(
              () => ChoiceChip(
                selectedColor: context.theme.primaryColorLight.withValues(
                  alpha: .4,
                ),
                backgroundColor: context.theme.primaryColorLight.withValues(
                  alpha: .2,
                ),
                checkmarkColor: context.theme.colorScheme.primary,
                label: Text(
                  c == 0 ? '∞' : c.toString().convertNumbersToCurrentLang(),
                  style: AppTextStyles.titleSmall(),
                ),
                selected: playList.repeatCount.value == c,
                onSelected: (_) {
                  playList.setRepeatCount(c);
                  Get.back();
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
