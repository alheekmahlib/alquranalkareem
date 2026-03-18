part of '../../quran.dart';

List<GlobalKey> playListTextFieldKeys = [];

class AyahsPlayListWidget extends StatelessWidget {
  AyahsPlayListWidget({super.key});
  final playList = PlayListController.instance;

  @override
  Widget build(BuildContext context) {
    playList.loadSavedPlayList();
    final size = MediaQuery.sizeOf(context);
    return SingleChildScrollView(
      child: Container(
        height: size.height * .89,
        width: context.customOrientation(size.width, size.width * .5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TitleWidget(
                  title: 'createPlayList',
                  horizontalPadding: 8.0,
                ),
                const Gap(16),
                AyahChangeReader(
                  downloadManagerStyle:
                      AudioCtrl.instance.ayahDownloadManagerStyle,
                  style: AudioCtrl.instance.ayahAudioStyle,
                  isDark: themeCtrl.isDarkMode,
                ),
                const Gap(16),
                AyahsChoiceWidget(),
                const Gap(16),
                const PlayListSaveWidget(),
                const Gap(16),
                PlayListBuild(),
                // مؤشر التحميل
                Obx(() {
                  if (!playList.isBatchDownloading.value) {
                    return const SizedBox.shrink();
                  }
                  final total = playList.batchTotal.value;
                  final completed = playList.batchCompleted.value;
                  final pct = total > 0 ? completed / total : 0.0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${'downloading'.tr}...',
                              style: AppTextStyles.titleMedium(),
                            ),
                            Text(
                              '${GeneralController.instance.state.arabicNumber.convert(completed)} / ${GeneralController.instance.state.arabicNumber.convert(total)}',
                              style: AppTextStyles.titleMedium(),
                            ),
                          ],
                        ),
                        const Gap(4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: pct,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: .15),
                            valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).colorScheme.primary,
                            ),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const Spacer(),
                PlayListAudioWidget(),
                const Gap(8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlayListAudioWidget extends StatelessWidget {
  PlayListAudioWidget({super.key});
  final playList = PlayListController.instance;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return SizedBox(
      width: Get.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(6),
          // تتبع الآية الحالية
          Obx(() {
            final ayahUQ = playList.currentPlayingAyahUQ.value;
            if (ayahUQ == 0) return const SizedBox.shrink();
            final ayah = playList.quranCtrl.state.allAyahs[ayahUQ - 1];
            final surah = playList.quranCtrl.getSurahDataByAyah(ayah);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '${surah.arabicName.replaceAll('سُورَةُ ', '')} - ${'ayah'.tr} ${ayah.ayahNumber.toString().convertNumbersToCurrentLang()}',
                style: AppTextStyles.titleMedium(),
              ),
            );
          }),
          // شريط التقدم للآية الحالية
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: StreamBuilder<PositionData>(
                  stream: playList.positionDataStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final positionData = snapshot.data;
                      return SliderWidget.player(
                        horizontalPadding: 0.0,
                        duration: positionData?.duration ?? Duration.zero,
                        position: positionData?.position ?? Duration.zero,
                        activeTrackColor: Theme.of(context).colorScheme.primary,
                        onChangeEnd: playList.playlistAudioPlayer.seek,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              // مؤشر التقدم الكلي
              PlayListProgressBar(),
            ],
          ),
          // أزرار التحكم
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PlayListSleepTimerWidget(),
                PlayListRepeatWidget(),
                // السابق
                CustomButton(
                  svgPath: isRtl
                      ? SvgPath.svgAudioNextIcon
                      : SvgPath.svgAudioPreviousIcon,
                  height: 40,
                  width: 40,
                  iconSize: 30,
                  isCustomSvgColor: true,
                  svgColor: context.theme.colorScheme.primary,
                  onPressed: () =>
                      playList.playlistAudioPlayer.seekToPrevious(),
                ),
                // تشغيل / إيقاف
                StreamBuilder<PlayerState>(
                  stream: playList.playlistAudioPlayer.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;
                    final playing = playerState?.playing ?? false;
                    final processingState = playerState?.processingState;
                    if (processingState == ProcessingState.loading ||
                        processingState == ProcessingState.buffering) {
                      return const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    }
                    return CustomButton(
                      svgPath: playing
                          ? SvgPath.svgAudioPauseArrow
                          : SvgPath.svgAudioPlayArrow,
                      height: 40,
                      width: 40,
                      iconSize: playing ? 28 : 38,
                      horizontalPadding: 10.0,
                      isCustomSvgColor: true,
                      backgroundColor: context.theme.colorScheme.primary,
                      svgColor: context.theme.colorScheme.surface,
                      onPressed: () {
                        if (playing) {
                          playList.playlistAudioPlayer.pause();
                        } else {
                          playList.playlistAudioPlayer.play();
                        }
                      },
                    );
                  },
                ),
                // التالي
                CustomButton(
                  svgPath: isRtl
                      ? SvgPath.svgAudioPreviousIcon
                      : SvgPath.svgAudioNextIcon,
                  height: 40,
                  width: 40,
                  iconSize: 30,
                  isCustomSvgColor: true,
                  svgColor: context.theme.colorScheme.primary,
                  onPressed: () => playList.playlistAudioPlayer.seekToNext(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
