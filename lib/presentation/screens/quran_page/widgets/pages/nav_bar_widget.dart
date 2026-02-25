part of '../../quran.dart';

class NavBarWidget extends StatelessWidget {
  NavBarWidget({super.key});
  final generalCtrl = GeneralController.instance;
  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta != null) {
          if (details.primaryDelta! < -8) {
            Future.delayed(const Duration(milliseconds: 10), () {
              quranCtrl.state.isPlayExpanded.value = true;
              quranCtrl.state.navBarController.animateTo(155);
            });
          } else if (details.primaryDelta! > 8) {
            quranCtrl.state.isPlayExpanded.value = false;
            quranCtrl.state.navBarController.animateTo(50);
          }
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return FlexibleSheet(
            maxHeight: 155, // constraints.maxHeight - 150,
            minHeight: 0,
            initialHeight: 0,
            direction: SheetDirection.bottomToTop,
            snapBehavior: SheetSnapBehavior.snapToEdge,
            controller: quranCtrl.state.navBarController,
            onStateChanged: (state) => log('isOpen: $state'),
            handleBuilder: (currentHeight) {
              final isExpanded = currentHeight == 155;
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 8,
                    width: Get.width,
                    margin: const EdgeInsets.symmetric(horizontal: 62.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          height: 62,
                          width: 62,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          height: 62,
                          width: 62,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8),
                              topLeft: Radius.circular(8),
                            ),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      Container(
                        height: 53,
                        width: Get.width,
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  if (isExpanded) {
                                    quranCtrl.state.navBarController.animateTo(
                                      0,
                                    );
                                  } else {
                                    quranCtrl.state.navBarController.animateTo(
                                      155,
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: customSvgWithColor(
                                    isExpanded
                                        ? SvgPath.svgHomeClose
                                        : SvgPath.svgHomeSurahList,
                                    height: 35,
                                    width: 35,
                                    color: context.theme.hintColor,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 12,
                              child: GetBuilder<GeneralController>(
                                id: 'showControl',
                                builder: (generalCtrl) =>
                                    generalCtrl.state.isShowControl.value ||
                                        generalCtrl
                                            .state
                                            .showAudioWidgetTemporarily
                                            .value
                                    ? AudioWidget()
                                    : const SizedBox.shrink(),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  customBottomSheet(
                                    const KhatmahBookmarksScreen(),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: customSvgWithColor(
                                    isExpanded
                                        ? SvgPath.svgHomeClose
                                        : SvgPath.svgHomeBookmarkList,
                                    height: 35,
                                    width: 35,
                                    color: context.theme.hintColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
            childBuilder: (c) => Container(
              height: Get.height,
              width: Get.width,
              color: Theme.of(context).colorScheme.primaryContainer,
              child: const Center(child: Text('data')),
            ),
          );
        },
      ),
    );
  }
}
