import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../../../core/utils/constants/svg_constants.dart';
import '../../../../../core/widgets/container_with_border.dart';
import '../../../../../core/widgets/container_with_lines.dart';
import '../../controller/splash_screen_controller.dart';

class LogoAndTitle extends StatelessWidget {
  const LogoAndTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final splashCtrl = SplashScreenController.instance;
    return ContainerWithLines(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          customSvg(
            SvgPath.svgSplashIcon,
            height: 100,
            width: 100,
          ),
          const Gap(16),
          ContainerWithBorder(
            color: Theme.of(context).colorScheme.primary,
            child: Obx(() {
              return AnimatedOpacity(
                duration: const Duration(seconds: 1),
                opacity: splashCtrl.state.animate.value ? 1 : 0,
                child: Text(
                  'وَرَتِّلِ ٱلۡقُرۡءَانَ تَرۡتِيلًا',
                  style: TextStyle(
                      fontFamily: 'uthmanic2',
                      color: Theme.of(context).colorScheme.primaryContainer,
                      fontSize: 22),
                ),
              );
            }),
          ),
          const Gap(16)
        ],
      ),
    );
  }
}
