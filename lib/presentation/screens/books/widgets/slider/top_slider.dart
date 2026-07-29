part of '../../books.dart';

class TopSlider extends StatelessWidget {
  // متغير يحدد إذا كان السلايدر ظاهر أم لا
  // Determines if the slider is visible
  final bool isVisible;
  final VoidCallback onClose;
  final Widget child;
  final Widget contentChild;
  final Function(DragUpdateDetails)? onVerticalDragUpdate;

  TopSlider({
    super.key,
    required this.isVisible,
    required this.onClose,
    required this.child,
    required this.contentChild,
    this.onVerticalDragUpdate,
  });
  // الحصول على الكونترولر الخاص بالسلايدر
  // Get the slider controller
  final sliderCtrl = SliderCtrl.instance;

  @override
  Widget build(BuildContext context) {
    // تحديث حالة الظهور عند كل بناء
    // Update visibility state on every build
    sliderCtrl.updateVisibility(isVisible);

    if (!isVisible) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.topCenter,
      child: SlideTransition(
        position: sliderCtrl.slideAnim,
        // استخدام Obx لمراقبة تغيير الارتفاع مع الأنيميشن
        // Use Obx to observe height changes with animation
        child: Container(
          // استخدام الارتفاع المتحرك للسلايدر العلوي
          // Use animated height for top slider
          decoration: BoxDecoration(
            color: context.theme.colorScheme.primary,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 32,
                offset: Offset(0, 12),
              ),
              BoxShadow(
                color: Color(0x26000000),
                blurRadius: 20,
                offset: Offset(0, 8),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              child,
              contentChild,
              // ====== Handle للسحب ======
              // ====== Drag Handle ======
              GestureDetector(
                // عند السحب للأسفل يفتح السلايدر، وعند السحب للأعلى يغلق
                // On vertical drag: down opens, up closes
                onVerticalDragUpdate: (details) {
                  if (details.primaryDelta != null) {
                    if (details.primaryDelta! > 8) {
                      // سحب للأسفل: فتح السلايدر
                      // Drag down: open
                      // sliderCtrl.showSettingsScreen();
                    } else if (details.primaryDelta! < -8) {
                      // سحب للأعلى: إغلاق السلايدر
                      // Drag up: close
                      // onClose();
                      sliderCtrl.topContentType.value = 'none';
                      onVerticalDragUpdate?.call(details);
                      sliderCtrl.setTopSmallHeight();
                    }
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    RotatedBox(
                      quarterTurns: 2,
                      child: customSvgWithColor(
                        SvgPath.svgHomeClose,
                        width: 120,
                        color: context.theme.canvasColor,
                      ),
                    ),
                    Container(
                      width: 70,
                      height: 4,
                      decoration: BoxDecoration(
                        color: context.theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
