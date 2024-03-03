import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
        dotColor: Theme.of(context).colorScheme.primary.withOpacity(.2),
        activeDotColor: Theme.of(context).colorScheme.primary,
        // strokeWidth: 5,
      ),
    );
  }
}
