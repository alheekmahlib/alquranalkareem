import 'package:alquranalkareem/core/utils/constants/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/services_locator.dart';
import '../utils/constants/shared_preferences_constants.dart';
import '/core/utils/constants/lists.dart';
import '/presentation/controllers/quran_controller.dart';

class MushafSettings extends StatelessWidget {
  const MushafSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final quranCtrl = sl<QuranController>();
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
                              opacity:
                                  quranCtrl.isPages.value == index ? 1 : .5,
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
                                      child: quranCtrl.isPages.value == index
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
                context.hDivider(width: MediaQuery.sizeOf(context).width),
                const Gap(8),
                // Text(
                //   'نوع الخط',
                //   style: TextStyle(
                //     fontFamily: 'naskh',
                //     fontSize: 20,
                //     height: 1.9,
                //     fontWeight: FontWeight.bold,
                //     color: Theme.of(context).colorScheme.inversePrimary,
                //   ),
                // ),
                Column(
                  children: List.generate(
                      2,
                      (index) => Obx(() => GestureDetector(
                            onTap: () {
                              quranCtrl.isBold.value = index;
                              sl<SharedPreferences>().setInt(IS_BOLD, index);
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
                                  child: quranCtrl.isBold.value == index
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
}
