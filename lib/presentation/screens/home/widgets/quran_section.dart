import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:quran_library/quran_library.dart';

import '/core/utils/constants/svg_constants.dart';
import '/presentation/controllers/general/app_section.dart';
import '/presentation/controllers/general/general_controller.dart';
import '../../../../core/tour/home_tour_script.dart';
import '../../../../core/utils/constants/extensions/convert_number_extension.dart';
import '../../../../core/utils/constants/extensions/svg_extensions.dart';
import '../../../../core/utils/helpers/app_text_styles.dart';
import '../../../../core/widgets/buttom_with_line.dart';
import '../../quran_page/quran.dart';
import 'ayah_tafsir_widget.dart';

class QuranSection extends StatelessWidget {
  QuranSection({super.key});

  final quranCtrl = QuranController.instance;
  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    final lastReadPage = quranCtrl.state.box.read('last_page') ?? 1;
    final surah = QuranCtrl.instance.getCurrentSurahByPageNumber(lastReadPage);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          GestureDetector(
            // هدف جولة الصفحة الرئيسية: بطاقة متابعة القراءة.
            key: HomeTourKeys.lastRead,
            onTap: () => generalCtrl.open(AppSection.mushaf),
            child: Stack(
              alignment: Alignment.center,
              children: [
                LinearProgressIndicator(
                  minHeight: 50,
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  value: (lastReadPage / 604).clamp(0.0, 1.0),
                  backgroundColor: Colors.transparent,
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: .5),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Gap(16),
                                Text(
                                  '${lastReadPage.toString().convertNumbersToCurrentLang()}',
                                  style: AppTextStyles.titleLarge().copyWith(
                                    fontSize: 35,
                                    height: .5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                ),
                                customSvgWithColor(
                                  'assets/svg/surah_name/00${surah.surahNumber}.svg',
                                  width: 160,
                                  color: Theme.of(context).cardColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          ButtomWithLine(
                            key: HomeTourKeys.quran,
                            isRtl: true,
                            svgPath: SvgPath.svgHomeQuranLogo,
                            title: 'quran',
                            onTap: () => generalCtrl.open(AppSection.mushaf),
                          ),
                          const Gap(8),
                          ButtomWithLine(
                            key: HomeTourKeys.quranAudio,
                            isRtl: false,
                            title: 'quranAudio',
                            svgPath: SvgPath.svgAudioAudioQuran,
                            onTap: () => generalCtrl.open(AppSection.audio),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const AyahTafsirWidget(),
        ],
      ),
    );
  }
}
