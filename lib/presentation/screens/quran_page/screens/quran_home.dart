part of '../quran.dart';

class QuranHome extends StatelessWidget {
  QuranHome({Key? key}) : super(key: key);

  final audioCtrl = AudioController.instance;
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
    GlobalKeyManager().resetDrawerKey();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) {
        if (didPop) {
          return;
        }
        NotificationManager().updateBookProgress(
            'quran'.tr,
            'notifyQuranBody'.trParams({
              'currentPageNumber':
                  '${quranCtrl.state.currentPageNumber.value}'.convertNumbers()
            }),
            quranCtrl.state.currentPageNumber.value);
        quranCtrl.state.selectedAyahIndexes.clear();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SafeArea(
          child: SliderDrawer(
            key: GlobalKeyManager().drawerKey,
            splashColor: Theme.of(context).colorScheme.primaryContainer,
            slideDirection: alignmentLayout(
                SlideDirection.RIGHT_TO_LEFT, SlideDirection.LEFT_TO_RIGHT),
            sliderOpenSize: 300.0,
            isCupertino: true,
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
                      child: Center(
                        child: ScreenSwitch(),
                      )),
                  Obx(() => generalCtrl.state.isShowControl.value
                      ? TabBarWidget(
                          isFirstChild: true,
                          isCenterChild: true,
                          isQuranSetting: true,
                          isNotification: false,
                          centerChild: Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: OpenContainerWrapper(
                              transitionType: QuranSearchController
                                  .instance.state.transitionType,
                              closedBuilder:
                                  (BuildContext _, VoidCallback openContainer) {
                                return SearchBarWidget(
                                    openContainer: openContainer);
                              },
                            ),
                          ),
                        )
                      : const SizedBox.shrink()),
                  Obx(() => audioCtrl.state.isStartPlaying.value ||
                          generalCtrl.state.isShowControl.value
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: AudioWidget(),
                        )
                      : const SizedBox.shrink()),
                  Obx(() => generalCtrl.state.isShowControl.value
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: NavBarWidget(),
                        )
                      : const SizedBox.shrink()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
