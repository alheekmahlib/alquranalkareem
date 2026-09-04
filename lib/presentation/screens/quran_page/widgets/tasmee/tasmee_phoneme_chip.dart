part of '../../quran.dart';

/// شريحة فونيم (المتوقع/المنطوق).
class _TasmeePhonemeChip extends StatelessWidget {
  const _TasmeePhonemeChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTextStyles.titleMedium(
          color: context.theme.colorScheme.inversePrimary,
          fontSize: 14,
        ),
      ),
    );
  }
}
