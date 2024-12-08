part of '../quran.dart';

class SurahJuzList extends StatelessWidget {
  SurahJuzList({super.key});

  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
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
                      color: Theme.of(context).colorScheme.surface,
                      fontFamily: 'kufi',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontFamily: 'kufi',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    indicator: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        color: Theme.of(context).colorScheme.primaryContainer),
                    tabs: [
                      Tab(
                        text: 'quran_sorah'.tr,
                      ),
                      Tab(
                        text: 'allJuz'.tr,
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
