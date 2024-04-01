import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mini_music_visualizer/mini_music_visualizer.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/extensions/extensions.dart';
import '../../../controllers/surah_audio_controller.dart';
import '/presentation/controllers/quran_controller.dart';

class SurahAudioList extends StatelessWidget {
  SurahAudioList({super.key});
  final quranCtrl = sl<QuranController>();
  final surahAudioCtrl = sl<SurahAudioController>();

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: Scrollbar(
        thumbVisibility: true,
        // interactive: true,
        controller: surahAudioCtrl.controller,
        child: Container(
          margin: const EdgeInsets.only(
              bottom: 50.0, right: 32.0, left: 32.0, top: 16.0),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                  width: 1, color: Theme.of(context).colorScheme.primary)),
          child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: quranCtrl.surahs.length,
              controller: surahAudioCtrl.controller,
              padding: EdgeInsets.zero,
              itemBuilder: (_, index) {
                final surah = quranCtrl.surahs[index];
                int surahNumber = index + 1;
                // RxBool isDownloaded =
                //     surahAudioCtrl.surahDownloadStatus[surahNumber] ??
                //         RxBool(false);
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 450),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Obx(
                        () => Column(
                          children: [
                            GestureDetector(
                              child: Container(
                                  height: 70,
                                  decoration: BoxDecoration(
                                      color:
                                          surahAudioCtrl.selectedSurah == index
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(.15)
                                              : Colors.transparent,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                SizedBox(
                                                    height: 40,
                                                    width: 40,
                                                    child: SvgPicture.asset(
                                                      'assets/svg/sora_num.svg',
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                              BlendMode.srcIn),
                                                    )),
                                                Transform.translate(
                                                  offset: const Offset(0, 1),
                                                  child: Text(
                                                    surahAudioCtrl.arabicNumber
                                                        .convert(
                                                            surah.surahNumber),
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .hintColor,
                                                        fontFamily: "kufi",
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        height: 2),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 8,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/svg/surah_name/00${index + 1}.svg',
                                                colorFilter: ColorFilter.mode(
                                                    Theme.of(context).hintColor,
                                                    BlendMode.srcIn),
                                                width: 100,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: Text(
                                                  surah.englishName,
                                                  style: TextStyle(
                                                    fontFamily: "naskh",
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (index + 1 ==
                                            surahAudioCtrl.surahNum.value)
                                          MiniMusicVisualizer(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            width: 4,
                                            height: 15,
                                            animate: true,
                                          ),
                                        const Gap(8.0),
                                        Obx(() => surahAudioCtrl
                                                    .surahDownloadStatus
                                                    .value[surahNumber] ??
                                                false
                                            ? const SizedBox.shrink()
                                            : Icon(
                                                Icons.cloud_download_outlined,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface,
                                              )),
                                      ],
                                    ),
                                  )),
                              onTap: () {
                                print('Surah tapped with index: $index');
                                // sl<GeneralController>().closeSlider();
                                surahAudioCtrl.selectedSurah.value = index;
                                surahAudioCtrl.surahNum.value = index + 1;
                                // surahAudioCtrl.playNextSurah();
                                surahAudioCtrl.changeAudioSource();
                                print(
                                    'Updated sorahNum.value to: ${surahAudioCtrl.surahNum.value}');
                              },
                            ),
                            context.hDivider(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(.2)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
