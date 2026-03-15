import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:quran_library/quran_library.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '/core/utils/constants/extensions/text_span_extension.dart';
import '/core/utils/helpers/app_text_styles.dart';
import '../../../../core/utils/constants/extensions/svg_extensions.dart';
import '../../../../core/utils/constants/lists.dart';
import '../../../../core/utils/constants/svg_constants.dart';
import '../../../../core/widgets/read_more_less/read_more_less.dart';
import '../../../controllers/daily_ayah_controller.dart';
import '../../quran_page/quran.dart';

class AyahTafsirWidget extends StatelessWidget {
  AyahTafsirWidget({super.key});

  final dailyCtrl = DailyAyahController.instance;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: FutureBuilder<AyahModel>(
        future: dailyCtrl.getDailyAyah(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return Container(
              width: Get.width,
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.theme.primaryColorLight.withValues(alpha: .01),
                    context.theme.primaryColorLight.withValues(alpha: .05),
                    context.theme.primaryColorLight.withValues(alpha: .1),
                    context.theme.primaryColorLight.withValues(alpha: .15),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.4, 0.8, 1.0],
                ),
                // color: context.theme.primaryColorLight.withValues(alpha: .1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  GetSingleAyah(
                    surahNumber: snapshot.data!.surahNumber!,
                    ayahNumber: snapshot.data!.ayahNumber,
                    enableWordSelection: false,
                    fontSize: 28,
                    textAlign: TextAlign.center,
                    enabledTajweed:
                        QuranCtrl.instance.state.isTajweedEnabled.value,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: surahNameWidget(
                          height: 40,
                          QuranController.instance
                              .getSurahDataByAyahUQ(snapshot.data!.ayahUQNumber)
                              .surahNumber
                              .toString(),
                          Get.theme.hintColor,
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: context.hDivider(width: Get.width),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: context.theme.colorScheme.surface.withValues(
                              alpha: .4,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6),
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '${tafsirNameRandom[int.parse(dailyCtrl.tafsirRadioValue)]['name']}'
                                  .tr,
                              style: AppTextStyles.titleSmall(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  snapshot.connectionState == ConnectionState.done
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ReadMoreLess(
                            text: dailyCtrl.selectedTafsir!.tafsirText
                                .buildTextSpans(),
                            textStyle: TextStyle(
                              fontFamily: 'naskh',
                              fontSize:
                                  TafsirCtrl.instance.fontSizeArabic.value,
                              color: Theme.of(
                                context,
                              ).colorScheme.inversePrimary,
                              overflow: TextOverflow.fade,
                            ),
                            textAlign: TextAlign.justify,
                            animationDuration: const Duration(
                              milliseconds: 300,
                            ),
                            maxLines: 1,
                            collapsedHeight: 30,
                            readMoreText: 'readMore'.tr,
                            readLessText: 'readLess'.tr,
                            iconExpanded: Transform.flip(
                              flipY: true,
                              child: customSvgWithColor(
                                SvgPath.svgHomeArrowDown,
                                color: context.theme.primaryColorDark,
                                height: 10,
                              ),
                            ),
                            iconCollapsed: Transform.flip(
                              flipY: false,
                              child: customSvgWithColor(
                                SvgPath.svgHomeArrowDown,
                                color: context.theme.primaryColorDark,
                                height: 10,
                              ),
                            ),
                            buttonTextStyle: AppTextStyles.titleSmall()
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                            iconColor: Theme.of(context).colorScheme.surface,
                          ),
                        )
                      : const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
