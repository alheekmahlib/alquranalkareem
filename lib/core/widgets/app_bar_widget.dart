import 'package:alquranalkareem/core/utils/constants/extensions/alignment_rotated_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/font_size_extension.dart';
import '../services/notifications_manager.dart';
import '../utils/constants/extensions/extensions.dart';
import '../utils/constants/extensions/svg_extensions.dart';
import '../utils/constants/svg_constants.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final bool isTitled;
  final bool isFontSize;
  final Widget searchButton;
  final String? title;
  final Color? color;
  final bool isNotifi;
  final bool isBooks;
  final PreferredSizeWidget? bottom;
  final Widget? centerChild;

  const AppBarWidget({
    super.key,
    required this.isTitled,
    this.title,
    required this.isFontSize,
    required this.searchButton,
    this.color,
    required this.isNotifi,
    required this.isBooks,
    this.bottom,
    this.centerChild,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: color ?? Theme.of(context).colorScheme.primaryContainer,
      elevation: 0,
      title:
          centerChild ??
          (isTitled
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.surface,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    title!,
                    style: TextStyle(
                      color: Get.isDarkMode
                          ? Colors.white
                          : Theme.of(context).hintColor,
                      fontSize: context.customOrientation(12.0, 16.0),
                      fontFamily: 'kufi',
                    ),
                  ),
                )
              : const SizedBox.shrink()),
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          isNotifi
              ? NotificationManager().updateBookProgress(
                  title!,
                  isBooks
                      ? 'notifyBooksBody'.trParams({'bookName': '$title'})
                      : 'notifyAdhkarBody'.trParams({'adhkarType': '$title'}),
                  0,
                )
              : null;
          Get.back();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Transform.flip(
            flipX: alignmentLayout(false, true),
            child: customSvgWithColor(
              height: 30,
              width: 30,
              SvgPath.svgHomeArrowBack,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
        ),
      ),
      leadingWidth: 60,
      actions: [
        isFontSize ? fontSizeDropDownWidget() : const SizedBox.shrink(),
        searchButton,
      ],
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
