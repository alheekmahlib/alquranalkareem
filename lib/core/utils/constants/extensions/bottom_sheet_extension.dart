import 'package:family_bottom_sheet/family_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';

extension BottomSheetExtension on void {
  /// يعرض bottomSheet بنمط التطبيق ويعيد future يكتمل عند إغلاقها،
  /// لتمكين المتصل من معرفة لحظة الإغلاق (مثل إعادة ضبط حارس فتح النتائج).
  Future<T?> customBottomSheet<T>(
    Widget child, {
    Color? backgroundColor,
    double? rightPadding,
    double? leftPadding,
    Widget? handleChild,
    Color? handleBackgroundColor,
    Color? handleDotsColor,
    double? bottomSheetWidth,
  }) async {
    // return showModalBottomSheet<T>(
    //   context: Get.context!,
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    //   backgroundColor: Colors.transparent,
    //   isScrollControlled: true,
    //   useSafeArea: true,
    //   enableDrag: true,
    //   isDismissible: true,
    //   // showDragHandle: true,
    //   constraints: BoxConstraints(
    //     maxWidth:
    //         bottomSheetWidth ??
    //         Get.context!.customOrientation(Get.width, Get.width * .5),
    //   ),
    //   builder: (context) {
    await FamilyModalSheet.show<void>(
      context: Get.context!,
      contentBackgroundColor: Colors.transparent,
      showDragHandle: false,
      useSafeArea: true,
      enableDrag: true,
      mainContentBorderRadius: BorderRadius.zero,
      safeAreaMinimum: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(Get.context!).bottom,
      ),
      builder: (context) {
        // family_bottom_sheet ينفّذ الـ builder أثناء initState، فلا يجوز
        // قراءة MediaQuery/Theme هنا مباشرة؛ Builder يؤجّل القراءات لمرحلة البناء.
        return Builder(
          builder: (context) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  right: rightPadding ?? 0.0,
                  left: leftPadding ?? 0.0,
                  // ارفع المحتوى فوق الكيبورد عند ظهوره.
                  bottom: MediaQuery.viewInsetsOf(context).bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (handleChild != null) handleChild,
                    Container(
                      height: 8,
                      width: 350,
                      margin: const EdgeInsets.symmetric(horizontal: 62.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Gap(8.0),
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                        color:
                            backgroundColor ??
                            Theme.of(context).colorScheme.primaryContainer,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Gap(8.0),
                          context.customArrowDown(
                            backgroundColor: handleBackgroundColor,
                            dotsColor: handleDotsColor,
                          ),
                          const Gap(8.0),
                          child,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    return null;
  }

  void customPushToPage(
    BuildContext context,
    Widget child, {
    Color? backgroundColor,
    double? rightPadding,
    double? leftPadding,
    Widget? handleChild,
    Color? handleBackgroundColor,
    Color? handleDotsColor,
    double? bottomSheetWidth,
  }) async {
    // return showModalBottomSheet<T>(
    //   context: Get.context!,
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    //   backgroundColor: Colors.transparent,
    //   isScrollControlled: true,
    //   useSafeArea: true,
    //   enableDrag: true,
    //   isDismissible: true,
    //   // showDragHandle: true,
    //   constraints: BoxConstraints(
    //     maxWidth:
    //         bottomSheetWidth ??
    //         Get.context!.customOrientation(Get.width, Get.width * .5),
    //   ),
    //   builder: (context) {
    FamilyModalSheet.of(context).pushPage(
      // family_bottom_sheet ينفّذ الـ builder أثناء initState، فلا يجوز
      // قراءة MediaQuery/Theme هنا مباشرة؛ Builder يؤجّل القراءات لمرحلة البناء.
      Builder(
        builder: (context) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                right: rightPadding ?? 0.0,
                left: leftPadding ?? 0.0,
                // ارفع المحتوى فوق الكيبورد عند ظهوره.
                bottom: MediaQuery.viewInsetsOf(context).bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (handleChild != null) handleChild,
                  Container(
                    height: 8,
                    width: 350,
                    margin: const EdgeInsets.symmetric(horizontal: 62.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const Gap(8.0),
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      color:
                          backgroundColor ??
                          Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Gap(8.0),
                        context.customArrowDown(
                          backgroundColor: handleBackgroundColor,
                          dotsColor: handleDotsColor,
                        ),
                        const Gap(8.0),
                        child,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
    return null;
  }
}
