import 'package:alquranalkareem/core/utils/constants/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RightPage extends StatelessWidget {
  final Widget child;
  const RightPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: 'Quran Page',
      child: Container(
        height: MediaQuery.sizeOf(context).height,
        margin: context.customOrientation(
            const EdgeInsets.only(right: 4.0, top: 16.0, bottom: 16.0),
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
          child: Container(
            margin: const EdgeInsets.only(right: 4.0),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12))),
            child: child,
          ),
        ),
      ),
    );
  }
}
