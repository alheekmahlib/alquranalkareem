import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/font_size_extension.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '/core/utils/constants/extensions/text_span_extension.dart';
import '/presentation/screens/quran_page/controllers/extensions/quran_getters.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/extensions/extensions.dart';
import '../../../../core/utils/constants/lists.dart';
import '../../../../core/utils/constants/svg_constants.dart';
import '../../../controllers/general/general_controller.dart';
import '../controllers/quran/quran_controller.dart';
import '../controllers/tafsir_controller.dart';
import '../controllers/tafsir_ctrl.dart';
import '../controllers/translate_controller.dart';
import '../data/data_source/tafsir_database.dart';
import 'ayahs/share_copy_widget.dart';
import 'change_tafsir.dart';

class ShowTafseer extends StatelessWidget {
  late final int ayahUQNumber;
  late final int index;

  ShowTafseer({Key? key, required this.ayahUQNumber, required this.index})
      : super(key: key);

  final ScrollController _scrollController = ScrollController();
  final quranCtrl = QuranController.instance;
  final generalCtrl = GeneralController.instance;
  final ayatCtrl = TafsirController.instance;
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
                      customSvg(
                        SvgPath.svgTafseer,
                        height: 30,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const ChangeTafsir(),
                      context.vDivider(height: 20.0),
                      Transform.translate(
                          offset: const Offset(0, 5),
                          child: fontSizeDropDown(height: 25.0)),
                    ],
                  ),
                ],
              ),
              Flexible(
                flex: 4,
                child: GetBuilder<TafsirCtrl>(
                    id: 'change_tafsir',
                    builder: (tafsirCtrl) {
                      if (tafsirCtrl.tafseerList.isEmpty &&
                          sl<TranslateDataController>().data.isEmpty) {
                        return const Center(child: Text('No Tafsir available'));
                      }
                      return PageView.builder(
                          controller: PageController(
                              initialPage:
                                  (selectedAyahIndexInFullPage).toInt()),
                          itemCount: pageAyahs.length,
                          itemBuilder: (context, index) {
                            final ayahs = pageAyahs[index];
                            int ayahIndex =
                                pageAyahs.first.ayahUQNumber + index;
                            final tafsir = tafsirCtrl.tafseerList.firstWhere(
                              (element) => element.id == ayahIndex,
                              orElse: () => const TafsirTableData(
                                  id: 0,
                                  tafsirText: '',
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
                                      .withOpacity(.1),
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                    width: 2,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Scrollbar(
                                  controller: _scrollController,
                                  child: SingleChildScrollView(
                                    controller: _scrollController,
                                    child: Obx(() => Text.rich(
                                          TextSpan(
                                            children: <InlineSpan>[
                                              TextSpan(
                                                text: '﴿${ayahs.text}﴾\n',
                                                style: TextStyle(
                                                  fontFamily: 'uthmanic2',
                                                  fontSize: 24,
                                                  height: 1.9,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .inversePrimary,
                                                ),
                                              ),
                                              WidgetSpan(
                                                child: ShareCopyWidget(
                                                  ayahNumber: ayahs.ayahNumber,
                                                  ayahText: ayahs.text,
                                                  ayahTextNormal:
                                                      ayahs.aya_text_emlaey,
                                                  ayahUQNumber: ayahIndex,
                                                  surahName: quranCtrl
                                                      .getSurahDataByAyahUQ(
                                                          ayahIndex)
                                                      .arabicName,
                                                  surahNumber: quranCtrl
                                                      .getSurahDataByAyahUQ(
                                                          ayahIndex)
                                                      .surahNumber,
                                                  tafsirName: tafsirName[
                                                      tafsirCtrl.radioValue
                                                          .value]['name'],
                                                  tafsir: ayatCtrl
                                                          .isTafseer.value
                                                      ? ayatCtrl.selectedTafsir!
                                                          .tafsirText
                                                      : sl<TranslateDataController>()
                                                              .data[ayatCtrl
                                                                  .ayahUQNumber
                                                                  .value -
                                                              1]['text'] ??
                                                          '',
                                                ),
                                              ),
                                              tafsirCtrl.isTafsir.value
                                                  ? TextSpan(
                                                      children: tafsir
                                                          .tafsirText
                                                          .buildTextSpans(),
                                                      style: TextStyle(
                                                          color: Get
                                                              .theme
                                                              .colorScheme
                                                              .inversePrimary,
                                                          height: 1.5,
                                                          fontSize: generalCtrl
                                                              .state
                                                              .fontSizeArabic
                                                              .value),
                                                    )
                                                  : TextSpan(
                                                      text: sl<TranslateDataController>()
                                                              .data[ayatCtrl
                                                                  .ayahUQNumber
                                                                  .value -
                                                              1]['text'] ??
                                                          '',
                                                      style: TextStyle(
                                                          color: Get
                                                              .theme
                                                              .colorScheme
                                                              .inversePrimary,
                                                          height: 1.5,
                                                          fontSize: generalCtrl
                                                              .state
                                                              .fontSizeArabic
                                                              .value),
                                                    ),
                                              WidgetSpan(
                                                child: Center(
                                                  child: SizedBox(
                                                    height: 50,
                                                    child: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            1 /
                                                            2,
                                                        child: SvgPicture.asset(
                                                          'assets/svg/space_line.svg',
                                                        )),
                                                  ),
                                                ),
                                              )
                                              // TextSpan(text: 'world', style: TextStyle(fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                          // showCursor: true,
                                          // cursorWidth: 3,
                                          // cursorColor: Theme.of(context).dividerColor,
                                          // cursorRadius: const Radius.circular(5),
                                          // scrollPhysics:
                                          //     const ClampingScrollPhysics(),
                                          textDirection: TextDirection.rtl,
                                          textAlign: TextAlign.justify,
                                          // contextMenuBuilder:
                                          //     buildMyContextMenu(),
                                          // onSelectionChanged:
                                          //     handleSelectionChanged,
                                        )),
                                  ),
                                ),
                              ),
                            );
                          });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String allText = '';
String allTitle = '';
String? selectedTextED;

void handleSelectionChanged(
    TextSelection selection, SelectionChangedCause? cause) {
  if (cause == SelectionChangedCause.longPress) {
    final characters = allText.characters;
    final start = characters.take(selection.start).length;
    final end = characters.take(selection.end).length;
    final selectedText = allText.substring(start - 5, end - 5);

    selectedTextED = selectedText;
    print(selectedText);
  }
}
