part of '../../../quran.dart';

class KhatmahBuildWidget extends StatelessWidget {
  KhatmahBuildWidget({super.key});

  final khatmahCtrl = KhatmahController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (khatmahCtrl.khatmas.isEmpty) {
        return Center(
          child: Column(
            children: [
              Gap(64.h),
              AnimatedDrawingWidget(
                svgPath: SvgPath.svgQuranKhatmah,
                height: 50,
                width: 140,
                opacity: 1,
                paintMode: PaintMode.fillOnly,
                customColor: context.theme.colorScheme.surface,
              ),
              const Gap(32),
            ],
          ),
        );
      }
      return ListView.builder(
        primary: false,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: khatmahCtrl.khatmas.length,
        itemBuilder: (context, index) {
          final khatmah = khatmahCtrl.khatmas[index];
          final int currentDay =
              khatmah.dayStatuses.indexWhere((status) => !status.isCompleted) +
              1;
          final int totalDays = khatmah.daysCount;
          final double progress = currentDay > 0 && currentDay <= totalDays
              ? (currentDay - 1) / totalDays
              : currentDay > totalDays
              ? 1.0
              : 0.0;

          return Dismissible(
            background: const DeleteWidget(),
            key: ValueKey<int>(khatmah.id),
            onDismissed: (DismissDirection direction) {
              khatmahCtrl.deleteKhatmahOnTap(khatmah.id);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              decoration: BoxDecoration(
                color: context.theme.primaryColorLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ExpansionTileWidget(
                getxCtrl: khatmahCtrl,
                backgroundColor: context.theme.primaryColorLight.withValues(
                  alpha: 0.1,
                ),
                manager: GeneralController.instance.state.expansionManager,
                name: 'khatmah_expansion_tile_${khatmah.id}',
                tilePadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                titleChild: _titleWidget(
                  khatmah,
                  progress,
                  context,
                  currentDay,
                  totalDays,
                ),
                child: KhatmahDaysPage(khatmah: khatmah),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _titleWidget(
    Khatmah khatmah,
    double progress,
    BuildContext context,
    int currentDay,
    int totalDays,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 100,
          width: 70,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(khatmah.color).withValues(alpha: .6),
                Colors.transparent,
              ],
              begin: AlignmentDirectional.centerStart,
              end: AlignmentDirectional.centerEnd,
            ),
            color: Color(khatmah.color).withValues(alpha: .8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              '${(progress * 100).toInt()}%'.convertNumbersToCurrentLang(),
              style: AppTextStyles.titleSmall(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ),
        const Gap(8),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Get.width,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      khatmah.name ?? 'khatmah'.tr,
                      style: AppTextStyles.titleMedium(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${'Day'.tr}: ',
                          style: AppTextStyles.titleSmall(
                            color: context.theme.primaryColorDark,
                          ),
                        ),
                        Text(
                          currentDay > totalDays
                              ? totalDays
                                    .toString()
                                    .convertNumbersToCurrentLang()
                              : currentDay
                                    .toString()
                                    .convertNumbersToCurrentLang(),
                          style: AppTextStyles.titleSmall(),
                        ),
                        Text(
                          '/$totalDays'.convertNumbersToCurrentLang(),
                          style: AppTextStyles.titleSmall(
                            color: context.theme.primaryColorDark,
                          ),
                        ),
                        if (khatmah.isTahzibSahabah) ...[
                          const Gap(8),
                          Text(
                            '| ${'divisionBySahabah'.tr}',
                            style: AppTextStyles.titleSmall(
                              color: context.theme.primaryColorDark,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(8),
              SizedBox(
                width: 220,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surface.withValues(alpha: .2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(khatmah.color),
                    ),
                    minHeight: 6,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
