part of '../ai_search.dart';

class IconWidget extends StatelessWidget {
  final bool? isOnlineMode;
  const IconWidget({super.key, this.isOnlineMode = false});

  @override
  Widget build(BuildContext context) {
    final ctrl = AiSearchController.instance;
    return Column(
      children: [
        const SizedBox().customSvg(SvgPath.svgHomeMidadIcon, height: 70),
        const Gap(8),
        Text(
          isOnlineMode == true
              ? 'midadDescription'.tr
              : ctrl.state.hasAnySectionLoaded
              ? 'midadDescription'.tr
              : 'downloadSections'.tr,
          style: AppTextStyles.titleMedium(
            fontSize: 14,
            color: context.theme.colorScheme.surface,
          ),
        ),
        const Gap(24),
      ],
    );
  }
}
