part of '../quran.dart';

/// شريط أزرار اختيار وضع العرض
///
/// يظهر كشريط عمودي بأيقونات على يمين الشاشة، ويختفي/يظهر مع
/// عناصر التحكم (_ControlWidget).
///
/// [DisplayModeBar] A vertical bar with icons for selecting the display mode.
/// Shows/hides with the control overlay.
class DisplayModeBar extends StatelessWidget {
  const DisplayModeBar({
    super.key,
    required this.isDark,
    this.style,
    this.languageCode = 'ar',
  });

  final bool isDark;
  final DisplayModeBarStyle? style;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final s =
        style ??
        (DisplayModeBarTheme.of(context)?.style ??
            DisplayModeBarStyle.defaults(isDark: isDark, context: context));

    return Obx(() {
      final quranCtrl = QuranCtrl.instance;
      final currentMode = quranCtrl.state.displayMode.value;
      final availableModes = quranCtrl.getAvailableModes(context);

      // لا تعرض الشريط إذا كان وضع واحد فقط متاحًا
      if (availableModes.length <= 1) return const SizedBox.shrink();

      return Align(
        alignment: s.position ?? Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 64 : 8),
          child: Material(
            color: Colors.transparent,
            elevation: s.elevation ?? 4,
            borderRadius: BorderRadius.circular(s.borderRadius ?? 16),
            child: Container(
              decoration: BoxDecoration(
                color:
                    s.backgroundColor ??
                    Colors.grey.shade200.withValues(alpha: .85),
                borderRadius: BorderRadius.circular(s.borderRadius ?? 16),
              ),
              padding:
                  s.padding ??
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: availableModes
                    .map(
                      (mode) => _buildModeButton(
                        context: context,
                        mode: mode,
                        isSelected: mode == currentMode,
                        style: s,
                        onTap: () => quranCtrl.setDisplayMode(mode),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildModeButton({
    required BuildContext context,
    required QuranDisplayMode mode,
    required bool isSelected,
    required DisplayModeBarStyle style,
    required VoidCallback onTap,
  }) {
    final iconSize = style.iconSize ?? 24;
    final spacing = style.spacing ?? 16;
    final label = languageCode == 'ar' ? mode.labelAr : mode.labelEn;
    final showTooltip = style.showTooltip ?? true;

    Widget button = Padding(
      padding: EdgeInsets.symmetric(vertical: spacing),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected
                ? (style.selectedBackgroundColor ??
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: .8))
                : Colors.transparent,
            borderRadius: BorderRadius.circular((style.borderRadius ?? 16) - 4),
            border: !isSelected
                ? Border.all(
                    color: (style.selectedBackgroundColor ?? Colors.teal)
                        .withValues(alpha: .5),
                    width: 1,
                  )
                : null,
          ),
          child: Icon(
            mode.icon,
            size: iconSize,
            color: isSelected
                ? (style.selectedIconColor ?? Colors.white)
                : (style.unselectedIconColor ?? Colors.grey.shade600),
          ),
        ),
      ),
    );

    if (showTooltip) {
      button = Tooltip(
        message: label,
        preferBelow: false,
        decoration: BoxDecoration(
          color: style.tooltipBackgroundColor ?? Colors.grey.shade800,
          borderRadius: BorderRadius.circular(6),
        ),
        textStyle:
            style.tooltipTextStyle ?? const TextStyle(color: Colors.white),
        child: button,
      );
    }

    return button;
  }
}
