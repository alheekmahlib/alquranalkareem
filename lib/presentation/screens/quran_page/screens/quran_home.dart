import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/alignment_rotated_extension.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/helpers/global_key_manager.dart';
import '../../../../core/widgets/tab_bar_widget.dart';
import '../../../../database/notificationDatabase.dart';
import '../../../controllers/general/general_controller.dart';
import '../controllers/audio/audio_controller.dart';
import '../controllers/aya_controller.dart';
import '../controllers/bookmarks_controller.dart';
import '../controllers/quran/quran_controller.dart';
import '../widgets/audio/audio_widget.dart';
import '../widgets/pages/nav_bar_widget.dart';
import '../widgets/screen_switch.dart';
import '../widgets/search/search_bar.dart';
import '../widgets/surah_juz_list.dart';

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
    NotificationDatabaseHelper.loadNotifications();
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
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
                          centerChild: Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: OpenContainerWrapper(
                              transitionType:
                                  sl<AyaController>().transitionType,
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
