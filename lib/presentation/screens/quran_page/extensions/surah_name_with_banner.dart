part of '../quran.dart';

extension CustomSurahNameWithBannerExtension on Widget {
  Widget surahNameWidget(
    String num,
    Color color, {
    double? height,
    double? width,
  }) {
    return SvgPicture.asset(
      'assets/svg/surah_name/00$num.svg',
      height: height ?? 30,
      width: width,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
