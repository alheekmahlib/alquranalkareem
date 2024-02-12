import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../controllers/bookmarks_controller.dart';
import '/core/utils/constants/extensions.dart';
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
      height: MediaQuery.sizeOf(context).height * .9,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
          color: Get.theme.colorScheme.background,
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
            Flexible(
              child: ListView(
                children: [
                  const Gap(32),
                  BookmarkPagesBuild(),
                  const Gap(32),
                  BookmarkAyahsBuild(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
