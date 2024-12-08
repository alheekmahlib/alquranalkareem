part of '../splash.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final s = SplashScreenController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: context.customOrientation(
              Stack(
                alignment: Alignment.center,
                children: [
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: AlheekmahAndLoading(),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 48.0),
                      child: Opacity(
                        opacity: .4,
                        child: customSvg(
                          SvgPath.svgSplashIconHalfS,
                          height: MediaQuery.sizeOf(context).width * .4,
                        ),
                      ),
                    ),
                  ),
                  Obx(() => AnimatedContainer(
                        alignment: Alignment.bottomCenter,
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOutCirc,
                        height: s.state.smallContainerHeight.value,
                        width: Get.width,
                        color:
                            context.theme.colorScheme.surface.withOpacity(.5),
                      )),
                  Obx(() => AnimatedContainer(
                        alignment: Alignment.bottomCenter,
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOutCirc,
                        height: s.state.secondSmallContainerHeight.value,
                        width: Get.width,
                        color:
                            context.theme.colorScheme.surface.withOpacity(.7),
                      )),
                  Obx(() => AnimatedContainer(
                        alignment: Alignment.bottomCenter,
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOutCirc,
                        height: s.state.thirdSmallContainerHeight.value,
                        width: Get.width,
                        color: context.theme.colorScheme.primary,
                      )),
                  Obx(() => AnimatedContainer(
                        alignment: Alignment.center,
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOutCirc,
                        height: s.state.containerAnimate.value
                            ? context.customOrientation(
                                s.state.containerHeight.value,
                                s.state.containerHHeight.value)
                            : 0,
                        width: Get.width,
                        color: context.theme.colorScheme.primaryContainer,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: Get.height,
                              width: Get.width,
                              color: context.theme.colorScheme.primaryContainer,
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 10,
                                width: MediaQuery.sizeOf(context).width,
                                margin: const EdgeInsets.only(bottom: 8.0),
                                color: context.theme.colorScheme.primary,
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: 10,
                                width: MediaQuery.sizeOf(context).width,
                                margin: const EdgeInsets.only(top: 8.0),
                                color: context.theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      )),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 56.0),
                        child: SplashScreenController.instance
                            .ramadhanOrEidGreeting()),
                  ),
                  GetX<SplashScreenController>(
                    builder: (s) => AnimatedOpacity(
                      opacity: s.state.containerAnimate.value ? 1 : 0,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOutCirc,
                      child: s.customWidget,
                    ),
                  ),
                ],
              ),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: LogoAndTitle(),
                        ),
                        Expanded(
                          flex: 4,
                          child: AlheekmahAndLoading(),
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: SplashScreenController.instance
                          .ramadhanOrEidGreeting(),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: customSvg(
                        SvgPath.svgSplashIconHalfS,
                        height: MediaQuery.sizeOf(context).width * .25,
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
