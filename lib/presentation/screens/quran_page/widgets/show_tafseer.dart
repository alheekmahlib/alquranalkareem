import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/ayat_controller.dart';
import '../../../controllers/general_controller.dart';
import '../../../controllers/translate_controller.dart';
import '../../quran_text/widgets/tafsir_wedget/share_copy_wedget.dart';
import '../data/model/aya.dart';
import '/core/utils/constants/extensions.dart';
import '/core/utils/constants/extensions/text_span_extension.dart';
import '/core/utils/constants/svg_picture.dart';
import 'change_tafsir.dart';

class ShowTafseer extends StatelessWidget {
  ShowTafseer({Key? key}) : super(key: key);

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final ayatCtrl = sl<AyatController>();
    // sl<TranslateDataController>().fetchTranslate(context);
    return Container(
      height: size.height * .9,
      width: size.width,
      decoration: BoxDecoration(
          color: Get.theme.colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          )),
      child: SafeArea(
        child: Obx(() {
          ayatCtrl.getNewTranslationAndNotify(
              ayatCtrl.surahNumber.value, ayatCtrl.numberOfAyahText.value);
          final ayat = ayatCtrl.ayatList;
          if (ayat != null && ayat.length > ayatCtrl.numberOfAyahText.value) {
            Aya aya = ayat[ayatCtrl.numberOfAyahText.value];
            print('numberOfAyahText${aya.ayaNum}');
          }
          return Padding(
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
                        tafseer_icon(height: 30.0),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const ChangeTafsir(),
                        context.vDivider(height: 20.0),
                        context.fontSizeDropDown(height: 40.0),
                      ],
                    ),
                  ],
                ),
                Flexible(
                  flex: 4,
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                        color: Get.theme.colorScheme.surface.withOpacity(.1),
                        border: Border.symmetric(
                            horizontal: BorderSide(
                          width: 2,
                          color: Get.theme.colorScheme.primary,
                        ))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Scrollbar(
                        controller: _scrollController,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Obx(() {
                            if (ayat != null &&
                                ayat.length >
                                    ayatCtrl.numberOfAyahText.value) {}
                            if (ayatCtrl.currentText.value != null) {
                              allText =
                                  ayatCtrl.currentText.value!.translateAyah +
                                      ayatCtrl.currentText.value!.translate;
                              allTitle =
                                  ayatCtrl.currentText.value!.translateAyah;
                            }
                            if (ayatCtrl.currentPageLoading.value) {
                              return const CircularProgressIndicator();
                            } else if (ayatCtrl.currentText.value != null) {
                              allText =
                                  '﴿${ayatCtrl.currentText.value!.translateAyah}﴾\n\n' +
                                      ayatCtrl.currentText.value!.translate;
                              allTitle =
                                  '﴿${ayatCtrl.currentText.value!.translateAyah}﴾';
                              return Obx(() {
                                return SelectableText.rich(
                                  TextSpan(
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text:
                                            '﴿${ayatCtrl.ayahTextNormal.value}﴾\n',
                                        style: TextStyle(
                                          fontFamily: 'uthmanic2',
                                          fontSize: 24,
                                          height: 1.9,
                                          color: Get
                                              .theme.colorScheme.inversePrimary,
                                        ),
                                      ),
                                      const WidgetSpan(
                                        child: ShareCopyWidget(),
                                      ),
                                      ayatCtrl.isTafseer.value
                                          ? TextSpan(
                                              children: ayatCtrl
                                                  .currentText.value!.translate
                                                  .buildTextSpans(),
                                              style: TextStyle(
                                                  color: Get.theme.colorScheme
                                                      .inversePrimary,
                                                  height: 1.5,
                                                  fontSize:
                                                      sl<GeneralController>()
                                                          .fontSizeArabic
                                                          .value),
                                            )
                                          : TextSpan(
                                              text:
                                                  sl<TranslateDataController>()
                                                          .data[ayatCtrl
                                                              .ayahUQNumber
                                                              .value -
                                                          1]['text'] ??
                                                      '',
                                              style: TextStyle(
                                                  color: Get.theme.colorScheme
                                                      .inversePrimary,
                                                  height: 1.5,
                                                  fontSize:
                                                      sl<GeneralController>()
                                                          .fontSizeArabic
                                                          .value),
                                            ),
                                      WidgetSpan(
                                        child: Center(
                                          child: SizedBox(
                                            height: 50,
                                            child: SizedBox(
                                                width: MediaQuery.of(context)
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
                                  showCursor: true,
                                  cursorWidth: 3,
                                  cursorColor: Get.theme.dividerColor,
                                  cursorRadius: const Radius.circular(5),
                                  scrollPhysics: const ClampingScrollPhysics(),
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.justify,
                                  contextMenuBuilder: buildMyContextMenu(),
                                  onSelectionChanged: handleSelectionChanged,
                                );
                              });
                            } else {
                              return Text(
                                  'Error: ${ayatCtrl.currentPageError.value}');
                            }
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
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

    // setState(() {
    selectedTextED = selectedText;
    // });
    print(selectedText);
  }
}
