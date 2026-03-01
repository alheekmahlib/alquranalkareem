part of '../../quran.dart';

class AyahsMenu extends StatelessWidget {
  final SurahModel surah;
  final AyahModel ayah;
  final int pageIndex;
  final String surahName;
  final bool isSelected;
  final int index;

  AyahsMenu({
    super.key,
    required this.surah,
    required this.ayah,
    required this.pageIndex,
    required this.surahName,
    required this.isSelected,
    required this.index,
  });

  final generalCtrl = GeneralController.instance;
  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.surface.withValues(alpha: .4)
            : Theme.of(context).colorScheme.surface.withValues(alpha: .15),
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
                SvgPicture.asset(
                  'assets/svg/sora_num.svg',
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      '${ayah.ayahNumber.toString().convertNumbersToCurrentLang()}',
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontFamily: "kufi",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 2,
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
                  TafsirButton(ayah: ayah, pageIndex: pageIndex),
                  const Gap(6),
                  context.vDivider(height: 18.0),
                  PlayButton(surah: surah, ayah: ayah, singleAyahOnly: true),
                  const Gap(6),
                  context.vDivider(height: 18.0),
                  GestureDetector(
                    onTap: () => quranCtrl.toggleMenu(
                      "${surah.surahNumber}-${ayah.ayahNumber}",
                    ),
                    child: Icon(
                      Icons.more_vert_outlined,
                      size: 24,
                      color: Theme.of(context).colorScheme.primary,
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
                      TafsirButton(ayah: ayah, pageIndex: pageIndex),
                      const Gap(6),
                      context.vDivider(height: 18.0),
                      PlayButton(
                        surah: surah,
                        ayah: ayah,
                        singleAyahOnly: true,
                      ),
                      const Gap(6),
                      context.vDivider(height: 18.0),
                      PlayButton(surah: surah, ayah: ayah),
                      const Gap(4),
                      context.vDivider(height: 18.0),
                      const Gap(6),
                      AddBookmarkButton(
                        surah: surah,
                        ayah: ayah,
                        pageIndex: pageIndex,
                      ),
                      const Gap(6),
                      context.vDivider(height: 18.0),
                      const Gap(6),
                      CopyButton(ayah: ayah, surah: surah),
                      const Gap(6),
                      context.vDivider(height: 18.0),
                      const Gap(6),
                      ShareAyahOptions(
                        ayah: ayah,
                        surah: surah,
                        pageNumber: pageIndex,
                      ),
                      const Gap(6),
                      context.vDivider(height: 18.0),
                      context.customClose(
                        height: 16.0,
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
