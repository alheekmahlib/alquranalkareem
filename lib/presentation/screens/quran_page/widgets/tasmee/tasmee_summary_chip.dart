part of '../../quran.dart';

/// شريحة ملخص (النوع + العدد).
class _TasmeeSummaryChip extends StatelessWidget {
  const _TasmeeSummaryChip({
    required this.label,
    required this.value,
    this.color,
  });

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? context.theme.colorScheme.surface;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: c,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTextStyles.titleSmall(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: context.theme.colorScheme.inversePrimary,
            ),
          ),
          const Gap(4),
          Text(
            label,
            style: AppTextStyles.bodySmall(
              fontSize: 12,
              color: context.theme.colorScheme.inversePrimary.withValues(
                alpha: .8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
