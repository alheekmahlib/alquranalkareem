part of '../quran.dart';

class QuranHome extends StatelessWidget {
  QuranHome({Key? key}) : super(key: key);

  final audioCtrl = AudioCtrl.instance;
  final generalCtrl = GeneralController.instance;
  final bookmarkCtrl = BookmarksController.instance;
  final quranCtrl = QuranController.instance;

  // bool hasUnopenedNotifications() {
  //   return sl<NotificationsController>()
  //       .sentNotifications
  //       .any((notification) => !notification['opened']);
  // }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) {
        if (didPop) {
          return;
        }
        quranCtrl.state.selectedAyahIndexes.clear();
        Get.back();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SafeArea(
          child: SliderDrawer(
            key: GlobalKeyManager().drawerKey,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            slideDirection: alignmentLayout(
              SlideDirection.rightToLeft,
              SlideDirection.leftToRight,
            ),
            sliderOpenSize: 300.0,
            isDraggable: true,
            appBar: const SizedBox.shrink(),
            slider: SurahJuzList(),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorDark,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Center(child: ScreenSwitch()),
                  ),
                  GetBuilder<GeneralController>(
                    id: 'showControl',
                    builder: (generalCtrl) =>
                        generalCtrl.state.isShowControl.value
                        ? Stack(
                            children: [
                              TabBarWidget(
                                isFirstChild: true,
                                isCenterChild: true,
                                isQuranSetting: true,
                                isNotification: false,
                                centerChild: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: OpenContainerWrapper(
                                    transitionType: QuranSearchController
                                        .instance
                                        .state
                                        .transitionType,
                                    closedBuilder:
                                        (
                                          BuildContext _,
                                          VoidCallback openContainer,
                                        ) {
                                          return SearchBarWidget(
                                            openContainer: openContainer,
                                          );
                                        },
                                  ),
                                ),
                              ),

                              Align(
                                alignment: Alignment.bottomCenter,
                                child: NavBarWidget(),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      size: 32,
                                    ),
                                    color: Theme.of(context).colorScheme.primary,
                                    style: IconButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer
                                            .withValues(alpha: 0.8)),
                                    onPressed: () => QuranLibrary
                                        .quranCtrl.quranPagesController
                                        .nextPage(
                                      duration:
                                          const Duration(milliseconds: 600),
                                      curve: Curves.easeInOut,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 32,
                                    ),
                                    color: Theme.of(context).colorScheme.primary,
                                    style: IconButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer
                                            .withValues(alpha: 0.8)),
                                    onPressed: () => QuranLibrary
                                        .quranCtrl.quranPagesController
                                        .previousPage(
                                      duration:
                                          const Duration(milliseconds: 600),
                                      curve: Curves.easeInOut,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                  GetBuilder<GeneralController>(
                    id: 'showControl',
                    builder: (generalCtrl) =>
                        generalCtrl.state.isShowControl.value ||
                            generalCtrl.state.showAudioWidgetTemporarily.value
                        ? Align(
                            alignment: Alignment.bottomCenter,
                            child: AudioWidget(),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
