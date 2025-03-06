import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:read_more_less/read_more_less.dart';

import '/presentation/screens/books/controller/extensions/books_getters.dart';
import '/presentation/screens/books/controller/extensions/books_ui.dart';
import '../controller/books_controller.dart';
import 'book_cover_widget.dart';

class BookDetails extends StatelessWidget {
  final int bookNumber;
  final String bookName;
  final String aboutBook;

  BookDetails({
    super.key,
    required this.bookName,
    required this.bookNumber,
    required this.aboutBook,
  });

  final booksCtrl = BooksController.instance;

  @override
  Widget build(BuildContext context) {
    // OverlayTooltipScaffold.of(context)?.controller.start(3);
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          // height: 290,
          width: 380,
          margin: const EdgeInsets.only(top: 120, right: 16.0, left: 16.0),
          decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.surface.withValues(alpha: .15),
              borderRadius: const BorderRadius.all(Radius.circular(8))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: 32,
                // width: 107,
                padding:
                    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
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
                  child: Obx(() => ReadMoreLess(
                        text: aboutBook,
                        maxLines: 1,
                        collapsedHeight:
                            booksCtrl.collapsedHeight(bookNumber).value
                                ? 130
                                : 30,
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontFamily: 'naskh',
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        textAlign: TextAlign.justify,
                        readMoreText: 'readMore'.tr,
                        readLessText: 'readLess'.tr,
                        buttonTextStyle: TextStyle(
                          fontSize: 12,
                          fontFamily: 'kufi',
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        iconColor: Theme.of(context).colorScheme.inversePrimary,
                      ))),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BookCoverWidget(
                  isInDetails: true,
                  bookNane: bookName,
                  bookNumber: bookNumber),
              Align(
                alignment: Alignment.center,
                child: Center(
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
                        : Row(
                            children: [
                              booksCtrl.state.downloading[bookNumber] == true
                                  ? Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4)),
                                      ),
                                      child: LinearProgressIndicator(
                                        minHeight: 10,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4)),
                                        value: booksCtrl.state
                                                .downloadProgress[bookNumber] ??
                                            0,
                                        //(daysRemaining / 1000).toDouble(),
                                        backgroundColor:
                                            Theme.of(context).canvasColor,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              booksCtrl.state.downloading[bookNumber] == true
                                  ? const SizedBox.shrink()
                                  : GestureDetector(
                                      child: Icon(
                                        Icons.download,
                                        size: 24,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      onTap: () async => await booksCtrl
                                          .downloadBook(bookNumber),
                                    ),
                            ],
                          ),
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
