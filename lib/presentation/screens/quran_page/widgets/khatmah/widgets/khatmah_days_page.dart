part of '../../../quran.dart';

class KhatmahDaysPage extends StatelessWidget {
  final Khatmah khatmah;
  KhatmahDaysPage({super.key, required this.khatmah});

  final khatmahCtrl = KhatmahController.instance;
  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    final int daysCount = khatmah.daysCount; // عدد الأيام
    final bool isTahzibSahabah = khatmah.isTahzibSahabah;
    final int currentDay =
        khatmah.dayStatuses.indexWhere((status) => !status.isCompleted) + 1;

    return SizedBox(
      // height: Get.height,
      width: Get.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (currentDay > 0 && currentDay <= daysCount)
            ListTile(
              title: Text(
                'الورد: $currentDay'.convertNumbers(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 18,
                  fontFamily: 'kufi',
                ),
              ),
              trailing: Icon(
                Icons.chrome_reader_mode,
                size: 24,
                color: Theme.of(context).colorScheme.surface,
              ),
              subtitle: Text(
                '${'pages'.tr.replaceAll('صفحات', 'الصفحات')}: ${khatmah.dayStatuses[currentDay - 1].startPage} - ${khatmah.dayStatuses[currentDay - 1].endPage}'
                    .convertNumbers(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontSize: 14,
                  fontFamily: 'kufi',
                ),
              ),
            ),
          context.hDivider(width: Get.width),
          Flexible(
            child: ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: isTahzibSahabah ? 7 : daysCount,
              itemBuilder: (context, index) {
                final dayStatus = khatmah.dayStatuses[index];
                final startPage = dayStatus.startPage;
                final endPage = dayStatus.endPage;

                return ListTile(
                  title: Text(
                    '${'Day'.tr.replaceAll('يوم', 'اليوم')} ${index + 1}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 14,
                      fontFamily: 'kufi',
                    ),
                  ),
                  subtitle: Text(
                    '${'pages'.tr.replaceAll('صفحات', 'الصفحات')}: $startPage - $endPage'
                        .convertNumbers(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 14,
                      fontFamily: 'kufi',
                    ),
                  ),
                  trailing: Checkbox(
                    value: dayStatus.isCompleted,
                    activeColor: Theme.of(context).colorScheme.surface,
                    onChanged: (bool? value) {
                      dayStatus.isCompleted = value ?? false;
                      khatmahCtrl.updateKhatmahDayStatus(
                          khatmah.id, index + 1, value ?? false);
                      (context as Element).markNeedsBuild();
                    },
                  ),
                  onTap: () {
                    quranCtrl.changeSurahListOnTap(startPage);
                    Get.back();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
