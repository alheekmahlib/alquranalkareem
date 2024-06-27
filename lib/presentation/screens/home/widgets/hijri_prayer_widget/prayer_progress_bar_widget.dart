import 'package:flutter/material.dart';

import 'hijri_widget.dart';
import 'prayer_widget.dart';

class PrayerProgressBar extends StatelessWidget {
  PrayerProgressBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SizedBox(
        height: 275,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 275,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: HijriWidget(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: PrayerWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
