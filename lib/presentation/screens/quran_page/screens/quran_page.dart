part of '../quran.dart';

class QuranPages extends StatelessWidget {
  QuranPages({Key? key}) : super(key: key);
  final quranCtrl = QuranController.instance;
  final bookmarkCtrl = BookmarksController.instance;

  @override
  Widget build(BuildContext context) {
    NotificationManager().updateBookProgress(
      'quran'.tr,
      'notifyQuranBody'.trParams({
        'currentPageNumber': '${quranCtrl.state.currentPageNumber.value}',
      }),
      quranCtrl.state.currentPageNumber.value,
    );
    return GestureDetector(
      onTap: () => quranCtrl.clearSelection(),
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
              // sl<TranslateDataController>().fetchTranslate();
              return !quranCtrl.state.isPageMode.value
                  ? _regularModeWidget(context, index)
                  : _pageModeWidget(context, index);
            },
          ),
        ),
      ),
    );
  }

  Widget _pageModeWidget(BuildContext context, int pageIndex) {
    return
    // Responsive.isMobile(context) || Responsive.isMobileLarge(context)
    //     ?
    Center(
      child: pageIndex.isEven
          ? RightPage(child: TextBuild(pageIndex: pageIndex))
          : LeftPage(child: TextBuild(pageIndex: pageIndex)),
    );
    // : Center(
    //     child: pageIndex.isEven
    //         ? RightPage(
    //             child: Focus(
    //               focusNode: quranCtrl.state.quranPageUDFocusNode,
    //               onKeyEvent: (node, event) =>
    //                   quranCtrl.controlUDByKeyboard(node, event),
    //               child: Padding(
    //                 padding: const EdgeInsets.symmetric(
    //                   horizontal: 32.0,
    //                 ),
    //                 child: TextBuild(pageIndex: pageIndex),
    //               ),
    //             ),
    //           )
    //         : LeftPage(
    //             child: Focus(
    //               focusNode: quranCtrl.state.quranPageUDFocusNode,
    //               onKeyEvent: (node, event) =>
    //                   quranCtrl.controlUDByKeyboard(node, event),
    //               child: Padding(
    //                 padding: const EdgeInsets.symmetric(
    //                   horizontal: 32.0,
    //                 ),
    //                 child: TextBuild(pageIndex: pageIndex),
    //               ),
    //             ),
    //           ));
  }

  Widget _regularModeWidget(BuildContext context, int pageIndex) {
    final size = MediaQuery.sizeOf(context);
    return
    // Responsive.isMobile(context) || Responsive.isMobileLarge(context)
    //     ?
    Center(
      child: pageIndex.isEven
          ? Container(
              height: size.height,
              color: quranCtrl.backgroundColor,
              child: TextBuild(pageIndex: pageIndex),
            )
          : Container(
              height: size.height,
              color: quranCtrl.backgroundColor,
              child: TextBuild(pageIndex: pageIndex),
            ),
    );
    // : Center(
    //     child: pageIndex.isEven
    //         ? Container(
    //             height: MediaQuery.sizeOf(context).height,
    //             color: quranCtrl.backgroundColor,
    //             child: Focus(
    //               focusNode: quranCtrl.state.quranPageUDFocusNode,
    //               onKeyEvent: (node, event) =>
    //                   quranCtrl.controlUDByKeyboard(node, event),
    //               child: Padding(
    //                 padding: const EdgeInsets.symmetric(
    //                   horizontal: 32.0,
    //                 ),
    //                 child: TextBuild(pageIndex: pageIndex),
    //               ),
    //             ),
    //           )
    //         : Container(
    //             height: MediaQuery.sizeOf(context).height,
    //             color: quranCtrl.backgroundColor,
    //             child: Focus(
    //               focusNode: quranCtrl.state.quranPageUDFocusNode,
    //               onKeyEvent: (node, event) =>
    //                   quranCtrl.controlUDByKeyboard(node, event),
    //               child: Padding(
    //                 padding: const EdgeInsets.symmetric(
    //                   horizontal: 32.0,
    //                 ),
    //                 child: TextBuild(pageIndex: pageIndex),
    //               ),
    //             ),
    //           ));
  }
}
