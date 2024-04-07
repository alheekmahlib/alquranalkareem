import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/svg_picture.dart';
import '../../../../controllers/audio_controller.dart';
import '../../../../controllers/bookmarks_controller.dart';
import '../../../../controllers/general_controller.dart';
import '/core/utils/constants/extensions/custom_error_snackBar.dart';

class AddBookmarkButton extends StatelessWidget {
  final int surahNum;
  final int ayahNum;
  final int ayahUQNum;
  final int pageIndex;
  final String surahName;
  final Function? cancel;

  const AddBookmarkButton({
    super.key,
    required this.surahNum,
    required this.ayahNum,
    required this.ayahUQNum,
    required this.pageIndex,
    required this.surahName,
    this.cancel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Obx(() => Semantics(
            button: true,
            enabled: true,
            label: 'Add Bookmark',
            child:
                sl<BookmarksController>().hasBookmark(surahNum, ayahUQNum).value
                    ? bookmark_icon2(height: 20.0)
                    : bookmark_icon(height: 20.0),
          )),
      onTap: () async {
        if (sl<BookmarksController>().hasBookmark(surahNum, ayahUQNum).value) {
          sl<BookmarksController>().deleteBookmarksText(ayahUQNum);
          // sl<QuranController>().clearSelection();
        } else {
          sl<BookmarksController>()
              .addBookmarkText(surahName, surahNum, pageIndex + 1, ayahNum,
                  ayahUQNum, sl<GeneralController>().timeNow.dateNow)
              .then(
                  (value) => context.showCustomErrorSnackBar('addBookmark'.tr));
          // sl<QuranController>().clearSelection();
        }
        sl<AudioController>().clearSelection();
        cancel!();
      },
    );
  }
}
