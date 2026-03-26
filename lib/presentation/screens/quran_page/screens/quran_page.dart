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
    return Center(
      child: GetBuilder<QuranController>(
        id: 'backgroundColor',
        builder: (quranCtrl) {
          return Container(
            height: Get.height,
            color: quranCtrl.backgroundColor,
            child: TextBuild(),
          );
        },
      ),
    );
  }
}
