import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/extensions/extensions.dart';
import '../../../controllers/bookmarks_controller.dart';
import '../../../controllers/general_controller.dart';
import '../../../controllers/translate_controller.dart';
import '../widgets/pages/left_page.dart';
import '../widgets/pages/pages_widget.dart';
import '../widgets/pages/right_page.dart';
import '../widgets/pages/top_title_widget.dart';
import '/presentation/controllers/audio_controller.dart';

class QuranPages extends StatelessWidget {
  QuranPages({Key? key}) : super(key: key);
  final audioCtrl = sl<AudioController>();
  final generalCtrl = sl<GeneralController>();
  final bookmarkCtrl = sl<BookmarksController>();

  @override
  Widget build(BuildContext context) {
    bookmarkCtrl.getBookmarks();
    final size = MediaQuery.sizeOf(context);

    return SafeArea(
      child: GetBuilder<GeneralController>(
        builder: (generalCtrl) => GestureDetector(
          onTap: () {
            audioCtrl.clearSelection();
          },
          child: PageView.builder(
            controller: generalCtrl.pageController,
            itemCount: 604,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            onPageChanged: generalCtrl.pageChanged,
            itemBuilder: (_, index) {
              sl<TranslateDataController>().fetchTranslate(context);
              return index.isEven
                  ? RightPage(
                      child: ListView(
                        children: [
                          TopTitleWidget(index: index, isRight: true),
                          Gap(size.height * .04),
                          PagesWidget(pageIndex: index),
                          Gap(size.height * .04),
                          Center(
                            child: Text(
                              '${generalCtrl.convertNumbers('${index + 1}')}',
                              style: TextStyle(
                                  fontSize:
                                      context.customOrientation(18.0, 22.0),
                                  fontFamily: 'naskh',
                                  color: const Color(0xff77554B)),
                            ),
                          ),
                        ],
                      ),
                    )
                  : LeftPage(
                      child: ListView(
                        children: [
                          TopTitleWidget(index: index, isRight: false),
                          Gap(size.height * .04),
                          PagesWidget(pageIndex: index),
                          Gap(size.height * .04),
                          Center(
                            child: Text(
                              '${generalCtrl.convertNumbers('${index + 1}')}',
                              style: TextStyle(
                                  fontSize:
                                      context.customOrientation(18.0, 22.0),
                                  fontFamily: 'naskh',
                                  color: const Color(0xff77554B)),
                            ),
                          )
                        ],
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
