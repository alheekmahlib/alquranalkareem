import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../core/utils/constants/extensions/extensions.dart';
import '../../../core/utils/constants/svg_constants.dart';
import '../../../core/widgets/animated_drawing_widget.dart';
import '../../../core/widgets/app_bar_widget.dart';
import 'about_app_text.dart';
import 'user_options.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBarWidget(
        isBooks: false,
        isTitled: false,
        isNotifi: false,
        isFontSize: false,
        searchButton: const SizedBox.shrink(),
        centerChild: customSvgWithCustomColor(
          SvgPath.svgHomeQuranLogo,
          height: 35,
          color: context.theme.primaryColorLight,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: context.customOrientation(
            ListView(
              children: [
                const Gap(32),
                AnimatedDrawingWidget(
                  opacity: 1,
                  svgPath: SvgPath.svgHomeQuranLogo,
                  width: 130,
                  height: 110,
                  customColor: context.theme.colorScheme.surface,
                ),
                const Gap(32),
                const AboutAppText(),
                const Gap(16),
                const UserOptions(),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: AnimatedDrawingWidget(
                    opacity: 1,
                    svgPath: SvgPath.svgHomeQuranLogo,
                    width: 130,
                    height: 110,
                    customColor: context.theme.colorScheme.surface,
                  ),
                ),
                const Gap(32),
                Expanded(
                  flex: 4,
                  child: ListView(
                    children: const [AboutAppText(), Gap(16), UserOptions()],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
