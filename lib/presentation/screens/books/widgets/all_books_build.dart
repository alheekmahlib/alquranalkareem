import 'package:alquranalkareem/presentation/screens/books/widgets/book_cover_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '../controller/books_controller.dart';

class AllBooksBuild extends StatelessWidget {
  AllBooksBuild({super.key});

  final booksCtrl = BooksController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (booksCtrl.state.isLoading.value) {
        return const Center(child: CircularProgressIndicator.adaptive());
      }
      final allBooks = booksCtrl.state.booksList;
      return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'allBooks'.tr,
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: 'kufi',
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            children: List.generate(
              allBooks.length,
              (index) {
                final book = allBooks[index];
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
