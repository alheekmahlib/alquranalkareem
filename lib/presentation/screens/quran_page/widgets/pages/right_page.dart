import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '/presentation/screens/quran_page/controllers/extensions/quran_getters.dart';
import '../../controllers/quran/quran_controller.dart';

class RightPage extends StatelessWidget {
  final Widget child;

  RightPage({super.key, required this.child});

  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: 'Quran Page',
      child: Container(
        height: MediaQuery.sizeOf(context).height,
        margin: context.customOrientation(const EdgeInsets.only(right: 4.0),
            const EdgeInsets.only(right: 4.0)),
        decoration: BoxDecoration(
            color: Get.isDarkMode
                ? Theme.of(context).primaryColorDark.withOpacity(.5)
                : Theme.of(context).dividerColor.withOpacity(.5),
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12))),
        child: Container(
          margin: const EdgeInsets.only(right: 4.0),
          decoration: BoxDecoration(
              color: Get.isDarkMode
                  ? Theme.of(context).primaryColorDark.withOpacity(.7)
                  : Theme.of(context).dividerColor.withOpacity(.7),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12))),
          child: GetX<QuranController>(
            builder: (quranCtrl) => Container(
              margin: const EdgeInsets.only(right: 4.0),
              decoration: BoxDecoration(
                  color: quranCtrl.backgroundColor,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12))),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
