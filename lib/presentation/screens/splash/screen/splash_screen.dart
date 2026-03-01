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
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Radial gradient background
              Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.2,
                    colors: [
                      Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: 0.15),
                      Theme.of(context).primaryColor,
                    ],
                  ),
                ),
              ),
              // Bottom branding
              const Align(
                alignment: Alignment.bottomCenter,
                child: AlheekmahAndLoading(),
              ),
              // Decorative background icon
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 48.0),
                  child: Opacity(
                    opacity: .25,
                    child: customSvgWithColor(
                      SvgPath.svgSplashIconHalfS,
                      height: MediaQuery.sizeOf(context).width * .4,
                    ),
                  ),
                ),
              ),
              // Animated color wave layers
              Obx(
                () => AnimatedContainer(
                  alignment: Alignment.bottomCenter,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutCubic,
                  height: s.state.smallContainerHeight.value,
                  width: Get.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        context.theme.colorScheme.surface.withValues(
                          alpha: 0.0,
                        ),
                        context.theme.colorScheme.surface.withValues(
                          alpha: 0.4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Obx(
                () => AnimatedContainer(
                  alignment: Alignment.bottomCenter,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutCubic,
                  height: s.state.secondSmallContainerHeight.value,
                  width: Get.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        context.theme.colorScheme.surface.withValues(
                          alpha: 0.0,
                        ),
                        context.theme.colorScheme.surface.withValues(
                          alpha: 0.6,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Obx(
                () => AnimatedContainer(
                  alignment: Alignment.bottomCenter,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutCubic,
                  height: s.state.thirdSmallContainerHeight.value,
                  width: Get.width,
                  color: context.theme.colorScheme.primary,
                ),
              ),
              // Greeting
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 56.0),
                  child: s.ramadhanOrEidGreeting(),
                ),
              ),
              // Main expanding container
              Obx(
                () => AnimatedContainer(
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.easeInOutCubic,
                  height: s.state.containerAnimate.value
                      ? context.customOrientation(
                          s.state.containerHeight.value,
                          s.state.containerHHeight.value,
                        )
                      : 0,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.primaryContainer,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: Get.height,
                        width: Get.width,
                        color: context.theme.colorScheme.primaryContainer,
                      ),
                      // Top accent line
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 4,
                          width: MediaQuery.sizeOf(context).width,
                          margin: const EdgeInsets.only(top: 8.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                context.theme.colorScheme.primary.withValues(
                                  alpha: 0.0,
                                ),
                                context.theme.colorScheme.primary,
                                context.theme.colorScheme.primary,
                                context.theme.colorScheme.primary.withValues(
                                  alpha: 0.0,
                                ),
                              ],
                              stops: const [0.0, 0.3, 0.7, 1.0],
                            ),
                          ),
                        ),
                      ),
                      // Bottom accent line
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 4,
                          width: MediaQuery.sizeOf(context).width,
                          margin: const EdgeInsets.only(bottom: 8.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                context.theme.colorScheme.primary.withValues(
                                  alpha: 0.0,
                                ),
                                context.theme.colorScheme.primary,
                                context.theme.colorScheme.primary,
                                context.theme.colorScheme.primary.withValues(
                                  alpha: 0.0,
                                ),
                              ],
                              stops: const [0.0, 0.3, 0.7, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GetX<SplashScreenController>(
                builder: (s) => AnimatedOpacity(
                  opacity: s.state.containerAnimate.value ? 1 : 0,
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.easeInOutCubic,
                  child: s.customWidget,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
