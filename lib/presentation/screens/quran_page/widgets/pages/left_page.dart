import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeftPage extends StatelessWidget {
  final Widget child;
  const LeftPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: 'Quran Page',
      child: Container(
        height: MediaQuery.sizeOf(context).height,
        margin: const EdgeInsets.only(left: 4.0, top: 16.0, bottom: 16.0),
        decoration: BoxDecoration(
            color: Get.isDarkMode
                ? Theme.of(context).primaryColorDark.withOpacity(.5)
                : Theme.of(context).dividerColor.withOpacity(.5),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12), bottomLeft: Radius.circular(12))),
        child: Container(
          margin: const EdgeInsets.only(left: 4.0),
          decoration: BoxDecoration(
              color: Get.isDarkMode
                  ? Theme.of(context).primaryColorDark.withOpacity(.7)
                  : Theme.of(context).dividerColor.withOpacity(.7),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12))),
          child: Container(
            margin: const EdgeInsets.only(left: 4.0),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12))),
            child: child,
          ),
        ),
      ),
    );
  }
}
