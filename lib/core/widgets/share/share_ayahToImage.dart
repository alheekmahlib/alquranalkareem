import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:screenshot/screenshot.dart';

import '../../../presentation/controllers/share_controller.dart';
import '../../services/services_locator.dart';
import '../../utils/helpers/functions.dart';

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
    required int verseNumber,
    required int surahNumber,
    required String verseText,
  }) {
    final ayahToImage = sl<ShareController>();
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
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: 928.0,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                ayahToImage.shareNumber(verseText, verseNumber),
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
  }
}
