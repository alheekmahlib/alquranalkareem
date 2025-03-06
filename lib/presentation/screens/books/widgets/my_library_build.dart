import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../../core/utils/constants/svg_constants.dart';
import '../controller/books_controller.dart';
import 'book_cover_widget.dart';

class MyLibraryBuild extends StatelessWidget {
  MyLibraryBuild({super.key});

  final booksCtrl = BooksController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (booksCtrl.state.isLoading.value) {
        return const Center(child: CircularProgressIndicator.adaptive());
      }
      final downloadedBooks = booksCtrl.state.booksList
          .where((book) => booksCtrl.state.downloaded[book.bookNumber] == true)
          .toList();
      return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'myLibrary'.tr,
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: 'kufi',
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
          downloadedBooks.isEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Gap(64),
                    customSvgWithCustomColor(
                      SvgPath.svgTafseer,
                      height: 50,
                    ),
                    const Gap(16),
                    Text(
                      'noBooksDownloaded'.tr,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'kufi',
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    const Gap(64),
                  ],
                )
              : Wrap(
                  alignment: WrapAlignment.center,
                  children: List.generate(
                    downloadedBooks.length,
                    (index) {
                      final book = downloadedBooks[index];
                      return BookCoverWidget(book: book);
                    },
                  ),
                ),
          context.hDivider(width: Get.width),
        ],
      );
    });
  }
}
