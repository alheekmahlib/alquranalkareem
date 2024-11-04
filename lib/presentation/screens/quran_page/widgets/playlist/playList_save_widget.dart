part of '../../quran.dart';

class PlayListSaveWidget extends StatelessWidget {
  const PlayListSaveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final playList = PlayListController.instance;
    return GestureDetector(
        onTap: () {
          playList.saveList();
          playList.reset();
          playList.saveCard.currentState?.expand();
        },
        child: ContainerButton(
          height: 35,
          child: Text(
            'save'.tr,
            style: TextStyle(
              color: Theme.of(context).canvasColor,
              fontSize: 14,
              fontFamily: 'kufi',
            ),
          ),
        ));
  }
}
