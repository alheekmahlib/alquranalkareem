part of '../../quran.dart';

class PlayListSaveWidget extends StatelessWidget {
  const PlayListSaveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final playList = PlayListController.instance;
    return Obx(() {
      // نراقب القيم لإعادة البناء عند تغيّرها
      playList.startAyahUQ.value;
      playList.endAyahUQ.value;
      final valid = playList.isRangeValid;
      return Align(
        alignment: Alignment.center,
        child: ContainerButton(
          onPressed: valid
              ? () {
                  playList.saveList();
                  log('playList saved');
                }
              : null,
          height: 35,
          width: Get.width * .5,
          title: 'save',
          isTitleCentered: true,
          backgroundColor: context.theme.colorScheme.surface,
        ),
      );
    });
  }
}
