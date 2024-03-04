import 'container_with_lines.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../utils/constants/lottie.dart';
import '/core/utils/constants/extensions/extensions.dart';

class RamadanGreeting extends StatelessWidget {
  final String lottieFile;
  final String title;
  final String content;
  const RamadanGreeting(
      {super.key,
      required this.lottieFile,
      required this.title,
      required this.content});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      height: size.height * .9,
      width: size.width,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          )),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ListView(
            children: [
              const Gap(8),
              context.customClose(),
              ramadanOrEid(lottieFile),
              ContainerWithLines(
                containerColor:
                    Theme.of(context).colorScheme.surface.withOpacity(.1),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontFamily: 'kufi',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    height: 1.7,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Gap(32),
              Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.symmetric(horizontal: 32.0),
                decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surface.withOpacity(.1),
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                child: Text(
                  content,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontFamily: 'naskh',
                    fontSize: 19,
                    height: 1.7,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
