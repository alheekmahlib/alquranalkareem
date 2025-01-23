part of '../quran.dart';

class QuranJuz extends StatelessWidget {
  QuranJuz({super.key});

  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
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
              final surah = quranCtrl.state.surahs[index];
              final juz = quranCtrl.state.allAyahs.firstWhere(
                (a) => a.juz == index + 1,
              );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '${'juz'.tr} ${(index + 1).toString().convertNumbers()}',
                      style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontFamily: "kufi",
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          height: 2),
                    ),
                  ),
                  GestureDetector(
                    child: GetX<QuranController>(
                      builder: (quranCtrl) {
                        return Container(
                            height: 62,
                            decoration: BoxDecoration(
                                color: (index % 2 == 0
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: .15)
                                    : Colors.transparent),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                border: Border.all(
                                    width: 2,
                                    color: quranCtrl
                                            .getCurrentJuzNumber(index)
                                            .value
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.transparent)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return const LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black
                                      ],
                                      stops: [0.0, 0.2],
                                    ).createShader(bounds);
                                  },
                                  blendMode: BlendMode.dstIn,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              SizedBox(
                                                  height: 40,
                                                  width: 40,
                                                  child: SvgPicture.asset(
                                                    'assets/svg/sora_num.svg',
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .primary,
                                                            BlendMode.srcIn),
                                                  )),
                                              Transform.translate(
                                                offset: const Offset(0, 1),
                                                child: Text(
                                                  '${(index + 1).toString().convertNumbers()}',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .hintColor,
                                                      fontFamily: "kufi",
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      height: 2),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 8,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${juz.text}',
                                              style: TextStyle(
                                                color:
                                                    Theme.of(context).hintColor,
                                                fontFamily: "uthmanic2",
                                                fontSize: 20,
                                                height: 2,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow
                                                  .clip, // Change overflow to clip
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Text(
                                                '${quranCtrl.getCurrentSurahByPage(juz.page).arabicName} ${quranCtrl.getCurrentSurahByPage(juz.page).surahNumber.toString().convertNumbers()} - ${'page'.tr} ${juz.page.toString().convertNumbers()}',
                                                style: TextStyle(
                                                  fontFamily: "naskh",
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ));
                      },
                    ),
                    onTap: () {
                      quranCtrl.clearAndAddSelection(juz.ayahUQNumber);
                      quranCtrl.changeSurahListOnTap(juz.page);
                    },
                  ),
                  context.hDivider(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: .2)),
                ],
              );
            }),
      ),
    );
  }
}
