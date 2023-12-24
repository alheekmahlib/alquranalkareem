import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';

import '../../../presentation/controllers/ayat_controller.dart';
import '../../../presentation/controllers/share_controller.dart';
import '../../services/services_locator.dart';
import '../../utils/helpers/functions.dart';
import '/presentation/controllers/translate_controller.dart';

class TafseerImageCreator extends StatelessWidget {
  final int verseNumber;
  final int verseUQNumber;
  final int surahNumber;
  final String verseText;
  final String tafseerText;

  TafseerImageCreator({
    Key? key,
    required this.verseNumber,
    required this.verseUQNumber,
    required this.surahNumber,
    required this.verseText,
    required this.tafseerText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tafseerToImage = sl<ShareController>();

    return Column(
      children: [
        Screenshot(
          controller: tafseerToImage.tafseerScreenController,
          child: buildVerseImageWidget(
            verseNumber: verseNumber,
            verseUQNumber: verseUQNumber,
            surahNumber: surahNumber,
            verseText: verseText,
            tafseerText: tafseerText,
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
    required int verseNumber,
    required int verseUQNumber,
    required int surahNumber,
    required String verseText,
    required String tafseerText,
  }) {
    final tafseerToImage = sl<ShareController>();

    return GetBuilder<TranslateDataController>(builder: (translateController) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          width: 960.0,
          decoration: const BoxDecoration(
              color: const Color(0xff91a57d),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
                color: Color(0xfff3efdf),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        child: Image.asset(
                          'assets/share_images/Sorah_name_ba.png',
                          height: 40.0,
                          width: 940.0,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Image.asset(
                          height: 30.0,
                          width: 100,
                          'assets/share_images/surah_name/${formatNumber(surahNumber)}.png'),
                    ],
                  ),
                  const Gap(16),
                  SizedBox(
                      width: 928.0,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              tafseerToImage.shareNumber(
                                  verseText, verseNumber),
                              style: const TextStyle(
                                fontSize: 20,
                                fontFamily: 'uthmanic2',
                                color: Color(0xff161f07),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Gap(16),
                          Align(
                            alignment: tafseerToImage.checkAndApplyRtlLayout(
                                '${tafseerToImage.currentTranslate.value}'),
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  color:
                                      const Color(0xffcdba72).withOpacity(.3),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8))),
                              child: Obx(
                                () => Text(
                                  tafseerToImage.currentTranslate.value,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'kufi',
                                    color: Color(0xff161f07),
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ),
                          ),
                          const Gap(8),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                color: const Color(0xff91a57d).withOpacity(.3),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                            child: Obx(
                              () => Text(
                                sl<ShareController>().isTafseer.value
                                    ? sl<AyatController>()
                                        .currentText
                                        .value!
                                        .translate
                                    : sl<TranslateDataController>()
                                        .data[verseUQNumber - 1]['text'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'naskh',
                                  color: Color(0xff161f07),
                                ),
                                textAlign: TextAlign.justify,
                                textDirection:
                                    tafseerToImage.checkApplyRtlLayout(
                                        tafseerToImage.currentTranslate.value),
                              ),
                            ),
                          ),
                        ],
                      )),
                  const Gap(24),
                  Image.asset(
                    'assets/share_images/Logo_line2.png',
                    height: 40,
                    width: 160,
                  ),
                  // Add more widgets as needed
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
