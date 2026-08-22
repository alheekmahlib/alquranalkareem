part of '../ai_search.dart';

class MidadNoteWidget extends StatelessWidget {
  final Color? textColor;
  final Color? iconColor;
  final double? horizontalMargin;
  const MidadNoteWidget({
    super.key,
    this.horizontalMargin,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: horizontalMargin ?? 16.0,
              vertical: 16.0,
            ),
            padding: const EdgeInsets.only(
              right: 12.0,
              left: 12.0,
              top: 12.0,
              bottom: 8.0,
            ),
            decoration: BoxDecoration(
              color: (iconColor ?? context.theme.colorScheme.surface)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'midadNote'.tr,
              style: AppTextStyles.titleMedium(
                fontSize: 13,
                color: (textColor ?? context.theme.canvasColor).withValues(
                  alpha: 0.8,
                ),
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: const SizedBox().customSvgWithColor(
              SvgPath.svgAlert,
              height: 24,
              color: context.theme.colorScheme.surface.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
