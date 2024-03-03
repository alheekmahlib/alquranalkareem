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
      child: GetBuilder<GeneralController>(
        builder: (generalCtrl) => GestureDetector(
          onTap: () {
            audioCtrl.clearSelection();
          },
          child: PageView.builder(
            controller: generalCtrl.pageController,
            itemCount: 604,
            padEnds: false,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            onPageChanged: generalCtrl.pageChanged,
            itemBuilder: (_, index) {
              sl<TranslateDataController>().fetchTranslate(context);
              return context.customOrientation(
                  index.isEven
                      ? RightPage(
                          child: Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Align(
                                    alignment: Alignment.topCenter,
                                    child: TopTitleWidget(
                                        index: index, isRight: true)),
                              ),
                              Expanded(
                                  flex: 10,
                                  child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: PagesWidget(pageIndex: index))),
                              Expanded(
                                flex: 1,
                                child: Align(
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
                              ),
                            ],
                          ),
                        )
                      : LeftPage(
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Align(
                                      alignment: Alignment.topCenter,
                                      child: TopTitleWidget(
                                          index: index, isRight: false))),
                              Expanded(
                                  flex: 10,
                                  child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: PagesWidget(pageIndex: index))),
                              Expanded(
                                flex: 1,
                                child: Align(
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
                              )
                            ],
                          ),
                        ),
                  index.isEven
                      ? RightPage(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                TopTitleWidget(index: index, isRight: true),
                                PagesWidget(pageIndex: index),
                                Text(
                                  '${generalCtrl.convertNumbers('${index + 1}')}',
                                  style: TextStyle(
                                      fontSize:
                                          context.customOrientation(18.0, 22.0),
                                      fontFamily: 'naskh',
                                      color: const Color(0xff77554B)),
                                ),
                              ],
                            ),
                          ),
                        )
                      : LeftPage(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                TopTitleWidget(index: index, isRight: false),
                                PagesWidget(pageIndex: index),
                                Text(
                                  '${generalCtrl.convertNumbers('${index + 1}')}',
                                  style: TextStyle(
                                      fontSize:
                                          context.customOrientation(18.0, 22.0),
                                      fontFamily: 'naskh',
                                      color: const Color(0xff77554B)),
                                )
                              ],
                            ),
                          ),
                        ));
            },
          ),
        ),
      ),
    );
  }
}
