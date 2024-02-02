import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget notFound() {
  return Lottie.asset('assets/lottie/notFound.json', width: 200, height: 200);
}

Widget search(double? width, double? height) {
  return Lottie.asset(
    'assets/lottie/search.json',
    width: width,
    height: height,
  );
}

Widget bookmarks(double? width, double? height) {
  return Lottie.asset('assets/lottie/bookmarks.json',
      width: width, height: height);
}

Widget loadingLottie(double? width, double? height) {
  return Lottie.asset('assets/lottie/loading.json',
      width: width, height: height);
}

Widget loading({double? width, double? height}) {
  return Lottie.asset('assets/lottie/splash_loading.json',
      width: width, height: height);
}

Widget noteLottie(double? width, double? height) {
  return Lottie.asset('assets/lottie/notes.json', width: width, height: height);
}

Widget playButtonLottie(double? width, double? height) {
  return Lottie.asset('assets/lottie/play_button.json',
      width: width, height: height);
}

Widget shareLottie({double? width, double? height}) {
  return Lottie.asset('assets/lottie/share.json', width: width, height: height);
}

Widget hand(double? width, double? height) {
  return Transform.rotate(
      angle: 3,
      child: Lottie.asset('assets/lottie/hand.json',
          width: width, height: height));
}

Widget notificationLottie(double? width, double? height) {
  return Lottie.asset('assets/lottie/notification.json',
      width: width, height: height);
}

Widget azkar({double? width, double? height}) {
  return Lottie.asset('assets/lottie/azkar.json',
      width: width, height: height, repeat: false);
}

Widget quran_au_ic({double? width, double? height}) {
  return Lottie.asset('assets/lottie/quran_au_ic.json',
      width: width, height: height, repeat: false);
}

Widget arrow({double? width, double? height}) {
  return Lottie.asset('assets/lottie/arrow.json', width: width, height: height);
}
