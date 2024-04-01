import 'package:flutter/material.dart';

import '../../../presentation/controllers/khatmah_controller.dart';
import '../../services/services_locator.dart';
import 'khatmah.dart';

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
              onPressed: () {
                khatmahCtrl.saveLastKhatmah();
              },
              icon: const Icon(
                Icons.add,
                size: 24,
              )),
          Flexible(
            child: ListView.builder(
              itemCount: khatmahCtrl.khatmasList.length,
              itemBuilder: (context, index) {
                final khatmah = khatmahCtrl.khatmasList[index];
                return Khatmah(
                  name: khatmah.name,
                  surahNumber: khatmah.surahNumber,
                  pageNumber: khatmah.pageNumber,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
