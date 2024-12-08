part of '../../whats_new.dart';

class SmoothPageIndicatorWidget extends StatelessWidget {
  final PageController controller;
  final List<Map<String, dynamic>> newFeatures;
  const SmoothPageIndicatorWidget(
      {super.key, required this.controller, required this.newFeatures});

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: controller,
      count: newFeatures.length,
      effect: ExpandingDotsEffect(
        dotHeight: 10,
        dotWidth: 13,
        paintStyle: PaintingStyle.fill,
        dotColor: Theme.of(context).colorScheme.surface,
        activeDotColor: Theme.of(context).colorScheme.primary,
        // strokeWidth: 5,
      ),
    );
  }
}
