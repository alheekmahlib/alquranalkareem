import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../../core/utils/constants/svg_constants.dart';
import '../../../controllers/books_controller.dart';
import '../widgets/book_details_widget.dart';
import '../widgets/books_chapters_build.dart';
import '../widgets/search_screen.dart';

class ChaptersPage extends StatelessWidget {
  final int bookNumber;
  final String bookName;

  ChaptersPage({required this.bookNumber, required this.bookName});

  final booksCtrl = BooksController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('الكتب'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () =>
                  Get.bottomSheet(SearchScreen(), isScrollControlled: true),
              icon: customSvgWithColor(SvgPath.svgSearchIcon,
                  color: Theme.of(context).canvasColor)),
        ],
      ),
      body: SafeArea(
          child: Column(
        children: [
          const Gap(8),
          BookDetails(
            bookNumber: bookNumber,
            bookName: bookName,
          ),
          const Gap(64),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: BooksChapterBuild(
                  bookNumber: bookNumber,
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
