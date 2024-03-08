import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget customLottie(String path,
    {double? width, double? height, bool? isRepeat}) {
  return Lottie.asset(path,
      width: width, height: height, repeat: isRepeat ?? true);
}

Widget ramadanOrEid(String name, {double? width, double? height}) {
  return Lottie.asset('assets/lottie/$name.json', width: width, height: height);
}
