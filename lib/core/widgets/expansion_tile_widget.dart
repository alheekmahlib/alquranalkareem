import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/expansion_tile_manager.dart';
import '../utils/constants/extensions/svg_extensions.dart';
import '../utils/constants/svg_constants.dart';
import '../utils/helpers/app_text_styles.dart';
// expansion_tile_widget.dart

class ExpansionTileWidget<T extends GetxController> extends StatelessWidget {
  final Widget child;
  final String? title;
  final String? subtitle;
  final String name;
  final ExpansionTileManager manager;
  final T getxCtrl;
  final Widget? titleChild;
  final Color? backgroundColor;

  const ExpansionTileWidget({
    super.key,
    required this.name,
    required this.manager,
    required this.child,
    this.title,
    this.subtitle,
    required this.getxCtrl,
    this.titleChild,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(
      id: 'expansion_tile_$name', // ✅ معرّف فريد
      init: getxCtrl,
      builder: (ctrl) {
        final isExpanded = manager.isExpanded(name);
        final controller = manager.getController(name);

        return ExpansionTile(
          controller: controller,
          backgroundColor:
              backgroundColor ??
              context.theme.primaryColorLight.withValues(alpha: .2),
          collapsedBackgroundColor:
              backgroundColor ??
              context.theme.primaryColorLight.withValues(alpha: .2),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 8.0),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          onExpansionChanged: (expanded) {
            manager.getExpandedState(name).value = expanded;
            getxCtrl.update(['expansion_tile_$name']);
          },
          trailing: Transform.flip(
            flipY: isExpanded,
            child: customSvgWithColor(
              SvgPath.svgHomeArrowDown,
              color: context.theme.primaryColorDark,
              height: 18,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  style: AppTextStyles.bodySmall(
                    fontSize: 12.0,
                    color: context.theme.primaryColorDark.withValues(alpha: .7),
                  ),
                )
              : null,
          title:
              titleChild ??
              SizedBox(
                width: 100.0,
                child: Text(title ?? '', style: AppTextStyles.titleMedium()),
              ),
          children: <Widget>[const Divider(thickness: 1.0, height: 1.0), child],
        );
      },
    );
  }
}
