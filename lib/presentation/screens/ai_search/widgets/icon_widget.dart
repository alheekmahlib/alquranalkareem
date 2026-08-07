part of '../ai_search.dart';

class IconWidget extends StatelessWidget {
  const IconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = AiSearchController.instance;
    return Column(
      children: [
        const SizedBox().customSvg(SvgPath.svgHomeMidadIcon, height: 70),
        const Gap(8),
        Text(
          ctrl.state.hasAnySectionLoaded
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
