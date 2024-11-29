import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/font_size_extension.dart';
import '../services/notifications_manager.dart';
import '../utils/constants/extensions/extensions.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final bool isTitled;
  final bool isFontSize;
  final Widget searchButton;
  final String title;
  final Color? color;
  final bool isNotifi;
  final bool isBooks;
  final PreferredSizeWidget? bottom;

  const AppBarWidget({
    super.key,
    required this.isTitled,
    required this.title,
    required this.isFontSize,
    required this.searchButton,
    this.color,
    required this.isNotifi,
    required this.isBooks,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: color ?? Theme.of(context).colorScheme.primaryContainer,
      elevation: 0,
      title: isTitled
          ? Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.surface, width: 1)),
              child: Text(
                title,
                style: TextStyle(
                  color: Get.isDarkMode
                      ? Colors.white
                      : Theme.of(context).hintColor,
                  fontSize: context.customOrientation(12.0, 16.0),
                  fontFamily: 'kufi',
                ),
              ),
            )
          : const SizedBox.shrink(),
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          isNotifi
              ? NotificationManager().updateBookProgress(
                  title,
                  isBooks
                      ? 'notifyBooksBody'.trParams({'bookName': '$title'})
                      : 'notifyAdhkarBody'.trParams({'adhkarType': '$title'}),
                  0)
              : null;
          Get.back();
        },
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Image.asset(
              'assets/icons/arrow_back.png',
              color: Theme.of(context).colorScheme.surface,
            )),
      ),
      actions: [
        isFontSize ? fontSizeDropDown() : const SizedBox.shrink(),
        searchButton,
      ],
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}
