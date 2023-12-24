import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../../../core/services/l10n/app_localizations.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/surah_audio_controller.dart';

class SurahSearch extends StatelessWidget {
  const SurahSearch({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Semantics(
        button: true,
        enabled: true,
        label: AppLocalizations.of(context)!.searchToSurah,
        child: SizedBox(
          height: 40,
          child: AnimSearchBar(
            width: orientation(context, width * .75, 300.0),
            textController: sl<SurahAudioController>().textController,
            rtl: true,
            textFieldColor: ThemeProvider.themeOf(context).id == 'blue'
                ? Theme.of(context).primaryColor
                : Theme.of(context).colorScheme.surface,
            helpText: AppLocalizations.of(context)!.searchToSurah,
            textFieldIconColor: Theme.of(context).canvasColor,
            searchIconColor: Theme.of(context).canvasColor,
            style: TextStyle(
                color: Theme.of(context).canvasColor,
                fontFamily: 'kufi',
                fontSize: 15),
            onSubmitted: (String value) {
              sl<SurahAudioController>().searchSurah(context, value);
            },
            autoFocus: false,
            color: ThemeProvider.themeOf(context).id == 'blue'
                ? Theme.of(context).primaryColor
                : Theme.of(context).colorScheme.surface,
            onSuffixTap: () {
              sl<SurahAudioController>().textController.clear();
            },
          ),
        ),
      ),
    );
  }
}
