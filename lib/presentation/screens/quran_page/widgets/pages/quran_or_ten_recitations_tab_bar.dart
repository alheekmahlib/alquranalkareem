part of '../../quran.dart';

class QuranOrTenRecitationsTabBar extends StatelessWidget {
  QuranOrTenRecitationsTabBar({super.key});

  final quranCtrl = QuranCtrl.instance;

  @override
  Widget build(BuildContext context) {
    final surah = quranCtrl.getCurrentSurahByPageNumber(
      quranCtrl.state.currentPageNumber.value,
    );
    final ayah = quranCtrl.getPageAyahsByIndex(
      quranCtrl.state.currentPageNumber.value - 1,
    );
    return !quranCtrl.state.isTajweedEnabled.value
        ? TabBar(
            controller: WordInfoCtrl.instance.tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            onTap: (index) {
              // عند اختيار "القراءات العشر" تأكد من أن البيانات محمّلة.
              if (index == 1 &&
                  !WordInfoCtrl.instance.isKindAvailable(
                    WordInfoKind.recitations,
                  )) {
                // TabBar يغيّر التبويب قبل onTap، لذا نرجع مباشرة للتبويب الأول.
                WordInfoCtrl.instance.tabController.animateTo(0);

                AyahMenuHelper.show(
                  context,
                  surah: surah,
                  ayah: ayah.first,
                  pageIndex: quranCtrl.state.currentPageNumber.value,
                );
                log(
                  'Surah: ${surah.arabicName}, Ayah: ${ayah.first.ayahNumber}, Page: ${quranCtrl.state.currentPageNumber.value}',
                );

                // await showWordInfoBottomSheet(
                //   context: context,
                //   ref: fallbackRef,
                //   initialKind: WordInfoKind.recitations,
                //   isDark: isDark,
                // );

                if (WordInfoCtrl.instance.isKindAvailable(
                  WordInfoKind.recitations,
                )) {
                  WordInfoCtrl.instance.tabController.animateTo(1);
                }
              }
            },
            indicator: BoxDecoration(
              color: context.theme.colorScheme.surface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            unselectedLabelColor: context.theme.colorScheme.surface.withValues(
              alpha: 0.8,
            ),
            indicatorPadding: const EdgeInsets.all(4),
            labelStyle: AppTextStyles.titleSmall(),
            tabs: [
              Tab(text: 'quran'.tr),
              Tab(text: 'recitations'.tr),
            ],
          )
        : const SizedBox.shrink();
  }
}
