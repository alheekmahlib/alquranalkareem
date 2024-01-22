import 'dart:convert';

import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../controllers/general_controller.dart';
import '/core/widgets/widgets.dart';

class QuranJuz extends StatelessWidget {
  final controller = ScrollController();

  QuranJuz({super.key});

  @override
  Widget build(BuildContext context) {
    ArabicNumbers arabicNumber = ArabicNumbers();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: FutureBuilder(
          builder: (context, snapshot) {
            var showData = json.decode(snapshot.data.toString());
            if (snapshot.connectionState == ConnectionState.done) {
              return Scrollbar(
                thumbVisibility: true,
                interactive: true,
                controller: controller,
                child: ListView.builder(
                  controller: controller,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Get.theme.colorScheme.surface,
                                    width: 1,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      topLeft: Radius.circular(8))),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 8),
                                    child: juzNum2(
                                        '${showData[index]['index']}',
                                        context,
                                        Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        30),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      children: [
                                        Text(
                                          'من الآية ${arabicNumber.convert(showData[index]['start']['verse'])}',
                                          style: TextStyle(
                                            fontFamily: "kufi",
                                            fontWeight: FontWeight.normal,
                                            fontSize: 10,
                                            color: Get.isDarkMode
                                                ? Get.theme.canvasColor
                                                : Get.theme.primaryColorDark,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: RichText(
                                              textAlign: TextAlign.justify,
                                              text: TextSpan(
                                                  style: TextStyle(
                                                      fontFamily: "uthmanic",
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 18,
                                                      color: Get.isDarkMode
                                                          ? Get
                                                              .theme.canvasColor
                                                          : Get.theme
                                                              .primaryColorDark,
                                                      backgroundColor: Get.theme
                                                          .colorScheme.surface
                                                          .withOpacity(.2)),
                                                  text:
                                                      '﴿${showData[index]['start']['ayatext']}﴾',
                                                  children: [
                                                    WidgetSpan(
                                                        child: ayaNum(
                                                            arabicNumber.convert(
                                                                showData[index][
                                                                        'start']
                                                                    ['verse']),
                                                            context,
                                                            Get.theme
                                                                .primaryColorDark)),
                                                  ])),
                                        ),
                                        const Divider(
                                          height: 4,
                                        ),
                                        Text(
                                          'إلى الآية ${arabicNumber.convert(showData[index]['end']['verse'])}',
                                          style: TextStyle(
                                            fontFamily: "kufi",
                                            fontWeight: FontWeight.normal,
                                            fontSize: 10,
                                            color: Get.isDarkMode
                                                ? Get.theme.canvasColor
                                                : Get.theme.primaryColorDark,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: RichText(
                                              textAlign: TextAlign.justify,
                                              text: TextSpan(
                                                  style: TextStyle(
                                                      fontFamily: "uthmanic",
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 18,
                                                      color: Get.isDarkMode
                                                          ? Get
                                                              .theme.canvasColor
                                                          : Get.theme
                                                              .primaryColorDark,
                                                      backgroundColor: Get.theme
                                                          .colorScheme.surface
                                                          .withOpacity(.2)),
                                                  text:
                                                      '﴿${showData[index]['end']['ayatext']}﴾',
                                                  children: [
                                                    WidgetSpan(
                                                        child: ayaNum(
                                                      arabicNumber.convert(
                                                          showData[index]['end']
                                                              ['verse']),
                                                      context,
                                                      Get.theme
                                                          .primaryColorDark,
                                                    )),
                                                  ])),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          )
                        ],
                      ),
                      onTap: () {
                        sl<GeneralController>()
                            .quranPageController
                            .animateToPage(
                              showData[index]['start']['pageNum'] - 1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                        sl<GeneralController>().slideClose();
                      },
                    );
                  },
                  itemCount: 30,
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
          future:
              DefaultAssetBundle.of(context).loadString("assets/json/juz.json"),
        ),
      ),
    );
  }

  Widget ayaNum(String num, context, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
              height: 30,
              width: 30,
              child: SvgPicture.asset('assets/svg/ayah_no.svg')),
          Text(
            num,
            style: TextStyle(
                fontSize: 9, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
