import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';

class AboutAppText extends StatelessWidget {
  const AboutAppText({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTileCard(
      elevation: 0.0,
      initialElevation: 0.0,
      expandedTextColor:
          Theme.of(context).colorScheme.surface.withValues(alpha: .15),
      title: SizedBox(
        width: 100.0,
        child: Text(
          'aboutApp'.tr,
          style: TextStyle(
            fontFamily: 'kufi',
            fontSize: 18,
            color: Theme.of(context).hintColor,
          ),
        ),
      ),
      baseColor: Theme.of(context).colorScheme.surface.withValues(alpha: .15),
      expandedColor:
          Theme.of(context).colorScheme.surface.withValues(alpha: .15),
      children: <Widget>[
        context.hDivider(width: MediaQuery.sizeOf(context).width * .5),
        OverflowBar(
          alignment: MainAxisAlignment.spaceAround,
          spacing: 42.0,
          overflowSpacing: 90.0,
          children: [
            Text(
              'about_app'.tr,
              style: TextStyle(
                fontFamily: 'naskh',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).hintColor,
              ),
              textAlign: TextAlign.justify,
            ),
            const Gap(24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ('about_app3').tr,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'naskh',
                    // fontWeight: FontWeight.bold,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                context.hDivider(width: MediaQuery.sizeOf(context).width),
                const Gap(16),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
