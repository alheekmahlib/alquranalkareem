part of '../../../quran.dart';

extension QuranUi on QuranController {
  /// -------- [onTap] --------

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
    state.currentPageNumber.value = page;
    if (state.isPages == 1) {
      state.itemScrollController.jumpTo(index: page - 1);
    } else {
      state.quranPageController.jumpToPage(page - 1);
    }
    GlobalKeyManager().drawerKey.currentState!.closeSlider();
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

  void pageChanged(int index) {
    state.currentPageNumber.value = index;
    // sl<PlayListController>().reset();
    GeneralController.instance.state.isShowControl.value = false;
    AudioController.instance.state.pageAyahNumber = '0';

    SchedulerBinding.instance.scheduleTask(() {
      state.lastReadSurahNumber.value = getSurahNumberFromPage(index + 1);
      state.box
        ..write(MSTART_PAGE, index)
        ..write(MLAST_URAH, state.lastReadSurahNumber.value);
    }, Priority.idle);
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
