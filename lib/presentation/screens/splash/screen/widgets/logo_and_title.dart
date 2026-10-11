part of '../../splash.dart';

class LogoAndTitle extends StatelessWidget {
  const LogoAndTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedDrawingWidget(
      customColor: Get.theme.canvasColor,
      width: 110,
      height: 90,
      duration: 1500,
    );
  }
}
