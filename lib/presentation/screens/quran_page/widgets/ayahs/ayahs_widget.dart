import 'package:alquranalkareem/core/utils/constants/extensions/extensions.dart';
import 'package:alquranalkareem/presentation/controllers/audio_controller.dart';
import 'package:alquranalkareem/presentation/controllers/general_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../controllers/quran_controller.dart';
import 'ayah_build.dart';

class AyahsWidget extends StatelessWidget {
  AyahsWidget({
    super.key,
  });

  final quranCtrl = sl<QuranController>();
  final audioCtrl = sl<AudioController>();
  final generalCtrl = sl<GeneralController>();

  @override
  Widget build(BuildContext context) {
    // quranCtrl.listenToScrollPositions();
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          Container(
            height: 40,
            color: Theme.of(context).colorScheme.background,
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
                  child: Obx(() => Text(
                        quranCtrl.getSurahNameFromPage(
                            quranCtrl.currentListPage.value),
                        style: TextStyle(
                            fontSize: context.customOrientation(18.0, 22.0),
                            fontFamily: 'naskh',
                            color: Theme.of(context).hintColor),
                      )),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 2.0),
                  decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.surface.withOpacity(.1),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0))),
                  child: Obx(
                    () => Text(
                      '${'juz'.tr}: ${generalCtrl.convertNumbers(quranCtrl.pages[quranCtrl.currentListPage.value].first.juz.toString())}',
                      style: TextStyle(
                          fontSize: context.customOrientation(18.0, 22.0),
                          fontFamily: 'naskh',
                          color: Theme.of(context).hintColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: GestureDetector(
              onTap: () {
                audioCtrl.clearSelection();
              },
              child: GetBuilder<QuranController>(builder: (quranCtrl) {
                return quranCtrl.pages.isEmpty
                    ? const CircularProgressIndicator.adaptive()
                    : ScrollablePositionedList.builder(
                        shrinkWrap: false,
                        initialScrollIndex:
                            generalCtrl.currentPageNumber.value - 1,
                        itemScrollController: quranCtrl.itemScrollController,
                        itemPositionsListener: quranCtrl.itemPositionsListener,
                        scrollOffsetController:
                            quranCtrl.scrollOffsetController,
                        itemCount: quranCtrl.pages.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, pageIndex) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 4.0),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
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
              }),
            ),
          ),
        ],
      ),
    );
  }
}
