import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'juz_page.dart';
import 'quran_surah_list.dart';

class SurahJuzList extends StatelessWidget {
  SurahJuzList({super.key});

  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Get.theme.colorScheme.background,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20))),
      child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                    child: Text(
                      'quran_sorah'.tr,
                      style: TextStyle(
                          color: Get.theme.colorScheme.surface,
                          fontSize: 12,
                          fontFamily: 'kufi'),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'allJuz'.tr,
                      style: TextStyle(
                          color: Get.theme.colorScheme.surface,
                          fontSize: 12,
                          fontFamily: 'kufi'),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    QuranSurahList(),
                    QuranJuz(),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
