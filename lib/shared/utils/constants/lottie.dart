import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

notFound() {
  return Lottie.asset('assets/lottie/notFound.json', width: 200, height: 200);
}

search(double? width, double? height) {
  return Lottie.asset('assets/lottie/search.json',
      width: width, height: height);
}

bookmarks(double? width, double? height) {
  return Lottie.asset('assets/lottie/bookmarks.json',
      width: width, height: height);
}

loadingLottie(double? width, double? height) {
  return Lottie.asset('assets/lottie/loading.json',
      width: width, height: height);
}

loading(double? width, double? height) {
  return Lottie.asset('assets/lottie/splash_loading.json',
      width: width, height: height);
}

noteLottie(double? width, double? height) {
  return Lottie.asset('assets/lottie/notes.json', width: width, height: height);
}

playButtonLottie(double? width, double? height) {
  return Lottie.asset('assets/lottie/play_button.json',
      width: width, height: height);
}

shareLottie(double? width, double? height) {
  return Lottie.asset('assets/lottie/share.json', width: width, height: height);
}

hand(double? width, double? height) {
  return Transform.rotate(
      angle: 3,
      child: Lottie.asset('assets/lottie/hand.json',
          width: width, height: height));
}

notificationLottie(double? width, double? height) {
  return Lottie.asset('assets/lottie/notification.json',
      width: width, height: height);
}
