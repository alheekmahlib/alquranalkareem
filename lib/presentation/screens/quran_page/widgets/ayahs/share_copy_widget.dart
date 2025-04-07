part of '../../quran.dart';

class ShareCopyWidget extends StatelessWidget {
  final int ayahNumber;
  final int ayahUQNumber;
  final int surahNumber;
  final String ayahTextNormal;
  final String ayahText;
  final String surahName;
  final String tafsirName;
  final String tafsir;
  final int pageIndex;
  const ShareCopyWidget(
      {super.key,
      required this.ayahNumber,
      required this.ayahUQNumber,
      required this.surahNumber,
      required this.ayahTextNormal,
      required this.ayahText,
      required this.surahName,
      required this.tafsir,
      required this.tafsirName,
      required this.pageIndex});

  @override
  Widget build(BuildContext context) {
    final tafsirCtrl = TafsirCtrl.instance;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        margin: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            border: Border.symmetric(
                vertical: BorderSide(
              width: 3,
              color: Theme.of(context).colorScheme.primary,
            ))),
        child: Row(
          children: [
            GestureDetector(
              child: Semantics(
                button: true,
                enabled: true,
                label: 'copy'.tr,
                child: customSvgWithCustomColor(
                  SvgPath.svgCopyIcon,
                  height: 25,
                ),
              ),
              onTap: () async => await tafsirCtrl.copyTafsirOnTap(
                  tafsirName, tafsir, ayahTextNormal),
            ),
            const Gap(16),
            ShareAyahOptions(
              ayahNumber: ayahNumber,
              ayahUQNumber: ayahUQNumber,
              surahNumber: surahNumber,
              ayahTextNormal: ayahTextNormal,
              ayahText: ayahText,
              surahName: surahName,
              pageNumber: pageIndex,
            ),
          ],
        ),
      ),
    );
  }
}
