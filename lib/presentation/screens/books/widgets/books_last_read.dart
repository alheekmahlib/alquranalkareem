import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../controllers/books_controller.dart';
import '../../../controllers/general_controller.dart';
import '../screens/read_view_screen.dart';

class BooksLastRead extends StatelessWidget {
  BooksLastRead({super.key});

  final generalCtrl = GeneralController.instance;
  final bookCtrl = BooksController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var lastReadBooks = bookCtrl.booksList.where((book) {
        return bookCtrl.lastReadPage.containsKey(book.bookNumber);
      }).toList();
      return lastReadBooks.isNotEmpty
          ? Container(
              height: 150,
              width: Get.width,
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              margin: const EdgeInsets.symmetric(vertical: 32.0),
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
                  const Gap(8.0),
                  Container(
                    height: 100,
                    width: Get.width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: lastReadBooks.length,
                      itemBuilder: (context, index) {
                        var book = lastReadBooks[index];
                        var currentPage =
                            bookCtrl.lastReadPage[book.bookNumber] ?? 0;
                        var totalPages =
                            bookCtrl.bookTotalPages[book.bookNumber] ?? 1;
                        var progress = currentPage / totalPages;

                        return GestureDetector(
                          onTap: () => Get.to(() => PagesPage(
                              bookNumber: book.bookNumber,
                              initialPage: currentPage)),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            width: 70,
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(.15),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0))),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Text(
                                  book.bookName,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: 'naskh',
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).hintColor,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: LinearProgressIndicator(
                                    minHeight: 10,
                                    value: progress,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                    ),
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(.15),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surface
                                        .withOpacity(.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink();
    });
  }
}
