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
  const SelectScreenBuild({
    super.key,
    required this.isButton,
    required this.isButtonBack,
  });

  @override
  Widget build(BuildContext context) {
    final generalCtrl = GeneralController.instance;
    final size = MediaQuery.sizeOf(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isButtonBack
                  ? GestureDetector(
                      onTap: () => generalCtrl.selectScreenToggleView(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 8.0,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 18,
                              color: Theme.of(context).hintColor,
                            ),
                            const Gap(4),
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
                      ),
                    )
                  : const SizedBox.shrink(),
              const Gap(16),
              Flexible(
                child: ListView(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 6.0,
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: .15),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        child: Text(
                          'selectScreen'.tr,
                          style: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontFamily: 'kufi',
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const Gap(12),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Wrap(
                          children: List.generate(
                            screensList.length,
                            (index) => index == 2
                                ? const SizedBox.shrink()
                                : Obx(() {
                                    final isSelected =
                                        index ==
                                        generalCtrl
                                            .state
                                            .screenSelectedValue
                                            .value;
                                    return AnimatedOpacity(
                                      opacity: isSelected ? 1 : .45,
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          generalCtrl
                                                  .state
                                                  .screenSelectedValue
                                                  .value =
                                              index;
                                          GetStorage().write(
                                            SCREEN_SELECTED_VALUE,
                                            index,
                                          );
                                          GetStorage().write(
                                            IS_SCREEN_SELECTED_VALUE,
                                            true,
                                          );
                                        },
                                        child: AnimatedScale(
                                          scale: isSelected ? 1.0 : 0.95,
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 4.0,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                      .withValues(alpha: .15),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                ),
                                                child: Text(
                                                  '${screensList[index]['name']}'
                                                      .tr,
                                                  style: TextStyle(
                                                    color: Theme.of(
                                                      context,
                                                    ).hintColor,
                                                    fontFamily: 'kufi',
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              const Gap(4),
                                              Container(
                                                width: 120,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16.0,
                                                    ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                        Radius.circular(12.0),
                                                      ),
                                                  border: Border.all(
                                                    color: isSelected
                                                        ? Theme.of(
                                                            context,
                                                          ).colorScheme.surface
                                                        : Theme.of(context)
                                                              .colorScheme
                                                              .surface
                                                              .withValues(
                                                                alpha: 0.3,
                                                              ),
                                                    width: isSelected ? 2 : 1,
                                                  ),
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                                  boxShadow: isSelected
                                                      ? [
                                                          BoxShadow(
                                                            color:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .surface
                                                                    .withValues(
                                                                      alpha:
                                                                          0.3,
                                                                    ),
                                                            blurRadius: 8,
                                                            spreadRadius: 1,
                                                          ),
                                                        ]
                                                      : null,
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                        Radius.circular(11.0),
                                                      ),
                                                  child: Image.asset(
                                                    screensList[index]['imagePath'],
                                                  ),
                                                ),
                                              ),
                                              const Gap(8),
                                              Container(
                                                height: 22,
                                                width: 22,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                        Radius.circular(22.0),
                                                      ),
                                                  border: Border.all(
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.surface,
                                                    width: 2,
                                                  ),
                                                  gradient: isSelected
                                                      ? LinearGradient(
                                                          colors: [
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .surface,
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .primary,
                                                          ],
                                                        )
                                                      : null,
                                                  color: isSelected
                                                      ? null
                                                      : Theme.of(
                                                          context,
                                                        ).colorScheme.primary,
                                                ),
                                                child: isSelected
                                                    ? const Icon(
                                                        Icons.done,
                                                        size: 14,
                                                        color: Colors.white,
                                                      )
                                                    : null,
                                              ),
                                              const Gap(16),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          isButton
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 8.0,
                    ),
                    child: ElevatedButtonWidget(
                      onClick: () => Get.off(() => ScreenTypeL()),
                      index: 1,
                      height: 48,
                      width: size.width * .6,
                      child: Center(
                        child: Text(
                          'save'.tr,
                          style: TextStyle(
                            fontFamily: 'kufi',
                            fontSize: 18,
                            color: Theme.of(context).canvasColor,
                          ),
                        ),
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
