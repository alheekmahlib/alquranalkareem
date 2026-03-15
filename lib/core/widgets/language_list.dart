import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/presentation/controllers/general/general_controller.dart';
import '../../presentation/controllers/settings_controller.dart';
import '../../presentation/screens/quran_page/quran.dart';
import '../services/languages/app_constants.dart';
import '../services/languages/localization_controller.dart';
import '../utils/helpers/app_text_styles.dart';
import 'container_button.dart';
import 'custom_switch_widget.dart';
import 'expansion_tile_widget.dart';

class LanguageList extends StatelessWidget {
  LanguageList({super.key});

  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(
      builder: (localizationController) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Text('langChange'.tr, style: AppTextStyles.titleMedium()),
            const Gap(4),
            Divider(
              thickness: 1.0,
              height: 1.0,
              endIndent: 32.0,
              indent: 32.0,
              color: Theme.of(context).primaryColorLight.withValues(alpha: .5),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ExpansionTileWidget(
                getxCtrl: quranCtrl,
                manager: GeneralController.instance.state.expansionManager,
                name: 'language_expansion_tile',
                title: SettingsController.instance.languageName.value,
                child: OverflowBar(
                  alignment: MainAxisAlignment.spaceAround,
                  spacing: 32.0,
                  overflowSpacing: 0.0,
                  children: List.generate(AppConstants.languages.length, (
                    index,
                  ) {
                    final lang = AppConstants.languages[index];
                    return ContainerButton(
                      onPressed: () async =>
                          await localizationController.changeLangOnTap(index),
                      width: Get.width,
                      value: 'appLang'.tr == lang.appLang
                          ? true.obs
                          : false.obs,
                      title: lang.languageName,
                      titleColor: 'appLang'.tr == lang.appLang
                          ? Theme.of(context).colorScheme.inverseSurface
                          : Theme.of(
                              context,
                            ).colorScheme.inversePrimary.withValues(alpha: .5),
                      backgroundColor: 'appLang'.tr == lang.appLang
                          ? Theme.of(
                              context,
                            ).primaryColorLight.withValues(alpha: .2)
                          : Colors.transparent,
                    );
                  }),
                ),
              ),
            ),
            Obx(
              () => CustomSwitchListTile(
                title: 'englishNumbers'.tr,
                contentMargin: const EdgeInsets.symmetric(horizontal: 4.0),
                value:
                    GeneralController.instance.state.isUseEnglishNumbers.value,
                onChanged: (_) {
                  GeneralController.instance.state.isUseEnglishNumbers.toggle();
                  Get.forceAppUpdate();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
