part of '../../quran.dart';

class PlayListAyatWidget extends StatelessWidget {
  final bool? startNum;
  final bool? endNum;
  PlayListAyatWidget({super.key, this.startNum = false, this.endNum = false});
  final playList = PlayListController.instance;
  final quranCtrl = QuranController.instance;
  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    playList.ayahPosition(startNum!);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: 500,
        width: 190,
        child: ListView.builder(
            controller: playList.scrollController,
            itemCount: quranCtrl.currentPageAyahs.length,
            itemBuilder: (context, index) {
              final ayah = quranCtrl.currentPageAyahs[index];
              return InkWell(
                child: SizedBox(
                  height: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'آية | ${generalCtrl.state.arabicNumber.convert(ayah.ayahNumber)}',
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 18,
                          fontFamily: 'naskh',
                        ),
                      ),
                      Text(
                        ayah.text.toString(),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.surface,
                            fontSize: 18,
                            fontFamily: 'uthmanic2',
                            overflow: TextOverflow.fade),
                        maxLines: 1,
                      ),
                      const Divider(
                        endIndent: 16,
                        indent: 16,
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  if (startNum == true) {
                    playList.startUQNum.value = ayah.ayahUQNumber;
                    playList.startNum.value = ayah.ayahNumber;
                    log("startUQNum: ${playList.startUQNum.value}");
                  } else {
                    playList.endUQNum.value = ayah.ayahUQNumber;
                    playList.endNum.value = ayah.ayahNumber;
                    log("endUQNum: ${playList.endUQNum.value}");
                  }
                  Get.back();
                },
              );
            }),
      ),
    );
  }
}
