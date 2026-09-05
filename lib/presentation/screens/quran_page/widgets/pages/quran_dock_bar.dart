part of '../../quran.dart';

/// أنواع محتوى الشريط السفلي الموسّع.
enum NavBarType { none, surahList, bookmarkList }

/// الشريط السفلي العائم لصفحة القرآن — بديل [NavBarWidget] السابق بنفس
/// الميزات تمامًا (زر قائمة السور/الأجزاء، الخانة المركزية للصوت أو
/// التسميع، زر العلامات، والتوسيع للقائمتين) وبتصميم عصري: حاوية عائمة
/// بزوايا مستديرة وظل ناعم وحركات ضمنية (ارتفاع متحرك، مقبض متفاعل،
/// وانتقال بين وضعي الصوت والتسميع). كل الألوان من ثيم colorScheme —
/// لا ألوان صلبة. الويدجت Stateless.
class QuranDockBar extends StatelessWidget {
  QuranDockBar({
    super.key,
    this.bodyChild,
    this.handleChild,
    this.handleHeight,
    required this.navBarController,
  });

  final Widget? bodyChild;
  final Widget? handleChild;
  final double? handleHeight;
  final FlexibleSheetController navBarController;

  final generalCtrl = GeneralController.instance;
  final quranCtrl = QuranController.instance;
  final tasmee = TasmeeCtrl.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (quranCtrl.state.tabBarController.isOpen) {
          quranCtrl.state.isPlayExpanded.value = false;
          return;
        }
        // في وضع التسميع لا يوجد شريط صوت قابل للتوسيع.
        if (tasmee.state.isTasmeeMode.value) return;
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
            controller: navBarController,
            onStateChanged: (state) {
              if (quranCtrl.state.navBarType.value == NavBarType.none &&
                  !tasmee.state.isTasmeeMode.value) {
                quranCtrl.state.isPlayExpanded.value = state;
              }
            },
            handleBuilder: (currentHeight) =>
                _buildDock(context, currentHeight),
            childBuilder: (currentHeight) {
              if (quranCtrl.getNavBarType(NavBarType.surahList).value) {
                return Material(
                  elevation: 20,
                  color: Colors.transparent,
                  child: bodyChild ?? SurahJuzList(),
                );
              } else {
                return Material(
                  elevation: 20,
                  color: Colors.transparent,
                  child: BookmarksList(),
                );
              }
            },
          );
        },
      ),
    );
  }

  /// الرصيف العائم: مقبض متفاعل فوق حاوية مستديرة بظل ناعم وحد خفيف.
  Widget _buildDock(BuildContext context, double currentHeight) {
    final isExpanded = currentHeight >= 155;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildHandlePill(context, isExpanded),
        const Gap(6),
        Material(
          elevation: 12,
          shadowColor: Theme.of(
            context,
          ).colorScheme.primary.withValues(alpha: .30),
          borderRadius: BorderRadius.circular(24),
          color: Colors.transparent,
          child: Obx(
            () => AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              height:
                  handleHeight ??
                  (quranCtrl.state.isPlayExpanded.value ? 170 : 56),
              width: Get.width,
              margin: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: .12),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: handleChild ?? _buildDockRow(context, isExpanded),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// مقبض السحب — يضيق ويشفّ عند التوسيع كإحساس حركي خفيف.
  Widget _buildHandlePill(BuildContext context, bool isExpanded) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      height: 5,
      width: isExpanded ? 40 : 56,
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: isExpanded ? .45 : .8),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  /// صف أزرار الرصيف: قائمة السور | الخانة المركزية | العلامات.
  Widget _buildDockRow(BuildContext context, bool isExpanded) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: ContainerButton(
            onPressed: () {
              isExpanded
                  ? quranCtrl.setNavBarType = NavBarType.none
                  : quranCtrl.setNavBarType = NavBarType.surahList;
              navBarController.toggle();
              quranCtrl.state.isPlayExpanded.value = false;
            },
            svgHeight: 32,
            svgWidth: 32,
            horizontalMargin: 6.0,
            verticalMargin: 6.0,
            svgColor: context.theme.colorScheme.primary,
            backgroundColor: Colors.transparent,
            svgWithColorPath:
                isExpanded &&
                    quranCtrl.getNavBarType(NavBarType.surahList).value
                ? SvgPath.svgHomeClose
                : SvgPath.svgHomeSurahList,
          ),
        ),
        Flexible(flex: 12, child: _buildCenterSlot()),
        // في وضع التسميع يُخفى زر العلامات ويبقى مكانه للحفاظ على التوازن.
        tasmee.state.isTasmeeMode.value
            ? const SizedBox.shrink()
            : Expanded(
                flex: 2,
                child: ContainerButton(
                  onPressed: () {
                    isExpanded
                        ? quranCtrl.setNavBarType = NavBarType.none
                        : quranCtrl.setNavBarType = NavBarType.bookmarkList;
                    navBarController.toggle();
                    quranCtrl.state.isPlayExpanded.value = false;
                  },
                  svgHeight: 32,
                  svgWidth: 32,
                  horizontalMargin: 6.0,
                  verticalMargin: 6.0,
                  backgroundColor: Colors.transparent,
                  svgColor: context.theme.colorScheme.primary,
                  svgWithColorPath:
                      isExpanded &&
                          quranCtrl.getNavBarType(NavBarType.bookmarkList).value
                      ? SvgPath.svgHomeClose
                      : SvgPath.svgHomeBookmarkList,
                ),
              ),
      ],
    );
  }

  /// الخانة المركزية — تنتقل بحركة تلاشٍ وانزلاق خفيف بين الصوت والتسميع
  /// وتختفي نظيفة عند إخفاء عناصر التحكم.
  Widget _buildCenterSlot() {
    return GetBuilder<GeneralController>(
      id: 'showControl',
      builder: (generalCtrl) {
        final show =
            generalCtrl.state.isShowControl.value ||
            generalCtrl.state.showAudioWidgetTemporarily.value;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          layoutBuilder: (currentChild, previousChildren) => Stack(
            alignment: Alignment.center,
            children: [
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          ),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, .3),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: !show
              ? const SizedBox.shrink(key: ValueKey('dock-hidden'))
              : tasmee.state.isTasmeeMode.value
              ? TasmeeBarWidget(key: const ValueKey('dock-tasmee'))
              : AudioWidget(key: const ValueKey('dock-audio')),
        );
      },
    );
  }
}
