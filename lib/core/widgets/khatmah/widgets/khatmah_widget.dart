import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../presentation/controllers/khatmah_controller.dart';
import '../data/data_source/khatmah_database.dart';
import 'khatmah_days_page.dart';

class KhatmahWidget extends StatelessWidget {
  final Khatmah khatmah;
  KhatmahWidget({
    super.key,
    required this.khatmah,
  });

  final khatmahCtrl = KhatmahController.instance;

  @override
  Widget build(BuildContext context) {
    final int daysCount = khatmah.daysCount ?? 30; // عدد الأيام
    final int pagesPerDay = (khatmahCtrl.totalPages / daysCount).ceil();

    return GestureDetector(
      onTap: () {
        Get.to(() => KhatmahDaysPage(khatmah: khatmah));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
        child: Container(
          height: 70,
          width: 380,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(.15),
              borderRadius: const BorderRadius.all(Radius.circular(8.0))),
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                height: 70,
                width: 70,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surface.withOpacity(.6),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0))),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        khatmah.name ?? 'No Name',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).hintColor,
                          height: 1.5,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Days: $daysCount',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).hintColor,
                              height: 1.5,
                            ),
                          ),
                          Text(
                            'Pages: $pagesPerDay',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).hintColor,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
