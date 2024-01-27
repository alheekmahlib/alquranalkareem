import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/azkar_controller.dart';
import '/core/utils/constants/extensions.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final azkarCtrl = sl<AzkarController>();
    return AppBar(
      backgroundColor: Get.theme.colorScheme.background,
      elevation: 0,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            border: Border.all(color: Get.theme.colorScheme.primary, width: 1)),
        child: Text(
          azkarCtrl.filteredZekrList.first.category,
          style: TextStyle(
            color: Get.isDarkMode ? Colors.white : Get.theme.primaryColor,
            fontSize: context.customOrientation(12.0, 16.0),
            fontFamily: 'kufi',
          ),
        ),
      ),
      centerTitle: true,
      leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 22,
            color: Get.theme.colorScheme.primary,
          )),
      actions: [
        fontSizeDropDown(context),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
