import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:screenshot/screenshot.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../presentation/screens/quran_page/controllers/share_controller.dart';
import '../../../presentation/screens/quran_page/extensions/surah_name_with_banner.dart';
import '../../utils/constants/extensions/extensions.dart';
import '../../utils/constants/svg_constants.dart';

class VerseImageCreator extends StatelessWidget {
  final int verseNumber;
  final int surahNumber;
  final String verseText;

  VerseImageCreator({
    Key? key,
    required this.verseNumber,
    required this.surahNumber,
    required this.verseText,
  }) : super(key: key);
  final ayahToImage = ShareController.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Screenshot(
          controller: ayahToImage.ayahScreenController,
          child: buildVerseImageWidget(
            context: context,
            verseNumber: verseNumber,
            surahNumber: surahNumber,
            verseText: verseText,
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
    required int surahNumber,
    required String verseText,
  }) {
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
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        customSvg(SvgPath.svgSurahBanner1),
                        surahNameWidget(
                            height: 25,
                            '$surahNumber',
                            const Color(0xff404C6E)),
                      ],
                    ),
                    const Gap(16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: 928.0,
                        child: RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    '﴿ $verseText ${ayahToImage.arabicNumber.convert(verseNumber)} ﴾',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'uthmanic2',
                                  color: Color(0xff161f07),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Gap(8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
