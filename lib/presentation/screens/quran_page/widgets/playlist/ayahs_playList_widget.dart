import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/constants/extensions/extensions.dart';
import '../../controllers/playList_controller.dart';
import '../audio/change_reader.dart';
import 'ayahs_choice_widget.dart';
import 'playList_build.dart';
import 'playList_play_widget.dart';
import 'playList_save_widget.dart';

List<GlobalKey> playListTextFieldKeys = [];

class AyahsPlayListWidget extends StatelessWidget {
  AyahsPlayListWidget({super.key});
  final playList = PlayListController.instance;

  @override
  Widget build(BuildContext context) {
    playList.loadSavedPlayList();
    final size = MediaQuery.sizeOf(context);
    return SingleChildScrollView(
      child: Container(
        height: size.height * .94,
        width: context.customOrientation(size.width, size.width * .5),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            )),
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  context.customClose(close: () {
                    playList.isSelect.value = false;
                    Get.back();
                  }),
                  Text(
                    'createPlayList'.tr,
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontSize: 16,
                      fontFamily: 'kufi',
                    ),
                  ),
                ],
              ),
              const Gap(32),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                      width: 1,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(.15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ChangeReader(),
                    const Gap(16),
                    AyahsChoiceWidget(),
                    const Gap(16),
                    const PlayListSaveWidget(),
                  ],
                ),
              ),
              const Gap(16),
              PlayListBuild(),
              Obx(() => playList.isSelect.value
                  ? const PlayListPlayWidget()
                  : const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}
