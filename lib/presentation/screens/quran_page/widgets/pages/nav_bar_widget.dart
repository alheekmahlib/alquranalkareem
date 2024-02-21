import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/svg_picture.dart';
import '../../../../controllers/general_controller.dart';
import '/presentation/screens/quran_page/widgets/bookmarks/bookmarks_list.dart';

class NavBarWidget extends StatelessWidget {
  const NavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final generalCtrl = sl<GeneralController>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => generalCtrl.drawerKey.currentState!.toggle(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  RotatedBox(
                      quarterTurns: 30,
                      child: button_curve(height: 45.0, width: 45.0)),
                  Container(
                      padding: const EdgeInsets.all(4),
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          border: Border.all(
                              width: 1,
                              color: Theme.of(context).colorScheme.surface)),
                      child: list_icon(height: 25.0, width: 25.0)),
                ],
              ),
            ),
            // PagesIndicator(),
            GestureDetector(
              onTap: () {
                Get.bottomSheet(BookmarksList(), isScrollControlled: true);
                generalCtrl.showSelectScreenPage.value = false;
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  RotatedBox(
                      quarterTurns: 30,
                      child: button_curve(height: 45.0, width: 45.0)),
                  Container(
                      padding: const EdgeInsets.all(4),
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          border: Border.all(
                              width: 1,
                              color: Theme.of(context).colorScheme.surface)),
                      child: bookmark_list(height: 25.0, width: 25.0)),
                ],
              ),
            ),
          ],
        ),
        Container(
          height: 15,
          width: MediaQuery.sizeOf(context).width,
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }
}
