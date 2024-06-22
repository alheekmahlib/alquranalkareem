import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '/core/utils/constants/extensions/alignment_rotated_extension.dart';
import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/core/utils/constants/extensions/extensions.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../../core/utils/constants/lottie_constants.dart';
import '../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../../controllers/books_controller.dart';
import '../../../controllers/general_controller.dart';
import '../screens/read_view_screen.dart';

class BooksLastRead extends StatelessWidget {
  BooksLastRead({super.key});

  final box = GetStorage();
  final generalCtrl = GeneralController.instance;
  final bookCtrl = BooksController.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => PagesPage(
          bookNumber: bookCtrl.bookNumber,
          initialPage: bookCtrl.currentPage - 1)),
      child: Container(
        height: 125,
        width: 380,
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(8.0),
            Text(
              'lastRead'.tr,
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: 'kufi',
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                height: 70,
                width: 380,
                decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(.15),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0))),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    LinearProgressIndicator(
                      minHeight: 70,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      value: ((box.read(PAGE_NUMBER) ?? 0) /
                              (box.read(TOTAL_PAGES) ?? 0)) ??
                          0.0,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(.15),
                      color:
                          Theme.of(context).colorScheme.surface.withOpacity(.5),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              '${bookCtrl.bookName}',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: 'naskh',
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).hintColor,
                                  height: 1.5),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          context.vDivider(height: 30),
                          Expanded(
                            flex: 7,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      '${'pageNo'.tr}: ${bookCtrl.currentPage}'
                                          .convertNumbers(),
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontFamily: 'naskh',
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context).hintColor,
                                          height: 1.5),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ),
                                ),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8))),
                                    ),
                                    alignmentLayout(
                                        context,
                                        RotatedBox(
                                            quarterTurns: 15,
                                            child: customLottie(
                                                LottieConstants
                                                    .assetsLottieArrow,
                                                height: 50.0)),
                                        RotatedBox(
                                            quarterTurns: 25,
                                            child: customLottie(
                                                LottieConstants
                                                    .assetsLottieArrow,
                                                height: 50.0))),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
