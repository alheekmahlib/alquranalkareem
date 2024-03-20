import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../presentation/controllers/daily_ayah_controller.dart';
import '../../../presentation/screens/quran_page/data/model/surahs_model.dart';
import '../../services/services_locator.dart';
import '/presentation/controllers/general_controller.dart';
import 'ayah_tafsir_widget.dart';

class AyahWidget extends StatelessWidget {
  AyahWidget({super.key});
  final dailyCtrl = sl<DailyAyahController>();
  final generalCtrl = sl<GeneralController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Get.bottomSheet(AyahTafsirWidget(), isScrollControlled: true),
      child: FutureBuilder<Ayah>(
          future: dailyCtrl.getDailyAyah(),
          builder: (context, snapshot) {
            return snapshot.data != null && dailyCtrl.ayahOfTheDay != null
                ? Container(
                    width: 380,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 8.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withOpacity(.4),
                              offset: const Offset(6, 6),
                              spreadRadius: 0,
                              blurRadius: 0)
                        ]),
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: '${dailyCtrl.ayahOfTheDay!.text}',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'uthmanic2',
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.secondary,
                              height: 1.5),
                        ),
                        TextSpan(
                          text:
                              ' ${generalCtrl.convertNumbers(dailyCtrl.ayahOfTheDay!.ayahNumber.toString())}',
                          style: TextStyle(
                              fontSize: 24.0,
                              fontFamily: 'uthmanic2',
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.secondary,
                              height: 1.5),
                        ),
                      ]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                      textDirection: TextDirection.rtl,
                    ),
                  )
                : const CircularProgressIndicator();
          }),
    );
  }
}
