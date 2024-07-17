import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/core/utils/constants/extensions/extensions.dart';
import '/core/utils/constants/extensions/surah_name_with_banner.dart';
import '/core/utils/constants/extensions/text_span_extension.dart';
import '/presentation/screens/quran_page/controllers/extensions/quran_getters.dart';
import '../../../presentation/controllers/daily_ayah_controller.dart';
import '../../../presentation/controllers/general_controller.dart';
import '../../../presentation/screens/quran_page/controllers/ayat_controller.dart';
import '../../../presentation/screens/quran_page/controllers/quran/quran_controller.dart';
import '../../services/services_locator.dart';
import '../../utils/constants/lists.dart';

class AyahTafsirWidget extends StatelessWidget {
  AyahTafsirWidget({super.key});

  final dailyCtrl = DailyAyahController.instance;
  final ayatCtrl = AyatController.instance;
  final generalCtrl = GeneralController.instance;
  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * .94,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
            topLeft: Radius.circular(8),
          )),
      child: SafeArea(
        child: Column(
          children: [
            const Gap(8),
            context.customClose(),
            const Gap(16),
            surahBannerWidget(quranCtrl
                .getSurahDataByAyahUQ(dailyCtrl.ayahOfTheDay!.ayahUQNumber)
                .surahNumber
                .toString()),
            const Gap(8),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.sizeOf(context).width,
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.all(Radius.circular(6))),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surface.withOpacity(.4),
                    borderRadius: const BorderRadius.all(Radius.circular(6))),
                child: Text(
                  '${tafsirNameRandom[dailyCtrl.radioValue.value]['name']}',
                  style: TextStyle(
                    fontFamily: 'naskh',
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
            ),
            const Gap(8),
            Flexible(
              child: SingleChildScrollView(
                child: FutureBuilder(
                    future: ayatCtrl.getTafsir(
                        dailyCtrl.ayahOfTheDay!.ayahUQNumber,
                        quranCtrl
                            .getSurahDataByAyahUQ(
                                dailyCtrl.ayahOfTheDay!.ayahUQNumber)
                            .surahNumber),
                    builder: (context, snapshot) {
                      return snapshot.connectionState == ConnectionState.done
                          ? Container(
                              width: MediaQuery.sizeOf(context).width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Scrollbar(
                                  controller: dailyCtrl.scrollController,
                                  child: SingleChildScrollView(
                                    controller: dailyCtrl.scrollController,
                                    child: Text.rich(
                                      TextSpan(
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text:
                                                '﴿${dailyCtrl.ayahOfTheDay!.text} ${dailyCtrl.ayahOfTheDay!.ayahNumber.toString().convertNumbers()}﴾\n',
                                            style: TextStyle(
                                              fontFamily: 'uthmanic2',
                                              fontSize: 24,
                                              height: 1.9,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary,
                                            ),
                                          ),
                                          WidgetSpan(
                                              child: context.hDivider(
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                          .width)),
                                          TextSpan(
                                            children: ayatCtrl
                                                .selectedTafsir!.text
                                                .buildTextSpans(),
                                            style: TextStyle(
                                                color: Get.theme.colorScheme
                                                    .inversePrimary,
                                                height: 1.5,
                                                fontSize:
                                                    sl<GeneralController>()
                                                        .fontSizeArabic
                                                        .value),
                                          ),
                                          WidgetSpan(
                                            child: Center(
                                              child: SizedBox(
                                                height: 50,
                                                child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1 /
                                                            2,
                                                    child: SvgPicture.asset(
                                                      'assets/svg/space_line.svg',
                                                    )),
                                              ),
                                            ),
                                          )
                                          // TextSpan(text: 'world', style: TextStyle(fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
