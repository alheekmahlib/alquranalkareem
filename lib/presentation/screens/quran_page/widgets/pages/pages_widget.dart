import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/presentation/screens/quran_page/controllers/extensions/quran_ui.dart';
import '../../../../../core/services/services_locator.dart';
import '../../../../controllers/general/general_controller.dart';
import '../../controllers/audio/audio_controller.dart';
import '../../controllers/bookmarks_controller.dart';
import '../../controllers/quran/quran_controller.dart';
import 'text_build.dart';
import 'text_scale_build.dart';

class PagesWidget extends StatelessWidget {
  final int pageIndex;

  PagesWidget({super.key, required this.pageIndex});

  final audioCtrl = AudioController.instance;
  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    sl<BookmarksController>().getBookmarksText();
    return GetX<QuranController>(builder: (quranCtrl) {
      return Container(
        padding: pageIndex == 0 || pageIndex == 1
            ? EdgeInsets.symmetric(horizontal: Get.width * .08)
            : EdgeInsets.zero,
        margin: pageIndex == 0 || pageIndex == 1
            ? EdgeInsets.symmetric(vertical: Get.width * .16)
            : const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
        child: quranCtrl.state.pages.isEmpty
            ? const CircularProgressIndicator.adaptive()
            : quranCtrl.textScale(TextBuild(pageIndex: pageIndex),
                TextScaleBuild(pageIndex: pageIndex)),
      );
    });
  }
}
