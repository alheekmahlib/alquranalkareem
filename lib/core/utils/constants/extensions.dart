import 'dart:io';

import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  dynamic customOrientation(var n1, var n2) {
    Orientation orientation = MediaQuery.orientationOf(this);
    return orientation == Orientation.portrait ? n1 : n2;
  }

  dynamic definePlatform(var p1, var p2) =>
      (Platform.isIOS || Platform.isAndroid || Platform.isFuchsia) ? p1 : p2;
}
