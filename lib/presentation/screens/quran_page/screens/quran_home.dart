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
    // if (quranCtrl.state.tabBarController.isHandleVisible) {
    //   quranCtrl.state.tabBarController.toggle();
    // }
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, _) async {
        if (didPop) {
          return;
        }
        // await HomeWidgetService.instance.updateReadingProgress();
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
                            const QuranTopBar(),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TajweedMenuWidget(),
                            ),
                            TopBarWidget(
                              isHomeChild: true,
                              isQuranSetting: true,
                              isNotification: false,
                              tabBarController:
                                  quranCtrl.state.tabBarController,
                              // في وضع AI: اعرض AssistantView + ModelSelector بدل QuranSearch.
                              bodyChild: Obx(() {
                                if (searchCtrl.state.isAiMode.value) {
                                  return AiBodyWidget();
                                }
                                return QuranSearch();
                              }),
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
                                  // امسح محادثة المساعد أيضاً إن كانت نشطة.
                                  if (searchCtrl.state.isAiMode.value) {
                                    AiSearchController.instance
                                        .clearConversation();
                                  }
                                },
                                onChanged: (query) {
                                  // في وضع AI: لا بحث مباشر (الإرسال عند Enter فقط).
                                  if (searchCtrl.state.isAiMode.value) return;
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
                                  // في وضع AI: أرسل للمساعد الذكي.
                                  if (searchCtrl.state.isAiMode.value) {
                                    if (query.trim().isNotEmpty) {
                                      AiSearchController.instance.sendMessage(
                                        query,
                                      );
                                      searchCtrl.state.searchTextEditing
                                          .clear();
                                    }
                                    return;
                                  }
                                  if (query.length <= 0 ||
                                      query.trim().isNotEmpty) {
                                    searchCtrl.addSearchItem(query);
                                  }
                                },
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: NavBarWidget(
                                navBarController:
                                    quranCtrl.state.navBarController,
                              ),
                            ),
                            // const AutoScrollSpeedSliderWidget(),
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

  /// يبني جسم وضع AI: شريط اختيار النموذج + واجهة المساعد.
  // Widget _buildAiBody(BuildContext context) {
  //   final ctrl = AiSearchController.instance;
  //   // اضبط وضع المساعد في AiSearchController ليقرأه AssistantView.
  //   ctrl.state.midasMode.value = MidasMode.assistant;
  //   return Container(
  //     height: Get.height,
  //     width: Get.width,
  //     color: context.theme.colorScheme.primaryContainer,
  //     child: SafeArea(
  //       child: Column(
  //         children: [
  //           // واجهة المساعد الموحَّد (المحادثة + مؤشر التفكير + أزرار النسخ).
  //           Expanded(
  //             child: UnifiedAssistantView(
  //               isInMidad: false,
  //               iconColor: context.theme.primaryColorLight,
  //               textColor: context.theme.colorScheme.inversePrimary,
  //             ),
  //           ),
  //           // شريط اختيار النموذج (ModelSelectorWidget من ai_search).
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //             child: Row(
  //               mainAxisAlignment: .spaceBetween,
  //               children: [
  //                 // سجل المحادثة — يظهر في الوضعين (موحّد).
  //                 CustomButton(
  //                   // tooltip: 'newChat'.tr,
  //                   onPressed: () =>
  //                       customBottomSheet(const ChatHistorySheet()),
  //                   isCustomSvgColor: true,
  //                   svgPath: SvgPath.svgHomeHistory,
  //                   svgColor: context.theme.primaryColorLight,
  //                 ),
  //                 ModelSelectorWidget(
  //                   textColor: context.theme.colorScheme.inversePrimary,
  //                   backgroundColor: context.theme.primaryColorLight,
  //                 ),
  //                 CustomButton(
  //                   // tooltip: 'newChat'.tr,
  //                   onPressed: () => ctrl.clearConversation(),
  //                   isCustomSvgColor: true,
  //                   svgPath: SvgPath.svgHomeNewChat,
  //                   svgColor: context.theme.primaryColorLight,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
