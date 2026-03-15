import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/svg_constants.dart';
import '../../../../core/utils/helpers/app_text_styles.dart';
import '../../../../core/widgets/buttom_with_line.dart';
import '../../books/books.dart';

class BooksSection extends StatelessWidget {
  const BooksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.theme.primaryColorLight.withValues(alpha: .01),
            context.theme.primaryColorLight.withValues(alpha: .05),
            context.theme.primaryColorLight.withValues(alpha: .1),
            context.theme.primaryColorLight.withValues(alpha: .15),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.4, 0.8, 1.0],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.surface.withValues(
                      alpha: .4,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'islamicLibrary'.tr,
                    style: AppTextStyles.titleMedium(),
                    textAlign: TextAlign.center,
                  ),
                ),
                ButtomWithLine(
                  isRtl: false,
                  svgPath: SvgPath.svgBooksIslamicLibrary,
                  onTap: () => Get.to(
                    () => BooksScreen(),
                    transition: Transition.downToUp,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Hero(
              tag: 'lastReadBooks',
              child: BooksLastRead(
                horizontalMargin: 16.0,
                horizontalPadding: 0.0,
                verticalMargin: 16.0,
                backgroundColor: context.theme.colorScheme.primaryContainer
                    .withValues(alpha: .5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
