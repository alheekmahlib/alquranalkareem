import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/presentation/controllers/general/extensions/general_ui.dart';
import '../../presentation/controllers/general/general_controller.dart';
import '../utils/constants/lists.dart';

class SelectScreen extends StatelessWidget {
  const SelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final generalCtrl = GeneralController.instance;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'startScreen'.tr,
            style: TextStyle(
              color: Theme.of(context).hintColor,
              fontFamily: 'kufi',
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const Gap(8),
          GestureDetector(
            onTap: () => generalCtrl.selectScreenToggleView(),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surface.withValues(alpha: 0.08),
                borderRadius: const BorderRadius.all(Radius.circular(16)),
              ),
              child: SizedBox(
                height: 56,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 9,
                      child: Text(
                        '${screensList[generalCtrl.state.screenSelectedValue.value]['name']}'
                            .tr,
                        style: TextStyle(
                          fontFamily: 'kufi',
                          fontSize: 18,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 24,
                        color: Theme.of(
                          context,
                        ).hintColor.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
