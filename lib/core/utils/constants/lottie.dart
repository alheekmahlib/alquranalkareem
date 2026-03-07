import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

Widget customLottie(
  String path, {
  double? width,
  double? height,
  bool? isRepeat,
}) {
  return Lottie.asset(
    path,
    width: width,
    height: height,
    repeat: isRepeat ?? true,
  );
}

Widget customLottieWithColor(
  String path, {
  double? width,
  double? height,
  bool? isRepeat,
  Color? color,
  BoxFit? boxFit,
}) {
  return ColorFiltered(
    colorFilter: ColorFilter.mode(
      color ?? Get.theme.primaryColorDark,
      BlendMode.modulate,
    ),
    child: Lottie.asset(
      path,
      width: width,
      height: height,
      repeat: isRepeat ?? true,
      fit: boxFit,
      // delegates: LottieDelegates(
      //   values: [
      //     ValueDelegate.color(
      //       const ['Vector', 'Group', 'Fill'],
      //       value: Colors.green,
      //     ),
      //   ],
      // ),
    ),
  );
}

Widget ramadanOrEid(String name, {double? width, double? height}) {
  return Lottie.asset('assets/lottie/$name.json', width: width, height: height);
}
