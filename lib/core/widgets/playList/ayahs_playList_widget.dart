import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:theme_provider/theme_provider.dart';

import '/core/widgets/widgets.dart';
import '/presentation/controllers/playList_controller.dart';
import '/presentation/screens/quran_page/widgets/change_reader.dart';
import '../../../presentation/controllers/ayat_controller.dart';
import '../../services/l10n/app_localizations.dart';
import '../../services/services_locator.dart';
import 'ayahs_choice_widget.dart';
import 'playList_build.dart';
import 'playList_play_widget.dart';
import 'playList_save_widget.dart';

List<GlobalKey> playListTextFieldKeys = [];

class AyahsPlayListWidget extends StatelessWidget {
  AyahsPlayListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    sl<AyatController>().fetchAllAyat();
    final playList = sl<PlayListController>();
    playList.loadSavedPlayList();
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            )),
        margin: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            customClose(context),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                    width: 1,
                    color: Theme.of(context).dividerColor.withOpacity(.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.createPlayList,
                    style: TextStyle(
                      color: ThemeProvider.themeOf(context).id == 'dark'
                          ? Colors.white
                          : Theme.of(context).primaryColorLight,
                      fontSize: 16,
                      fontFamily: 'kufi',
                    ),
                  ),
                  const Gap(16),
                  Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).dividerColor.withOpacity(.4),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      child: const ChangeReader()),
                  const Gap(16),
                  const AyahsChoiceWidget(),
                  const Gap(16),
                  const PlayListSaveWidget(),
                ],
              ),
            ),
            const Gap(16),
            Container(
                // padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor.withOpacity(.1),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                      width: 1,
                      color: Theme.of(context).dividerColor.withOpacity(.5)),
                ),
                child: const PlayListBuild()),
            const PlayListPlayWidget(),
          ],
        ),
      ),
    );
  }
}
