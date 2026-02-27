import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '../../../core/widgets/expansion_tile_widget.dart';
import '../../controllers/general/general_controller.dart';
import '../quran_page/quran.dart';

class AboutAppText extends StatelessWidget {
  const AboutAppText({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTileWidget(
      getxCtrl: QuranController.instance,
      manager: GeneralController.instance.state.expansionManager,
      name: 'about_app_expansion_tile',
      title: 'aboutApp'.tr,
      child: OverflowBar(
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
    );
  }
}
