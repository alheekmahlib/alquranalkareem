part of '../surah_audio.dart';

extension SurahAudioHelper on AudioCtrl {
  SurahAudioState get surahState => SurahAudioState();

  /// -------- [Getters] ----------

  RxBool isSelectedSurahIndex(int index) =>
      (AudioCtrl.instance.state.selectedSurahIndex.value == index
              ? true
              : false)
          .obs;

  SurahAudioStyle get surahAudioStyle =>
      SurahAudioStyle.defaults(
        isDark: ThemeController.instance.isDarkMode,
        context: Get.context!,
      ).copyWith(
        dialogWidth: Get.context!.customOrientation(Get.width, Get.width * .5),
        audioSliderBackgroundColor: Get.context!.theme.canvasColor,
        backgroundColor: Get.context!.theme.colorScheme.primaryContainer,
        dialogBackgroundColor: Get.context!.theme.colorScheme.primary,
        textColor: Get.context!.theme.colorScheme.inversePrimary,
        dialogCloseIconColor: Get.context!.theme.canvasColor,
        dialogHeaderTitleColor: Get.context!.theme.canvasColor,
        dialogReaderTextColor: Get.context!.theme.canvasColor,
        dialogSelectedReaderColor: Get.context!.theme.colorScheme.surface,
        dialogUnSelectedReaderColor: Get
            .context!
            .theme
            .colorScheme
            .inversePrimary
            .withValues(alpha: 0.1),
        iconColor: Get.context!.theme.colorScheme.surface,
        playIconColor: Get.context!.theme.colorScheme.surface,
        primaryColor: Get.context!.theme.colorScheme.surface,
        readerNameInItemColor: Get.context!.theme.colorScheme.surface,
        secondaryIconColor: Get.context!.theme.canvasColor,
        secondaryTextColor: Get.context!.theme.canvasColor,
        seekBarThumbColor: Get.context!.theme.colorScheme.surface,
        surahNameColor: Get.context!.theme.canvasColor,
        timeContainerColor: Get.context!.theme.colorScheme.surface,
        seekBarActiveTrackColor: Get.context!.theme.colorScheme.surface,
        seekBarInactiveTrackColor: Get.context!.theme.colorScheme.surface
            .withValues(alpha: 0.5),
        dialogHeaderBackgroundGradient: LinearGradient(
          colors: [
            Get.context!.theme.colorScheme.surface.withValues(alpha: 0.5),
            Colors.transparent,
          ],
        ),
      );

  void searchSurah(String searchInput) {
    // تنظيف النص المدخل وإزالة المسافات الزائدة
    // Clean input text and remove extra spaces
    final cleanedInput = searchInput.trim();

    if (cleanedInput.isEmpty) {
      log('Search input is empty', name: 'SurahAudioController');
      return;
    }

    final surahList = QuranCtrl.instance.state.surahs;

    int index = -1;

    // تحويل الأرقام العربية إلى إنجليزية للبحث الرقمي
    // Convert Arabic numbers to English for numeric search
    final convertedInput = cleanedInput.convertArabicToEnglishNumbers(
      cleanedInput,
    );

    if (int.tryParse(convertedInput) != null) {
      // إذا كان الإدخال رقمًا، ابحث باستخدام رقم السورة
      // If input is a number, search using surah number
      final surahNumber = int.parse(convertedInput);
      index = surahList.indexWhere((surah) => surah.surahNumber == surahNumber);
      log(
        'Searching by number: $surahNumber, found at index: $index',
        name: 'SurahAudioController',
      );
    } else {
      // إذا كان الإدخال نصًا، ابحث باستخدام اسم السورة
      // If input is text, search using surah name
      index = surahList.indexWhere(
        (surah) =>
            surah.arabicName
                .removeDiacriticsQuran(surah.arabicName)
                .contains(cleanedInput) ||
            surah.englishName.toLowerCase().contains(
              cleanedInput.toLowerCase(),
            ),
      );
      log(
        'Searching by name: "$cleanedInput", found at index: $index',
        name: 'SurahAudioController',
      );
    }

    if (index != -1) {
      log(
        'Found surah at index: $index, jumping to it',
        name: 'SurahAudioController',
      );
      AudioCtrl.instance.state.selectedSurahIndex.value = index;

      state.isSheetOpen.value = true;
      // تنقل سلس إلى السورة المختارة بعد تحديث الحالة
      // Smooth scroll to selected surah after state update
      scrollToSelectedSurah(index);
      // jumpToSurah(index);
    } else {
      log(
        'Surah not found for search: "$cleanedInput"',
        name: 'SurahAudioController',
      );
    }
  }

