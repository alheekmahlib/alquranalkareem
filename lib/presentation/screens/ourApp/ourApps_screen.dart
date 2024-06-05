import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/alignment_rotated_extension.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '/core/widgets/container_with_lines.dart';
import '/presentation/controllers/ourApps_controller.dart';
import '/presentation/screens/ourApp/widgets/our_apps_build.dart';
import '../../../core/services/services_locator.dart';
import '../../../core/utils/constants/extensions/extensions.dart';
import '../../../core/utils/constants/svg_constants.dart';

class OurApps extends StatelessWidget {
  const OurApps({super.key});

  @override
  Widget build(BuildContext context) {
    sl<OurAppsController>().fetchApps();
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
      body: context.customOrientation(
          Column(
            children: [
              const Gap(32),
              customSvg(
                SvgPath.svgSplashIconS,
                height: 200,
              ),
              const Gap(32),
              ContainerWithLines(
                linesColor: Theme.of(context).colorScheme.primary,
                containerColor:
                    Theme.of(context).colorScheme.surface.withOpacity(.15),
                child: OurAppsBuild(),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: customSvgWithColor(SvgPath.svgAlheekmahLogo,
                    width: 80.0.w, color: Get.theme.colorScheme.primary),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    customSvg(
                      SvgPath.svgSplashIconS,
                      height: 150,
                    ),
                    const Spacer(),
                    Padding(
                      padding: context.customOrientation(
                          const EdgeInsets.symmetric(vertical: 40.0).r,
                          const EdgeInsets.symmetric(vertical: 32.0).r),
                      child: customSvgWithColor(SvgPath.svgAlheekmahLogo,
                          width: 80.0.w, color: Get.theme.colorScheme.surface),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: ContainerWithLines(
                  linesColor: Theme.of(context).colorScheme.primary,
                  containerColor:
                      Theme.of(context).colorScheme.surface.withOpacity(.15),
                  child: OurAppsBuild(),
                ),
              ),
            ],
          )),
    );
  }
}
