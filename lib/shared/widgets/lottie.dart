
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

notFound() {
  return Lottie.asset('assets/lottie/notFound.json',
      width: 200, height: 200);
}
search(double? width, height) {
  return Lottie.asset('assets/lottie/search.json',
      width: width, height: height);
}