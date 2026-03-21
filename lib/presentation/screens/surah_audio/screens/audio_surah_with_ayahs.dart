part of '../surah_audio.dart';

class AudioSurahWithAyahs extends GetView<AudioSurahWithAyahsController> {
  const AudioSurahWithAyahs({super.key});

  @override
  Widget build(BuildContext context) {
    final surahCtrl = AudioCtrl.instance;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) {
        if (didPop) {
          return;
        }
        surahCtrl.state.audioPlayer.stop();
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: context.theme.primaryColor,
        body: SafeArea(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Opacity(
                opacity: 0.1,
                child: Align(
                  alignment: Alignment.center,
                  child: AnimatedDrawingWidget(
                    opacity: 1,
                    svgPath: SvgPath.svgAudioAudioQuran,
                    width: 250,
                    height: 200,
                    customColor: context.theme.colorScheme.surface,
                  ),
                ),
              ),
              context.customOrientation(
                Column(
                  children: [
                    Container(
                      height: 100,
                      width: 45,
                      alignment: AlignmentDirectional.bottomCenter,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: context.theme.primaryColorLight.withValues(
                          alpha: .2,
                        ),
                        borderRadius: const BorderRadiusDirectional.only(
                          bottomEnd: Radius.circular(8),
                          bottomStart: Radius.circular(8),
                        ),
                      ),
                      child: CustomButton(
                        onPressed: () => Get.back(),
                        height: 35,
                        width: 40,
                        isCustomSvgColor: true,
                        svgPath: SvgPath.svgHomeClose,
                        svgColor: context.theme.colorScheme.primary,
                        backgroundColor: context.theme.canvasColor,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 8,
                      width: Get.width,
                      margin: const EdgeInsets.symmetric(horizontal: 62.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                    const Gap(8.0),
                    Obx(() {
                      final isAvailable =
                          controller.segState.isSegmentsAvailable.value;
                      final surahNum =
                          controller.segState.currentSegmentSurahNumber.value ??
                          surahCtrl.state.currentAudioListSurahNum.value;

                      if (isAvailable) {
                        return _buildAyahTracker(context, surahCtrl, surahNum);
                      } else {
                        return _buildSurahInfoCard(
                          context,
                          surahCtrl,
                          surahNum,
                        );
                      }
                    }),
                    const Gap(8.0),
                    Container(
                      height: 8,
                      width: Get.width,
                      margin: const EdgeInsets.symmetric(horizontal: 62.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GetBuilder<AudioCtrl>(
                          id: 'change_surah_reader',
                          builder: (surahAudioCtrl) => Text(
                            ReadersConstants
                                .activeSurahReaders[surahAudioCtrl
                                    .state
                                    .surahReaderIndex
                                    .value]
                                .name
                                .tr,
                            style: AppTextStyles.titleMedium().copyWith(
                              color: context.theme.colorScheme.surface,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                            color: context.theme.colorScheme.surface.withValues(
                              alpha: .8,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Obx(
                          () => surahNameWidget(
                            surahCtrl.state.currentAudioListSurahNum.value
                                .toString(),
                            context.theme.colorScheme.surface,
                            height: 50,
                            width: 80,
                          ),
                        ),
                      ],
                    ),
                    PlayWidget(
                      iconColor: context.theme.canvasColor,
                      backgroundColor: context.theme.primaryColorLight,
                      isFullScreen: true,
                    ),
                  ],
                ),
                Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: [
                    Container(
                      height: 45,
                      width: 100,
                      alignment: AlignmentDirectional.centerEnd,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: context.theme.primaryColorLight.withValues(
                          alpha: .2,
                        ),
                        borderRadius: const BorderRadiusDirectional.only(
                          topEnd: Radius.circular(8),
                          bottomEnd: Radius.circular(8),
                        ),
                      ),
                      child: CustomButton(
                        onPressed: () => Get.back(),
                        height: 35,
                        width: 40,
                        isCustomSvgColor: true,
                        svgPath: SvgPath.svgHomeClose,
                        svgColor: context.theme.colorScheme.primary,
                        backgroundColor: context.theme.canvasColor,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: PlayWidget(
                            iconColor: context.theme.canvasColor,
                            backgroundColor: context.theme.primaryColorLight,
                            isFullScreen: true,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Spacer(),
                              Container(
                                height: 8,
                                width: Get.width,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 62.0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Theme.of(context).primaryColorLight,
                                ),
                              ),
                              const Gap(8.0),
                              Obx(() {
                                final isAvailable = controller
                                    .segState
                                    .isSegmentsAvailable
                                    .value;
                                final surahNum =
                                    controller
                                        .segState
                                        .currentSegmentSurahNumber
                                        .value ??
                                    surahCtrl
                                        .state
                                        .currentAudioListSurahNum
                                        .value;

                                if (isAvailable) {
                                  return _buildAyahTracker(
                                    context,
                                    surahCtrl,
                                    surahNum,
                                  );
                                } else {
                                  return _buildSurahInfoCard(
                                    context,
                                    surahCtrl,
                                    surahNum,
                                  );
                                }
                              }),
                              const Gap(8.0),
                              Container(
                                height: 8,
                                width: Get.width,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 62.0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Theme.of(context).primaryColorLight,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GetBuilder<AudioCtrl>(
                                    id: 'change_surah_reader',
                                    builder: (surahAudioCtrl) => Text(
                                      ReadersConstants
                                          .activeSurahReaders[surahAudioCtrl
                                              .state
                                              .surahReaderIndex
                                              .value]
                                          .name
                                          .tr,
                                      style: AppTextStyles.titleMedium()
                                          .copyWith(
                                            color: context
                                                .theme
                                                .colorScheme
                                                .surface,
                                            fontSize: 22,
                                          ),
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    width: 4,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: context.theme.colorScheme.surface
                                          .withValues(alpha: .8),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  Obx(
                                    () => surahNameWidget(
                                      surahCtrl
                                          .state
                                          .currentAudioListSurahNum
                                          .value
                                          .toString(),
                                      context.theme.colorScheme.surface,
                                      height: 50,
                                      width: 80,
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(8.0),
                            ],
                          ),
                        ),
                      ],
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

  /// ويدجت تتبع الآية والكلمة (عند توفر segments)
  Widget _buildAyahTracker(
    BuildContext context,
    AudioCtrl surahCtrl,
    int surahNum,
  ) {
    final ayahNum = controller.segState.currentSegmentAyahNumber.value ?? 1;
    final wordNum = controller.segState.currentSegmentWordIndex.value ?? 1;
    final selectedWordRef = WordRef(
      surahNumber: surahNum,
      ayahNumber: ayahNum,
      wordNumber: wordNum,
    );
    return AnimatedSize(
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      child: Container(
        width: Get.width,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.primaryContainer,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: GetSingleAyah(
          surahNumber: surahNum,
          ayahNumber: ayahNum,
          textHeight: 2,
          enableWordSelection: true,
          isDark: ThemeController.instance.isDarkMode,
          externalSelectedWordRef: selectedWordRef,
          textAlign: TextAlign.center,
          textColor: context.theme.canvasColor,
          selectedWordColor: context.theme.colorScheme.surface.withValues(
            alpha: .5,
          ),
          enabledTajweed: QuranCtrl.instance.state.isTajweedEnabled.value,
        ),
      ),
    );
  }

  /// بطاقة اسم السورة + معلوماتها (عند عدم توفر segments)
  Widget _buildSurahInfoCard(
    BuildContext context,
    AudioCtrl surahCtrl,
    int surahNum,
  ) {
    final surah = QuranCtrl.instance.surahs.firstWhere(
      (s) => s.surahNumber == surahNum,
    );

    return Container(
      width: Get.width,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: context.theme.canvasColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Lottie خلفية زخرفية خفيفة
          Opacity(
            opacity: 0.08,
            child: customLottieWithColor(
              LottieConstants.assetsLottieQuranAuIc,
              height: 220,
              width: 220,
              isRepeat: false,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // اسم السورة بحجم كبير
              surahNameWidget(
                surahNum.toString(),
                context.theme.primaryColorDark,
                height: 70,
              ),
              const Gap(16.0),
              // شريط فاصل زخرفي
              Container(
                height: 2,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  color: context.theme.primaryColorDark.withValues(alpha: .3),
                ),
              ),
              const Gap(16.0),
              // معلومات السورة
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _infoChip(
                    context,
                    surah.revelationType?.tr ?? '',
                    Icons.place_outlined,
                  ),
                  const Gap(16.0),
                  _infoChip(
                    context,
                    '${'aya_count'.tr} ${surah.ayahs.length}'
                        .convertNumbersToCurrentLang(),
                    Icons.format_list_numbered_rounded,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoChip(BuildContext context, String text, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 22, color: context.theme.primaryColorDark),
        const Gap(4.0),
        Text(
          text,
          style: AppTextStyles.titleMedium().copyWith(
            color: context.theme.primaryColorLight,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
