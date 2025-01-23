part of '../quran.dart';

class QuranPages extends StatelessWidget {
  QuranPages({Key? key}) : super(key: key);
  final audioCtrl = AudioController.instance;
  final quranCtrl = QuranController.instance;
  final bookmarkCtrl = BookmarksController.instance;

  @override
  Widget build(BuildContext context) {
    bookmarkCtrl.getBookmarks();
    NotificationManager().updateBookProgress(
        'quran'.tr,
        'notifyQuranBody'.trParams({
          'currentPageNumber': '${quranCtrl.state.currentPageNumber.value}'
        }),
        quranCtrl.state.currentPageNumber.value);
    return SafeArea(
      child: GetBuilder<QuranController>(
        id: 'clearSelection',
        builder: (quranCtrl) => GestureDetector(
          onTap: () => audioCtrl.clearSelection(),
          onScaleStart: (details) => quranCtrl.state.baseScaleFactor.value =
              quranCtrl.state.scaleFactor.value,
          onScaleUpdate: (ScaleUpdateDetails details) =>
              quranCtrl.updateTextScale(details),
          child: Container(
            height: MediaQuery.sizeOf(context).height,
            child: Focus(
              focusNode: quranCtrl.state.quranPageRLFocusNode,
              onKeyEvent: (node, event) =>
                  quranCtrl.controlRLByKeyboard(node, event),
              child: PageView.builder(
                controller: quranCtrl.pageController,
                itemCount:
                    604, // Responsive.isDesktop(context) ? (604 / 2).ceil() : 604,
                padEnds: false,
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                onPageChanged: quranCtrl.pageChanged,
                itemBuilder: (_, index) {
                  int leftPageIndex = index * 2;
                  int rightPageIndex = leftPageIndex + 1;
                  sl<TranslateDataController>().fetchTranslate();
                  log('width: ${MediaQuery.sizeOf(context).width}');
                  return !quranCtrl.state.isPageMode.value
                      ? _regularModeWidget(
                          context, index, leftPageIndex, rightPageIndex)
                      : _pageModeWidget(context, index);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _pageModeWidget(BuildContext context, int index) {
    return Center(
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
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          quranCtrl.getHizbQuarterDisplayByPage(index + 1),
                          style: TextStyle(
                              fontSize: context.customOrientation(18.0, 22.0),
                              fontFamily: 'naskh',
                              color: const Color(0xff77554B)),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                        child: TopTitleWidget(index: index, isRight: false)),
                    Align(
                        alignment: Alignment.center,
                        child: PagesWidget(pageIndex: index)),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          quranCtrl.getHizbQuarterDisplayByPage(index + 1),
                          style: TextStyle(
                              fontSize: context.customOrientation(18.0, 22.0),
                              fontFamily: 'naskh',
                              color: const Color(0xff77554B)),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
              ));
  }

  Widget _regularModeWidget(
      BuildContext context, int index, int leftPageIndex, int rightPageIndex) {
    return Center(
        child:
            // Responsive.isDesktop(context)
            //     ? Container(
            //         height: MediaQuery.sizeOf(context).height,
            //         color: quranCtrl.backgroundColor,
            //         child: Row(
            //           children: [
            //             Expanded(
            //               flex: 5,
            //               child: Stack(
            //                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 // crossAxisAlignment: CrossAxisAlignment.center,
            //                 children: [
            //                   Align(
            //                       alignment: Alignment.topCenter,
            //                       child: TopTitleWidget(
            //                           index: leftPageIndex, isRight: true)),
            //                   Align(
            //                       alignment: Alignment.center,
            //                       child: PagesWidget(pageIndex: leftPageIndex)),
            //                   Align(
            //                     alignment: Alignment.bottomLeft,
            //                     child: Padding(
            //                       padding:
            //                           const EdgeInsets.symmetric(horizontal: 16.0),
            //                       child: Text(
            //                         quranCtrl.getHizbQuarterDisplayByPage(
            //                             leftPageIndex + 1),
            //                         style: TextStyle(
            //                             fontSize:
            //                                 context.customOrientation(18.0, 22.0),
            //                             fontFamily: 'naskh',
            //                             color: const Color(0xff77554B)),
            //                       ),
            //                     ),
            //                   ),
            //                   Align(
            //                     alignment: Alignment.bottomRight,
            //                     child: Padding(
            //                       padding:
            //                           const EdgeInsets.symmetric(horizontal: 16.0),
            //                       child: showVerseToast(leftPageIndex),
            //                     ),
            //                   ),
            //                   Align(
            //                     alignment: Alignment.bottomCenter,
            //                     child: Text(
            //                       '${leftPageIndex + 1}'.convertNumbers(),
            //                       style: TextStyle(
            //                           fontSize:
            //                               context.customOrientation(20.0, 22.0),
            //                           fontFamily: 'naskh',
            //                           color: const Color(0xff77554B)),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //             if (leftPageIndex < 604)
            //               Expanded(
            //                 flex: 5,
            //                 child: Stack(
            //                   children: [
            //                     Align(
            //                         alignment: Alignment.topCenter,
            //                         child: TopTitleWidget(
            //                             index: rightPageIndex, isRight: false)),
            //                     Align(
            //                         alignment: Alignment.center,
            //                         child: PagesWidget(pageIndex: rightPageIndex)),
            //                     Align(
            //                       alignment: Alignment.bottomRight,
            //                       child: Padding(
            //                         padding: const EdgeInsets.symmetric(
            //                             horizontal: 16.0),
            //                         child: Text(
            //                           quranCtrl.getHizbQuarterDisplayByPage(
            //                               rightPageIndex + 1),
            //                           style: TextStyle(
            //                               fontSize:
            //                                   context.customOrientation(18.0, 22.0),
            //                               fontFamily: 'naskh',
            //                               color: const Color(0xff77554B)),
            //                         ),
            //                       ),
            //                     ),
            //                     Align(
            //                       alignment: Alignment.bottomLeft,
            //                       child: Padding(
            //                           padding: const EdgeInsets.symmetric(
            //                               horizontal: 16.0),
            //                           child: showVerseToast(rightPageIndex)),
            //                     ),
            //                     Align(
            //                       alignment: Alignment.bottomCenter,
            //                       child: Text(
            //                         '${rightPageIndex + 1}'.convertNumbers(),
            //                         style: TextStyle(
            //                             fontSize:
            //                                 context.customOrientation(20.0, 22.0),
            //                             fontFamily: 'naskh',
            //                             color: const Color(0xff77554B)),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //           ],
            //         ),
            //       )
            //     :
            index.isEven
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
                  ));
  }
}
