import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/extensions/extensions.dart';
import '../../../../../core/utils/constants/lottie.dart';
import '../../../../controllers/bookmarks_controller.dart';
import 'bookmark_ayahs_build.dart';
import 'bookmark_pages_build.dart';

class BookmarksList extends StatelessWidget {
  BookmarksList({Key? key}) : super(key: key);

  final bookmarkCtrl = sl<BookmarksController>();

  @override
  Widget build(BuildContext context) {
    bookmarkCtrl.getBookmarks();
    bookmarkCtrl.getBookmarksText();
    return Container(
      height: MediaQuery.sizeOf(context).height * .96,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
          )),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            context.customClose(),
            GetBuilder<BookmarksController>(
              builder: (bookmarkCtrl) => bookmarkCtrl.bookmarksList.isEmpty &&
                      bookmarkCtrl.BookmarkTextList.isEmpty
                  ? Center(
                      child: Column(
                      children: [
                        Text(
                          'bookmarks'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.surface,
                              fontFamily: 'kufi',
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                        ),
                        search(150.0, 150.0),
                      ],
                    ))
                  : Flexible(
                      child: Column(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Text(
                              'bookmarks'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.surface,
                                  fontFamily: 'kufi',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18),
                            ),
                          ),
                          bookmarkCtrl.bookmarksList.isEmpty
                              ? const SizedBox.shrink()
                              : Flexible(flex: 10, child: BookmarkPagesBuild()),
                          const Gap(16),
                          bookmarkCtrl.BookmarkTextList.isEmpty
                              ? const SizedBox.shrink()
                              : Flexible(flex: 10, child: BookmarkAyahsBuild()),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
