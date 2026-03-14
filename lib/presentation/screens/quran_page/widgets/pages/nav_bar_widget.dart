part of '../../quran.dart';

enum NavBarType { none, surahList, bookmarkList }

class NavBarWidget extends StatelessWidget {
  final Widget? bodyChild;
  final Widget? handleChild;
  final double? handleHeight;
  NavBarWidget({
    super.key,
    this.bodyChild,
    this.handleChild,
    this.handleHeight,
  });
  final generalCtrl = GeneralController.instance;
  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta != null && handleChild == null) {
          if (details.primaryDelta! < -8 &&
              quranCtrl.getNavBarType(NavBarType.none).value) {
            Future.delayed(const Duration(milliseconds: 10), () {
              quranCtrl.state.isPlayExpanded.value = true;
            });
          } else if (details.primaryDelta! > 8) {
            quranCtrl.state.isPlayExpanded.value = false;
          }
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return FlexibleSheet(
            maxHeight: context.customOrientation(
              constraints.maxHeight - 150,
              constraints.maxHeight - 70,
            ),
            minHeight: 0,
            initialHeight: 0,
            alignment: context.customOrientation(
              Alignment.bottomCenter,
              AlignmentDirectional.bottomStart,
            ),
            width: context.customOrientation(Get.width, Get.width * 0.5),
            isDraggable: false,
            direction: SheetDirection.bottomToTop,
            snapBehavior: SheetSnapBehavior.snapToEdge,
            controller: quranCtrl.state.navBarController,
            onStateChanged: (state) {
              if (quranCtrl.state.navBarType.value == NavBarType.none) {
                quranCtrl.state.isPlayExpanded.value = state;
                log('isOpen: $state');
              }
            },
            handleBuilder: (currentHeight) {
              final isExpanded = currentHeight >= 155;
              return Material(
                elevation: 20,
                color: Colors.transparent,
                child: Column(
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
                        AnimatedSize(
                          alignment: Alignment.bottomCenter,
                          duration: const Duration(milliseconds: 200),
                          child: Obx(
                            () => Container(
                              height:
                                  handleHeight ??
                                  (quranCtrl.state.isPlayExpanded.value
                                      ? 170
                                      : 53),
                              width: Get.width,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                                color: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
                              ),
                              child:
                                  handleChild ??
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: ContainerButton(
                                          onPressed: () {
                                            isExpanded
                                                ? quranCtrl.setNavBarType =
                                                      NavBarType.none
                                                : quranCtrl.setNavBarType =
                                                      NavBarType.surahList;
                                            quranCtrl.state.navBarController
                                                .toggle();
                                            quranCtrl
                                                    .state
                                                    .isPlayExpanded
                                                    .value =
                                                false;
                                          },
                                          svgHeight: 35,
                                          svgWidth: 35,
                                          horizontalMargin: 4.0,
                                          verticalMargin: 5.0,
                                          svgColor: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          backgroundColor: Colors.transparent,
                                          svgWithColorPath:
                                              isExpanded &&
                                                  quranCtrl
                                                      .getNavBarType(
                                                        NavBarType.surahList,
                                                      )
                                                      .value
                                              ? SvgPath.svgHomeClose
                                              : SvgPath.svgHomeSurahList,
                                        ),
                                      ),
                                      Flexible(
                                        flex: 12,
                                        child: GetBuilder<GeneralController>(
                                          id: 'showControl',
                                          builder: (generalCtrl) =>
                                              generalCtrl
                                                      .state
                                                      .isShowControl
                                                      .value ||
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
                                        child: ContainerButton(
                                          onPressed: () {
                                            isExpanded
                                                ? quranCtrl.setNavBarType =
                                                      NavBarType.none
                                                : quranCtrl.setNavBarType =
                                                      NavBarType.bookmarkList;
                                            quranCtrl.state.navBarController
                                                .toggle();
                                            quranCtrl
                                                    .state
                                                    .isPlayExpanded
                                                    .value =
                                                false;
                                          },
                                          svgHeight: 35,
                                          svgWidth: 35,
                                          horizontalMargin: 4.0,
                                          verticalMargin: 5.0,
                                          backgroundColor: Colors.transparent,
                                          svgColor:
                                              context.theme.colorScheme.primary,
                                          svgWithColorPath:
                                              isExpanded &&
                                                  quranCtrl
                                                      .getNavBarType(
                                                        NavBarType.bookmarkList,
                                                      )
                                                      .value
                                              ? SvgPath.svgHomeClose
                                              : SvgPath.svgHomeBookmarkList,
                                        ),
                                      ),
                                    ],
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            childBuilder: (currentHeight) {
              if (quranCtrl.getNavBarType(NavBarType.surahList).value) {
                return Material(
                  elevation: 20,
                  color: Colors.transparent,
                  child: bodyChild ?? SurahJuzList(),
                );
              } else {
                return const Material(
                  elevation: 20,
                  color: Colors.transparent,
                  child: KhatmahBookmarksScreen(),
                );
              }
            },
          );
        },
      ),
    );
  }
}
