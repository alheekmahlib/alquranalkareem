import 'package:alquranalkareem/l10n/app_localizations.dart';
import 'package:alquranalkareem/shared/widgets/sorah_list.dart';
import 'package:alquranalkareem/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'juz_page.dart';

class SorahJuzList extends StatefulWidget {
  const SorahJuzList({super.key});

  @override
  _SorahJuzListState createState() => _SorahJuzListState();
}

class _SorahJuzListState extends State<SorahJuzList>
    with SingleTickerProviderStateMixin {
  var dSorahJuzListKey = GlobalKey<ScaffoldState>();
  var controller = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: dSorahJuzListKey,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20))),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            topBar(context),
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
                const SorahList(),
                QuranJuz(),
              ],
            ),)
          ],
        )
      ),
    );
  }
}