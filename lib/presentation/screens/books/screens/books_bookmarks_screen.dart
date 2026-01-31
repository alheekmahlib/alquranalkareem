import 'dart:developer';

import 'package:alquranalkareem/core/utils/constants/extensions/custom_error_snackBar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../../core/utils/constants/lottie_constants.dart';
import '../controller/books_bookmarks_controller.dart';
import 'read_view_screen.dart';

class BookBookmarksScreen extends StatelessWidget {
  final booksBookmarksCtrl = BooksBookmarksController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var groupedBookmarks = booksBookmarksCtrl.groupByBookName(
        booksBookmarksCtrl.bookmarks,
      );

      return booksBookmarksCtrl.bookmarks.isEmpty
          ? Column(
              children: [
                const Gap(64),
                Text(
                  'bookmarks'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                    fontFamily: 'kufi',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                customLottieWithColor(
                  LottieConstants.assetsLottieSearch,
                  height: 150.0,
                  width: 150.0,
                ),
                const Gap(64),
              ],
            )
          : ListView.builder(
              itemCount: groupedBookmarks.length,
              itemBuilder: (context, index) {
                var bookName = groupedBookmarks.keys.elementAt(index);
                var bookmarks = groupedBookmarks[bookName]!;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ExpansionTile(
                    title: Text(
                      bookName,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'kufi',
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    collapsedIconColor: Theme.of(
                      context,
                    ).colorScheme.inversePrimary,
                    iconColor: Theme.of(context).colorScheme.inversePrimary,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: .1),
                    collapsedBackgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: .1),
                    children: bookmarks.map((bookmark) {
                      return ListTile(
                        title: Text(
                          '${'page'.tr}: ${bookmark.currentPage}'
                              .convertNumbersToCurrentLang(),
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'kufi',
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            size: 24,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          onPressed: () {
                            booksBookmarksCtrl
                                .deleteBookmark(
                                  bookmark.bookNumber!,
                                  bookmark.currentPage!,
                                )
                                .then(
                                  (_) => Get.context!.showCustomErrorSnackBar(
                                    'deletedBookmark'.tr,
                                  ),
                                );
                            // booksBookmarksCtrl.deleteBookmark(
                            //     bookmark.id, bookmark.currentPage!);
                            log('bookmark deleted');
                          },
                        ),
                        onTap: () {
                          Get.to(
                            () =>
                                PagesPage(bookNumber: bookmark.bookNumber ?? 0),
                          );
                        },
                      );
                    }).toList(),
                  ),
                );
              },
            );
    });
  }
}
