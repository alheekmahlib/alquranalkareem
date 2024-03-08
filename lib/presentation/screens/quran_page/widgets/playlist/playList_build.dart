import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/svg_picture.dart';
import '../../../../../core/widgets/delete_widget.dart';
import '../../../../controllers/playList_controller.dart';
import '/presentation/controllers/audio_controller.dart';
import '/presentation/controllers/general_controller.dart';
import 'ayahs_playList_widget.dart';

class PlayListBuild extends StatelessWidget {
  PlayListBuild({super.key});
  final playList = sl<PlayListController>();
  final generalCtrl = sl<GeneralController>();
  final audioCtrl = sl<AudioController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.primary.withOpacity(.15)),
      ),
      child: ExpansionTileCard(
        key: playList.saveCard,
        elevation: 0.0,
        initialElevation: 0.0,
        title: SizedBox(
          width: 100.0,
          child: Text(
            'playList'.tr,
            style: TextStyle(
              color: Theme.of(context).hintColor,
              fontSize: 16,
              fontFamily: 'kufi',
            ),
          ),
        ),
        baseColor: Theme.of(context).colorScheme.primary.withOpacity(.1),
        expandedColor: Colors.transparent,
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * .25,
            child: ListView(
              children: [
                Obx(
                  () => Column(
                    children: List<Widget>.generate(
                      playList.playLists.length,
                      (int index) {
                        final play = playList.playLists[index];
                        GlobalKey textFieldKey = GlobalKey();
                        playListTextFieldKeys.add(textFieldKey);
                        return GestureDetector(
                          child: Container(
                            height: 55,
                            width: MediaQuery.sizeOf(context).width,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(.15),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                            ),
                            // padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.all(8.0),
                            child: Dismissible(
                              background: const DeleteWidget(),
                              key: UniqueKey(),
                              onDismissed: (DismissDirection direction) async {
                                await playList.deletePlayList(context, index);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          playlist(height: 25.0),
                                          const Gap(8),
                                          Container(
                                            width: 120,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 4.0),
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .background
                                                    .withOpacity(.8),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(4))),
                                            child: Transform.translate(
                                              offset: const Offset(0, 2),
                                              child: Text(
                                                play.name
                                                    .replaceAll('سُورَةُ ', ''),
                                                style: TextStyle(
                                                  fontFamily: 'kufi',
                                                  fontSize: 16,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                                maxLines: 2,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${generalCtrl.convertNumbers(play.startNum.toString())}-${generalCtrl.convertNumbers(play.endNum.toString())}',
                                            style: TextStyle(
                                              fontFamily: 'kufi',
                                              fontSize: 18,
                                              color:
                                                  Theme.of(context).hintColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            playList.isSelect.value = true;
                            playList.choiceFromPlayList(
                                play.startNum,
                                play.endNum,
                                play.startUQNum,
                                play.endUQNum,
                                play.surahNum,
                                audioCtrl.readerName.value);
                            playList.loadPlaylist();
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
