import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    return SafeArea(
      child: SingleChildScrollView(
        child: GetBuilder<GeneralController>(
          builder: (generalCtrl) => GestureDetector(
            onTap: () {
              audioCtrl.clearSelection();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              height: MediaQuery.sizeOf(context).height,
              child: PageView.builder(
                controller: generalCtrl.pageController,
                itemCount: 604,
                padEnds: false,
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                onPageChanged: generalCtrl.pageChanged,
                itemBuilder: (_, index) {
                  sl<TranslateDataController>().fetchTranslate(context);
                  return Center(
                    child: index.isEven
                        ? RightPage(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                    alignment: Alignment.topCenter,
                                    child: TopTitleWidget(
                                        index: index, isRight: true)),
                                Flexible(
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: SingleChildScrollView(
                                            child:
                                                PagesWidget(pageIndex: index)),
                                      )),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    '${generalCtrl.convertNumbers('${index + 1}')}',
                                    style: TextStyle(
                                        fontSize: context.customOrientation(
                                            18.0, 22.0),
                                        fontFamily: 'naskh',
                                        color: const Color(0xff77554B)),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : LeftPage(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                    alignment: Alignment.topCenter,
                                    child: TopTitleWidget(
                                        index: index, isRight: false)),
                                Flexible(
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: SingleChildScrollView(
                                            child:
                                                PagesWidget(pageIndex: index)),
                                      )),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    '${generalCtrl.convertNumbers('${index + 1}')}',
                                    style: TextStyle(
                                        fontSize: context.customOrientation(
                                            18.0, 22.0),
                                        fontFamily: 'naskh',
                                        color: const Color(0xff77554B)),
                                  ),
                                )
                              ],
                            ),
                          ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
