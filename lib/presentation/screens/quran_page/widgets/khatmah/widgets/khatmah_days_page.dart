part of '../../../quran.dart';

class KhatmahDaysPage extends StatelessWidget {
  final Khatmah khatmah;
  KhatmahDaysPage({super.key, required this.khatmah});

  final khatmahCtrl = KhatmahController.instance;
  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    final int daysCount = khatmah.daysCount;
    final bool isTahzibSahabah = khatmah.isTahzibSahabah;
    final int currentDay =
        khatmah.dayStatuses.indexWhere((status) => !status.isCompleted) + 1;

    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: isTahzibSahabah ? 7 : daysCount,
      itemBuilder: (context, index) {
        final dayStatus = khatmah.dayStatuses[index];
        final startPage = dayStatus.startPage;
        final endPage = dayStatus.endPage;
        final bool isCurrentDay = (index + 1) == currentDay;

        return Container(
          width: Get.width,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          margin: const EdgeInsets.symmetric(vertical: 3.0),
          decoration: BoxDecoration(
            color: context.theme.primaryColorLight.withValues(
              alpha: isCurrentDay ? 0.3 : 0.1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              quranCtrl.changeSurahListOnTap(startPage);
              Get.back();
            },
            child: Row(
              children: [
                /// رقم اليوم مع حالة الإكمال
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: dayStatus.isCompleted
                            ? Color(khatmah.color).withValues(alpha: .8)
                            : Theme.of(
                                context,
                              ).colorScheme.surface.withValues(alpha: .15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    if (dayStatus.isCompleted)
                      const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 22,
                      )
                    else
                      Text(
                        '${index + 1}'.convertNumbersToCurrentLang(),
                        style: AppTextStyles.titleMedium(),
                      ),
                  ],
                ),
                const Gap(12),

                /// معلومات الورد
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${'Day'.tr.replaceAll('يوم', 'اليوم')} ${(index + 1).toString().convertNumbersToCurrentLang()}',
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontFamily: 'kufi',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isCurrentDay)
                        Text(
                          'الورد الحالي',
                          style: TextStyle(
                            color: Color(khatmah.color),
                            fontFamily: 'kufi',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
                const Gap(12),

                /// الصفحات والتحكم
                Expanded(
                  flex: 3,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 6.0,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$startPage - $endPage'
                                .convertNumbersToCurrentLang(),
                            style: AppTextStyles.titleSmall(),
                          ),
                        ),
                        const Gap(6),
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: dayStatus.isCompleted,
                            activeColor: Color(khatmah.color),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (bool? value) {
                              dayStatus.isCompleted = value ?? false;
                              khatmahCtrl.updateKhatmahDayStatus(
                                khatmah.id,
                                index + 1,
                                value ?? false,
                              );
                              (context as Element).markNeedsBuild();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
