part of '../quran.dart';

class SurahJuzList extends StatelessWidget {
  SurahJuzList({super.key});

  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: DefaultTabController(
          length: 2,
          child: ClipRect(
            child: Column(
              children: [
                const Gap(6),
                Container(
                  height: 40,
                  padding: const EdgeInsets.all(4.0),
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).primaryColorDark.withValues(alpha: .3),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: TabBar(
                    unselectedLabelColor:
                        context.theme.colorScheme.inversePrimary,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelStyle: AppTextStyles.titleSmall(),
                    unselectedLabelStyle: AppTextStyles.titleSmall(),
                    indicator: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    tabs: [
                      Tab(text: 'quran_sorah'.tr),
                      Tab(text: 'allJuz'.tr),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: <Widget>[QuranSurahList(), QuranJuzList()],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
