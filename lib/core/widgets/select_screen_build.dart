import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '/presentation/controllers/general/extensions/general_ui.dart';
import '../../presentation/controllers/general/general_controller.dart';
import '../../presentation/screens/screen_type.dart';
import '../utils/constants/lists.dart';
import '../utils/constants/shared_preferences_constants.dart';
import 'elevated_button_widget.dart';

class SelectScreenBuild extends StatelessWidget {
  final bool isButton;
  final bool isButtonBack;
  const SelectScreenBuild(
      {super.key, required this.isButton, required this.isButtonBack});

  @override
  Widget build(BuildContext context) {
    final generalCtrl = GeneralController.instance;
    final size = MediaQuery.sizeOf(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isButtonBack
                  ? GestureDetector(
                      onTap: () => generalCtrl.selectScreenToggleView(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_back_ios_new_outlined,
                            size: 20,
                            color: Theme.of(context).hintColor,
                          ),
                          Text(
                            'setting'.tr,
                            style: TextStyle(
                              fontFamily: 'kufi',
                              fontSize: 18,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
              const Gap(32),
              Flexible(
                child: ListView(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 4.0),
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: .2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4))),
                        child: Text(
                          'selectScreen'.tr,
                          style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontFamily: 'kufi',
                              fontStyle: FontStyle.italic,
                              fontSize: 16),
                        ),
                      ),
                    ),
                    const Gap(8),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).colorScheme.surface,
                                width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        child: Wrap(
                          children: List.generate(
                              screensList.length,
                              (index) => index == 2
                                  ? const SizedBox.shrink()
                                  : Obx(() {
                                      return AnimatedOpacity(
                                        opacity: index ==
                                                generalCtrl.state
                                                    .screenSelectedValue.value
                                            ? 1
                                            : .5,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        child: GestureDetector(
                                          onTap: () {
                                            generalCtrl
                                                .state
                                                .screenSelectedValue
                                                .value = index;
                                            GetStorage().write(
                                                SCREEN_SELECTED_VALUE, index);
                                            GetStorage().write(
                                                IS_SCREEN_SELECTED_VALUE, true);
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6.0,
                                                        vertical: 4.0),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0.0),
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                        .withValues(alpha: .2),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                4))),
                                                child: Text(
                                                  '${screensList[index]['name']}'
                                                      .tr,
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .hintColor,
                                                      fontFamily: 'kufi',
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 14),
                                                ),
                                              ),
                                              Container(
                                                width: 120,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(4.0)),
                                                  border: Border.all(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                      width: 1),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                                child: Image.asset(
                                                  screensList[index]
                                                      ['imagePath'],
                                                ),
                                              ),
                                              const Gap(6),
                                              Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(
                                                              20.0)),
                                                  border: Border.all(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                      width: 2),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                                child: index ==
                                                        generalCtrl
                                                            .state
                                                            .screenSelectedValue
                                                            .value
                                                    ? const Icon(Icons.done,
                                                        size: 14,
                                                        color: Colors.white)
                                                    : null,
                                              ),
                                              const Gap(16),
                                            ],
                                          ),
                                        ),
                                      );
                                    })),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          isButton
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 8.0),
                    child: ElevatedButtonWidget(
                      onClick: () => Get.off(() => ScreenTypeL()),
                      index: 1,
                      height: 40,
                      width: size.width * .6,
                      child: Center(
                        child: Text('save'.tr,
                            style: TextStyle(
                                fontFamily: 'kufi',
                                fontSize: 18,
                                color: Theme.of(context).canvasColor)),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
