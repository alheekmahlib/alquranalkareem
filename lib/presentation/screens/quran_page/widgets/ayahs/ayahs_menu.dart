part of '../../quran.dart';

class AyahsMenu extends StatelessWidget {
  final SurahModel surah;
  final AyahModel ayah;
  final int pageIndex;

  AyahsMenu({
    super.key,
    required this.surah,
    required this.ayah,
    required this.pageIndex,
  });

  final generalCtrl = GeneralController.instance;
  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: .15),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 35,
            width: 35,
            child: Stack(
              alignment: Alignment.center,
              children: [
                customSvgWithColor(
                  SvgPath.svgQuranSurahNumberZakhrafa,
                  color: Theme.of(context).primaryColorLight,
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      '${ayah.ayahNumber.toString().convertNumbersToCurrentLang()}',
                      style: AppTextStyles.titleSmall(
                        color: context.theme.canvasColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          GetBuilder<QuranController>(
            id: 'ayahs_menu',
            builder: (c) => AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              firstChild: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PlayButton(
                    surah: surah,
                    ayah: ayah,
                    singleAyahOnly: true,
                    iconColor: context.theme.primaryColorLight,
                  ),
                  const Gap(6),
                  context.vDivider(height: 18.0),
                  GestureDetector(
                    onTap: () => quranCtrl.toggleMenu(
                      "${surah.surahNumber}-${ayah.ayahNumber}",
                    ),
                    child: Icon(
                      Icons.more_vert_outlined,
                      size: 24,
                      color: context.theme.primaryColorLight,
                    ),
                  ),
                ],
              ),
              secondChild: Container(
                width: MediaQuery.sizeOf(context).width * .6,
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PlayButton(
                        surah: surah,
                        ayah: ayah,
                        singleAyahOnly: true,
                        iconColor: context.theme.primaryColorLight,
                      ),
                      const Gap(6),
                      context.vDivider(height: 18.0),
                      PlayButton(
                        surah: surah,
                        ayah: ayah,
                        iconColor: context.theme.primaryColorLight,
                      ),
                      const Gap(4),
                      context.vDivider(height: 18.0),
                      const Gap(6),
                      AddBookmarkButton(
                        surah: surah,
                        ayah: ayah,
                        pageIndex: pageIndex,
                        iconColor: context.theme.primaryColorLight,
                      ),
                      const Gap(6),
                      context.vDivider(height: 18.0),
                      const Gap(6),
                      CopyButton(
                        ayah: ayah,
                        surah: surah,
                        iconColor: context.theme.primaryColorLight,
                      ),
                      const Gap(6),
                      context.vDivider(height: 18.0),
                      const Gap(6),
                      ShareAyahOptions(
                        ayah: ayah,
                        surah: surah,
                        pageNumber: pageIndex,
                        iconColor: context.theme.primaryColorLight,
                      ),
                      const Gap(6),
                      context.vDivider(height: 18.0),
                      context.customClose(
                        height: 25.0,
                        close: () => quranCtrl.toggleMenu(
                          "${surah.surahNumber}-${ayah.ayahNumber}",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              crossFadeState:
                  c.state.moreOptionsMap["${surah.surahNumber}-${ayah.ayahNumber}"] ==
                      true
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          ),
        ],
      ),
    );
  }
}
