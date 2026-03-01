import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/widgets/container_button.dart';
import '../../presentation/controllers/theme_controller.dart';
import '../utils/constants/svg_constants.dart';
import '../utils/helpers/app_text_styles.dart';

class ThemeChange extends StatelessWidget {
  const ThemeChange({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = ThemeController.instance;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Text('themeTitle'.tr, style: AppTextStyles.titleMedium()),
          const Gap(4),
          Divider(
            thickness: 1.0,
            height: 1.0,
            endIndent: 32.0,
            indent: 32.0,
            color: Theme.of(context).primaryColorLight.withValues(alpha: .5),
          ),
          const Gap(2),
          SizedBox(
            width: Get.width,
            child: Wrap(
              alignment: WrapAlignment.center,
              children: List.generate(
                AppTheme.values.length,
                (index) => ContainerButton(
                  onPressed: () {
                    themeCtrl.setTheme(AppTheme.values[index]);
                    Get.forceAppUpdate();
                  },
                  horizontalMargin: 4.0,
                  verticalMargin: 4.0,
                  value: (AppTheme.values[index] == themeCtrl.currentTheme).obs,
                  svgPath: SvgPath.svgSplashIconW,
                  backgroundColor: getBackgroundColorByTheme(
                    AppTheme.values[index],
                  ),
                  svgHeight: 75,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color getBackgroundColorByTheme(AppTheme theme) {
    switch (theme) {
      case AppTheme.blue:
        return const Color(0xff404C6E);
      case AppTheme.dark:
        return const Color(0xff1E1E1E);
      case AppTheme.brown:
        return const Color(0xff583623);
      case AppTheme.green:
        return const Color(0xff606C38);
    }
  }
}
