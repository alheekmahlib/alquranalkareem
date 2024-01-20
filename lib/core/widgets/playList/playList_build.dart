import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../../presentation/controllers/playList_controller.dart';
import '../../services/l10n/app_localizations.dart';
import '../../services/services_locator.dart';
import '../delete_widget.dart';
import '/presentation/screens/quran_text/widgets/widgets.dart';
import 'ayahs_playList_widget.dart';

class PlayListBuild extends StatelessWidget {
  const PlayListBuild({super.key});

  @override
  Widget build(BuildContext context) {
    final playList = sl<PlayListController>();
    return ExpansionTileCard(
      key: playList.saveCard,
      elevation: 0.0,
      initialElevation: 0.0,
      title: SizedBox(
        width: 100.0,
        child: Text(
          AppLocalizations.of(context)!.playList,
          style: TextStyle(
            color: ThemeProvider.themeOf(context).id == 'dark'
                ? Colors.white
                : Theme.of(context).primaryColorLight,
            fontSize: 16,
            fontFamily: 'kufi',
          ),
        ),
      ),
      baseColor: Theme.of(context).colorScheme.background.withOpacity(.2),
      expandedColor: Theme.of(context).colorScheme.background.withOpacity(.2),
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height * .3,
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
                                .surface
                                .withOpacity(.2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
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
                                        Icon(
                                          Icons.playlist_add_check,
                                          size: 28,
                                          color: ThemeProvider.themeOf(context)
                                                      .id ==
                                                  'dark'
                                              ? Colors.white
                                              : Theme.of(context)
                                                  .primaryColorLight,
                                        ),
                                        const Gap(8),
                                        Container(
                                          width: 120,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 4.0),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .dividerColor
                                                  .withOpacity(.6),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(8))),
                                          child: Text(
                                            play.name,
                                            style: TextStyle(
                                              fontFamily: 'kufi',
                                              fontSize: 16,
                                              color:
                                                  ThemeProvider.themeOf(context)
                                                              .id ==
                                                          'dark'
                                                      ? Colors.white
                                                      : Theme.of(context)
                                                          .primaryColor,
                                            ),
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${play.surahName} | ',
                                          style: TextStyle(
                                            fontFamily: 'kufi',
                                            fontSize: 18,
                                            color:
                                                ThemeProvider.themeOf(context)
                                                            .id ==
                                                        'dark'
                                                    ? Colors.white
                                                    : Theme.of(context)
                                                        .primaryColorLight
                                                        .withOpacity(.6),
                                          ),
                                        ),
                                        Text(
                                          '${arabicNumber.convert(play.startNum)}-${arabicNumber.convert(play.endNum)}',
                                          style: TextStyle(
                                            fontFamily: 'kufi',
                                            fontSize: 18,
                                            color:
                                                ThemeProvider.themeOf(context)
                                                            .id ==
                                                        'dark'
                                                    ? Colors.white
                                                    : Theme.of(context)
                                                        .primaryColor,
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
                          playList.choiceFromPlayList(play.startNum,
                              play.endNum, play.surahNum, play.readerName);
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
    );
  }
}
