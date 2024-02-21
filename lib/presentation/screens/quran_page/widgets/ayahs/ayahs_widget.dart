import 'package:alquranalkareem/presentation/controllers/audio_controller.dart';
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

  @override
  Widget build(BuildContext context) {
    // quranCtrl.listenToScrollPositions();
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.symmetric(vertical: 64.0),
      child: GestureDetector(
        onTap: () {
          audioCtrl.clearSelection();
        },
        child: GetBuilder<QuranController>(builder: (quranCtrl) {
          return quranCtrl.pages.isEmpty
              ? const CircularProgressIndicator.adaptive()
              : ScrollablePositionedList.builder(
                  shrinkWrap: true,
                  itemScrollController: quranCtrl.itemScrollController,
                  itemPositionsListener: quranCtrl.itemPositionsListener,
                  itemCount: quranCtrl.pages.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, pageIndex) => Container(
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
                  ),
                );
        }),
      ),
    );
  }
}
