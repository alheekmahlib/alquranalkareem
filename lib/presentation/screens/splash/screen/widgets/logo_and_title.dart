part of '../../splash.dart';

class LogoAndTitle extends StatelessWidget {
  const LogoAndTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final splashCtrl = SplashScreenController.instance;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        customSvgWithCustomColor(
          SvgPath.svgSplashIcon,
          height: 100,
          width: 100,
        ),
        const Gap(16),
        ContainerWithBorder(
          color: Theme.of(context).colorScheme.primary,
          child: Obx(() {
            return AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: splashCtrl.state.animate.value ? 1 : 0,
              child: Text(
                'وَرَتِّلِ ٱلۡقُرۡءَانَ تَرۡتِيلًا',
                style: TextStyle(
                    fontFamily: 'uthmanic2',
                    color: Theme.of(context).canvasColor,
                    fontSize: 22),
              ),
            );
          }),
        ),
        const Gap(16)
      ],
    );
  }
}