  void jumpToSurah(int index) async {
    // شرح: يجب حساب الـ offset بدقة بناءً على ارتفاع العنصر وأي هوامش أو حدود إضافية.
    // Explanation: You must calculate the offset accurately based on item height and any extra margin/divider.

    const double itemHeight = 75.0;
    const double dividerHeight = 1.0;

    final double offset = index * (itemHeight + dividerHeight);

    // التأكد من فتح الـ Sheet أولاً قبل التنقل
    // Ensure the Sheet is expanded first before scrolling
    if (!state.isSheetOpen.value) {
      state.isSheetOpen.value = true;

      // انتظار فتح الـ Sheet ثم التنقل
      // Wait for Sheet to expand then scroll
      Future.delayed(const Duration(milliseconds: 500), () {
        _performJumpToSurah(offset, index);
      });
    } else {
      // إذا كان الـ Sheet مفتوحًا بالفعل، قم بالتنقل مباشرة
      // If Sheet is already open, scroll directly
      _performJumpToSurah(offset, index);
    }
  }

  /// دالة للتنقل السلس للسورة المختارة (للاستخدام عند النقر على السورة)
  /// Function for smooth scrolling to selected surah (for use when tapping on surah)
  void scrollToSelectedSurah(int index) async {
    // شرح: هذه الدالة تتنقل للسورة بسلاسة دون فتح الـ Sheet إذا كان مفتوحًا بالفعل
    // Explanation: This function scrolls to surah smoothly without opening Sheet if already open

    const double itemHeight = 74.0;
    final double offset = index * (itemHeight);

    // حساب المدة بناءً على المسافة للحصول على تنقل أكثر طبيعية
    // Calculate duration based on distance for more natural scrolling
    final currentOffset = state.surahListController.hasClients
        ? state.surahListController.offset
        : 0.0;
    final distance = (offset - currentOffset).abs();
    final duration = Duration(
      milliseconds: (300 + (distance / 10)).clamp(300, 1000).toInt(),
    );

    log(
      'Scrolling to surah $index with duration: ${duration.inMilliseconds}ms',
      name: 'SurahAudioController',
    );

    // تأخير قصير للتأكد من تحديث الـ UI
    // Short delay to ensure UI update
    Future.delayed(const Duration(milliseconds: 100), () {
      _performJumpToSurahWithDuration(offset, index, duration);
    });
  }

  void _performJumpToSurahWithDuration(
    double offset,
    int index,
    Duration duration,
  ) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (state.surahListController.hasClients) {
        final maxScrollExtent =
            state.surahListController.position.maxScrollExtent;
        final targetOffset = offset.clamp(0.0, maxScrollExtent);

        state.surahListController.animateTo(
          targetOffset,
          duration: duration,
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _performJumpToSurah(double offset, int index) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (state.surahListController.hasClients) {
        log(
          'surahListController has clients. Jumping to offset: $offset (index: $index)',
          name: 'SurahAudioController',
        );

        // التحقق من أن الـ offset ضمن النطاق المسموح
        // Check that offset is within allowed range
        final maxScrollExtent =
            state.surahListController.position.maxScrollExtent;
        final targetOffset = offset.clamp(0.0, maxScrollExtent);

        // استخدم animateTo للانتقال السلس إلى السورة المطلوبة
        // Use animateTo for smooth scrolling to the required surah
        state.surahListController.animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      } else {
        // إذا لم يكن متصلًا، أعد المحاولة بعد فترة قصيرة
        // If not attached, retry after a short delay
        Future.delayed(const Duration(milliseconds: 300), () {
          if (state.surahListController.hasClients) {
            final maxScrollExtent =
                state.surahListController.position.maxScrollExtent;
            final targetOffset = offset.clamp(0.0, maxScrollExtent);

            state.surahListController.animateTo(
              targetOffset,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
            );
          } else {
            log(
              'surahListController has no clients. Cannot jump.',
              name: 'SurahAudioController',
            );
          }
        });
      }
    });
  }
}
