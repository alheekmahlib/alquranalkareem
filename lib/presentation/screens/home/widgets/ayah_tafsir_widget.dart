import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '/core/utils/constants/extensions/text_span_extension.dart';
import '../../../../core/utils/constants/lists.dart';
import '../../../../core/widgets/read_more_less/read_more_less.dart';
import '../../../controllers/daily_ayah_controller.dart';
import '../../../controllers/general/general_controller.dart';
import '../../quran_page/data/model/surahs_model.dart';
import '../../quran_page/quran.dart';

class AyahTafsirWidget extends StatelessWidget {
  AyahTafsirWidget({super.key});

  final dailyCtrl = DailyAyahController.instance;
  final generalCtrl = GeneralController.instance;
  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: FutureBuilder<Ayah>(
          future: dailyCtrl.getDailyAyah(),
          builder: (context, snapshot) {
            return snapshot.data != null && dailyCtrl.ayahOfTheDay != null
                ? Container(
                    width: Get.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    margin: const EdgeInsets.symmetric(horizontal: 32.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(.1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    child: Column(
                      children: [
                        Text(
                          '﴿${dailyCtrl.ayahOfTheDay?.text ?? ''} ${dailyCtrl.ayahOfTheDay != null ? generalCtrl.state.arabicNumber.convert(dailyCtrl.ayahOfTheDay!.ayahNumber) : ''}﴾',
                          style: TextStyle(
                            fontFamily: 'uthmanic2',
                            fontSize: 24,
                            height: 1.9,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: surahNameWidget(
                                  height: 40,
                                  quranCtrl
                                      .getSurahDataByAyahUQ(
                                          dailyCtrl.ayahOfTheDay!.ayahUQNumber)
                                      .surahNumber
                                      .toString(),
                                  Get.theme.hintColor),
                            ),
                            Expanded(
                                flex: 4,
                                child: context.hDivider(width: Get.width)),
                            Expanded(
                              flex: 4,
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surface
                                        .withOpacity(.4),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6))),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '${tafsirNameRandom[dailyCtrl.radioValue.value]['name']}'
                                        .tr,
                                    style: TextStyle(
                                      fontFamily: 'naskh',
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        snapshot.connectionState == ConnectionState.done
                            ? ReadMoreLess(
                                text: dailyCtrl.selectedTafsir!.tafsirText
                                    .buildTextSpans(),
                                textStyle: TextStyle(
                                  fontSize:
                                      generalCtrl.state.fontSizeArabic.value,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  overflow: TextOverflow.fade,
                                ),
                                textAlign: TextAlign.justify,
                                animationDuration:
                                    const Duration(milliseconds: 300),
                                maxLines: 1,
                                collapsedHeight: 30,
                                readMoreText: 'readMore'.tr,
                                readLessText: 'readLess'.tr,
                                buttonTextStyle: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'kufi',
                                  color: Theme.of(context).hintColor,
                                ),
                                iconColor: Theme.of(context).hintColor,
                              )
                            : const Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                      ],
                    ),
                  )
                : const SizedBox.shrink();
          }),
    );
  }
}
