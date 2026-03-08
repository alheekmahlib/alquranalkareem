import 'package:floating_menu_expendable/floating_menu_expendable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/svg_constants.dart';
import '/core/utils/helpers/app_text_styles.dart';
import '/core/widgets/container_button.dart';
import '/core/widgets/custom_button.dart';
import '../../controller/ourApps_controller.dart';
import '../../data/models/ourApp_model.dart';

class AppsInfo extends StatelessWidget {
  final OurAppInfo apps;
  final FloatingMenuAnchoredOverlayController controller;
  const AppsInfo({super.key, required this.apps, required this.controller});

  @override
  Widget build(BuildContext context) {
    final appInfo = OurAppsController.instance;
    return Material(
      color: context.theme.primaryColorLight.withValues(alpha: 0.2),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Stack(
            children: [
              CustomButton(
                onPressed: () => controller.close(),
                width: 55,
                iconSize: 55,
                svgPath: SvgPath.svgHomeClose,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: ListView(
                  children: [
                    SvgPicture.network(apps.appLogo, width: 80),
                    const Gap(8.0),
                    Center(
                      child: Text(
                        '| ${apps.appTitle} |',
                        style: AppTextStyles.titleMedium(),
                      ),
                    ),
                    const Divider(
                      height: 16,
                      thickness: 2,
                      endIndent: 16,
                      indent: 16,
                    ),
                    const Gap(8.0),
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: apps.appBanner == ''
                              ? const SizedBox.shrink()
                              : Image.network(
                                  apps.appBanner,
                                  // height: 400,
                                ),
                        ),
                        const Gap(8.0),
                        _storeButton(
                          context: context,
                          appInfo: appInfo,
                          apps: apps,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _storeButton({
    required BuildContext context,
    required OurAppsController appInfo,
    required OurAppInfo apps,
  }) {
    return ContainerButton(
      onPressed: () => appInfo.launchURL(context, apps),
      title: 'download',
      horizontalPadding: 16.0,
      verticalMargin: 8.0,
      backgroundColor: context.theme.primaryColorLight.withValues(alpha: .4),
    );
  }
}
