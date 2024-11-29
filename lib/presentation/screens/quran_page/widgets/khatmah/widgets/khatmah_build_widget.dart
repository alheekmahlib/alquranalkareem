import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/widgets/delete_widget.dart';
import '../../../controllers/khatmah_controller.dart';
import 'khatmah_days_page.dart';
import 'khatmah_name_widget.dart';

class KhatmahBuildWidget extends StatelessWidget {
  final khatmahCtrl = KhatmahController.instance;

  KhatmahBuildWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (khatmahCtrl.khatmas.isEmpty) {
        return const SizedBox.shrink();
      }
      return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: khatmahCtrl.khatmas.length,
        itemBuilder: (context, index) {
          final khatmah = khatmahCtrl.khatmas[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Dismissible(
              background: const DeleteWidget(),
              key: ValueKey<int>(khatmah.id),
              onDismissed: (DismissDirection direction) {
                khatmahCtrl.deleteKhatmahOnTap(khatmah.id);
              },
              child: ExpansionTileCard(
                elevation: 0.0,
                initialElevation: 0.0,
                leading: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Color(khatmah.color),
                      borderRadius: const BorderRadius.all(Radius.circular(8))),
                ),
                expandedTextColor: Theme.of(context).primaryColorDark,
                title: KhatmahNameWidget(
                  khatmah: khatmah,
                ),
                baseColor:
                    Theme.of(context).colorScheme.primary.withOpacity(.2),
                expandedColor:
                    Theme.of(context).colorScheme.primary.withOpacity(.2),
                children: <Widget>[
                  const Divider(
                    thickness: 1.0,
                    height: 1.0,
                  ),
                  OverflowBar(
                    alignment: MainAxisAlignment.spaceAround,
                    spacing: 42.0,
                    overflowSpacing: 90.0,
                    children: <Widget>[
                      KhatmahDaysPage(khatmah: khatmah),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
