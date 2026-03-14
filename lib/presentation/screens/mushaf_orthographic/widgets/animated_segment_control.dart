import 'package:alquranalkareem/core/utils/helpers/app_text_styles.dart';
import 'package:flutter/material.dart';

/// A professional animated sliding segment control
/// that switches between sections with a smooth sliding indicator.
class AnimatedSegmentControl extends StatelessWidget {
  final List<String> labels;
  final List<String>? svgIcons;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const AnimatedSegmentControl({
    super.key,
    required this.labels,
    this.svgIcons,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.surface.withValues(alpha: .15),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final segmentWidth = constraints.maxWidth / labels.length;
          return Stack(
            children: [
              // Sliding indicator
              IgnorePointer(
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOutCubic,
                  alignment: AlignmentDirectional(
                    -1.0 + (2.0 * selectedIndex / (labels.length - 1)),
                    0.0,
                  ),
                  child: Container(
                    width: segmentWidth,
                    height: 35,
                    decoration: BoxDecoration(
                      color: theme.primaryColorLight,
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                ),
              ),
              // Labels row
              SizedBox(
                height: 35,
                child: Row(
                  children: List.generate(labels.length, (index) {
                    final isSelected = index == selectedIndex;
                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onChanged(index),
                        child: AnimatedDefaultTextStyle(
                          textAlign: TextAlign.center,
                          duration: const Duration(milliseconds: 200),
                          style: AppTextStyles.titleMedium(
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected
                                ? theme.colorScheme.surface
                                : theme.primaryColorLight,
                          ),
                          child: Text(labels[index]),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
