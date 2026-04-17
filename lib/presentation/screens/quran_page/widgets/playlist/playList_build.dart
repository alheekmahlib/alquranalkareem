part of '../../quran.dart';

class PlayListBuild extends StatelessWidget {
  PlayListBuild({super.key});
  final playList = PlayListController.instance;
  final generalCtrl = GeneralController.instance;
  final audioCtrl = AudioCtrl.instance;

  @override
  Widget build(BuildContext context) {
    return ExpansionTileWidget(
      key: playList.saveCard,
      title: 'playList'.tr,
      getxCtrl: playList,
      manager: GeneralController.instance.state.expansionManager,
      name: 'playList_tile',
      child: SizedBox(
        height: context.customOrientation(Get.height * .25, Get.height * .5),
        child: Obx(
          () => ListView(
            children: List<Widget>.generate(playList.playLists.length, (
              int index,
            ) {
              final play = playList.playLists[index];
              GlobalKey textFieldKey = GlobalKey();
              playListTextFieldKeys.add(textFieldKey);
              return Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: [
                  ContainerButton(
                    onPressed: () => playList.playFromSavedPlayList(play),
                    value: true.obs,
                    width: double.infinity,
                    verticalMargin: 4.0,
                    backgroundColor: context.theme.primaryColorLight.withValues(
                      alpha: .2,
                    ),
                    child: Dismissible(
                      background: const DeleteWidget(),
                      key: UniqueKey(),
                      onDismissed: (DismissDirection direction) async {
                        await playList.deletePlayList(context, index);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Gap(8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 4.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                      .withValues(alpha: .8),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                ),
                                child: Text(
                                  play.displayName,
                                  style: AppTextStyles.titleMedium(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // تفاصيل النطاق
                                  Text(
                                    '${play.fromSurahName.replaceAll('سُورَةُ ', '')} (${generalCtrl.state.arabicNumber.convert(play.fromAyah)}) \u2190 ${play.toSurahName.replaceAll('سُورَةُ ', '')} (${generalCtrl.state.arabicNumber.convert(play.toAyah)})',
                                    style: AppTextStyles.titleSmall(),
                                  ),
                                  const Gap(8),
                                  Text(
                                    '${generalCtrl.state.arabicNumber.convert(play.totalAyahs)} ${'ayah'.tr}',
                                    style: AppTextStyles.titleSmall(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // زر التصدير
                  CustomButton(
                    height: 30,
                    width: 30,
                    iconSize: 25,
                    isCustomSvgColor: true,
                    svgPath: SvgPath.svgHomeShare,
                    svgColor: Get.theme.colorScheme.primary,
                    onPressed: () => playList.exportPlaylist(play),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
