import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/core/utils/constants/extensions/extensions.dart';
import '/presentation/screens/quran_page/controllers/extensions/quran_ui.dart';
import '../../../controllers/khatmah_controller.dart';
import '../../../controllers/quran/quran_controller.dart';

class KhatmahDaysPage extends StatelessWidget {
  final Khatmah khatmah;
  KhatmahDaysPage({super.key, required this.khatmah});

  final khatmahCtrl = KhatmahController.instance;
  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    final int daysCount = khatmah.daysCount; // عدد الأيام
    final bool isTahzibSahabah = khatmah.isTahzibSahabah;
    final int pagesPerDay = (khatmahCtrl.totalPages / daysCount).ceil();
    final int currentDay =
        khatmah.dayStatuses.indexWhere((status) => !status.isCompleted) + 1;

    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: Column(
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
                '${'pages'.tr.replaceAll('صفحات', 'الصفحات')}: ${isTahzibSahabah ? khatmahCtrl.getTahzibSahabahPageForDay(currentDay) : (currentDay - 1) * pagesPerDay + 1} - ${isTahzibSahabah ? (currentDay < 7 ? khatmahCtrl.getTahzibSahabahPageForDay(currentDay + 1) - 1 : 604) : ((currentDay * pagesPerDay > 604) ? 604 : currentDay * pagesPerDay)}'
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
