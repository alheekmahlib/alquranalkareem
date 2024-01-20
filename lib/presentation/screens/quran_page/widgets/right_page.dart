import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class RightPage extends StatelessWidget {
  final Widget child;
  const RightPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1280,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 4.0, top: 16.0, bottom: 16.0),
            child: Container(
              decoration: BoxDecoration(
                  color: ThemeProvider.themeOf(context).id == 'dark'
                      ? Theme.of(context).primaryColorDark.withOpacity(.5)
                      : Theme.of(context).dividerColor.withOpacity(.5),
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12))),
              // child: child,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 16.0, bottom: 16.0),
            child: Container(
              decoration: BoxDecoration(
                  color: ThemeProvider.themeOf(context).id == 'dark'
                      ? Theme.of(context).primaryColorDark.withOpacity(.7)
                      : Theme.of(context).dividerColor.withOpacity(.7),
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12))),
              // child: child,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(right: 12.0, top: 16.0, bottom: 16.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12))),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}