part of '../quran.dart';

class QuranJuzList extends StatelessWidget {
  QuranJuzList({super.key});

  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    quranCtrl.scrollToCurrentJuz();
    final jozzNames = QuranLibrary.allJoz;
    final hizbNames = QuranLibrary.allHizb;
    final isCurrent = quranCtrl.getCurrentJuzNumber;

    return CupertinoScrollbar(
      controller: quranCtrl.juzController,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: 30,
          controller: quranCtrl.juzController,
          itemBuilder: (_, index) {
            final juzNumber = index + 1;
            final juz = quranCtrl.state.allAyahs.firstWhere(
              (a) => a.juz == juzNumber,
            );
            final surah = quranCtrl.getCurrentSurahByPage(juz.page);
            final hizb1Index = index * 2;
            final hizb2Index = index * 2 + 1;

            return Column(
              children: [
                /// --- عنصر الجزء ---
                Container(
                  width: Get.width,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  decoration: BoxDecoration(
                    color: context.theme.primaryColorLight.withValues(
                      alpha: isCurrent(index).value ? 0.3 : 0.1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    onTap: () {
                      QuranLibrary().jumpToJoz(juzNumber);
                      quranCtrl.state.navBarController.close();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// رقم الجزء داخل الزخرفة
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            RepaintBoundary(
                              child: customSvg(
                                height: 64,
                                width: 64,
                                SvgPath.svgQuranSurahNumberZakhrafa,
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                ),
                                child: Text(
                                  '$juzNumber'.convertNumbersToCurrentLang(),
                                  style: AppTextStyles.titleMedium(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(12),

                        /// معلومات الجزء
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 6.0,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    jozzNames[index],
                                    style: AppTextStyles.titleMedium(
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                const Gap(2),
                                Text(
                                  surah.arabicName,
                                  style: AppTextStyles.titleSmall(
                                    color: context.theme.primaryColorDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Gap(12),

                        /// الصفحة
                        Expanded(
                          flex: 3,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 6.0,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${'page'.tr}:',
                                    style: AppTextStyles.titleSmall(
                                      color: context.theme.primaryColorDark,
                                    ),
                                  ),
                                  const Gap(4),
                                  Text(
                                    '${juz.page}'.convertNumbersToCurrentLang(),
                                    style: AppTextStyles.titleSmall(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// --- الأحزاب ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: List.generate(2, (hi) {
                      final hizbGlobalIndex = hi == 0 ? hizb1Index : hizb2Index;
                      if (hizbGlobalIndex >= hizbNames.length) {
                        return const SizedBox.shrink();
                      }
                      final hizbNumber = hizbGlobalIndex + 1;
                      return InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          QuranLibrary().jumpToHizb(hizbNumber);
                          quranCtrl.state.navBarController.close();
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 12.0,
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 2.0),
                          decoration: BoxDecoration(
                            color: hi.isEven
                                ? Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: .06)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 8,
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: .5),
                              ),
                              const Gap(8),
                              Text(
                                hizbNames[hizbGlobalIndex],
                                style: AppTextStyles.titleSmall(
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                context.hDivider(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: .2),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
