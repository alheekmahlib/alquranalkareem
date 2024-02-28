import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../controllers/azkar_controller.dart';
import '/core/utils/constants/extensions/extensions.dart';
import '/core/utils/constants/svg_picture.dart';

class VerseImageCreator extends StatelessWidget {
  final String zekrText;
  final String category;
  final String reference;
  final String description;
  final String count;

  VerseImageCreator({
    Key? key,
    required this.zekrText,
    required this.category,
    required this.reference,
    required this.description,
    required this.count,
  }) : super(key: key);
  final zekrToImage = sl<AzkarController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Screenshot(
          controller: zekrToImage.zekrScreenController,
          child: buildVerseImageWidget(
            context: context,
            zekrText: zekrText,
            category: category,
            reference: reference,
            description: description,
            count: count,
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
    required zekrText,
    required category,
    required reference,
    required description,
    required count,
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
            Row(
              children: [
                Expanded(
                    flex: 4,
                    child: context.hDivider(
                        width: MediaQuery.sizeOf(context).width)),
                Expanded(
                  flex: 2,
                  child: SvgPicture.asset(
                    'assets/svg/azkar.svg',
                    height: 65,
                  ),
                ),
                Expanded(
                    flex: 4,
                    child: context.hDivider(
                        width: MediaQuery.sizeOf(context).width)),
              ],
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
                    const Gap(16),
                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'kufi',
                        fontWeight: FontWeight.bold,
                        color: Color(0xffCDAD80),
                      ),
                    ),
                    context.hDivider(
                        width: MediaQuery.sizeOf(context).width, height: 1),
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
                                children: zekrToImage.shareTextSpans(zekrText),
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'naskh',
                                  color: Color(0xff161f07),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Gap(4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: const Color(0xff404C6E).withOpacity(.05),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                        ),
                        child: Text(
                          reference,
                          style: const TextStyle(
                            fontSize: 10,
                            fontFamily: 'kufi',
                            fontWeight: FontWeight.bold,
                            color: Color(0xffCDAD80),
                          ),
                        ),
                      ),
                    ),
                    context.hDivider(
                        width: MediaQuery.sizeOf(context).width, height: 1),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        color: const Color(0xff404C6E).withOpacity(.05),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                      ),
                      child: Text(
                        description,
                        style: const TextStyle(
                          fontSize: 10,
                          fontFamily: 'kufi',
                          fontWeight: FontWeight.bold,
                          color: Color(0xffCDAD80),
                        ),
                      ),
                    ),
                    const Gap(16),
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
          ],
        ),
      ),
    );
  }
}
