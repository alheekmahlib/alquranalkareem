import 'package:flutter/material.dart';

import '../../../../presentation/controllers/khatmah_controller.dart';
import '../../../services/services_locator.dart';
import '../../delete_widget.dart';
import '../widgets/khatmah_widget.dart';

class KhatmasScreen extends StatelessWidget {
  KhatmasScreen({super.key});

  final khatmahCtrl = sl<KhatmahController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          )),
      child: Column(
        children: [
          IconButton(
              onPressed: () => khatmahCtrl.deleteKhatmah(2),
              icon: const Icon(
                Icons.add,
                size: 24,
              )),
          Flexible(
            child: ListView.builder(
              itemCount: khatmahCtrl.daysCount,
              itemBuilder: (context, index) {
                final day = index + 1;
                final pagesPerDay =
                    (khatmahCtrl.totalPages / khatmahCtrl.daysCount).ceil();
                final startPage = index * pagesPerDay;
                final endPage = (index + 1) * pagesPerDay;
                final isDayCompleted = khatmahCtrl.khatmas.any((khatma) =>
                    khatma.currentPage! > endPage || khatma.isCompleted);
                return Dismissible(
                  background: const DeleteWidget(),
                  key: ValueKey<int>(index),
                  onDismissed: (DismissDirection direction) {
                    khatmahCtrl.deleteKhatmah(index);
                  },
                  child: KhatmahWidget(
                    name: 'khatmah.name',
                    surahNumber: 1,
                    pageNumber: startPage,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
