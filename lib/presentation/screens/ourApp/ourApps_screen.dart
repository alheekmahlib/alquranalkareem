import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../core/services/services_locator.dart';
import '../../../core/utils/constants/extensions/extensions.dart';
import '../../../core/utils/constants/svg_picture.dart';
import '../../controllers/general_controller.dart';
import '/core/widgets/container_with_lines.dart';
import '/presentation/controllers/ourApps_controller.dart';
import '/presentation/screens/ourApp/widgets/our_apps_build.dart';

class OurApps extends StatelessWidget {
  const OurApps({super.key});

  @override
  Widget build(BuildContext context) {
    sl<OurAppsController>().fetchApps();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        title: splash_icon(height: 50),
        backgroundColor: Theme.of(context).colorScheme.background,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: sl<GeneralController>().checkWidgetRtlLayout(
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Image.asset(
                    'assets/icons/arrow_back.png',
                    color: Theme.of(context).colorScheme.primary,
                  )),
            )),
        leadingWidth: 56,
      ),
      body: context.customOrientation(
          Column(
            children: [
              const Gap(32),
              splash_icon_s(
                height: 200.0,
              ),
              const Gap(32),
              ContainerWithLines(
                linesColor: Theme.of(context).colorScheme.primary,
                containerColor:
                    Theme.of(context).colorScheme.surface.withOpacity(.15),
                child: const OurAppsBuild(),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: alheekmah_logo(
                    width: 80.w, color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    splash_icon_s(
                      height: 150.0,
                    ),
                    const Spacer(),
                    Padding(
                      padding: context.customOrientation(
                          const EdgeInsets.symmetric(vertical: 40.0).r,
                          const EdgeInsets.symmetric(vertical: 32.0).r),
                      child: alheekmah_logo(
                          width: 80.w,
                          color: Theme.of(context).colorScheme.surface),
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
                  child: const OurAppsBuild(),
                ),
              ),
            ],
          )),
    );
  }
}
