import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/widgets/container_button.dart';
import '/core/widgets/expansion_tile_widget.dart';
import '/presentation/controllers/theme_controller.dart';
import '../../presentation/controllers/general/general_controller.dart';
import '../../presentation/screens/quran_page/quran.dart';
import '../utils/helpers/app_text_styles.dart';

class FontFamilyPicker extends StatelessWidget {
  FontFamilyPicker();

  final _loadingFont = ''.obs;

  void _changeFont(String font, ThemeController themeCtrl) {
    _loadingFont.value = font;
    Future.delayed(const Duration(milliseconds: 150), () {
      themeCtrl.setFontFamily(font);
      Future.delayed(const Duration(milliseconds: 100), () {
        _loadingFont.value = '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeCtrl = ThemeController.instance;
    final generalCtrl = GeneralController.instance;
    final quranCtrl = QuranController.instance;

    return GetBuilder<ThemeController>(
      id: 'font_family',
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Text('fontFamilyTitle'.tr, style: AppTextStyles.titleMedium()),
              const Gap(4),
              Divider(
                thickness: 1.0,
                height: 1.0,
                endIndent: 32.0,
                indent: 32.0,
                color: Theme.of(
                  context,
                ).primaryColorLight.withValues(alpha: .5),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ExpansionTileWidget(
                  getxCtrl: quranCtrl,
                  manager: generalCtrl.state.expansionManager,
                  name: 'font_family_expansion_tile',
                  title: themeCtrl.currentFontDisplayName.tr,
                  child: Obx(
                    () => Column(
                      children: ThemeController.availableFontFamilies.map((
                        font,
                      ) {
                        final isLoading = _loadingFont.value == font;
                        final isSelected = themeCtrl.currentFontFamily == font;
                        return ContainerButton(
                          onPressed: isLoading
                              ? null
                              : () => _changeFont(font, themeCtrl),
                          width: Get.width,
                          value: isSelected.obs,
                          titleStyle: AppTextStyles.titleMedium(
                            fontFamily: font,
                            fontSize: font == 'naskh'
                                ? 22
                                : font == 'kufi'
                                ? 17
                                : 20,
                            color: isSelected
                                ? Theme.of(context).colorScheme.inverseSurface
                                : Theme.of(context).colorScheme.inversePrimary
                                      .withValues(alpha: .5),
                          ),
                          title:
                              ThemeController.fontFamilyTranslationKeys[font] ??
                              font,
                          titleColor: isSelected
                              ? Theme.of(context).colorScheme.inverseSurface
                              : Theme.of(context).colorScheme.inversePrimary
                                    .withValues(alpha: .5),
                          backgroundColor: isSelected
                              ? Theme.of(
                                  context,
                                ).primaryColorLight.withValues(alpha: .2)
                              : Colors.transparent,
                          child: isLoading
                              ? const Padding(
                                  padding: EdgeInsetsDirectional.only(start: 8),
                                  child: SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                    ),
                                  ),
                                )
                              : null,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
