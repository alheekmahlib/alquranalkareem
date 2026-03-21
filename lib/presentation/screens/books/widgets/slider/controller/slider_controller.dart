// SearchSliderController
// هذا الكونترولر خاص بإدارة حالة السلايدر الخاص بالبحث في القرآن
// This controller manages the state and animation of the Quran search slider.

part of '../../../books.dart';

class SliderCtrl extends GetxController with GetTickerProviderStateMixin {
  static SliderCtrl get instance => Get.isRegistered<SliderCtrl>()
      ? Get.find<SliderCtrl>()
      : Get.put<SliderCtrl>(SliderCtrl());
  // متحكم الأنيميشن
  // Animation controller
  late AnimationController controller;
  // أنيميشن السلايدر
  // Slider animation
  late Animation<Offset> slideAnim;

  // حالة ظهور السلايدر
  // Slider visibility state
  final RxBool isVisible = false.obs;

  // ارتفاع السلايدر العلوي (نسبة من ارتفاع الشاشة)
  // Top slider height (percentage of screen height)
  final RxDouble topSliderHeight = 0.1.obs; // 40% من الشاشة افتراضياً

  // متحكم أنيميشن الارتفاع للسلايدر العلوي
  // Height animation controller for top slider
  late AnimationController topHeightController;
  // أنيميشن الارتفاع للسلايدر العلوي
  // Height animation for top slider
  late Animation<double> topHeightAnimation;

  // متحكم الأنيميشن للسلايدر السفلي
  // Animation controller for bottom slider
  late AnimationController bottomController;
  // أنيميشن السلايدر السفلي
  // Bottom slider animation
  late Animation<Offset> bottomSlideAnim;

  // حالة ظهور السلايدر السفلي
  // Bottom slider visibility state
  final RxBool isBottomVisible = false.obs;

  // نوع المحتوى المعروض في السلايدر السفلي
  // Type of content displayed in bottom slider
  final RxString bottomContentType = 'none'.obs;
  final RxString topContentType = 'none'.obs;

  // ارتفاع السلايدر السفلي (نسبة من ارتفاع الشاشة)
  // Bottom slider height (percentage of screen height)
  final RxDouble bottomSliderHeight = 0.1.obs; // 60% من الشاشة افتراضياً

  // متحكم أنيميشن الارتفاع
  // Height animation controller
  late AnimationController heightController;
  // أنيميشن الارتفاع
  // Height animation
  late Animation<double> heightAnimation;

