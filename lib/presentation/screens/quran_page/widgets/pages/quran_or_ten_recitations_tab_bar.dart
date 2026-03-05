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
        ? Align(
            alignment: AlignmentDirectional.topEnd,
            child: Transform.translate(
              offset: const Offset(0, 75),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0, 0.0, 0),
                child: SizedBox(
                  width: context.customOrientation(Get.width, Get.width * .5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          width: context.customOrientation(
                            Get.width,
                            Get.width * .5,
                          ),
                          decoration: BoxDecoration(
                            color: context.theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: .1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: TabBar(
                            controller: WordInfoCtrl.instance.tabController,
                            indicatorSize: TabBarIndicatorSize.tab,
                            onTap: (index) async {
                              // عند اختيار "القراءات العشر" تأكد من أن البيانات محمّلة.
                              if (index == 1 &&
                                  !WordInfoCtrl.instance.isKindAvailable(
                                    WordInfoKind.recitations,
                                  )) {
                                // TabBar يغيّر التبويب قبل onTap، لذا نرجع مباشرة للتبويب الأول.
                                WordInfoCtrl.instance.tabController.animateTo(
                                  0,
                                );

                                AyahMenuHelper.show(
                                  context,
                                  surah: surah,
                                  ayah: ayah.first,
                                  pageIndex:
                                      quranCtrl.state.currentPageNumber.value,
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
                                  WordInfoCtrl.instance.tabController.animateTo(
                                    1,
                                  );
                                }
                              }
                            },
                            indicator: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).canvasColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            unselectedLabelColor: context.theme.canvasColor
                                .withValues(alpha: 0.5),
                            indicatorPadding: const EdgeInsets.all(4),
                            labelStyle: AppTextStyles.titleSmall(
                              color: context.theme.canvasColor,
                            ),
                            tabs: [
                              Tab(text: 'quran'.tr),
                              Tab(text: 'recitations'.tr),
                            ],
                          ),
                        ),
                      ),
                      const Gap(8),
                      Container(
                        height: 40,
                        width: 8,
                        decoration: BoxDecoration(
                          color: Get.theme.primaryColorLight,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
