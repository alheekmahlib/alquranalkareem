part of '../../splash.dart';

class AlheekmahAndLoading extends StatelessWidget {
  const AlheekmahAndLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: AnimatedOpacity(
        duration: const Duration(seconds: 1),
        opacity: 1.0,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 56.0),
                child: SplashScreenController.instance.ramadhanOrEidGreeting(),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: SizedBox(
                  height: 70,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      customSvgWithColor(
                        SvgPath.svgAlheekmahLogo,
                        color: Theme.of(context).primaryColorLight,
                        width: 90,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: customLottieWithColor(
                          LottieConstants.assetsLottieSplashLoading,
                          width: 60.0,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
