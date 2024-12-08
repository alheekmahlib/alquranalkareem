part of '../../quran.dart';

class AyahsChoiceWidget extends StatelessWidget {
  AyahsChoiceWidget({super.key});
  final playList = PlayListController.instance;
  final quranCtrl = QuranController.instance;
  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Obx(
            () {
              if (quranCtrl.currentPageAyahs.isEmpty) {
                return Center(
                    child: customLottie(LottieConstants.assetsLottieSearch,
                        width: 100.0, height: 40.0));
              } else {
                return PopupMenuButton(
                  position: PopupMenuPosition.under,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(.15),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '${'from'.tr}: ',
                          style: TextStyle(
                            fontFamily: 'kufi',
                            fontSize: 16,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        Obx(
                          () => Text(
                            '${quranCtrl.getCurrentSurahByPage(quranCtrl.state.currentPageNumber.value - 1).arabicName.replaceAll('سُورَةُ ', '')} | ${generalCtrl.state.arabicNumber.convert(playList.firstAyah)}',
                            style: TextStyle(
                              fontFamily: 'kufi',
                              fontSize: 16,
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      ],
                    ),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: PlayListAyatWidget(startNum: true),
                    )
                  ],
                );
              }
            },
          ),
        ),
        const Gap(8),
        Expanded(
          child: Obx(
            () {
              if (quranCtrl.currentPageAyahs.isEmpty) {
                return Center(
                    child: customLottie(LottieConstants.assetsLottieSearch,
                        width: 100.0, height: 40.0));
              } else {
                return PopupMenuButton(
                  position: PopupMenuPosition.under,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(.15),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '${'to'.tr}: ',
                          style: TextStyle(
                            fontFamily: 'kufi',
                            fontSize: 16,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        Text(
                          '${quranCtrl.getCurrentSurahByPage(quranCtrl.state.currentPageNumber.value - 1).arabicName.replaceAll('سُورَةُ ', '')} | ${generalCtrl.state.arabicNumber.convert(playList.lastAyah)}',
                          style: TextStyle(
                            fontFamily: 'kufi',
                            fontSize: 16,
                            color: Get.isDarkMode
                                ? Colors.white
                                : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      ],
                    ),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: PlayListAyatWidget(endNum: true),
                    )
                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
