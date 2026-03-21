import 'package:alquranalkareem/core/utils/constants/svg_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/contact_us_extension.dart';
import '/core/utils/constants/extensions/launch_alheekmah_url_extension.dart';
import '/core/utils/constants/extensions/share_app_extension.dart';
import '../../../core/widgets/container_button.dart';

class UserOptions extends StatelessWidget {
  const UserOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Theme.of(context).colorScheme.surface.withValues(alpha: .15),
      ),
      child: Column(
        children: [
          ContainerButton(
            onPressed: () async => await shareApp(),
            withArrow: true,
            isButton: true,
            width: double.infinity,
            title: 'share',
            horizontalPadding: 8.0,
            verticalPadding: 12.0,
            horizontalMargin: 8.0,
            svgWithColorPath: SvgPath.svgHomeShare,
            svgColor: context.theme.colorScheme.primary,
          ),
          const Divider(),
          ContainerButton(
            onPressed: () => contactUs(context: context),
            withArrow: true,
            isButton: true,
            width: double.infinity,
            title: 'email',
            horizontalPadding: 8.0,
            verticalPadding: 12.0,
            horizontalMargin: 8.0,
            svgWithColorPath: SvgPath.svgHomeEmail,
            svgColor: context.theme.colorScheme.primary,
          ),
          const Divider(),
          ContainerButton(
            onPressed: () => launchAlheekmahUrl(),
            withArrow: true,
            isButton: true,
            width: double.infinity,
            title: 'facebook',
            horizontalPadding: 8.0,
            verticalPadding: 12.0,
            horizontalMargin: 8.0,
            svgWithColorPath: SvgPath.svgHomeFacebook,
            svgColor: context.theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
