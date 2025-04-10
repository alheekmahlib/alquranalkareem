import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';

import '../../../controllers/general/general_controller.dart';
import '../controller/waqf_controller.dart';

class GroupButtonsWidget extends StatelessWidget {
  final generalCtrl = GeneralController.instance;
  final waqfCtrl = WaqfController.instance;

  GroupButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Use Obx to make the widget reactive.
      // استخدام Obx لجعل الواجهة تفاعلية.
      return Center(
        child: GroupButton(
          buttonIndexedBuilder: (isSelected, index, context) {
            return Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: SvgPicture.asset(
                waqfCtrl.waqfList[index].image,
                height: 40,
                width: 40,
                colorFilter: isSelected
                    ? ColorFilter.mode(
                        Theme.of(context).colorScheme.surface, BlendMode.srcIn)
                    : ColorFilter.mode(Theme.of(context).colorScheme.secondary,
                        BlendMode.srcIn),
              ),
            );
          },
          buttons: waqfCtrl.waqfList.map((e) => e.image).toList(),
          options: GroupButtonOptions(
            selectedShadow: const [],
            selectedColor: Theme.of(context).colorScheme.primary,
            unselectedShadow: const [],
            unselectedColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            unselectedTextStyle: TextStyle(
              fontSize: 18,
              fontFamily: 'kufi',
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
            borderRadius: BorderRadius.circular(4),
            spacing: 10,
            runSpacing: 10,
            groupingType: GroupingType.wrap,
            direction: Axis.horizontal,
            buttonHeight: 35,
            buttonWidth: 60,
            mainGroupAlignment: MainGroupAlignment.start,
            crossGroupAlignment: CrossGroupAlignment.start,
            groupRunAlignment: GroupRunAlignment.start,
            textAlign: TextAlign.center,
            textPadding: EdgeInsets.zero,
            alignment: Alignment.center,
            elevation: 0,
          ),
          onSelected: (isSelected, index, _) {
            generalCtrl.state.waqfScrollController.scrollTo(
              index: index,
              duration: const Duration(milliseconds: 400),
            );
          },
          isRadio: true,
        ),
      );
    });
  }
}
