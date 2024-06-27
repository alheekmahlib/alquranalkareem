import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:read_more_less/read_more_less.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../../core/utils/constants/svg_constants.dart';
import '../../../controllers/books_controller.dart';

class BookDetails extends StatelessWidget {
  final int bookNumber;
  final String bookName;
  BookDetails({
    super.key,
    required this.bookName,
    required this.bookNumber,
  });

  final booksCtrl = BooksController.instance;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Transform.translate(
          offset: const Offset(0, 120),
          child: Container(
            // height: 290,
            width: 380,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(.15),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 32,
                  width: 107,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.all(Radius.circular(4))),
                  child: Text(
                    'aboutBook'.tr,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'kufi',
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Gap(35.h),
                Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                    child: ReadMoreLess(
                      text: 'BOOK ABOUT NOT FOUND',
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontFamily: 'naskh',
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.justify,
                      readMoreText: 'readMore'.tr,
                      readLessText: 'readLess'.tr,
                      buttonTextStyle: TextStyle(
                        fontSize: 12,
                        fontFamily: 'kufi',
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      iconColor: Theme.of(context).colorScheme.primary,
                    )),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Hero(
                      tag: 'book-tag-:$bookNumber',
                      child: customSvg(SvgPath.svgRightBook)),
                  Transform.translate(
                    offset: const Offset(2, 20),
                    child: SizedBox(
                      height: 150,
                      width: 90,
                      child: Text(
                        bookName,
                        style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'kufi',
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                            height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: Obx(
                  () => booksCtrl.isBookDownloaded(bookNumber)
                      ? GestureDetector(
                          child: Icon(
                            Icons.delete,
                            size: 28,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          onTap: () async =>
                              await booksCtrl.deleteBook(bookNumber),
                        )
                      : booksCtrl.downloading[bookNumber] == true
                          ? SquarePercentIndicator(
                              width: 50,
                              height: 50,
                              startAngle: StartAngle.topRight,
                              reverse: false,
                              borderRadius: 12,
                              shadowWidth: 1.5,
                              progressWidth: 5,
                              shadowColor: Colors.grey,
                              progressColor: Colors.blue,
                              progress:
                                  booksCtrl.downloadProgress[bookNumber] ?? 0,
                              child: Center(
                                child: Text(
                                  '${((booksCtrl.downloadProgress[bookNumber] ?? 0) * 100).toStringAsFixed(0)}%',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            )
                          : GestureDetector(
                              child: Icon(
                                Icons.download,
                                size: 24,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onTap: () async =>
                                  await booksCtrl.downloadBook(bookNumber),
                            ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
