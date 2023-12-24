import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrientationController extends GetxController {
  orientation(BuildContext context, var n1, var n2) {
    Orientation orientation = MediaQuery.orientationOf(context);
    return orientation == Orientation.portrait ? n1 : n2;
  }
}
