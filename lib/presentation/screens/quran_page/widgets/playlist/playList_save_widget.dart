part of '../../quran.dart';

class PlayListSaveWidget extends StatelessWidget {
  const PlayListSaveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final playList = PlayListController.instance;
    return Align(
      alignment: Alignment.center,
      child: ElevatedButtonWidget(
        onClick: () {
          playList.saveList();
          playList.reset();
          playList.saveCard.currentState?.expand();
          log('playList saved');
        },
        index: 0,
        height: 35,
        width: Get.width * .6,
        child: Text(
          'save'.tr,
          style: TextStyle(
            color: Theme.of(context).canvasColor,
            fontSize: 14,
            fontFamily: 'kufi',
          ),
        ),
      ),
    );
  }
}
