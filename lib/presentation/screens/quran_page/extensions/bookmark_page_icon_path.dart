import 'package:flutter/material.dart';

import '../../../controllers/theme_controller.dart';

final themeCtrl = ThemeController.instance;

extension BookmarkPageIconPath on BuildContext {
  String bookmarkPageIconPath() {
    if (themeCtrl.isBlueMode) {
      return 'assets/svg/bookmark.svg';
    } else if (themeCtrl.isBrownMode) {
      return 'assets/svg/bookmark2.svg';
    } else if (themeCtrl.isOldMode) {
      return 'assets/svg/bookmark3.svg';
    } else {
      return 'assets/svg/bookmark.svg';
    }
  }
}
