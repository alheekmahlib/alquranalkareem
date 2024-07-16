import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';

import '/presentation/controllers/general_controller.dart';
import '../../../../core/utils/constants/lists.dart';

class GroupButtonsWidget extends StatelessWidget {
  GroupButtonsWidget({super.key});

  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GroupButton(
        buttonIndexedBuilder: (isSelected, index, BuildContext) {
          return Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.primary.withOpacity(.6),
              borderRadius: BorderRadius.circular(4),
            ),
            child: SvgPicture.asset(
              waqfMarks[index],
              height: 40,
              width: 40,
              colorFilter: isSelected
                  ? ColorFilter.mode(
                      Theme.of(context).colorScheme.surface, BlendMode.srcIn)
                  : ColorFilter.mode(
                      Theme.of(context).colorScheme.secondary, BlendMode.srcIn),
            ),
          );
        },
        buttons: waqfMarks,
        options: GroupButtonOptions(
          selectedShadow: const [],
          selectedColor: Theme.of(context).colorScheme.primary,
          unselectedShadow: const [],
          unselectedColor:
              Theme.of(context).colorScheme.primary.withOpacity(.5),
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
        onSelected: (isSelected, index, bool) =>
            generalCtrl.waqfScrollController.scrollTo(
                index: index, duration: const Duration(milliseconds: 400)),
        isRadio: true,
      ),
    );
  }
}
