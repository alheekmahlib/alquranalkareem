import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../controllers/general/general_controller.dart';
import '../controller/waqf_controller.dart';

class GroupButtonsWidget extends StatelessWidget {
  GroupButtonsWidget({super.key});

  final generalCtrl = GeneralController.instance;
  final waqfCtrl = WaqfController.instance;
  final _selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      final items = waqfCtrl.waqfList;
      if (items.isEmpty) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(items.length, (index) {
            final isSelected = _selectedIndex.value == index;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: GestureDetector(
                onTap: () {
                  _selectedIndex.value = index;
                  generalCtrl.state.waqfScrollController.scrollTo(
                    index: index,
                    duration: const Duration(milliseconds: 400),
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primary.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primary.withValues(alpha: .3),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: theme.colorScheme.primary.withValues(
                                alpha: .25,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: customSvgWithColor(
                      items[index].image,
                      height: 32,
                      width: 32,
                      color: isSelected
                          ? theme.colorScheme.surface
                          : theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}