  // تهيئة الكونترولر
  // Initialize controller
  @override
  void onInit() {
    super.onInit();
    // السلايدر العلوي - ينزل من الأعلى
    // Top slider - slides down from top
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
    );
    slideAnim = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    // السلايدر السفلي - يصعد من الأسفل
    // Bottom slider - slides up from bottom
    bottomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
    );
    bottomSlideAnim = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: bottomController, curve: Curves.easeOut));

    // متحكم أنيميشن الارتفاع - للتحكم في ارتفاع السلايدر السفلي
    // Height animation controller - for bottom slider height control
    heightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
    );

    // تهيئة أنيميشن الارتفاع مع القيمة الابتدائية
    // Initialize height animation with initial value
    heightAnimation =
        Tween<double>(
          begin: bottomSliderHeight.value,
          end: bottomSliderHeight.value,
        ).animate(
          CurvedAnimation(parent: heightController, curve: Curves.easeInOut),
        );

    // ربط الأنيميشن بالقيمة الفعلية
    // Link animation to actual value
    heightAnimation.addListener(() {
      bottomSliderHeight.value = heightAnimation.value;
    });

    // متحكم أنيميشن الارتفاع - للتحكم في ارتفاع السلايدر العلوي
    // Height animation controller - for top slider height control
    topHeightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
    );

    // تهيئة أنيميشن الارتفاع للسلايدر العلوي مع القيمة الابتدائية
    // Initialize top height animation with initial value
    topHeightAnimation =
        Tween<double>(
          begin: topSliderHeight.value,
          end: topSliderHeight.value,
        ).animate(
          CurvedAnimation(parent: topHeightController, curve: Curves.easeInOut),
        );

    // ربط الأنيميشن بالقيمة الفعلية للسلايدر العلوي
    // Link animation to actual value for top slider
    topHeightAnimation.addListener(() {
      topSliderHeight.value = topHeightAnimation.value;
    });

    log('SliderController initialized', name: 'SliderController');
  }

  // تحديث حالة الظهور
  // Update visibility state
  void updateVisibility(bool visible) {
    isVisible.value = visible;
    if (visible) {
      controller.forward();
    } else {
      controller.reverse();
    }
    log('Slider visibility updated: $visible', name: 'SearchSliderController');
  }

  void updateHandleVisibility(bool visible) {
    if (visible) {
      controller.forward();
    } else {
      controller.reverse();
    }
    log('Slider visibility updated: $visible', name: 'SearchSliderController');
  }

  // تحديث حالة ظهور السلايدر السفلي
  // Update bottom slider visibility state
  void updateBottomVisibility(bool visible) {
    isBottomVisible.value = visible;
    if (visible) {
      bottomController.forward();
    } else {
      bottomController.reverse();
    }
    log(
      'Bottom slider visibility updated: $visible',
      name: 'SearchSliderController',
    );
  }

  // تحديث حالة ظهور السلايدر السفلي مع تنظيف البيانات
  // Update bottom slider visibility state with data cleanup
  void updateBottomHandleVisibility(bool visible) {
    if (visible) {
      bottomController.forward();
    } else {
      bottomController.reverse();
    }
    log('Bottom slider visibility updated: $visible', name: 'SliderController');
  }

  // إخفاء السلايدر مع أنيميشن وانتظار الانتهاء
  // Hide slider with animation and wait for completion
  Future<void> hideWithAnimation() async {
    // بدء أنيميشن الإخفاء
    // Start hide animation
    await controller.reverse();
    // تحديث حالة الظهور بعد انتهاء الأنيميشن
    // Update visibility state after animation completes
    isVisible.value = false;
    log('Slider hidden with animation', name: 'SliderController');
  }

  // إخفاء السلايدر السفلي مع أنيميشن وانتظار الانتهاء
  // Hide bottom slider with animation and wait for completion
  Future<void> hideBottomWithAnimation() async {
    // بدء أنيميشن الإخفاء
    // Start hide animation
    await bottomController.reverse();
    // تحديث حالة الظهور بعد انتهاء الأنيميشن
    // Update visibility state after animation completes
    isBottomVisible.value = false;
    log('Bottom slider hidden with animation', name: 'SliderController');
  }

  // إظهار/إخفاء SurahJuzList في السلايدر السفلي (toggle)
  // Show/Hide SurahJuzList in bottom slider (toggle)
  void showSurahJuzList() {
    if (bottomContentType.value == 'surah_juz') {
      // إذا كان نفس المحتوى ظاهر، أخفيه
      // If same content is showing, hide it
      bottomContentType.value = 'none';
      setSmallHeight();
    } else {
      // إظهار المحتوى الجديد
      // Show new content
      bottomContentType.value = 'surah_juz';
      setLargeHeight(); // ارتفاع كبير لقائمة السور
      updateBottomVisibility(true);
    }
    log('Toggled SurahJuzList in bottom slider', name: 'SliderController');
  }

  // إظهار/إخفاء KhatmasScreen في السلايدر السفلي (toggle)
  // Show/Hide KhatmasScreen in bottom slider (toggle)
  void showKhatmasScreen() {
    if (bottomContentType.value == 'khatmas') {
      // إذا كان نفس المحتوى ظاهر، أخفيه
      // If same content is showing, hide it
      bottomContentType.value = 'none';
      setSmallHeight();
    } else {
      // إظهار المحتوى الجديد
      // Show new content
      bottomContentType.value = 'khatmas';
      setLargeHeight(); // ارتفاع كبير لشاشة الختمات
      updateBottomVisibility(true);
    }
    log('Toggled KhatmasScreen in bottom slider', name: 'SliderController');
  }

  // void showSettingsScreen() {
  //   if (topContentType.value == 'settings') {
  //     // إذا كان نفس المحتوى ظاهر، أخفيه
  //     // If same content is showing, hide it
  //     topContentType.value = 'none';
  //     setTopSmallHeight();
  //   } else {
  //     // إظهار المحتوى الجديد
  //     // Show new content
  //     topContentType.value = 'settings';
  //     setTopLargeHeight(); // ارتفاع كبير لشاشة الختمات
  //     updateHandleVisibility(true);
  //   }
  //   log('Toggled settings in top slider', name: 'SliderController');
  // }

  // إخفاء المحتوى وإعادة تعيين النوع
  // Hide content and reset type
  void hideBottomContent() {
    bottomContentType.value = 'none';
    updateBottomVisibility(false);
    log('Hiding bottom content', name: 'SliderController');
  }

  // تعديل ارتفاع السلايدر السفلي مع أنيميشن
  // Adjust bottom slider height with animation
  Future<void> setBottomSliderHeight(double heightPercentage) async {
    await animateToHeight(heightPercentage);
    log(
      'Bottom slider height animated to: ${(heightPercentage * 100).toStringAsFixed(0)}%',
      name: 'SliderController',
    );
  }

  // دالة مساعدة لأنيميشن الارتفاع مع إعداد أفضل
  // Helper function for height animation with better setup
  Future<void> animateToHeight(double targetHeight) async {
    double clampedHeight = targetHeight.clamp(0.1, 0.95);

    if ((bottomSliderHeight.value - clampedHeight).abs() < 0.01) {
      // إذا كان الفرق صغير جداً، لا حاجة للأنيميشن
      // If difference is very small, no need for animation
      return;
    }

    // إعداد الأنيميشن
    // Setup animation
    heightAnimation =
        Tween<double>(
          begin: bottomSliderHeight.value,
          end: clampedHeight,
        ).animate(
          CurvedAnimation(parent: heightController, curve: Curves.easeInOut),
        );

    // إزالة listeners السابقة لتجنب memory leaks
    // Remove previous listeners to avoid memory leaks
    heightController.removeListener(() {});

    // إضافة listener جديد
    // Add new listener
    heightAnimation.addListener(() {
      bottomSliderHeight.value = heightAnimation.value;
    });

    // تشغيل الأنيميشن
    // Run animation
    heightController.reset();
    await heightController.forward();
  }

  // ارتفاع صغير للسلايدر (40%)
  // Small height for slider (40%)
  void setSmallHeight() => setBottomSliderHeight(0.1);

  // ارتفاع متوسط للسلايدر (60%)
  // Medium height for slider (60%)
  void setMediumHeight() =>
      setBottomSliderHeight(Get.context!.customOrientation(0.23, 0.4));

  // ارتفاع كبير للسلايدر (80%)
  // Large height for slider (80%)
  void setLargeHeight() => setBottomSliderHeight(0.8);

  // ارتفاع كامل للسلايدر (90%)
  // Full height for slider (90%)
  void setFullHeight() => setBottomSliderHeight(0.9);

  // ==== دوال التحكم في ارتفاع السلايدر العلوي ====
  // ==== Top Slider Height Control Functions ====

  // تحديد ارتفاع السلايدر العلوي بأنيميشن
  // Set top slider height with animation
  Future<void> setTopSliderHeight(double heightPercentage) async {
    // التأكد من أن القيمة ضمن النطاق المسموح
    // Ensure value is within allowed range
    final clampedHeight = heightPercentage.clamp(0.1, 0.85);

    // إذا كانت القيمة هي نفسها القيمة الحالية، لا داعي للأنيميشن
    // If value is same as current, no need for animation
    if ((topSliderHeight.value - clampedHeight).abs() < 0.01) {
      log(
        'Top slider height already at target: $clampedHeight',
        name: 'SliderController',
      );
      return;
    }

    log(
      'Animating top slider height to: $clampedHeight',
      name: 'SliderController',
    );

    // إعداد الأنيميشن من القيمة الحالية إلى القيمة الجديدة
    // Setup animation from current value to new value
    topHeightAnimation =
        Tween<double>(begin: topSliderHeight.value, end: clampedHeight).animate(
          CurvedAnimation(parent: topHeightController, curve: Curves.easeInOut),
        );

    // إزالة listeners السابقة لتجنب memory leaks
    // Remove previous listeners to avoid memory leaks
    topHeightController.removeListener(() {});

    // إضافة listener جديد
    // Add new listener
    topHeightAnimation.addListener(() {
      topSliderHeight.value = topHeightAnimation.value;
    });

    // تشغيل الأنيميشن
    // Run animation
    topHeightController.reset();
    await topHeightController.forward();
  }

  // إخفاء السلايدر السفلي مع أنيميشن
  // Hide bottom slider with animation
  Future<void> hideBottomControl() async {
    if (isBottomVisible.value) {
      await hideBottomWithAnimation();
    }
    log('Bottom slider control hidden', name: 'QuranUi');
  }

  // إخفاء السلايدر العلوي مع أنيميشن
  // Hide top slider with animation
  Future<void> hideTopControl() async {
    if (isVisible.value) {
      await hideWithAnimation();
    }
    log('Top slider control hidden', name: 'QuranUi');
  }

  // إخفاء كلا السلايدرين مع أنيميشن
  // Hide both sliders with animation
  Future<void> hideBothSliders() async {
    // إخفاء السلايدر العلوي والسفلي بالتوازي
    // Hide top and bottom sliders in parallel
    List<Future<void>> hideAnimations = [];

    if (isVisible.value) {
      hideAnimations.add(hideWithAnimation());
    }

    if (isBottomVisible.value) {
      hideAnimations.add(hideBottomWithAnimation());
    }

    // انتظار انتهاء جميع الأنيميشنز
    // Wait for all animations to complete
    if (hideAnimations.isNotEmpty) {
      await Future.wait(hideAnimations);
    }

    log('Both sliders hidden with animation', name: 'QuranUi');
  }

  // ارتفاع صغير للسلايدر العلوي (30%)
  // Small height for top slider (30%)
  void setTopSmallHeight() => setTopSliderHeight(0.1);

  // ارتفاع متوسط للسلايدر العلوي (50%)
  // Medium height for top slider (50%)
  void setTopMediumHeight() => setTopSliderHeight(0.23);

  // ارتفاع كبير للسلايدر العلوي (70%)
  // Large height for top slider (70%)
  void setTopLargeHeight() => setTopSliderHeight(0.8);

  void setTopFullHeight() => setTopSliderHeight(0.9);

  // التخلص من الموارد
  // Dispose resources
  @override
  void onClose() {
    controller.dispose();
    bottomController.dispose();
    heightController.dispose();
    topHeightController.dispose(); // إضافة التخلص من متحكم السلايدر العلوي
    super.onClose();
    log('SearchSliderController disposed', name: 'SearchSliderController');
  }
}
