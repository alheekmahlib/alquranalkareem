part of '../../../quran.dart';

extension QuranUi on QuranController {
  /// -------- [onTap] --------
  dynamic textScale(dynamic widget1, dynamic widget2) {
    if (state.scaleFactor.value <= 1.3) {
      return widget1;
    } else {
      return widget2;
    }
  }

  void updateTextScale(ScaleUpdateDetails details) {
    double newScaleFactor = state.baseScaleFactor.value * details.scale;
    if (newScaleFactor < 1.0) {
      newScaleFactor = 1.0;
    }
    state.scaleFactor.value = newScaleFactor;
  }

  void switchMode(int newMode) {
    state.isPages.value = newMode;
    state.selectMushafSettingsPage.value = newMode;
    state.box.write(SWITCH_VALUE, newMode);
    Get.back();
    update();
    if (newMode == 1) {
      Future.delayed(const Duration(milliseconds: 600)).then((_) {
        if (state.itemScrollController.isAttached) {
          state.itemScrollController.jumpTo(
            index: state.currentPageNumber.value - 1,
          );
        }
      });
    } else {
      state.currentPageNumber.value =
          state.itemPositionsListener.itemPositions.value.last.index + 1;
    }
  }

  void changeSurahListOnTap(int page) {
    state.currentPageNumber.value = page - 1;
    if (state.isPages == 1) {
      state.itemScrollController.jumpTo(
        index: page - 1,
      );
    } else {
      state.quranPageController.jumpToPage(
        page - 1,
        // duration: const Duration(milliseconds: 500),
        // curve: Curves.easeIn,
      );
    }
    GlobalKeyManager().drawerKey.currentState!.closeSlider();
  }

  void toggleAyahSelection(int index) {
    if (state.selectedAyahIndexes.contains(index)) {
      state.selectedAyahIndexes.remove(index);
      update(['bookmarked']);
    } else {
      state.selectedAyahIndexes.clear();
      state.selectedAyahIndexes.add(index);
      state.selectedAyahIndexes.refresh();
      update(['bookmarked']);
    }
    state.selectedAyahIndexes.refresh();
    update(['bookmarked']);
  }

  void clearAndAddSelection(int index) {
    state.selectedAyahIndexes.clear();
    state.selectedAyahIndexes.add(index);
    state.selectedAyahIndexes.refresh();
  }

  void showControl() {
    generalCtrl.state.isShowControl.value =
        !generalCtrl.state.isShowControl.value;
  }

  void toggleMenu(String verseKey) {
    var currentState = state.moreOptionsMap[verseKey] ?? false;
    state.moreOptionsMap[verseKey] = !currentState;
    state.moreOptionsMap.forEach((key, value) {
      if (key != verseKey) state.moreOptionsMap[key] = false;
    });
    update(['ayahs_menu']);
  }

  Future<void> pageChanged(int index) async {
    state.currentPageNumber.value = index + 1;
    sl<PlayListController>().reset();
    sl<GeneralController>().state.isShowControl.value = false;
    sl<AudioController>().state.pageAyahNumber = '0';
    sl<BookmarksController>().getBookmarks();
    state.lastReadSurahNumber.value =
        sl<QuranController>().getSurahNumberFromPage(index + 1);
    state.box.write(MSTART_PAGE, index + 1);
    state.box.write(MLAST_URAH, state.lastReadSurahNumber.value);
  }

  void pageModeOnTap(bool value) {
    state.isPageMode.value = value;
    state.box.write(PAGE_MODE, value);
    update();
    Get.back();
  }

  KeyEventResult controlRLByKeyboard(FocusNode node, KeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      state.quranPageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      state.quranPageController.previousPage(
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
}
