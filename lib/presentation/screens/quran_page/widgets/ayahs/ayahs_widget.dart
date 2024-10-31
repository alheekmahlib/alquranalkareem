import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/core/utils/constants/extensions/extensions.dart';
import '/core/utils/constants/extensions/font_size_extension.dart';
import '../../../../controllers/general/general_controller.dart';
import '../../controllers/audio/audio_controller.dart';
import '../../controllers/extensions/audio/audio_ui.dart';
import '../../controllers/extensions/quran/quran_getters.dart';
import '../../controllers/quran/quran_controller.dart';
import 'ayah_build.dart';

class AyahsWidget extends StatelessWidget {
  AyahsWidget({
    super.key,
  });

  final quranCtrl = QuranController.instance;
  final audioCtrl = AudioController.instance;
  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Column(
        children: [
          const Gap(4),
          Container(
            height: 45,
            alignment: Alignment.center,
            color: Theme.of(context).colorScheme.primaryContainer,
            margin: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 2.0),
                  decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.surface.withOpacity(.1),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0))),
                  child: Row(
                    children: [
                      Obx(() => Text(
                            quranCtrl
                                .getCurrentSurahByPage(
                                    quranCtrl.state.currentListPage.value)
                                .arabicName,
                            style: TextStyle(
                                fontSize: context.customOrientation(18.0, 22.0),
                                fontFamily: 'naskh',
                                color: Theme.of(context).hintColor),
                          )),
                      Obx(
                        () => Text(
                          ' | ${'juz'.tr}: ${quranCtrl.state.pages[quranCtrl.state.currentListPage.value + 1].first.juz.toString().convertNumbers()}',
                          style: TextStyle(
                              fontSize: context.customOrientation(18.0, 22.0),
                              fontFamily: 'naskh',
                              color: Theme.of(context).hintColor),
                        ),
                      ),
                    ],
                  ),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     if (quranCtrl.state.isScrolling.value) {
                //       quranCtrl.state.isScrolling.value = false;
                //     } else {
                //       quranCtrl.scrollSlowly(context, 30.0);
                //     }
                //   },
                //   child: Text(quranCtrl.state.isScrolling.value
                //       ? 'إيقاف'
                //       : 'التمرير'),
                // ),
                fontSizeDropDown(
                    height: 25.0,
                    color:
                        Theme.of(context).colorScheme.surface.withOpacity(.7)),
              ],
            ),
          ),
          Flexible(
            child: GestureDetector(
              onTap: () => audioCtrl.clearSelection(),
              child: FutureBuilder<void>(
                  future: Future.delayed(Duration.zero),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return quranCtrl.state.pages.isEmpty
                          ? const Center(
                              child: CircularProgressIndicator.adaptive())
                          : ScrollablePositionedList.builder(
                              initialScrollIndex:
                                  quranCtrl.state.currentPageNumber.value - 1,
                              itemScrollController:
                                  quranCtrl.state.itemScrollController,
                              itemPositionsListener:
                                  quranCtrl.state.itemPositionsListener,
                              scrollOffsetController:
                                  quranCtrl.state.scrollOffsetController,
                              itemCount: quranCtrl.state.pages.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, pageIndex) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      border: Border.all(
                                        width: 1,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(.5),
                                      )),
                                  child: AyahsBuild(
                                    pageIndex: pageIndex,
                                  ),
                                );
                              },
                            );
                    } else {
                      return const Center(
                          child: CircularProgressIndicator.adaptive());
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
