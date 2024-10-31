import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../../core/utils/constants/svg_constants.dart';
import '../../../../core/widgets/app_bar_widget.dart';
import '../controller/books_controller.dart';
import '../widgets/book_details_widget.dart';
import '../widgets/books_chapters_build.dart';
import '../widgets/search_screen.dart';

class ChaptersPage extends StatelessWidget {
  final int bookNumber;
  final String bookName;
  final String aboutBook;

  ChaptersPage(
      {required this.bookNumber,
      required this.bookName,
      required this.aboutBook});

  final booksCtrl = BooksController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBarWidget(
        isTitled: true,
        title: 'tafsirLibrary'.tr,
        isFontSize: false,
        searchButton: IconButton(
            onPressed: () => Get.bottomSheet(
                SearchScreen(
                  onSubmitted: (v) => booksCtrl.searchBooks(
                      booksCtrl.state.searchController.text,
                      bookNumber: bookNumber),
                ),
                isScrollControlled: true),
            icon: customSvgWithColor(SvgPath.svgSearchIcon,
                color: Theme.of(context).colorScheme.surface)),
        isNotifi: false,
        isBooks: false,
      ),
      body: SafeArea(
          child: ListView(
        children: [
          const Gap(8),
          BookDetails(
            bookNumber: bookNumber,
            bookName: bookName,
            aboutBook: aboutBook,
          ),
          const Gap(16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: BooksChapterBuild(
                bookNumber: bookNumber,
              ),
            ),
          ),
          const Gap(16),
        ],
      )),
    );
  }
}
