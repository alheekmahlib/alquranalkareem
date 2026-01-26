part of '../surah_audio.dart';

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
            textController: AudioCtrl.instance.surahState.textController,
            rtl: true,
            textFieldColor: Theme.of(context).colorScheme.primary,
            helpText: 'searchToSurah'.tr,
            textFieldIconColor: Theme.of(context).colorScheme.primaryContainer,
            searchIconColor: Theme.of(context).colorScheme.primaryContainer,
            style: TextStyle(
              color: Theme.of(context).canvasColor,
              fontFamily: 'kufi',
              fontSize: 15,
            ),
            onSubmitted: (String value) =>
                AudioCtrl.instance.searchSurah(value),
            closeSearchOnSuffixTap: true,
            autoFocus: true,
            color: Theme.of(context).colorScheme.primary,
            suffixIcon: Icon(
              Icons.close,
              size: 20,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onSuffixTap: () => AudioCtrl.instance.state.textController.clear(),
          ),
        ),
      ),
    );
  }
}
