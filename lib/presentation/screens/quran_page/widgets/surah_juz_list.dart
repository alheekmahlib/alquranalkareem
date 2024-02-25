import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'juz_page.dart';
import 'quran_surah_list.dart';

class SurahJuzList extends StatelessWidget {
  SurahJuzList({super.key});

  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const Gap(6),
                Container(
                  height: 40,
                  padding: const EdgeInsets.all(4.0),
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: TabBar(
                    unselectedLabelColor: Colors.grey,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelStyle: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontFamily: 'kufi',
                      fontSize: 11,
                    ),
                    indicator: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        color: Theme.of(context)
                            .colorScheme
                            .background
                            .withOpacity(.3)),
                    tabs: [
                      Tab(
                        child: Text(
                          'quran_sorah'.tr,
                          style: TextStyle(
                              color: Theme.of(context).canvasColor,
                              fontSize: 12,
                              fontFamily: 'kufi'),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'allJuz'.tr,
                          style: TextStyle(
                              color: Theme.of(context).canvasColor,
                              fontSize: 12,
                              fontFamily: 'kufi'),
                        ),
                      ),
                    ],
                  ),
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
      ),
    );
  }
}
