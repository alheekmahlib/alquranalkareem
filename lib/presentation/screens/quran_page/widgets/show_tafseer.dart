part of '../quran.dart';

class ShowTafseer extends StatelessWidget {
  late final int ayahUQNumber;

  ShowTafseer({Key? key, required this.ayahUQNumber}) : super(key: key);

  final ScrollController _scrollController = ScrollController();
  final quranCtrl = QuranController.instance;
  final generalCtrl = GeneralController.instance;
  final tafsirCtrl = TafsirCtrl.instance;

  @override
  Widget build(BuildContext context) {
    final pageAyahs =
        quranCtrl.getPageAyahsByIndex(quranCtrl.state.currentPageNumber.value);
    final selectedAyahIndexInFullPage =
        pageAyahs.indexWhere((ayah) => ayah.ayahUQNumber == ayahUQNumber);
    return Container(
      height: Get.height * .9,
      width: Get.width,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          )),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Gap(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      context.customClose(),
                      const Gap(32),
                      customSvgWithCustomColor(
                        SvgPath.svgTafseer,
                        height: 30,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      QuranLibrary().changeTafsirPopupMenu(
                        pageNumber: quranCtrl.state.currentPageNumber.value + 1,
                        TafsirStyle(
                            linesColor: Get.theme.colorScheme.primary,
                            selectedTafsirColor: Get.theme.colorScheme.surface,
                            unSelectedTafsirColor:
                                Get.theme.colorScheme.inversePrimary,
                            translateName: 'translation'.tr),
                      ),
                      context.vDivider(height: 20.0),
                      Transform.translate(
                          offset: const Offset(0, 5),
                          child: fontSizeDropDownWidget(height: 25.0)),
                    ],
                  ),
                ],
              ),
              _pageViewWidget(context, pageAyahs, selectedAyahIndexInFullPage,
                  quranCtrl.state.currentPageNumber.value),
            ],
          ),
        ),
      ),
    );
  }

  Widget _copyShareWidget(BuildContext context, AyahFontsModel ayahs,
      int ayahIndex, int index, TafsirTableData tafsir, int pageIndex) {
    return ShareCopyWidget(
      ayahNumber: ayahs.ayahNumber,
      ayahText: ayahs.text,
      ayahTextNormal: ayahs.ayaTextEmlaey,
      ayahUQNumber: ayahIndex,
      pageIndex: pageIndex,
      surahName: quranCtrl.getSurahDataByAyahUQ(ayahIndex).arabicName,
      surahNumber: quranCtrl.getSurahDataByAyahUQ(ayahIndex).surahNumber,
      tafsirName: quranCtrl.state.qPackage
          .tafsirAndTraslationCollection[tafsirCtrl.radioValue.value].name,
      tafsir: QuranLibrary().isTafsir
          ? tafsir.tafsirText
          : QuranLibrary().translationList.isEmpty
              ? ''
              : QuranLibrary().translationList[ayahIndex - 1].text,
    );
  }

  TextSpan _textBuild(
      BuildContext context, TafsirTableData tafsir, int ayahIndex) {
    return QuranLibrary().isTafsir
        ? TextSpan(
            children: tafsir.tafsirText.buildTextSpans(),
            style: TextStyle(
                color: Get.theme.colorScheme.inversePrimary,
                height: 1.5,
                fontSize: generalCtrl.state.fontSizeArabic.value),
          )
        : TextSpan(
            text: QuranLibrary().translationList.isEmpty
                ? ''
                : QuranLibrary().translationList[ayahIndex - 1].text,
            style: TextStyle(
                color: Get.theme.colorScheme.inversePrimary,
                height: 1.5,
                fontSize: generalCtrl.state.fontSizeArabic.value),
          );
  }

  Widget _pageViewWidget(BuildContext context, List<AyahFontsModel> pageAyahs,
      int selectedAyahIndexInFullPage, int pageIndex) {
    return Flexible(
      flex: 4,
      child: Obx(() {
        if (QuranLibrary().tafsirList.isEmpty &&
            QuranLibrary().translationList.isEmpty) {
          return const Center(child: Text('No Tafsir available'));
        }
        return PageView.builder(
            controller: PageController(
                initialPage: (selectedAyahIndexInFullPage).toInt()),
            itemCount: pageAyahs.length,
            itemBuilder: (context, index) {
              final ayahs = pageAyahs[index];
              int ayahIndex = pageAyahs.first.ayahUQNumber + index;
              log('tafsirList: ${QuranLibrary().tafsirList.length}');
              final tafsir = QuranLibrary().tafsirList.firstWhere(
                    (element) => element.id == ayahIndex,
                    orElse: () => const TafsirTableData(
                        id: 0,
                        tafsirText: 'حدث خطأ أثناء عرض التفسير',
                        ayahNum: 0,
                        pageNum: 0,
                        surahNum: 0), // تصرف في حالة عدم وجود التفسير
                  );
              return Container(
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surface
                        .withValues(alpha: .1),
                    border: Border.symmetric(
                        horizontal: BorderSide(
                      width: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  child: Scrollbar(
                    controller: _scrollController,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Obx(() => Column(
                            children: [
                              Text(
                                '﴿${ayahs.text}﴾',
                                style: TextStyle(
                                  fontFamily: 'uthmanic2',
                                  fontSize: 24,
                                  height: 1.9,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                              _copyShareWidget(context, ayahs, ayahIndex, index,
                                  tafsir, pageIndex),
                              Text.rich(
                                TextSpan(
                                  children: <InlineSpan>[
                                    _textBuild(context, tafsir, ayahIndex),
                                    // TextSpan(text: 'world', style: TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                // showCursor: true,
                                // cursorWidth: 3,
                                // cursorColor: Theme.of(context).dividerColor,
                                // cursorRadius: const Radius.circular(5),
                                // scrollPhysics:
                                //     const ClampingScrollPhysics(),
                                textDirection: QuranLibrary().tafsirSelected > 4
                                    ? alignmentLayoutWPassLang(
                                        QuranLibrary()
                                            .tafsirAndTraslationCollection[
                                                QuranLibrary().tafsirSelected]
                                            .name,
                                        TextDirection.rtl,
                                        TextDirection.ltr)
                                    : TextDirection.rtl,
                                textAlign: TextAlign.justify,
                                // contextMenuBuilder:
                                //     buildMyContextMenu(),
                                // onSelectionChanged:
                                //     handleSelectionChanged,
                              ),
                              Center(
                                child: SizedBox(
                                  height: 50,
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1 /
                                          2,
                                      child: SvgPicture.asset(
                                        'assets/svg/space_line.svg',
                                      )),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
              );
            });
      }),
    );
  }
}
