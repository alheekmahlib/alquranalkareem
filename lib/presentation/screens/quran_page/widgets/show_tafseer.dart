// part of '../quran.dart';

// class ShowTafseer extends StatelessWidget {
//   late final int ayahUQNumber;

//   ShowTafseer({Key? key, required this.ayahUQNumber}) : super(key: key);

//   final ScrollController _scrollController = ScrollController();
//   final quranCtrl = QuranController.instance;
//   final generalCtrl = GeneralController.instance;
//   final tafsirCtrl = TafsirCtrl.instance;

//   @override
//   Widget build(BuildContext context) {
//     final pageAyahs =
//         quranCtrl.getPageAyahsByIndex(quranCtrl.state.currentPageNumber.value);
//     final selectedAyahIndexInFullPage =
//         pageAyahs.indexWhere((ayah) => ayah.ayahUQNumber == ayahUQNumber);
//     return Container(
//       height: Get.height * .9,
//       width: Get.width,
//       decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.primaryContainer,
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(8),
//             topRight: Radius.circular(8),
//           )),
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               const Gap(8),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       context.customClose(),
//                       const Gap(32),
//                       customSvgWithCustomColor(
//                         SvgPath.svgTafseer,
//                         height: 30,
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       QuranLibrary().changeTafsirPopupMenu(
//                         TafsirStyle(
//                           backgroundColor:
//                               Theme.of(context).colorScheme.primaryContainer,
//                           selectedTafsirColor:
//                               context.theme.colorScheme.surface,
//                           unSelectedTafsirColor:
//                               context.theme.colorScheme.surface,
//                           textColor: context.theme.colorScheme.inversePrimary,
//                           tafsirName: 'tafseer'.tr,
//                           translateName: 'translation'.tr,
//                           backgroundTitleColor:
//                               context.theme.colorScheme.surface,
//                           currentTafsirColor: context.theme.colorScheme.surface,
//                           selectedTafsirBorderColor:
//                               context.theme.colorScheme.surface,
//                           unSelectedTafsirBorderColor: context
//                               .theme.colorScheme.surface
//                               .withValues(alpha: .1),
//                         ),
//                         pageNumber: quranCtrl.state.currentPageNumber.value,
//                         isDark: Get.isDarkMode,
//                       ),
//                       // ChangeTafsir(
//                       //   isInPageMode: true,
//                       //   pageNumber: quranCtrl.state.currentPageNumber.value,
//                       // ),
//                       context.vDivider(height: 20.0),
//                       Transform.translate(
//                           offset: const Offset(0, 5),
//                           child: fontSizeDropDownWidget(height: 25.0)),
//                     ],
//                   ),
//                 ],
//               ),
//               _pageViewWidget(context, pageAyahs, selectedAyahIndexInFullPage,
//                   quranCtrl.state.currentPageNumber.value),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _copyShareWidget(BuildContext context, AyahModel ayahs, int ayahIndex,
//       int index, TafsirTableData tafsir, int pageIndex) {
//     return ShareCopyWidget(
//       ayahNumber: ayahs.ayahNumber,
//       ayahText: ayahs.text,
//       ayahTextNormal: ayahs.ayaTextEmlaey,
//       ayahUQNumber: ayahIndex,
//       pageIndex: pageIndex,
//       surahName: quranCtrl.getSurahDataByAyahUQ(ayahIndex).arabicName,
//       surahNumber: quranCtrl.getSurahDataByAyahUQ(ayahIndex).surahNumber,
//       tafsirName: QuranLibrary()
//           .tafsirAndTraslationsCollection[tafsirCtrl.radioValue.value]
//           .name,
//       tafsir: QuranLibrary().isTafsir
//           ? tafsir.tafsirText
//           : QuranLibrary().translationList.isEmpty
//               ? ''
//               : QuranLibrary().translationList[ayahIndex - 1].text,
//     );
//   }

//   TextSpan _textBuild(
//       BuildContext context, TafsirTableData tafsir, int ayahIndex) {
//     return QuranLibrary().isTafsir
//         ? TextSpan(
//             children: tafsir.tafsirText.buildTextSpans(),
//             style: TextStyle(
//                 color: Get.theme.colorScheme.inversePrimary,
//                 height: 1.5,
//                 fontSize: generalCtrl.state.fontSizeArabic.value),
//           )
//         : TextSpan(
//             children: _buildTranslationSpans(ayahIndex),
//             style: TextStyle(
//                 color: Get.theme.colorScheme.inversePrimary,
//                 height: 1.5,
//                 fontSize: generalCtrl.state.fontSizeArabic.value),
//           );
//   }

//   Widget _pageViewWidget(BuildContext context, List<AyahModel> pageAyahs,
//       int selectedAyahIndexInFullPage, int pageIndex) {
//     return Flexible(
//       flex: 4,
//       child: Obx(() {
//         if (QuranLibrary().tafsirList.isEmpty &&
//             QuranLibrary().translationList.isEmpty) {
//           return const Center(child: Text('No Tafsir available'));
//         }
//         return PageView.builder(
//             controller: PageController(
//                 initialPage: (selectedAyahIndexInFullPage).toInt()),
//             itemCount: pageAyahs.length,
//             itemBuilder: (context, index) {
//               final ayahs = pageAyahs[index];
//               int ayahIndex = pageAyahs.first.ayahUQNumber + index;
//               log('tafsirList: ${QuranLibrary().tafsirList.length}');
//               final tafsir = QuranLibrary().tafsirList.firstWhere(
//                     (element) => element.id == ayahIndex,
//                     orElse: () => const TafsirTableData(
//                         id: 0,
//                         tafsirText: 'حدث خطأ أثناء عرض التفسير',
//                         ayahNum: 0,
//                         pageNum: 0,
//                         surahNum: 0), // تصرف في حالة عدم وجود التفسير
//                   );
//               return Container(
//                 width: MediaQuery.sizeOf(context).width,
//                 decoration: BoxDecoration(
//                     color: Theme.of(context)
//                         .colorScheme
//                         .surface
//                         .withValues(alpha: .1),
//                     border: Border.symmetric(
//                         horizontal: BorderSide(
//                       width: 2,
//                       color: Theme.of(context).colorScheme.primary,
//                     ))),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 16.0, vertical: 16.0),
//                   child: Scrollbar(
//                     controller: _scrollController,
//                     child: SingleChildScrollView(
//                       controller: _scrollController,
//                       child: Obx(() => Column(
//                             children: [
//                               Directionality(
//                                 textDirection: TextDirection.rtl,
//                                 child: Text(
//                                   '﴿${ayahs.text}﴾',
//                                   style: TextStyle(
//                                     fontFamily: 'uthmanic2',
//                                     fontSize: 24,
//                                     height: 1.9,
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .inversePrimary,
//                                   ),
//                                   textAlign: TextAlign.justify,
//                                 ),
//                               ),
//                               _copyShareWidget(context, ayahs, ayahIndex, index,
//                                   tafsir, pageIndex),
//                               Text.rich(
//                                 TextSpan(
//                                   children: <InlineSpan>[
//                                     _textBuild(context, tafsir, ayahIndex),
//                                     // TextSpan(text: 'world', style: TextStyle(fontWeight: FontWeight.bold)),
//                                   ],
//                                 ),
//                                 // showCursor: true,
//                                 // cursorWidth: 3,
//                                 // cursorColor: Theme.of(context).dividerColor,
//                                 // cursorRadius: const Radius.circular(5),
//                                 // scrollPhysics:
//                                 //     const ClampingScrollPhysics(),
//                                 textDirection:
//                                     QuranLibrary().selectedTafsirIndex > 4
//                                         ? alignmentLayoutWPassLang(
//                                             QuranLibrary()
//                                                 .tafsirAndTraslationsCollection[
//                                                     QuranLibrary()
//                                                         .selectedTafsirIndex]
//                                                 .name,
//                                             TextDirection.rtl,
//                                             TextDirection.ltr)
//                                         : TextDirection.rtl,
//                                 textAlign: TextAlign.justify,
//                                 // contextMenuBuilder:
//                                 //     buildMyContextMenu(),
//                                 // onSelectionChanged:
//                                 //     handleSelectionChanged,
//                               ),
//                               Center(
//                                 child: SizedBox(
//                                   height: 50,
//                                   child: SizedBox(
//                                       width: MediaQuery.of(context).size.width /
//                                           1 /
//                                           2,
//                                       child: SvgPicture.asset(
//                                         'assets/svg/space_line.svg',
//                                       )),
//                                 ),
//                               ),
//                             ],
//                           )),
//                     ),
//                   ),
//                 ),
//               );
//             });
//       }),
//     );
//   }

//   // بناء spans للترجمة مع الحواشي
//   List<InlineSpan> _buildTranslationSpans(int ayahIndex) {
//     if (QuranLibrary().translationList.isEmpty ||
//         ayahIndex <= 0 ||
//         ayahIndex > QuranLibrary().translationList.length) {
//       return [const TextSpan(text: '')];
//     }

//     final translation = QuranLibrary().translationList[ayahIndex - 1];
//     final spans = <InlineSpan>[
//       // النص الأساسي بدون HTML tags
//       TextSpan(text: translation.cleanText),
//     ];

//     // إضافة الحواشي إذا وجدت
//     final footnotes = translation.orderedFootnotesWithNumbers;
//     if (footnotes.isNotEmpty) {
//       spans.add(const TextSpan(text: '\n\n'));

//       // إضافة خط فاصل
//       spans.add(WidgetSpan(
//         child: Container(
//           margin: const EdgeInsets.symmetric(vertical: 8),
//           height: 1,
//           color: Get.theme.colorScheme.inversePrimary.withValues(alpha: .5),
//         ),
//       ));
//       spans.add(const TextSpan(text: '\n'));

//       spans.add(TextSpan(
//         text: 'الحواشي:\n',
//         style: TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: generalCtrl.state.fontSizeArabic.value * 0.95,
//           color: Get.theme.colorScheme.inversePrimary.withValues(alpha: .7),
//         ),
//       ));

//       for (final footnoteEntry in footnotes) {
//         final number = footnoteEntry.key;
//         final footnoteData = footnoteEntry.value;

//         spans.add(TextSpan(
//           children: [
//             TextSpan(
//               text: '($number) ',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: generalCtrl.state.fontSizeArabic.value * 0.9,
//                 color:
//                     Get.theme.colorScheme.inversePrimary.withValues(alpha: .7),
//               ),
//             ),
//             TextSpan(
//               text: '${footnoteData.value}\n\n',
//               style: TextStyle(
//                 fontSize: generalCtrl.state.fontSizeArabic.value * 0.85,
//                 color:
//                     Get.theme.colorScheme.inversePrimary.withValues(alpha: .6),
//                 height: 1.4,
//               ),
//             ),
//           ],
//         ));
//       }
//     }

//     return spans;
//   }
// }
