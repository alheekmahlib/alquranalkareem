part of '../../../quran.dart';

/// يبني نص الآية مع تفسيرها/ترجمتها بصيغة موحدة للنسخ والمشاركة —
/// دالة نقية بلا حالة تكمل الباقي، لذا تُختبر مباشرة (test/tafsir_share_text_test.dart)
String buildTafsirShareText({
  required AyahModel ayah,
  required String surahName,
  required String tafsirName,
  required String tafsirBody,
}) {
  return '﴿${ayah.ayaTextEmlaey}﴾ '
      '[$surahName-'
      '${ayah.ayahNumber}]\n\n'
      '$tafsirName\n'
      '$tafsirBody\n\n'
      '${'appName'.tr}\n'
      '${ApiConstants.quranShareUrl}${ayah.page}&ayah=${ayah.ayahUQNumber}';
}

extension QuranUi on QuranController {
  /// -------- [onTap] --------

  void changeSurahListOnTap(int page) {
    state._quranRepository.saveLastPage(page);
    // QuranController.instance.state.box.write(MSTART_PAGE, page);
    QuranCtrl.instance.state.currentPageNumber.value = page;
    QuranLibrary.quranCtrl.quranPagesController.jumpToPage(page - 1);
    if (state.navBarController.isOpen) {
      state.navBarController.close();
      setNavBarType = NavBarType.none;
    } else if (state.tabBarController.isOpen) {
      state.tabBarController.close();
      setTopBarType = TopBarType.none;
    }
  }

  void toggleAyahSelection(int index) {
    if (state.selectedAyahIndexes.contains(index)) {
      state.selectedAyahIndexes.remove(index);
      update(['clearSelection']);
    } else {
      state.selectedAyahIndexes.clear();
      state.selectedAyahIndexes.add(index);
      state.selectedAyahIndexes.refresh();
      update(['clearSelection']);
    }
    state.selectedAyahIndexes.refresh();
    update(['clearSelection']);
  }

  void clearAndAddSelection(int index) {
    state.selectedAyahIndexes.clear();
    state.selectedAyahIndexes.add(index);
    state.selectedAyahIndexes.refresh();
    update(['clearSelection']);
  }

  void showControl() {
    if (state.tabBarController.isHandleVisible ||
        state.navBarController.isHandleVisible) {
      state.tabBarController.hideHandle();
      state.navBarController.hideHandle();
    } else {
      state.tabBarController.showHandle();
      state.navBarController.showHandle();
    }
    GeneralController.instance.state.isShowControl.toggle();
    GeneralController.instance.update(['showControl']);
    QuranCtrl.instance.isShowControl.toggle();
  }

  void toggleMenu(String verseKey) {
    var currentState = state.moreOptionsMap[verseKey] ?? false;
    state.moreOptionsMap[verseKey] = !currentState;
    state.moreOptionsMap.forEach((key, value) {
      if (key != verseKey) state.moreOptionsMap[key] = false;
    });
    update(['ayahs_menu']);
  }

  void pageModeOnTap(bool value) {
    update();
    Get.back();
  }

