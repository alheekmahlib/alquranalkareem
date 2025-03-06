import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../../core/utils/constants/svg_constants.dart';
import '../data/models/books_model.dart';
import '../screens/chapters_screen.dart';

class BookCoverWidget extends StatelessWidget {
  final Book? book;
  final int? bookNumber;
  final String? bookNane;
  final bool isInDetails;
  const BookCoverWidget(
      {super.key,
      this.book,
      this.isInDetails = false,
      this.bookNumber,
      this.bookNane});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: isInDetails
          ? SizedBox(height: 160, width: 150, child: _heroWidget(context))
          : GestureDetector(
              child: Container(
                height: 110.h,
                width: context.definePlatform(95.w, 85.0),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: .1),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: _heroWidget(context),
              ),
              onTap: isInDetails
                  ? null
                  : () {
                      Get.to(
                        () => ChaptersPage(
                          bookNumber: book!.bookNumber,
                          bookName: book!.bookName,
                          aboutBook: book!.aboutBook,
                        ),
                        transition: Transition.downToUp,
                      );
                    },
            ),
    );
  }

  Widget _heroWidget(BuildContext context) {
    return Hero(
      tag: 'book-tag:${isInDetails ? bookNumber : book!.bookNumber}',
      child: Stack(
        alignment: Alignment.center,
        children: [
          customSvgWithColor(SvgPath.svgBookBack),
          customSvg(SvgPath.svgRightBook),
          Transform.translate(
            offset: const Offset(0, -15),
            child: Container(
              height: isInDetails ? 150 : 60.h,
              width: isInDetails ? 90 : context.definePlatform(60.w, 50.0),
              alignment: Alignment.center,
              child: Text(
                isInDetails ? bookNane! : book!.bookName,
                style: TextStyle(
                  fontSize:
                      isInDetails ? 20 : context.definePlatform(12.0.sp, 12.0),
                  fontFamily: 'kufi',
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).canvasColor,
                  height: 1.5,
                ),
                maxLines: 3,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
