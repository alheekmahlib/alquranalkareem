part of '../../quran.dart';

/// مؤشر التقدم الكلي للـ playlist
class PlayListProgressBar extends StatelessWidget {
  PlayListProgressBar({super.key});
  final playList = PlayListController.instance;
  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.w,
      child: Obx(() {
        final total = playList.totalPlaylistAyahs.value;
        if (total == 0) return const SizedBox.shrink();

        final completed = playList.completedAyahs.value;
        final progressValue = total > 0 ? completed / total : 0.0;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${'ayah'.tr} ${generalCtrl.state.arabicNumber.convert(completed + 1)} ${'of'.tr} ${generalCtrl.state.arabicNumber.convert(total)}',
                    style: AppTextStyles.titleSmall(),
                  ),
                  Text(
                    '${(progressValue * 100).toInt()}%',
                    style: AppTextStyles.titleSmall(),
                  ),
                ],
              ),
              const Gap(4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progressValue,
                  minHeight: 4,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: .15),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const Gap(6),
            ],
          ),
        );
      }),
    );
  }
}
