import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '/core/utils/constants/svg_constants.dart';
import '../../../controllers/books_controller.dart';
import '../widgets/books_last_read.dart';
import '../widgets/search_screen.dart';
import 'chapters_screen.dart';

class BooksPage extends StatelessWidget {
  final booksCtrl = BooksController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                topLeft: Radius.circular(8),
              )),
          child: Obx(() {
            if (booksCtrl.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            // الكتب التي تم تحميلها
            final downloadedBooks = booksCtrl.booksList
                .where((book) => booksCtrl.downloaded[book.bookNumber] == true)
                .toList();
            // الكتب التي لم يتم تحميلها
            final allBooks = booksCtrl.booksList;

            return ListView(
              children: [
                const Gap(32),
                customSvg(
                  SvgPath.svgTafseer,
                  height: 60,
                ),
                BooksLastRead(),
                // قسم الكتب التي تم تحميلها
                downloadedBooks.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'الكتب التي تم تحميلها',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'kufi',
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: List.generate(
                    downloadedBooks.length,
                    (index) {
                      final book = downloadedBooks[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          child: Container(
                            height: 110.h,
                            width: 95.w,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(.1),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Hero(
                                  tag: 'book-tag:${book.bookNumber}',
                                  child: customSvg(SvgPath.svgRightBook),
                                ),
                                SizedBox(
                                  height: 60.h,
                                  width: 60.w,
                                  child: Text(
                                    book.bookName,
                                    style: TextStyle(
                                      fontSize: 12.0.sp,
                                      fontFamily: 'kufi',
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).canvasColor,
                                      height: 1.5,
                                    ),
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Get.to(
                              () => ChaptersPage(
                                bookNumber: book.bookNumber,
                                bookName: book.bookName,
                              ),
                              transition: Transition.downToUp,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                context.hDivider(width: Get.width),
                // قسم جميع الكتب
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'جميع الكتب',
                    style: TextStyle(
                      fontSize: 18.0,
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
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          child: Container(
                            height: 110.h,
                            width: 95.w,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(.1),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Hero(
                                  tag: 'book-tag-:${book.bookNumber}',
                                  child: customSvg(SvgPath.svgRightBook),
                                ),
                                SizedBox(
                                  height: 60.h,
                                  width: 60.w,
                                  child: Text(
                                    book.bookName,
                                    style: TextStyle(
                                      fontSize: 12.0.sp,
                                      fontFamily: 'kufi',
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).canvasColor,
                                      height: 1.5,
                                    ),
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Get.to(
                              () => ChaptersPage(
                                bookNumber: book.bookNumber,
                                bookName: book.bookName,
                              ),
                              transition: Transition.downToUp,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                context.hDivider(width: Get.width),
              ],
            );
          }),
        ),
      ),
    );
  }
}
