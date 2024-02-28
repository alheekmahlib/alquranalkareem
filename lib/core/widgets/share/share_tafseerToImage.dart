import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';

import '../../../presentation/controllers/ayat_controller.dart';
import '../../../presentation/controllers/share_controller.dart';
import '../../services/services_locator.dart';
import '../../utils/constants/extensions/extensions.dart';
import '../../utils/constants/svg_picture.dart';
import '/core/utils/constants/extensions/surah_name_with_banner.dart';
import '/core/utils/constants/extensions/text_span_extension.dart';
import '/presentation/controllers/translate_controller.dart';

class TafseerImageCreator extends StatelessWidget {
  final int verseNumber;
  final int verseUQNumber;
  final int surahNumber;
  final String verseText;
  final List<TextSpan> tafseerText;

  TafseerImageCreator({
    Key? key,
    required this.verseNumber,
    required this.verseUQNumber,
    required this.surahNumber,
    required this.verseText,
    required this.tafseerText,
  }) : super(key: key);
  final tafseerToImage = sl<ShareController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Screenshot(
          controller: tafseerToImage.tafseerScreenController,
          child: buildVerseImageWidget(
            context: context,
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
    required BuildContext context,
    required int verseNumber,
    required int verseUQNumber,
    required int surahNumber,
    required String verseText,
    required List<TextSpan> tafseerText,
  }) {
    final tafseerToImage = sl<ShareController>();

    return GetBuilder<TranslateDataController>(builder: (translateController) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          width: 960.0,
          decoration: const BoxDecoration(
            color: const Color(0xff404C6E),
          ),
          child: Column(
            children: [
              const Gap(8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/svg/splash_icon_w.svg',
                            height: 40,
                          ),
                          context.vDivider(),
                          const Text(
                            'القـرآن الكريــــم\nمكتبة الحكمة',
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'kufi',
                              color: Color(0xffffffff),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: context.hDivider(
                            width: MediaQuery.sizeOf(context).width)),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const Gap(6),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          surah_banner1(),
                          context.surahNameWidget(
                              height: 25,
                              '$surahNumber',
                              const Color(0xff404C6E)),
                        ],
                      ),
                      const Gap(16),
                      SizedBox(
                          width: 928.0,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(
                                  '﴿ $verseText ${tafseerToImage.arabicNumber.convert(verseNumber)} ﴾',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'uthmanic2',
                                    color: Color(0xff161f07),
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              const Gap(16),
                              Align(
                                alignment: tafseerToImage.checkAndApplyRtlLayout(
                                    '${tafseerToImage.currentTranslate.value}'),
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      color: const Color(0xffCDAD80)
                                          .withOpacity(.3),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8))),
                                  child: Obx(
                                    () => Text(
                                      tafseerToImage.currentTranslate.value,
                                      style: const TextStyle(
                                        fontSize: 10,
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
                                    color: const Color(0xff404C6E)
                                        .withOpacity(.15),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8))),
                                child: Obx(
                                  () => Text.rich(
                                    sl<ShareController>().isTafseer.value
                                        ? TextSpan(
                                            children: sl<AyatController>()
                                                .selectedTafsir!
                                                .text
                                                .buildTextSpans(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'naskh',
                                              color: Color(0xff161f07),
                                            ),
                                          )
                                        : TextSpan(
                                            text: sl<TranslateDataController>()
                                                    .data[verseUQNumber - 1]
                                                ['text'],
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontFamily: 'naskh',
                                              color: Color(0xff161f07),
                                            ),
                                          ),
                                    textAlign: TextAlign.justify,
                                    textDirection: tafseerToImage
                                        .checkApplyRtlLayout(tafseerToImage
                                            .currentTranslate.value),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      const Gap(8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
