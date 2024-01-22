import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/general_controller.dart';
import '../../../controllers/translate_controller.dart';
import '../../quran_page/widgets/sliding_up.dart';
import '../data/models/QuranModel.dart';
import '../widgets/audio_text_widget.dart';
import '../widgets/scrollable_list.dart';
import '../widgets/show_text_tafseer.dart';
import '../widgets/widgets.dart';
import '/core/utils/constants/extensions.dart';
import '/presentation/controllers/quranText_controller.dart';

int? lastAyahInPageA;
int pageN = 1;
int? textSurahNum;

// ignore: must_be_immutable
class TextPageView extends StatelessWidget {
  final SurahText? surah;
  int? nomPageF, nomPageL, pageNum = 1;

  TextPageView({
    super.key,
    // Key? key,
    this.nomPageF,
    this.nomPageL,
    this.pageNum,
    this.surah,
  });
  static int textCurrentPage = 0;
  static String lastTime = '';
  static String sorahTextName = '';

  ArabicNumbers arabicNumber = ArabicNumbers();
  String? translateText;
  Color? backColor;

  @override
  Widget build(BuildContext context) {
    sl<QuranTextController>().loadSwitchValue();
    sl<TranslateDataController>().fetchTranslate(context);
    sl<TranslateDataController>().loadTranslateValue();
    backColor = const Color(0xff91a57d).withOpacity(0.4);

    WidgetsBinding.instance.addPostFrameCallback(
        (_) => sl<QuranTextController>().jumbToPage(pageNum));
    return GetBuilder<QuranTextController>(builder: (textController) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Get.theme.colorScheme.background,
            appBar: AppBar(
              backgroundColor: Get.theme.colorScheme.background,
              title: sorahName(
                sl<QuranTextController>().currentSurahIndex.toString(),
                context,
                Get.isDarkMode ? Colors.white : Colors.black,
              ),
              centerTitle: true,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    sl<GeneralController>().textWidgetPosition.value = -240.0;
                    textController.selected.value = false;
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    size: 28,
                    color: Get.theme.colorScheme.surface,
                  )),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    children: [
                      fontSizeDropDown(context),
                      SizedBox(
                        width: 70,
                        child: animatedToggleSwitch(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height,
                    child: Padding(
                      padding: context.customOrientation(
                          const EdgeInsets.only(bottom: 16.0),
                          const EdgeInsets.only(
                              bottom: 16.0, right: 40.0, left: 40.0)),
                      child: ScrollableList(
                        surah: surah!,
                        nomPageF: nomPageF!,
                        nomPageL: nomPageL!,
                      ),
                    ),
                  ),
                  Obx(() => AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      bottom: sl<GeneralController>().textWidgetPosition.value,
                      left: 0,
                      right: 0,
                      child: const AudioTextWidget())),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: TextSliding(
                        myWidget1: ShowTextTafseer(),
                        cHeight: 110.0,
                      )),
                ],
              ),
            )),
      );
    });
  }
}

String textText = '';
String textTitle = '';
String? selectedTextT;

void handleSelectionChangedText(
    TextSelection selection, SelectionChangedCause? cause) {
  if (cause == SelectionChangedCause.longPress) {
    final characters = textText.characters;
    final start = characters.take(selection.start).length;
    final end = characters.take(selection.end).length;
    final selectedText = textText.substring(start - 1, end - 1);

    // setState(() {
    selectedTextT = selectedText;
    // });
    print(selectedText);
  }
}
