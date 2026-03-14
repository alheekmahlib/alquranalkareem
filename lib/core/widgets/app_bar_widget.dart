import 'package:alquranalkareem/core/utils/constants/extensions/alignment_rotated_extension.dart';
import 'package:alquranalkareem/core/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/font_size_extension.dart';
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
  final bool? centerTitle;
  final bool? backButton;

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
    this.centerTitle = true,
    this.backButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: color ?? Theme.of(context).colorScheme.primaryContainer,
      elevation: 0,
      title:
          centerChild ??
          (isTitled ? TitleWidget(title: title!) : const SizedBox.shrink()),
      centerTitle: centerTitle ?? true,
      leading: backButton == false
          ? null
          : GestureDetector(
              onTap: () {
                // isNotifi
                //     ? NotificationManager().updateBookProgress(
                //         title!,
                //         isBooks
                //             ? 'notifyBooksBody'.trParams({'bookName': '$title'})
                //             : 'notifyAdhkarBody'.trParams({'adhkarType': '$title'}),
                //         0,
                //       )
                //     : null;
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
