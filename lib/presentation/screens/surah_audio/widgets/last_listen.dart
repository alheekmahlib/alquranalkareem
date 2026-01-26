part of '../surah_audio.dart';

class LastListen extends StatelessWidget {
  LastListen({super.key});

  final surahAudioCtrl = AudioCtrl.instance;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: true,
      label: 'lastListen'.tr,
      child: GestureDetector(
        onTap: () {
          surahAudioCtrl.state.isPlayingSurahsMode = true;
          surahAudioCtrl.enableSurahAutoNextListener();
          surahAudioCtrl.enableSurahPositionSaving();
          surahAudioCtrl.loadLastSurahAndPosition();
          surahAudioCtrl.state.audioPlayer.play();
          surahAudioCtrl.state.isSheetOpen.value = true;
          // surahAudioCtrl.state.boxController.openBox();
          surahAudioCtrl.jumpToSurah(
            (surahAudioCtrl.state.selectedSurahIndex.value),
          );
        },
        child: Container(
          width: 280.0,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: .2),
              width: 1,
            ),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'lastListen'.tr.replaceAll(' ', '\n'),
                      style: TextStyle(
                        fontFamily: 'kufi',
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: Obx(
                        () => customSvgWithColor(
                          'assets/svg/surah_name/00${surahAudioCtrl.state.selectedSurahIndex.value + 1}.svg',
                          width: 110,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    if (context.mounted)
                      GetX<AudioCtrl>(
                        builder: (surahAudioController) => Text(
                          '${surahAudioCtrl.formatDuration(Duration(seconds: surahAudioCtrl.state.lastPosition.value))}',
                          style: TextStyle(
                            fontFamily: 'kufi',
                            fontSize: 16,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
