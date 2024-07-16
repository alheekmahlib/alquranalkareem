import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/presentation/screens/surah_audio/controller/extensions/surah_audio_ui.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/extensions/extensions.dart';
import '../controller/surah_audio_controller.dart';

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
        label: 'searchToSurah'.tr,
        child: SizedBox(
          height: 40,
          child: AnimSearchBar(
            width: context.customOrientation(width * .75, 300.0),
            textController: sl<SurahAudioController>().state.textController,
            rtl: true,
            textFieldColor: Theme.of(context).colorScheme.primary,
            helpText: 'searchToSurah'.tr,
            textFieldIconColor: Theme.of(context).colorScheme.primaryContainer,
            searchIconColor: Theme.of(context).colorScheme.primaryContainer,
            style: TextStyle(
                color: Theme.of(context).colorScheme.inverseSurface,
                fontFamily: 'kufi',
                fontSize: 15),
            onSubmitted: (String value) {
              sl<SurahAudioController>().searchSurah(value);
            },
            closeSearchOnSuffixTap: true,
            autoFocus: true,
            color: Theme.of(context).colorScheme.primary,
            suffixIcon: Icon(Icons.close,
                size: 20, color: Theme.of(context).colorScheme.onSurface),
            onSuffixTap: () {
              sl<SurahAudioController>().state.textController.clear();
            },
          ),
        ),
      ),
    );
  }
}
