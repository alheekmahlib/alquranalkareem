import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:screenshot/screenshot.dart';

import '../../../presentation/controllers/share_controller.dart';
import '../../../presentation/screens/quran_text/widgets/widgets.dart';
import '../../services/services_locator.dart';
import '/core/utils/constants/extensions.dart';
import '/core/utils/constants/svg_picture.dart';
import '/core/widgets/widgets.dart';

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

  @override
  Widget build(BuildContext context) {
    final ayahToImage = sl<ShareController>();
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
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Container(
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
                    surah_banner1(),
                    surahNameWidget(
                        height: 25, '$surahNumber', const Color(0xff404C6E)),
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
                                '﴿ $verseText ${arabicNumber.convert(verseNumber)} ﴾',
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'uthmanic2',
                              color: Color(0xff161f07),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Gap(24),
                Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        splash_icon(height: 40.0),
                        context.vDivider(),
                        const Text(
                          'القـرآن الكريــــم\nمكتبة الحكمة',
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'kufi',
                            color: Color(0xff161f07),
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
