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
        'currentPageNumber':
            '${QuranCtrl.instance.state.currentPageNumber.value}',
      }),
      QuranCtrl.instance.state.currentPageNumber.value,
    );
    return Container(
      height: MediaQuery.sizeOf(context).height,
      child: _regularModeWidget(context),
    );
  }

  Widget _regularModeWidget(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return
    // Responsive.isMobile(context) || Responsive.isMobileLarge(context)
    //     ?
    Center(
      child: Container(
        height: size.height,
        color: quranCtrl.backgroundColor,
        child: TextBuild(),
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
