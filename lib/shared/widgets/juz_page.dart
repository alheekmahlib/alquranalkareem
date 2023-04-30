import 'dart:convert';
import 'package:alquranalkareem/cubit/cubit.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:theme_provider/theme_provider.dart';

class QuranJuz extends StatefulWidget {
  @override
  _QuranJuzState createState() => _QuranJuzState();
}

class _QuranJuzState extends State<QuranJuz>
    with SingleTickerProviderStateMixin {
  var controller = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.surface,
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
                                    child: Container(
                                      width: MediaQuery.of(context).size.width /
                                          1 /
                                          4,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(2))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          'الجُزْءُ ${showData[index]['index2']}',
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).canvasColor,
                                            fontFamily: 'uthmanic',
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
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
                                            color:
                                                ThemeProvider.themeOf(context)
                                                            .id ==
                                                        'dark'
                                                    ? Theme.of(context)
                                                        .canvasColor
                                                    : Theme.of(context)
                                                        .primaryColorDark,
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
                                                    color: ThemeProvider
                                                                    .themeOf(
                                                                        context)
                                                                .id ==
                                                            'dark'
                                                        ? Theme.of(context)
                                                            .canvasColor
                                                        : Theme.of(context)
                                                            .primaryColorDark,
                                                  ),
                                                  text:
                                                      '﴿${showData[index]['start']['ayatext']}﴾',
                                                  children: [
                                                    WidgetSpan(
                                                        child: ayaNum(
                                                            "${arabicNumber.convert(showData[index]['start']['verse'])}",
                                                            context,
                                                            Theme.of(context)
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
                                            color:
                                                ThemeProvider.themeOf(context)
                                                            .id ==
                                                        'dark'
                                                    ? Theme.of(context)
                                                        .canvasColor
                                                    : Theme.of(context)
                                                        .primaryColorDark,
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
                                                    color: ThemeProvider
                                                                    .themeOf(
                                                                        context)
                                                                .id ==
                                                            'dark'
                                                        ? Theme.of(context)
                                                            .canvasColor
                                                        : Theme.of(context)
                                                            .primaryColorDark,
                                                  ),
                                                  text:
                                                      '﴿${showData[index]['end']['ayatext']}﴾',
                                                  children: [
                                                    WidgetSpan(
                                                        child: ayaNum(
                                                      "${arabicNumber.convert(showData[index]['end']['verse'])}",
                                                      context,
                                                      ThemeProvider.themeOf(
                                                                      context)
                                                                  .id ==
                                                              'green'
                                                          ? Theme.of(context)
                                                              .primaryColorDark
                                                          : Theme.of(context)
                                                              .canvasColor,
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
                        QuranCubit.get(context).dPageController?.animateToPage(
                              showData[index]['start']['pageNum'] - 1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                        Navigator.pop(context);
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
