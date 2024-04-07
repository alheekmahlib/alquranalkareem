import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../presentation/controllers/general_controller.dart';
import '../../../../presentation/controllers/quran_controller.dart';
import '../../../services/services_locator.dart';
import '../../../utils/constants/extensions/extensions.dart';
import '../../../utils/constants/lottie.dart';
import '../../../utils/constants/lottie_constants.dart';

class KhatmahWidget extends StatelessWidget {
  final String name;
  final int surahNumber;
  final int pageNumber;
  KhatmahWidget(
      {super.key,
      required this.name,
      required this.surahNumber,
      required this.pageNumber});

  final generalCtrl = sl<GeneralController>();
  final quranCtrl = sl<QuranController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        quranCtrl.changeSurahListOnTap(pageNumber + 1);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
        child: Container(
          height: 70,
          width: 380,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(.15),
              borderRadius: const BorderRadius.all(Radius.circular(8.0))),
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                height: 70,
                width: generalCtrl.calculateProgress(pageNumber, 604),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surface.withOpacity(.6),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0))),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: SvgPicture.asset(
                        'assets/svg/surah_name/00${surahNumber}.svg',
                        height: 60,
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).cardColor, BlendMode.srcIn),
                      ),
                    ),
                    context.vDivider(height: 30),
                    Expanded(
                      flex: 7,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 120,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${'pageNo'.tr}: ${generalCtrl.convertNumbers(pageNumber.toString())}',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: 'naskh',
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).hintColor,
                                    height: 1.5),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8))),
                              ),
                              generalCtrl.checkRtlLayout(
                                  RotatedBox(
                                      quarterTurns: 15,
                                      child: customLottie(
                                          LottieConstants.assetsLottieArrow,
                                          height: 50.0)),
                                  RotatedBox(
                                      quarterTurns: 25,
                                      child: customLottie(
                                          LottieConstants.assetsLottieArrow,
                                          height: 50.0))),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
