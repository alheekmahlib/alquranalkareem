import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:quran_library/quran.dart';

import '/core/utils/helpers/app_text_styles.dart';
import '/core/widgets/container_button.dart';
import '/core/widgets/expansion_tile_widget.dart';
import '/core/widgets/title_widget.dart';
import '/presentation/controllers/general/general_controller.dart';
import '../../../../../core/utils/constants/extensions/bottom_sheet_extension.dart';
import '../../../../../core/utils/constants/extensions/convert_number_extension.dart';
import '../../controllers/mutashabihat_controller.dart';
import 'mutashabihat_bottom_sheet.dart';

class MutashabihatBrowseSheet {
  const MutashabihatBrowseSheet._();

  static void show(BuildContext context) {
    final controller = MutashabihatController.instance;
    final grouped = controller.getAllGroupedBySurah();

    // Sort by surah number
    final sortedKeys = grouped.keys.toList()..sort();

    BottomSheetExtension(null).customPushToPage(
      context,
      backgroundColor: Get.theme.colorScheme.primaryContainer,
      // غلاف customBottomSheet يلتف حول المحتوى (mainAxisSize.min)،
      // فيلزم ارتفاع محدد حتى تعمل Expanded والقائمة داخله.
      SizedBox(
        height: Get.height * .75,
        width: Get.width,
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TitleWidget(
                title: 'browse_mutashabihat'.tr,
                horizontalPadding: 8.0,
              ),
            ),
            const Gap(16.0),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                itemCount: sortedKeys.length,
                separatorBuilder: (_, __) => const Gap(6),
                itemBuilder: (context, index) {
                  final surahNumber = sortedKeys[index];
                  final verseKeys = grouped[surahNumber]!;
                  final surah = QuranCtrl.instance.surahs.firstWhereOrNull(
                    (s) => s.surahNumber == surahNumber,
                  );

                  return ExpansionTileWidget<MutashabihatController>(
                    name: 'browse_surah_$surahNumber',
                    manager: GeneralController.instance.state.expansionManager,
                    getxCtrl: controller,
                    titleChild: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'surah${surah!.surahNumber.toString().padLeft(3, '0')} ',
                            style: TextStyle(
                              color: context.theme.colorScheme.inversePrimary,
                              letterSpacing: 5,
                              fontFamily: "surah-name-v4",
                              fontSize: 40,
                              package: "quran_library",
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 2.0,
                          ),
                          decoration: BoxDecoration(
                            color: context.theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${verseKeys.length}'.convertNumbersToCurrentLang(),
                            style: AppTextStyles.titleSmall(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    child: Column(
                      children: verseKeys.map((verseKey) {
                        final parts = verseKey.split(':');
                        final ayahNum = int.tryParse(parts.last) ?? 0;

                        return ContainerButton(
                          onPressed: () {
                            Get.back();
                            MutashabihatBottomSheet.show(
                              context: Get.context!,
                              surahNumber: surahNumber,
                              ayahNumber: ayahNum,
                            );
                          },
                          value: true.obs,
                          withArrow: true,
                          width: double.infinity,
                          verticalMargin: 4.0,
                          title:
                              '${'ayah'.tr} ${'$ayahNum'.convertNumbersToCurrentLang()}',
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
