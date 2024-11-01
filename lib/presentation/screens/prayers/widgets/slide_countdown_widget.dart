part of '../prayers.dart';

class SlideCountdownWidget extends StatelessWidget {
  final double fontSize;
  SlideCountdownWidget({super.key, required this.fontSize});

  final adhanCtrl = AdhanController.instance;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SlideCountdown(
        digitsNumber: [
          '0'.convertNumbers(),
          '1'.convertNumbers(),
          '2'.convertNumbers(),
          '3'.convertNumbers(),
          '4'.convertNumbers(),
          '5'.convertNumbers(),
          '6'.convertNumbers(),
          '7'.convertNumbers(),
          '8'.convertNumbers(),
          '9'.convertNumbers()
        ],
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        slideDirection: SlideDirection.up,
        duration: adhanCtrl.getTimeLeftForNextPrayer,
        style: TextStyle(
          color: context.theme.canvasColor,
          locale: const Locale('ar'),
          fontFamily: 'kufi', // أو أي خط يدعم الأرقام العربية
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
