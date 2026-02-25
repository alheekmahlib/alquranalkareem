import 'package:alquranalkareem/core/utils/helpers/app_text_styles.dart';
import 'package:alquranalkareem/presentation/screens/ourApp/controller/ourApps_controller.dart';
import 'package:floating_menu_expendable/floating_menu_expendable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/ourApp_model.dart';
import 'apps_info.dart';

class AppCard extends StatelessWidget {
  AppCard(this.app);

  final OurAppInfo app;
  final appCtrl = OurAppsController.instance;
  final FloatingMenuAnchoredOverlayController controller =
      FloatingMenuAnchoredOverlayController();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final apps = app;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: context.theme.primaryColorLight.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: FloatingMenuAnchoredOverlay(
        controller: controller,
        closeOnScroll: true,
        expandFromAnchor: true,
        panelWidth: 680,
        panelHeight: 510,
        style: FloatingMenuAnchoredOverlayStyle(
          barrierColor: scheme.scrim.withValues(alpha: 0.40),
          barrierBlurSigmaX: 10,
          barrierBlurSigmaY: 10,
          panelBorderRadius: const BorderRadius.all(Radius.circular(16)),
          panelDecoration: BoxDecoration(
            color: scheme.primaryContainer,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            border: Border.all(
              color: scheme.outlineVariant.withValues(alpha: 0.65),
            ),
          ),
        ),
        panelChild: AppsInfo(apps: apps, controller: controller),
        anchorBuilder: (context, toggle) => InkWell(
          // key: Key('grid_item_$index'),
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            toggle();
          },
          child: _gridCard(apps, scheme, context),
        ),
        child: _gridCard(apps, scheme, context),
      ),
    );
  }

  Column _gridCard(OurAppInfo apps, ColorScheme scheme, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Banner
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              apps.appBanner,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: scheme.primaryContainer,
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
                    ),
                  ),
                );
              },
              errorBuilder: (_, __, ___) => Container(
                color: scheme.primaryContainer,
                alignment: Alignment.center,
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
        // Title/Logo
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              apps.appTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.titleMedium(),
            ),
          ),
        ),
        // Description
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Text(
            apps.body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            style: AppTextStyles.titleSmall(),
          ),
        ),
      ],
    );
  }
}
