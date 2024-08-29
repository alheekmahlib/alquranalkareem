import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/presentation/screens/quran_page/controllers/extensions/audio_ui.dart';
import '/presentation/screens/quran_page/controllers/extensions/quran_getters.dart';
import '/presentation/screens/quran_page/controllers/extensions/quran_ui.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/extensions/extensions.dart';
import '../../../../core/utils/helpers/responsive.dart';
import '../controllers/audio/audio_controller.dart';
import '../controllers/bookmarks_controller.dart';
import '../controllers/quran/quran_controller.dart';
import '../controllers/translate_controller.dart';
import '../extensions/sajda_extension.dart';
import '../widgets/pages/left_page.dart';
import '../widgets/pages/pages_widget.dart';
import '../widgets/pages/right_page.dart';
import '../widgets/pages/top_title_widget.dart';

class QuranPages extends StatelessWidget {
  QuranPages({Key? key}) : super(key: key);
  final audioCtrl = AudioController.instance;
  final quranCtrl = QuranController.instance;
  final bookmarkCtrl = BookmarksController.instance;

  @override
  Widget build(BuildContext context) {
    bookmarkCtrl.getBookmarks();
    return SafeArea(
      child: GetBuilder<QuranController>(
        builder: (quranCtrl) => GestureDetector(
          onTap: () => audioCtrl.clearSelection(),
          onScaleStart: (details) => quranCtrl.state.baseScaleFactor.value =
              quranCtrl.state.scaleFactor.value,
          onScaleUpdate: (ScaleUpdateDetails details) => quranCtrl
              .state
              .scaleFactor
              .value = quranCtrl.state.baseScaleFactor.value * details.scale,
          child: Container(
            height: MediaQuery.sizeOf(context).height,
            child: PageView.builder(
              controller: quranCtrl.pageController,
              itemCount: 604,
              padEnds: false,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              onPageChanged: quranCtrl.pageChanged,
              itemBuilder: (_, index) {
                sl<TranslateDataController>().fetchTranslate(context);
                log('width: ${MediaQuery.sizeOf(context).width}');
                return !quranCtrl.state.isPageMode.value
                    ? _regularModeWidget(context, index)
                    : _pageModeWidget(context, index);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _pageModeWidget(BuildContext context, int index) {
    return Responsive.isMobile(context) || Responsive.isMobileLarge(context)
        ? Center(
            child: index.isEven
                ? RightPage(
                    child: Stack(
                      children: [
                        Align(
                            alignment: Alignment.topCenter,
                            child: TopTitleWidget(index: index, isRight: true)),
                        Align(
                            alignment: Alignment.center,
                            child: PagesWidget(pageIndex: index)),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              quranCtrl.getHizbQuarterDisplayByPage(index + 1),
                              style: TextStyle(
                                  fontSize:
                                      context.customOrientation(18.0, 22.0),
                                  fontFamily: 'naskh',
                                  color: const Color(0xff77554B)),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: showVerseToast(index)),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            '${'${index + 1}'.convertNumbers()}',
                            style: TextStyle(
                                fontSize: context.customOrientation(20.0, 22.0),
                                fontFamily: 'naskh',
                                color: const Color(0xff77554B)),
                          ),
                        ),
                      ],
                    ),
                  )
                : LeftPage(
                    child: Stack(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                            alignment: Alignment.topCenter,
                            child:
                                TopTitleWidget(index: index, isRight: false)),
                        Align(
                            alignment: Alignment.center,
                            child: PagesWidget(pageIndex: index)),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              quranCtrl.getHizbQuarterDisplayByPage(index + 1),
                              style: TextStyle(
                                  fontSize:
                                      context.customOrientation(18.0, 22.0),
                                  fontFamily: 'naskh',
                                  color: const Color(0xff77554B)),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: showVerseToast(index),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            '${'${index + 1}'.convertNumbers()}',
                            style: TextStyle(
                                fontSize: context.customOrientation(20.0, 22.0),
                                fontFamily: 'naskh',
                                color: const Color(0xff77554B)),
                          ),
                        ),
                      ],
                    ),
                  ))
        : Center(
            child: index.isEven
                ? RightPage(
                    child: ListView(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TopTitleWidget(index: index, isRight: true),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32.0,
                          ),
                          child: PagesWidget(pageIndex: index),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              quranCtrl.getHizbQuarterDisplayByPage(index + 1),
                              style: TextStyle(
                                  fontSize:
                                      context.customOrientation(18.0, 22.0),
                                  fontFamily: 'naskh',
                                  color: const Color(0xff77554B)),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: showVerseToast(index)),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            '${'${index + 1}'.convertNumbers()}',
                            style: TextStyle(
                                fontSize: context.customOrientation(18.0, 22.0),
                                fontFamily: 'naskh',
                                color: const Color(0xff77554B)),
                          ),
                        ),
                      ],
                    ),
                  )
                : LeftPage(
                    child: ListView(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TopTitleWidget(index: index, isRight: false),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32.0,
                          ),
                          child: PagesWidget(pageIndex: index),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              quranCtrl.getHizbQuarterDisplayByPage(index + 1),
                              style: TextStyle(
                                  fontSize:
                                      context.customOrientation(18.0, 22.0),
                                  fontFamily: 'naskh',
                                  color: const Color(0xff77554B)),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: showVerseToast(index)),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            '${index + 1}'.convertNumbers(),
                            style: TextStyle(
                                fontSize: context.customOrientation(18.0, 22.0),
                                fontFamily: 'naskh',
                                color: const Color(0xff77554B)),
                          ),
                        )
                      ],
                    ),
                  ));
  }

  Widget _regularModeWidget(BuildContext context, int index) {
    return Responsive.isMobile(context) || Responsive.isMobileLarge(context)
        ? Center(
            child: index.isEven
                ? Container(
                    height: MediaQuery.sizeOf(context).height,
                    color: quranCtrl.backgroundColor,
                    child: Stack(
                      children: [
                        Align(
                            alignment: Alignment.topCenter,
                            child: TopTitleWidget(index: index, isRight: true)),
                        Align(
                            alignment: Alignment.center,
                            child: PagesWidget(pageIndex: index)),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              quranCtrl.getHizbQuarterDisplayByPage(index + 1),
                              style: TextStyle(
                                  fontSize:
                                      context.customOrientation(18.0, 22.0),
                                  fontFamily: 'naskh',
                                  color: const Color(0xff77554B)),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: showVerseToast(index)),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            '${index + 1}'.convertNumbers(),
                            style: TextStyle(
                                fontSize: context.customOrientation(20.0, 22.0),
                                fontFamily: 'naskh',
                                color: const Color(0xff77554B)),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    height: MediaQuery.sizeOf(context).height,
                    color: quranCtrl.backgroundColor,
                    child: Stack(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                            alignment: Alignment.topCenter,
                            child:
                                TopTitleWidget(index: index, isRight: false)),
                        Align(
                            alignment: Alignment.center,
                            child: PagesWidget(pageIndex: index)),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              quranCtrl.getHizbQuarterDisplayByPage(index + 1),
                              style: TextStyle(
                                  fontSize:
                                      context.customOrientation(18.0, 22.0),
                                  fontFamily: 'naskh',
                                  color: const Color(0xff77554B)),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: showVerseToast(index),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            '${index + 1}'.convertNumbers(),
                            style: TextStyle(
                                fontSize: context.customOrientation(20.0, 22.0),
                                fontFamily: 'naskh',
                                color: const Color(0xff77554B)),
                          ),
                        ),
                      ],
                    ),
                  ))
        : Center(
            child: index.isEven
                ? Container(
                    height: MediaQuery.sizeOf(context).height,
                    color: quranCtrl.backgroundColor,
                    child: ListView(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TopTitleWidget(index: index, isRight: true),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32.0,
                          ),
                          child: PagesWidget(pageIndex: index),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              quranCtrl.getHizbQuarterDisplayByPage(index + 1),
                              style: TextStyle(
                                  fontSize:
                                      context.customOrientation(18.0, 22.0),
                                  fontFamily: 'naskh',
                                  color: const Color(0xff77554B)),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: showVerseToast(index)),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            '${index + 1}'.convertNumbers(),
                            style: TextStyle(
                                fontSize: context.customOrientation(18.0, 22.0),
                                fontFamily: 'naskh',
                                color: const Color(0xff77554B)),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    height: MediaQuery.sizeOf(context).height,
                    color: quranCtrl.backgroundColor,
                    child: ListView(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TopTitleWidget(index: index, isRight: false),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32.0,
                          ),
                          child: PagesWidget(pageIndex: index),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              quranCtrl.getHizbQuarterDisplayByPage(index + 1),
                              style: TextStyle(
                                  fontSize:
                                      context.customOrientation(18.0, 22.0),
                                  fontFamily: 'naskh',
                                  color: const Color(0xff77554B)),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: showVerseToast(index)),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            '${index + 1}'.convertNumbers(),
                            style: TextStyle(
                                fontSize: context.customOrientation(18.0, 22.0),
                                fontFamily: 'naskh',
                                color: const Color(0xff77554B)),
                          ),
                        )
                      ],
                    ),
                  ));
  }
}
