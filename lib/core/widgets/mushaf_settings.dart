import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '/core/utils/constants/lists.dart';
import '/presentation/screens/quran_page/controllers/extensions/quran_ui.dart';
import '../../presentation/controllers/general_controller.dart';
import '../../presentation/screens/quran_page/controllers/quran/quran_controller.dart';
import '../utils/constants/shared_preferences_constants.dart';

class MushafSettings extends StatelessWidget {
  const MushafSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final quranCtrl = QuranController.instance;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'choseQuran'.tr,
            style: TextStyle(
                color: Theme.of(context).hintColor,
                fontFamily: 'kufi',
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
          const Gap(4),
          Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.surface, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: Column(
              children: [
                const Gap(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                      mushafSettingsList.length,
                      (index) => Obx(() {
                            return AnimatedOpacity(
                              opacity: quranCtrl.state.isPages.value == index
                                  ? 1
                                  : .5,
                              duration: const Duration(milliseconds: 300),
                              child: GestureDetector(
                                onTap: () {
                                  quranCtrl.switchMode(index);
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4.0)),
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            width: 1),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      child: Image.asset(
                                        mushafSettingsList[index]['imageUrl'],
                                        width: 50,
                                      ),
                                    ),
                                    const Gap(6),
                                    Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20.0)),
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            width: 2),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      child:
                                          quranCtrl.state.isPages.value == index
                                              ? const Icon(Icons.done,
                                                  size: 14, color: Colors.white)
                                              : null,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })),
                ),
                const Gap(8),
                GetX<GeneralController>(
                  builder: (generalCtrl) => _page(context, generalCtrl),
                ),
                const Gap(8),
                context.hDivider(width: MediaQuery.sizeOf(context).width),
                const Gap(8),
                Column(
                  children: List.generate(
                      2,
                      (index) => Obx(() => GestureDetector(
                            onTap: () {
                              quranCtrl.state.isBold.value = index;
                              GetStorage().write(IS_BOLD, index);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20.0)),
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        width: 2),
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  child: quranCtrl.state.isBold.value == index
                                      ? const Icon(Icons.done,
                                          size: 14, color: Colors.white)
                                      : null,
                                ),
                                const Gap(6),
                                Text(
                                  'ٱللَّهُ لَآ إِلَٰهَ إِلَّا هُوَ ٱلۡحَيُّ ٱلۡقَيُّومُ',
                                  style: TextStyle(
                                    fontFamily: 'uthmanic2',
                                    fontSize: 18,
                                    height: 1.9,
                                    fontWeight: index == 0
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                                ),
                              ],
                            ),
                          ))),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _page(BuildContext context, GeneralController generalCtrl) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AnimatedOpacity(
          opacity: generalCtrl.isPageMode.value ? 1 : .5,
          duration: const Duration(milliseconds: 300),
          child: GestureDetector(
            onTap: () => generalCtrl.pageModeOnTap(true),
            child: Column(
              children: [
                Container(
                  height: 100,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.surface, width: 1),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Container(
                      margin: context.customOrientation(
                          const EdgeInsets.only(right: 4.0),
                          const EdgeInsets.only(right: 4.0)),
                      decoration: BoxDecoration(
                          color: Get.isDarkMode
                              ? Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(.5)
                              : Theme.of(context).dividerColor.withOpacity(.5),
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12))),
                      child: Container(
                        margin: const EdgeInsets.only(right: 4.0),
                        decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? Theme.of(context)
                                    .primaryColorDark
                                    .withOpacity(.7)
                                : Theme.of(context)
                                    .dividerColor
                                    .withOpacity(.7),
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(12),
                                bottomRight: Radius.circular(12))),
                        child: Container(
                          margin: const EdgeInsets.only(right: 4.0),
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  bottomRight: Radius.circular(12))),
                        ),
                      )),
                ),
                const Gap(6),
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.surface, width: 2),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: generalCtrl.isPageMode.value
                      ? const Icon(Icons.done, size: 14, color: Colors.white)
                      : null,
                ),
              ],
            ),
          ),
        ),
        AnimatedOpacity(
          opacity: !generalCtrl.isPageMode.value ? 1 : .5,
          duration: const Duration(milliseconds: 300),
          child: GestureDetector(
            onTap: () => generalCtrl.pageModeOnTap(false),
            child: Column(
              children: [
                Container(
                  height: 100,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.surface, width: 1),
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
                const Gap(6),
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.surface, width: 2),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: !generalCtrl.isPageMode.value
                      ? const Icon(Icons.done, size: 14, color: Colors.white)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
