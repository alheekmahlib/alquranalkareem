import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../controllers/ayat_controller.dart';
import '../../quran_text/widgets/widgets.dart';
import '../data/model/aya.dart';
import '../data/model/translate.dart';

class AyahTafseerList extends StatelessWidget {
  final double svgHeight;
  final double svgWidth;
  AyahTafseerList({Key? key, required this.svgHeight, required this.svgWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: Get.theme.dividerColor.withOpacity(.4),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: Center(
        child: Obx(
          () => FutureBuilder(
              future: sl<AyatController>().getAyatAndTafseer(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!['ayat'].length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, index) {
                      Tafseer ayaTafseer = snapshot.data!['tafseer'][index];
                      Aya aya = snapshot.data!['ayat'][index];
                      return Obx(
                        () => Opacity(
                          opacity: sl<AyatController>().isSelected.value ==
                                  index.toDouble()
                              ? 1.0
                              : .5,
                          child: Semantics(
                            button: true,
                            enabled: true,
                            label: 'Ayah ${aya.ayaNum}',
                            child: InkWell(
                              onTap: () {
                                sl<AyatController>().ayahAudioOnTap(aya, index);
                                sl<AyatController>()
                                    .ayahTafseerOnTap(ayaTafseer, aya, index);
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  Center(
                                    child: SvgPicture.asset(
                                      'assets/svg/ayah_no.svg',
                                      width: svgWidth,
                                      height: svgHeight,
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      arabicNumber.convert(aya.ayaNum),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Get.theme.primaryColor,
                                          fontFamily: 'kufi',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 11),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return Center(child: search(100.0, 40.0));
              }),
        ),
      ),
    );
  }
}
