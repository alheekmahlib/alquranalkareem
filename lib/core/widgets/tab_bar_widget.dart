import 'package:flexible_sheet/flexible_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/bottom_sheet_extension.dart';
import '/core/utils/constants/svg_constants.dart';
import '/presentation/screens/home/home_screen.dart';
import '/presentation/screens/quran_page/widgets/search/controller/quran_search_controller.dart';
import '../../presentation/screens/books/books.dart';
import '../../presentation/screens/quran_page/quran.dart';
import '../services/services_locator.dart';
import '../utils/constants/extensions/extensions.dart';
import 'container_button.dart';
import 'local_notification/notification_screen.dart';
import 'local_notification/widgets/notification_icon_widget.dart';
import 'settings_list.dart';

enum TopBarType { none, search, settings }

class TopBarWidget extends StatelessWidget {
  final bool isHomeChild;
  final Widget? centerChild;
  final bool? isQuranSetting;
  final bool isNotification;
  final bool? isCalendarSetting;
  final void Function()? settingOnTap;
  final bool? isDraggable;
  final Widget? bodyChild;
  final bool? isBackButton;
  final Color? squareColor;
  final FlexibleSheetController tabBarController;
  TopBarWidget({
    super.key,
    required this.isHomeChild,
    this.centerChild,
    this.isQuranSetting,
    required this.isNotification,
    this.settingOnTap,
    this.isCalendarSetting = false,
    this.isDraggable = true,
    this.bodyChild,
    this.isBackButton = false,
    this.squareColor,
    required this.tabBarController,
  });

