import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(.2),
                borderRadius: const BorderRadius.all(Radius.circular(4))),
            child: Text(
              'اختر طريقة العرض'.tr,
              style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontFamily: 'kufi',
                  fontStyle: FontStyle.italic,
                  fontSize: 16),
            ),
          ),
          const Gap(8),
          Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.surface, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                  mushafSettingsList.length,
                  (index) => Obx(() {
                        return AnimatedOpacity(
                          opacity: quranCtrl.isPages.value == index ? 1 : .5,
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
          ),
        ],
      ),
    );
  }
}
