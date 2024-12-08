part of '../quran.dart';

extension SajdaExtension on Widget {
  Widget showVerseToast(int pageIndex) {
    log('checking sajda posision');
    sl<QuranController>().getAyahWithSajdaInPage(pageIndex);
    return sl<QuranController>().state.isSajda.value
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              customSvg(
                SvgPath.svgSajdaIcon,
                height: 15,
              ),
              const Gap(8),
              Text(
                'sajda'.tr,
                style: TextStyle(
                  color: const Color(0xff77554B),
                  fontFamily: 'kufi',
                  fontSize: Get.context!.customOrientation(13.0, 18.0),
                ),
              )
            ],
          )
        : const SizedBox.shrink();
  }
}
