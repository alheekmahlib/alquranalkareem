import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:quran_library/quran.dart';
import 'package:screenshot/screenshot.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../presentation/screens/quran_page/quran.dart';
import '../../utils/constants/extensions/extensions.dart';
import '../../utils/constants/svg_constants.dart';
import '../../utils/helpers/app_text_styles.dart';

class VerseImageCreator extends StatelessWidget {
  final AyahModel ayah;
  final SurahModel surah;

  final ayahToImage = ShareController.instance;
  VerseImageCreator({super.key, required this.ayah, required this.surah});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Screenshot(
          controller: ayahToImage.ayahScreenController,
          child: buildVerseImageWidget(
            context: context,
            ayah: ayah,
            surah: surah,
          ),
        ),
        // if (ayahToImage.ayahToImageBytes != null)
        //   Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Image.memory(ayahToImage.ayahToImageBytes!),
        //   ),
      ],
    );
  }

  Widget buildVerseImageWidget({
    required BuildContext context,
    required AyahModel ayah,
    required SurahModel surah,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: 960.0,
        decoration: BoxDecoration(color: context.theme.colorScheme.primary),
        child: Column(
          children: [
            const Gap(8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.primaryContainer,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const Gap(8),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        customSvgWithColor(
                          SvgPath.svgQuranSurahBanner,
                          color: context.theme.colorScheme.primary,
                        ),
                        surahNameWidget(
                          height: 30,
                          '${surah.surahNumber}',
                          context.theme.colorScheme.inversePrimary,
                        ),
                      ],
                    ),
                    const Gap(16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: 928.0,
                        child: GetSingleAyah(
                          surahNumber: surah.surahNumber,
                          ayahNumber: ayah.ayahNumber,
                          fontSize: 22,
                          isDark: themeCtrl.isDarkMode,
                          textColor: context.theme.colorScheme.inversePrimary,
                          enabledTajweed:
                              QuranCtrl.instance.state.isTajweedEnabled.value,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const Gap(4),
                  ],
                ),
              ),
            ),
            const Gap(4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  customSvg(SvgPath.svgSplashIconW, height: 30),
                  context.vDivider(),
                  Text(
                    'القرآن الكريـم - مكتبة الحكمة',
                    style: AppTextStyles.titleSmall(
                      fontSize: 10,
                      color: context.theme.canvasColor,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            const Gap(4),
          ],
        ),
      ),
    );
  }
}
