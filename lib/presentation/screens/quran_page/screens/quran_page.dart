part of '../quran.dart';

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
                itemCount: 604,
                padEnds: false,
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                onPageChanged: quranCtrl.pageChanged,
                itemBuilder: (_, index) {
                  TranslateDataController.instance.fetchTranslate(context);
                  log('width: ${MediaQuery.sizeOf(context).width}');
                  return !quranCtrl.state.isPageMode.value
                      ? _regularModeWidget(context, index)
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
                    child: Focus(
                      focusNode: quranCtrl.state.quranPageUDFocusNode,
                      onKeyEvent: (node, event) =>
                          quranCtrl.controlUDByKeyboard(node, event),
                      child: ListView(
                        controller: quranCtrl.state.ScrollUpDownQuranPage,
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
                                quranCtrl
                                    .getHizbQuarterDisplayByPage(index + 1),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: showVerseToast(index)),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              '${'${index + 1}'.convertNumbers()}',
                              style: TextStyle(
                                  fontSize:
                                      context.customOrientation(18.0, 22.0),
                                  fontFamily: 'naskh',
                                  color: const Color(0xff77554B)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : LeftPage(
                    child: Focus(
                      focusNode: quranCtrl.state.quranPageUDFocusNode,
                      onKeyEvent: (node, event) =>
                          quranCtrl.controlUDByKeyboard(node, event),
                      child: ListView(
                        controller: quranCtrl.state.ScrollUpDownQuranPage,
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
                                quranCtrl
                                    .getHizbQuarterDisplayByPage(index + 1),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: showVerseToast(index)),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              '${index + 1}'.convertNumbers(),
                              style: TextStyle(
                                  fontSize:
                                      context.customOrientation(18.0, 22.0),
                                  fontFamily: 'naskh',
                                  color: const Color(0xff77554B)),
                            ),
                          )
                        ],
                      ),
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
                    child: Focus(
                      focusNode: quranCtrl.state.quranPageUDFocusNode,
                      onKeyEvent: (node, event) =>
                          quranCtrl.controlUDByKeyboard(node, event),
                      child: ListView(
                        controller: quranCtrl.state.ScrollUpDownQuranPage,
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
                                quranCtrl
                                    .getHizbQuarterDisplayByPage(index + 1),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: showVerseToast(index)),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              '${index + 1}'.convertNumbers(),
                              style: TextStyle(
                                  fontSize:
                                      context.customOrientation(18.0, 22.0),
                                  fontFamily: 'naskh',
                                  color: const Color(0xff77554B)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    height: MediaQuery.sizeOf(context).height,
                    color: quranCtrl.backgroundColor,
                    child: Focus(
                      focusNode: quranCtrl.state.quranPageUDFocusNode,
                      onKeyEvent: (node, event) =>
                          quranCtrl.controlUDByKeyboard(node, event),
                      child: ListView(
                        controller: quranCtrl.state.ScrollUpDownQuranPage,
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
                                quranCtrl
                                    .getHizbQuarterDisplayByPage(index + 1),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: showVerseToast(index)),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              '${index + 1}'.convertNumbers(),
                              style: TextStyle(
                                  fontSize:
                                      context.customOrientation(18.0, 22.0),
                                  fontFamily: 'naskh',
                                  color: const Color(0xff77554B)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ));
  }
}
