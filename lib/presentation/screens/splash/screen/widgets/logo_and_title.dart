part of '../../splash.dart';

class LogoAndTitle extends StatelessWidget {
  const LogoAndTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // customSvgWithColor(
            //   height: 200,
            //   width: 200,
            //   SvgPath.svgQuranSurahNumberZakhrafa,
            //   color: Get.theme.colorScheme.surface,
            // ),
            // customSvgWithColor(
            //   height: 175,
            //   width: 175,
            //   SvgPath.svgQuranSurahNumberZakhrafa,
            //   color: Get.theme.colorScheme.primaryContainer,
            // ),
            AnimatedDrawingWidget(
              customColor: Get.theme.canvasColor,
              width: 110,
              height: 90,
            ),
          ],
        ),
      ],
    );
  }
}
