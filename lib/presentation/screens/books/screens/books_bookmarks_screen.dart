import 'package:alquranalkareem/core/utils/constants/extensions/convert_number_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/books_bookmarks_controller.dart';
import 'read_view_screen.dart';

class BookBookmarksScreen extends StatelessWidget {
  final booksBookmarksCtrl = BooksBookmarksController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var groupedBookmarks =
          booksBookmarksCtrl.groupByBookName(booksBookmarksCtrl.bookmarks);

      return ListView.builder(
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
              collapsedIconColor: Theme.of(context).colorScheme.inversePrimary,
              iconColor: Theme.of(context).colorScheme.inversePrimary,
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(.1),
              collapsedBackgroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(.1),
              children: bookmarks.map((bookmark) {
                return ListTile(
                  title: Text(
                    '${'page'.tr}: ${bookmark.currentPage}'.convertNumbers(),
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
                      booksBookmarksCtrl.deleteBookmark(
                          bookmark.id, bookmark.currentPage!);
                    },
                  ),
                  onTap: () {
                    Get.to(() => PagesPage(
                          bookNumber: bookmark.bookNumber ?? 0,
                        ));
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
