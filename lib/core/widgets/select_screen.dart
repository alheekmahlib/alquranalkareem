import '../utils/constants/lists.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../presentation/controllers/general_controller.dart';
import '../services/services_locator.dart';

class SelectScreen extends StatelessWidget {
  const SelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final generalCtrl = sl<GeneralController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(.2),
                borderRadius: const BorderRadius.all(Radius.circular(4))),
            child: Text(
              'startScreen'.tr,
              style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontFamily: 'kufi',
                  fontStyle: FontStyle.italic,
                  fontSize: 16),
            ),
          ),
          const Gap(8),
          Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.surface, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: GestureDetector(
              onTap: () => generalCtrl.selectScreenToggleView(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(.2),
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                child: SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 9,
                        child: Text(
                          '${screensList[generalCtrl.screenSelectedValue.value]['name']}'
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
                          Icons.arrow_forward_ios_outlined,
                          size: 20,
                          color: Theme.of(context).hintColor,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
