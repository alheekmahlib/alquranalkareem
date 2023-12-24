import 'package:flutter/material.dart';

import '/core/services/l10n/app_localizations.dart';
import '/presentation/screens/quran_page/widgets/surah_list.dart';
import 'juz_page.dart';

class SurahJuzList extends StatelessWidget {
  SurahJuzList({super.key});

  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
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
                      AppLocalizations.of(context)!.quran_sorah,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontSize: 12,
                          fontFamily: 'kufi'),
                    ),
                  ),
                  Tab(
                    child: Text(
                      AppLocalizations.of(context)!.allJuz,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontSize: 12,
                          fontFamily: 'kufi'),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    SurahList(),
                    QuranJuz(),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