  final quranCtrl = QuranController.instance;
  final booksCtrl = BooksController.instance;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FlexibleSheet(
          maxHeight: context.customOrientation(
            constraints.maxHeight - 150,
            constraints.maxHeight - 70,
          ),
          minHeight: 0,
          initialHeight: 0,
          isDraggable: isDraggable ?? true,
          alignment: context.customOrientation(
            Alignment.topCenter,
            AlignmentDirectional.topEnd,
          ),
          width: context.customOrientation(Get.width, Get.width * 0.5),
          direction: SheetDirection.topToBottom,
          snapBehavior: SheetSnapBehavior.snapToEdge,
          controller: tabBarController,
          onStateChanged: (state) {
            if (!tabBarController.isOpen) {
              quranCtrl.state.topBarType.value = TopBarType.none.name;
              // أعد ضبط وضع AI عند إغلاق الـ sheet.
              final searchCtrl = QuranSearchController.instance;
              if (searchCtrl.state.isAiMode.value) {
                searchCtrl.state.isAiMode.value = false;
                searchCtrl.state.searchTextEditing.clear();
              }
            } else {
              quranCtrl.state.isPlayExpanded.value = false;
            }
          },
          handleBuilder: (currentHeight) {
            final isExpanded = currentHeight >= 155;
            return Column(
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        height: 62,
                        width: 62,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                          color:
                              squareColor ??
                              Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        height: 62,
                        width: 62,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                          color:
                              squareColor ??
                              Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    Container(
                      height: 53,
                      width: Get.width,
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: isHomeChild
                                ? Obx(() {
                                    // فقط في وضع بحث القرآن: اعرض زر التبديل لـ AI
                                    // بدل زر Home لاستغلال المساحة.
                                    if (quranCtrl.getTopBarType(
                                      TopBarType.search,
                                    )) {
                                      return _buildAiToggleButton(context);
                                    }
                                    // if (booksCtrl.getTopBarType(
                                    //   TopBarType.search,
                                    // )) {
                                    //   return _buildAiToggleButton(context);
                                    // }
                                    // وإلا: زر Home الأصلي كما هو.
                                    return ContainerButton(
                                      onPressed: () async {
                                        if (isBackButton ?? false) {
                                          quranCtrl.setTopBarType =
                                              TopBarType.none;
                                          Get.back();
                                          return;
                                        }
                                        quranCtrl.setTopBarType =
                                            TopBarType.none;
                                        Get.offAll(
                                          () => const HomeScreen(),
                                          transition: Transition.upToDown,
                                        );
                                        sl<QuranController>()
                                            .state
                                            .selectedAyahIndexes
                                            .clear();
                                      },
                                      svgHeight: 35,
                                      svgWidth: 35,
                                      horizontalMargin: 4.0,
                                      verticalMargin: 5.0,
                                      backgroundColor: Colors.transparent,
                                      svgColor:
                                          context.theme.colorScheme.primary,
                                      svgWithColorPath: isBackButton ?? false
                                          ? SvgPath.svgHomeArrowBack
                                          : SvgPath.svgHomeHome,
                                    );
                                  })
                                : isNotification
                                ? FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: ContainerButton(
                                      onPressed: () => customBottomSheet(
                                        NotificationsScreen(),
                                      ),
                                      svgHeight: 35,
                                      svgWidth: 35,
                                      horizontalMargin: 6.0,
                                      verticalMargin: 12.0,
                                      backgroundColor: Colors.transparent,
                                      child: const NotificationIconWidget(
                                        iconHeight: 30,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          Expanded(
                            flex: 12,
                            child: centerChild != null
                                ? centerChild!
                                : SizedBox(width: Get.width),
                          ),
                          Expanded(
                            flex: 2,
                            child: ContainerButton(
                              onPressed:
                                  settingOnTap ??
                                  () {
                                    quranCtrl.setTopBarType =
                                        TopBarType.settings;
                                    tabBarController.toggle();
                                    quranCtrl.state.isPlayExpanded.value =
                                        false;
                                  },
                              svgHeight: 35,
                              svgWidth: 35,
                              horizontalMargin: 4.0,
                              verticalMargin: 4.0,
                              backgroundColor: Colors.transparent,
                              svgColor: context.theme.colorScheme.primary,
                              svgWithColorPath: isExpanded
                                  ? SvgPath.svgHomeClose
                                  : SvgPath.svgHomeSetting,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 8,
                  width: 350,
                  margin: const EdgeInsets.symmetric(horizontal: 62.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: squareColor ?? Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            );
          },
          childBuilder: (currentHeight) {
            if (quranCtrl.getTopBarType(TopBarType.search)) {
              return Material(
                elevation: 8,
                color: Colors.transparent,
                child: bodyChild ?? QuranSearch(),
              );
            } else {
              return Material(
                elevation: 8,
                color: Colors.transparent,
                child: SettingsList(
                  isQuranSetting: isQuranSetting,
                  isCalendarSetting: isCalendarSetting,
                ),
              );
            }
          },
        );
      },
    );
  }

  /// زر التبديل بين البحث العادي والـ AI — يظهر فقط في وضع بحث القرآن.
  Widget _buildAiToggleButton(BuildContext context) {
    final searchCtrl = QuranSearchController.instance;
    return Obx(() {
      final isAi =
          searchCtrl.state.isAiMode.value || booksCtrl.state.isAiMode.value;
      return ContainerButton(
        onPressed: () {
          searchCtrl.state.isAiMode.value = !isAi;
          booksCtrl.state.isAiMode.value = !isAi;
          // امسح حقل البحث عند التبديل لتفادي نتائج مختلطة.
          searchCtrl.state.searchTextEditing.clear();
          searchCtrl.state.ayahList.clear();
          searchCtrl.state.surahList.clear();
        },
        svgHeight: 35,
        svgWidth: 35,
        horizontalMargin: 4.0,
        verticalMargin: 5.0,
        backgroundColor: Colors.transparent,
        svgColor: isAi
            ? context.theme.colorScheme.primary
            : context.theme.colorScheme.primary.withValues(alpha: 0.5),
        svgWithColorPath: SvgPath.svgHomeAiMcp,
      );
    });
  }
}
