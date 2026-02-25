import 'package:alquranalkareem/core/widgets/container_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../presentation/controllers/settings_controller.dart';
import '../../presentation/screens/quran_page/quran.dart';
import '../services/languages/app_constants.dart';
import '../services/languages/localization_controller.dart';
import '../services/services_locator.dart';
import '../utils/constants/extensions/svg_extensions.dart';
import '../utils/constants/svg_constants.dart';
import '../utils/helpers/app_text_styles.dart';

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
              child: Obx(
                () => ExpansionTile(
                  controller: quranCtrl.state.languageController,
                  backgroundColor: context.theme.primaryColorLight.withValues(
                    alpha: .2,
                  ),
                  collapsedBackgroundColor: context.theme.primaryColorLight
                      .withValues(alpha: .2),
                  childrenPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onExpansionChanged: (isExpanded) {
                    quranCtrl.state.isLanguageExpanded.value = isExpanded;
                  },
                  trailing: Transform.flip(
                    flipY: quranCtrl.state.isLanguageExpanded.value
                        ? true
                        : false,
                    child: customSvgWithColor(
                      SvgPath.svgHomeArrowDown,
                      color: context.theme.primaryColorDark,
                      height: 18,
                    ),
                  ),
                  title: SizedBox(
                    width: 100.0,
                    child: Obx(() {
                      return Text(
                        sl<SettingsController>().languageName.value,
                        style: AppTextStyles.titleMedium(),
                      );
                    }),
                  ),
                  children: <Widget>[
                    const Divider(thickness: 1.0, height: 1.0),
                    OverflowBar(
                      alignment: MainAxisAlignment.spaceAround,
                      spacing: 32.0,
                      overflowSpacing: 0.0,
                      children: List.generate(AppConstants.languages.length, (
                        index,
                      ) {
                        final lang = AppConstants.languages[index];
                        return ContainerButton(
                          onPressed: () async => await localizationController
                              .changeLangOnTap(index),
                          width: Get.width,
                          value: 'appLang'.tr == lang.appLang
                              ? true.obs
                              : false.obs,
                          title: lang.languageName,
                          titleColor: 'appLang'.tr == lang.appLang
                              ? Theme.of(context).colorScheme.inverseSurface
                              : Theme.of(context).colorScheme.inversePrimary
                                    .withValues(alpha: .5),
                          backgroundColor: 'appLang'.tr == lang.appLang
                              ? Theme.of(
                                  context,
                                ).primaryColorLight.withValues(alpha: .2)
                              : Colors.transparent,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
