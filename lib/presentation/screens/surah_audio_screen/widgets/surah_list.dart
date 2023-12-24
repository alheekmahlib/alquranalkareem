import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mini_music_visualizer/mini_music_visualizer.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/general_controller.dart';
import '../../../controllers/surah_audio_controller.dart';
import '../../../controllers/surah_repository_controller.dart';

class SurahList extends StatelessWidget {
  const SurahList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: orientation(
          context,
          const EdgeInsets.only(
              right: 16.0, left: 16.0, top: 260.0, bottom: 16.0),
          const EdgeInsets.only(
              right: 16.0, left: 16.0, top: 16.0, bottom: 16.0)),
      child: AnimationLimiter(
        child: Scrollbar(
          thumbVisibility: true,
          // interactive: true,
          controller: sl<SurahAudioController>().controller,
          child: Obx(
            () => ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: sl<SurahRepositoryController>().sorahs.length,
                controller: sl<SurahAudioController>().controller,
                padding: EdgeInsets.zero,
                itemBuilder: (_, index) {
                  final sorah = sl<SurahRepositoryController>().sorahs[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 450),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Obx(
                          () => GestureDetector(
                            child: Container(
                                height: 65,
                                decoration: BoxDecoration(
                                    color: (index % 2 == 0
                                        ? sl<SurahAudioController>()
                                                    .selectedSurah
                                                    .value ==
                                                index
                                            ? Theme.of(context)
                                                .cardColor
                                                .withOpacity(.2)
                                            : Theme.of(context)
                                                .colorScheme
                                                .background
                                        : sl<SurahAudioController>()
                                                    .selectedSurah
                                                    .value ==
                                                index
                                            ? Theme.of(context)
                                                .cardColor
                                                .withOpacity(.2)
                                            : Theme.of(context)
                                                .dividerColor
                                                .withOpacity(.3)),
                                    border: Border.all(
                                        width: 2,
                                        color: sl<SurahAudioController>()
                                                    .selectedSurah ==
                                                index
                                            ? Theme.of(context)
                                                .colorScheme
                                                .surface
                                            : Colors.transparent)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
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
                                                  )),
                                              Text(
                                                sl<SurahAudioController>()
                                                    .arabicNumber
                                                    .convert(sorah.id),
                                                style: TextStyle(
                                                    color: ThemeProvider
                                                                    .themeOf(
                                                                        context)
                                                                .id ==
                                                            'dark'
                                                        ? Theme.of(context)
                                                            .canvasColor
                                                        : Theme.of(context)
                                                            .primaryColorDark,
                                                    fontFamily: "kufi",
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    height: 2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/svg/surah_name/00${index + 1}.svg',
                                              colorFilter: ColorFilter.mode(
                                                  ThemeProvider.themeOf(context)
                                                              .id ==
                                                          'dark'
                                                      ? Theme.of(context)
                                                          .canvasColor
                                                      : Theme.of(context)
                                                          .primaryColorDark,
                                                  BlendMode.srcIn),
                                              width: 100,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Text(
                                                sorah.nameEn,
                                                style: TextStyle(
                                                  fontFamily: "naskh",
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10,
                                                  color: ThemeProvider.themeOf(
                                                                  context)
                                                              .id ==
                                                          'dark'
                                                      ? Theme.of(context)
                                                          .canvasColor
                                                      : Theme.of(context)
                                                          .primaryColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (index + 1 ==
                                          sl<SurahAudioController>()
                                              .surahNum
                                              .value)
                                        MiniMusicVisualizer(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          width: 4,
                                          height: 15,
                                        ),
                                    ],
                                  ),
                                )),
                            onTap: () {
                              print('Surah tapped with index: $index');
                              // sl<GeneralController>().closeSlider();
                              sl<GeneralController>().widgetPosition.value =
                                  0.0;
                              sl<SurahAudioController>().isDownloading.value =
                                  false;
                              sl<SurahAudioController>().selectedSurah.value =
                                  index;
                              sl<SurahAudioController>().surahNum.value =
                                  index + 1;
                              sl<SurahAudioController>().playNextSurah();
                              sl<SurahAudioController>().changeAudioSource();
                              print(
                                  'Updated sorahNum.value to: ${sl<SurahAudioController>().surahNum.value}');
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
