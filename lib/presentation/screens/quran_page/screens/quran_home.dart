part of '../quran.dart';

class QuranHome extends StatelessWidget {
  QuranHome({Key? key}) : super(key: key);

  final audioCtrl = AudioCtrl.instance;
  final generalCtrl = GeneralController.instance;
  final bookmarkCtrl = BookmarksController.instance;
  final quranCtrl = QuranController.instance;
  final searchCtrl = QuranSearchController.instance;

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
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Center(child: QuranPages()),
                ),
                // GetBuilder<GeneralController>(
                //   id: 'showControl',
                //   builder: (generalCtrl) =>
                //       generalCtrl.state.isShowControl.value
                //       ? const QuranOrTenRecitationsTabBar()
                //       : const SizedBox.shrink(),
                // ),
                GetBuilder<GeneralController>(
                  id: 'showControl',
                  builder: (generalCtrl) =>
                      generalCtrl.state.isShowControl.value
                      ? Stack(
                          children: [
                            DisplayModeBar(
                              isDark: themeCtrl.isDarkMode,
                              languageCode: Get.locale!.languageCode,
                              style: quranCtrl.displayModeBarStyle,
                            ),
                            QuranOrTenRecitationsTabBar(),
                            TopBarWidget(
                              isHomeChild: true,
                              isQuranSetting: true,
                              isNotification: false,
                              centerChild: TextFieldBarWidget(
                                controller: searchCtrl.state.searchTextEditing,
                                horizontalPadding: 0.0,
                                onPressed: () {
                                  quranCtrl.setTopBarType = TopBarType.search;
                                  quranCtrl.state.tabBarController.open();
                                },
                                onButtonPressed: () {
                                  searchCtrl.state.searchTextEditing.clear();
                                  searchCtrl.state.ayahList.clear();
                                  searchCtrl.state.surahList.clear();
                                },
                                onChanged: (query) {
                                  if (searchCtrl
                                          .state
                                          .searchTextEditing
                                          .text
                                          .isNotEmpty ||
                                      query.trim().isNotEmpty) {
                                    searchCtrl.surahSearchMethod(query);
                                    searchCtrl.search(query);
                                  } else {
                                    searchCtrl.state.searchTextEditing.clear();
                                    searchCtrl.state.ayahList.clear();
                                    searchCtrl.state.surahList.clear();
                                  }
                                },
                                onSubmitted: (query) {
                                  if (query.length <= 0 ||
                                      query.trim().isNotEmpty) {
                                    searchCtrl.addSearchItem(query);
                                  }
                                  // await sl<QuranSearchControllers>().addSearchItem(query);
                                  // searchCtrl.textSearchController.clear();
                                },
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: NavBarWidget(),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
