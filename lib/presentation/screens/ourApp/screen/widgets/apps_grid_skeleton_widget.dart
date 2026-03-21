import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AppsGridSkeleton extends StatelessWidget {
  const AppsGridSkeleton({required this.crossAxisCount});
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final placeholders = List.generate(
      crossAxisCount * 2,
      (_) => const SizedBox(),
    );
    // نسبة الأبعاد متوافقة مع الشبكة الرئيسية
    double aspect;
    if (crossAxisCount == 1) {
      aspect = 1.18;
    } else if (crossAxisCount == 2) {
      aspect = 1.25;
    } else {
      aspect = 4 / 3;
    }
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: aspect,
      ),
      itemCount: placeholders.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: scheme.primaryContainer,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Column(
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                ),
              ),
              const Gap(10),
              Container(
                height: 12,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const Gap(8),
              Container(
                height: 10,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
