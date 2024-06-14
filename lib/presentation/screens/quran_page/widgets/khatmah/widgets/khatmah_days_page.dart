import 'package:alquranalkareem/core/utils/constants/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '../../../../../controllers/khatmah_controller.dart';
import '../../../../../controllers/quran_controller.dart';

class KhatmahDaysPage extends StatelessWidget {
  final Khatmah khatmah;
  KhatmahDaysPage({super.key, required this.khatmah});

  final khatmahCtrl = KhatmahController.instance;
  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    final int daysCount = khatmah.daysCount; // عدد الأيام
    final bool isTahzibSalaf = khatmah.isTahzibSalaf;
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
                '${'pages'.tr}: ${isTahzibSalaf ? khatmahCtrl.getTahzibSalafPageForDay(currentDay) : (currentDay - 1) * pagesPerDay + 1} - ${isTahzibSalaf ? (currentDay < 7 ? khatmahCtrl.getTahzibSalafPageForDay(currentDay + 1) - 1 : 604) : currentDay * pagesPerDay}'
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
              itemCount: isTahzibSalaf ? 7 : daysCount,
              itemBuilder: (context, index) {
                final int startPage = isTahzibSalaf
                    ? khatmahCtrl.getTahzibSalafPageForDay(index + 1)
                    : index * pagesPerDay + 1;
                final int endPage = isTahzibSalaf
                    ? (index < 6
                        ? khatmahCtrl.getTahzibSalafPageForDay(index + 2) - 1
                        : 604)
                    : (index + 1) * pagesPerDay;
                final dayStatus = khatmah.dayStatuses[index];

                return ListTile(
                  title: Text(
                    '${'Day'.tr} ${index + 1}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 14,
                      fontFamily: 'kufi',
                    ),
                  ),
                  subtitle: Text(
                    '${'pages'.tr}: $startPage - $endPage'.convertNumbers(),
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
