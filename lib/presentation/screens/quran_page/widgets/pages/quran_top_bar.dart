part of '../../quran.dart';

class QuranTopBar extends StatelessWidget {
  const QuranTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topEnd,
      child: Transform.translate(
        offset: const Offset(0, 75),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0, 0.0, 0),
          child: SizedBox(
            width: context.customOrientation(Get.width, Get.width * .5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Row(
                            children: [
                              Obx(() {
                                final isAutoScrollActive = AutoScrollCtrl
                                    .instance
                                    .state
                                    .isActive
                                    .value;
                                return QuranCtrl
                                            .instance
                                            .state
                                            .displayMode
                                            .value ==
                                        QuranDisplayMode.defaultMode
                                    ? CustomButton(
                                        height: 35,
                                        width: 35,
                                        iconSize: 35,
                                        isCustomSvgColor: true,
                                        horizontalPadding: 8,
                                        svgPath: SvgPath.svgQuranArrowDown,
                                        svgColor: Get.theme.canvasColor,
                                        backgroundColor: isAutoScrollActive
                                            ? Get.theme.colorScheme.primary
                                            : Get.theme.colorScheme.primary
                                                  .withValues(alpha: .6),
                                        onPressed: () {
                                          final ctrl = AutoScrollCtrl.instance;
                                          if (ctrl.state.isActive.value) {
                                            ctrl.stopAutoScroll();
                                          } else {
                                            final currentPage = QuranCtrl
                                                .instance
                                                .state
                                                .currentPageNumber
                                                .value;
                                            ctrl.startAutoScroll(currentPage);
                                          }
                                          QuranController.instance
                                              .showControl();
                                          // GeneralController
                                          //     .instance
                                          //     .state
                                          //     .isShowControl
                                          //     .toggle();
                                          // GeneralController.instance.update([
                                          //   'showControl',
                                          // ]);
                                        },
                                      )
                                    : const SizedBox.shrink();
                              }),
                              const Gap(4),
                              CustomButton(
                                height: 35,
                                width: 35,
                                iconSize: 35,
                                isCustomSvgColor: true,
                                svgPath: SvgPath.svgAudioPlaylist,
                                svgColor: Get.theme.canvasColor,
                                backgroundColor: Get.theme.colorScheme.primary,
                                onPressed: () => customBottomSheet(
                                  backgroundColor:
                                      Get.theme.colorScheme.primaryContainer,
                                  AyahsPlayListWidget(),
                                  bottomSheetWidth: context.customOrientation(
                                    Get.width,
                                    Get.width * .75,
                                  ),
                                ),
                              ),
                              const Gap(4),
                              CustomButton(
                                height: 35,
                                width: 60,
                                iconSize: 40,
                                isCustomSvgColor: true,
                                svgPath: SvgPath.svgQuranKhatmah,
                                svgColor: Get.theme.canvasColor,
                                backgroundColor: Get.theme.colorScheme.primary,
                                onPressed: () => customBottomSheet(
                                  backgroundColor:
                                      Get.theme.colorScheme.primaryContainer,
                                  KhatmasScreen(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(8),
                        Expanded(flex: 6, child: QuranOrTenRecitationsTabBar()),
                      ],
                    ),
                  ),
                ),
                const Gap(8),
                Container(
                  height: 50,
                  width: 8,
                  decoration: BoxDecoration(
                    color: Get.theme.primaryColorLight,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
