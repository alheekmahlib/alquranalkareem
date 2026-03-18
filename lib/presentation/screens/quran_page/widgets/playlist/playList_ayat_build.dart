part of '../../quran.dart';

class PlayListAyatBuild extends StatelessWidget {
  final bool isStartAyah;
  final bool isFromSurah;
  PlayListAyatBuild({
    super.key,
    this.isStartAyah = true,
    this.isFromSurah = true,
  });
  final playList = PlayListController.instance;
  final quranCtrl = QuranController.instance;
  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    playList.ayahPosition(isStartAyah);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: 500,
        width: 190,
        child: Obx(() {
          final ayahs = isFromSurah
              ? playList.fromSurahAyahs
              : playList.toSurahAyahs;
          return ListView.builder(
            controller: playList.scrollController,
            itemCount: ayahs.length,
            itemBuilder: (context, index) {
              final ayah = ayahs[index];
              return InkWell(
                child: SizedBox(
                  height: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${'ayah'.tr} | ${ayah.ayahNumber.toString().convertNumbersToCurrentLang()}',
                        style: AppTextStyles.titleSmall(),
                      ),
                      Text(
                        ayah.text.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontSize: 18,
                          fontFamily: 'uthmanic2',
                          overflow: TextOverflow.fade,
                        ),
                        maxLines: 1,
                      ),
                      const Divider(endIndent: 16, indent: 16),
                    ],
                  ),
                ),
                onTap: () {
                  if (isStartAyah) {
                    playList.setStartAyah(ayah.ayahNumber, ayah.ayahUQNumber);
                  } else {
                    playList.setEndAyah(ayah.ayahNumber, ayah.ayahUQNumber);
                  }
                  Get.back();
                },
              );
            },
          );
        }),
      ),
    );
  }
}
