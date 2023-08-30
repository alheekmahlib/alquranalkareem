import 'package:alquranalkareem/shared/widgets/show_tafseer.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../quran_page/data/model/ayat.dart';
import '../controller/ayat_controller.dart';
import '../controller/general_controller.dart';
import 'controllers_put.dart';
import 'lottie.dart';

class AyahList extends StatelessWidget {
  AyahList({Key? key}) : super(key: key);

  final ArabicNumbers arabicNumber = ArabicNumbers();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AyatController>();
    controller.fetchAyat(generalController.cuMPage);
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: Theme.of(context).dividerColor.withOpacity(.2),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
            topLeft: Radius.circular(8),
          ),
          border: Border.all(
              color: ThemeProvider.themeOf(context).id == 'blue'
                  ? Theme.of(context).dividerColor.withOpacity(.6)
                  : const Color(0xffcdba72),
              width: 2)),
      child: Center(
        child: Obx(() {
          final ayat = controller.ayatList;
          if (ayat.isEmpty) {
            return Center(child: search(100.0, 40.0));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            scrollDirection: Axis.horizontal,
            itemCount: ayat.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, index) {
              Ayat? aya = ayat[index];

              return Obx(
                () => Opacity(
                  opacity: ayatController.isSelected.value == index.toDouble()
                      ? 1.0
                      : .5,
                  child: InkWell(
                    onTap: () {
                      ayatController.isSelected.value = index.toDouble();
                      ayatController.tafseerAyah = "${aya.ayatext ?? ''}";
                      ayatController.tafseerText = "${aya.translate ?? ''}";
                      audioController.pageAyahNumber = '${aya.ayaNum ?? 0}';
                      ayatController.currentAyahNumber.value =
                          '${aya.ayaNum ?? 0}';
                      audioController.pageSurahNumber = '${aya.suraNum ?? 0}';
                      print(audioController.pageAyahNumber);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/svg/ayah_no.svg',
                          width: 30,
                          height: 30,
                        ),
                        Text(
                          "${arabicNumber.convert(aya.ayaNum)}",
                          // "1",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontFamily: 'kufi',
                              fontWeight: FontWeight.w700,
                              fontSize: 9),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

class AyahList2 extends StatelessWidget {
  AyahList2({Key? key}) : super(key: key);

  final ArabicNumbers arabicNumber = ArabicNumbers();
  late final AyatController ayatController = Get.put(AyatController());
  late final GeneralController generalController = Get.put(GeneralController());

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AyatController>();
    controller.fetchAyat(generalController.cuMPage);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          height: 40,
          decoration: BoxDecoration(
              color: Theme.of(context).dividerColor.withOpacity(.2),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                topLeft: Radius.circular(8),
              ),
              border:
                  Border.all(color: Theme.of(context).dividerColor, width: 2)),
          child: Center(
            child: Obx(() {
              final ayat = controller.ayatList;
              if (ayat.isEmpty) {
                return Center(child: search(100.0, 40.0));
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                scrollDirection: Axis.horizontal,
                itemCount: ayat.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, index) {
                  Ayat aya = ayat[index];
                  return Obx(
                    () => Opacity(
                      opacity:
                          ayatController.isSelected.value == index.toDouble()
                              ? 1.0
                              : .5,
                      child: InkWell(
                        onTap: () {
                          ayatController.getNewTranslationAndNotify(
                              context, aya.suraNum!, aya.ayaNum!);
                          print("suraNum ${aya.ayaNum}");
                          ayatController.isSelected.value = index.toDouble();
                          ayahSelected = index;
                          ayahNumber = aya.ayaNum;
                          surahNumber = aya.suraNum;
                          surahName = aya.sura_name_ar;
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Center(
                              child: SvgPicture.asset(
                                'assets/svg/ayah_no.svg',
                                width: 35,
                                height: 35,
                              ),
                            ),
                            Center(
                              child: Text(
                                "${arabicNumber.convert(aya.ayaNum)}",
                                // "1",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontFamily: 'kufi',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ],
    );
  }
}
