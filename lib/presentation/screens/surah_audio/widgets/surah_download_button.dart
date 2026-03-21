part of '../surah_audio.dart';

class SurahDownloadButton extends StatelessWidget {
  final SurahAudioStyle? style;
  final int surahNumber;
  const SurahDownloadButton({super.key, this.style, required this.surahNumber});

  @override
  Widget build(BuildContext context) {
    final isSelected =
        AudioCtrl.instance.state.selectedSurahIndex.value == surahNumber - 1;
    return GetBuilder<AudioCtrl>(
      id: 'surahDownloadManager_id',
      builder: (surahAudioCtrl) {
        final isDownloaded = surahAudioCtrl.state
            .isSurahDownloadedByNumber(surahNumber)
            .value;
        return Obx(() {
          final progress = surahAudioCtrl.state.progress.value;
          final isDownloading = surahAudioCtrl.state.isDownloading.value;
          final currentlySelected =
              AudioCtrl.instance.state.selectedSurahIndex.value ==
              surahNumber - 1;
          final isDownloadingThis =
              currentlySelected && isDownloading && !isDownloaded;
          return CustomDownloadButton(
            size: 60,
            progress: progress,
            isDownloading: isDownloadingThis,
            isDownloaded: isDownloaded,
            child: _buildContent(
              context,
              surahAudioCtrl,
              isSelected,
              isDownloaded,
            ),
          );
        });
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    AudioCtrl surahAudioCtrl,
    bool isSelected,
    bool isDownloaded,
  ) {
    if (isSelected &&
        surahAudioCtrl.state.isDownloading.value &&
        !isDownloaded) {
      return CustomButton(
        onPressed: () => surahAudioCtrl.cancelDownload(),
        height: 45,
        width: 45,
        isCustomSvgColor: true,
        svgPath: SvgPath.svgHomeClose,
        svgColor: context.theme.colorScheme.primary,
        backgroundColor: Colors.transparent,
      );
    }
    return StreamBuilder<PlayerState>(
      stream: surahAudioCtrl.state.audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        if ((processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) &&
            isSelected) {
          return SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: style?.downloadProgressColor ?? Colors.white,
            ),
          );
        } else {
          return CustomButton(
            onPressed: () =>
                surahAudioCtrl.downloadSurah(surahNum: surahNumber),
            height: 45,
            width: 45,
            isCustomSvgColor: true,
            svgPath: isDownloaded
                ? SvgPath.svgCheckMark
                : SvgPath.svgAudioDownload,
            svgColor: context.theme.colorScheme.primary,
            backgroundColor: Colors.transparent,
          );
        }
      },
    );
  }
}
