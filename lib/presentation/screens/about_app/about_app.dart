import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/alignment_rotated_extension.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../core/utils/constants/extensions/extensions.dart';
import '../../../core/utils/constants/svg_constants.dart';
import 'about_app_text.dart';
import 'user_options.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        centerTitle: true,
        title: customSvg(
          SvgPath.svgSplashIcon,
          height: 50,
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Image.asset(
                'assets/icons/arrow_back.png',
                color: Theme.of(context).colorScheme.primary,
              ),
            ).rotatedRtlLayout()),
        leadingWidth: 56,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: context.customOrientation(
              ListView(
                children: [
                  const Gap(32),
                  customSvg(
                    SvgPath.svgSplashIconS,
                    height: 200,
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
                    child: customSvg(
                      SvgPath.svgSplashIconS,
                      height: 200,
                    ),
                  ),
                  const Gap(32),
                  Expanded(
                    flex: 4,
                    child: ListView(
                      children: const [
                        AboutAppText(),
                        Gap(16),
                        UserOptions(),
                      ],
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