  KeyEventResult controlRLByKeyboard(FocusNode node, KeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      QuranLibrary.quranCtrl.quranPagesController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      QuranLibrary.quranCtrl.quranPagesController.previousPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  KeyEventResult controlUDByKeyboard(FocusNode node, KeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      state.ScrollUpDownQuranPage.animateTo(
        state.ScrollUpDownQuranPage.offset - 100,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      state.ScrollUpDownQuranPage.animateTo(
        state.ScrollUpDownQuranPage.offset + 100,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void clearSelection() {
    setTopBarType = TopBarType.none;
    setNavBarType = NavBarType.none;
    state.navBarController.close();
    state.tabBarController.close();
    if (AudioCtrl.instance.state.audioPlayer.playing) {
      showControl();
      // GeneralController.instance.update(['showControl']);
    } else if (QuranLibrary.quranCtrl.selectedAyahsByUnequeNumber.isNotEmpty) {
      QuranLibrary.quranCtrl.selectedAyahsByUnequeNumber.clear();
      QuranLibrary.quranCtrl.selectedAyahsByUnequeNumber.refresh();
      QuranLibrary.quranCtrl.clearSelection();
      update(['clearSelection']);
    } else {
      showControl();
      // GeneralController.instance.update(['showControl']);
    }
    // GlobalKeyManager().drawerKey.currentState!.closeSlider();
  }

  void showControlToggle() {
    if (AudioCtrl.instance.state.isPlaying.value) {
      showControl();
      update([
        'isShowControl',
        'selection_page_${QuranCtrl.instance.state.currentPageNumber.value}',
      ]);
    } else if (QuranCtrl.instance.selectedAyahsByUnequeNumber.isNotEmpty) {
      clearSelection();
    } else {
      clearSelection();
      showControl();
      update([
        'isShowControl',
        'selection_page_${QuranCtrl.instance.state.currentPageNumber.value}',
      ]);
    }
  }

  bool getTopBarType(TopBarType type) {
    return state.topBarType.value == type.name;
  }

  set setTopBarType(TopBarType type) {
    state.topBarType.value = type.name;
  }

  RxBool getNavBarType(NavBarType type) {
    return (state.navBarType.value == type.name).obs;
  }

  set setNavBarType(NavBarType type) {
    state.navBarType.value = type.name;
  }

  // void scrollSlowly(BuildContext context, double duration) async {
  //   double scrollPosition = 0.0;
  //   final double totalHeight = state.pages.length.toDouble();
  //   final int steps = (totalHeight / 100).round();
  //   final double stepDuration = (duration * 60 * 1000) / steps;
  //
  //   state.isScrolling.value = true; // بدء التمرير
  //
  //   for (int i = steps; i >= 0; i--) {
  //     if (!state.itemScrollController.isAttached || !state.isScrolling.value)
  //       break; // استخدم break للخروج من الحلقة
  //
  //     scrollPosition = i * 100;
  //     state.itemScrollController.scrollTo(
  //       index: (scrollPosition / 100).floor(),
  //       duration: Duration(milliseconds: stepDuration.toInt()),
  //       curve: Curves.linear,
  //     );
  //     await Future.delayed(Duration(milliseconds: stepDuration.toInt()));
  //
  //     // تحقق من حالة isScrolling بعد التأخير
  //     if (!state.isScrolling.value) break;
  //   }
  //
  //   state.isScrolling.value = false; // التمرير انتهى
  // }

  /// -------- [التفسير: نسخ ومشاركة] --------

  /// اسم السورة بالعربية من قائمة سور الحالة، مع احتياطي اسم الآية نفسها
  String _surahNameFor(AyahModel ayah) {
    for (final surah in state.surahs) {
      if (surah.surahNumber == ayah.surahNumber) return surah.arabicName;
    }
    return ayah.arabicName ?? '';
  }

  /// نص التفسير أو الترجمة المعروض حاليًا للآية من TafsirCtrl — نص خام
  String _tafsirBodyFor(int ayahUQNumber) {
    final tafsirCtrl = TafsirCtrl.instance;
    if (tafsirCtrl.selectedTafsir.isTafsir) {
      return tafsirCtrl.tafseerList
          .firstWhere(
            (element) => element.id == ayahUQNumber,
            orElse: () => const TafsirTableData(
              id: 0,
              tafsirText: '',
              ayahNum: 0,
              pageNum: 0,
              surahNum: 0,
            ),
          )
          .tafsirText;
    }
    final ayah = QuranCtrl.instance.getAyahByUq(ayahUQNumber);
    return tafsirCtrl
            .getTranslationForAyahModel(ayah, ayahUQNumber)
            ?.cleanText ??
        '';
  }

  /// نص جاهز للنسخ/المشاركة للآية المعروضة حاليًا في نافذة التفسير —
  /// null إن لم تكن النافذة مفتوحة (لم تُضبط آية حالية بعد)
  String? _currentTafsirShareText() {
    final ayahUQNumber = state.currentTafsirAyahUQ.value;
    if (ayahUQNumber <= 0) return null;
    final ayah = QuranCtrl.instance.getAyahByUq(ayahUQNumber);
    return buildTafsirShareText(
      ayah: ayah,
      surahName: _surahNameFor(ayah),
      tafsirName: TafsirCtrl.instance.selectedTafsir.name,
      tafsirBody: _tafsirBodyFor(ayahUQNumber),
    );
  }

  /// نسخ تفسير/ترجمة الآية المعروضة حاليًا في نافذة التفسير
  Future<void> copyTafsirOnTap() async {
    final text = _currentTafsirShareText();
    if (text == null) return;
    await Clipboard.setData(ClipboardData(text: text)).then(
      (value) =>
          Get.context!.showCustomErrorSnackBar('copyTafseer'.tr, isDone: true),
    );
  }

  /// مشاركة تفسير/ترجمة الآية المعروضة حاليًا في نافذة التفسير
  Future<void> shareTafsirOnTap() async {
    final text = _currentTafsirShareText();
    if (text == null) return;
    await SharePlus.instance.share(
      ShareParams(text: text, subject: 'appName'.tr),
    );
  }
}
