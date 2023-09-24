import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/services/controllers_put.dart';
import '../../shared/widgets/widgets.dart';

class SurahSearch extends StatelessWidget {
  const SurahSearch({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 40,
        child: AnimSearchBar(
          width: orientation(context, width * .75, 300.0),
          textController: surahAudioController.textController,
          rtl: true,
          textFieldColor: Theme.of(context).colorScheme.surface,
          helpText: AppLocalizations.of(context)!.searchToSurah,
          textFieldIconColor: Theme.of(context).canvasColor,
          searchIconColor: Theme.of(context).canvasColor,
          style: TextStyle(
              color: Theme.of(context).canvasColor,
              fontFamily: 'kufi',
              fontSize: 15),
          onSubmitted: (String value) {
            surahAudioController.searchSurah(context, value);
          },
          autoFocus: false,
          color: Theme.of(context).colorScheme.surface,
          onSuffixTap: () {
            surahAudioController.textController.clear();
          },
        ),
      ),
    );
  }
}
