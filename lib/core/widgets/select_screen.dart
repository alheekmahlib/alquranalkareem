import 'package:alquranalkareem/core/widgets/container_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../presentation/controllers/general/general_controller.dart';
import '../utils/constants/lists.dart';
import '../utils/constants/shared_preferences_constants.dart';
import '../utils/helpers/app_text_styles.dart';

class SelectScreen extends StatelessWidget {
  const SelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final generalCtrl = GeneralController.instance;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Text('startScreen'.tr, style: AppTextStyles.titleMedium()),
          const Gap(4),
          Divider(
            thickness: 1.0,
            height: 1.0,
            endIndent: 32.0,
            indent: 32.0,
            color: Theme.of(context).primaryColorLight.withValues(alpha: .5),
          ),
          Wrap(
            children: List.generate(
              screensList.length,
              (index) => index == 2
                  ? const SizedBox.shrink()
                  : Obx(
                      () => ContainerButton(
                        onPressed: () {
                          generalCtrl.state.screenSelectedValue.value = index;
                          GetStorage().write(SCREEN_SELECTED_VALUE, index);
                          GetStorage().write(IS_SCREEN_SELECTED_VALUE, true);
                        },
                        value:
                            (generalCtrl.state.screenSelectedValue.value ==
                                    index)
                                .obs,
                        horizontalPadding: 8.0,
                        verticalPadding: 8.0,
                        horizontalMargin: 4.0,
                        verticalMargin: 4.0,
                        title: '${screensList[index]['name']}',
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
