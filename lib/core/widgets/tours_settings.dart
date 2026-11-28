import 'package:flexible_sheet/flexible_sheet.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../tour/tour_launcher.dart';
import '../utils/helpers/app_text_styles.dart';
import 'container_button.dart';

/// كتلة «إعادة تشغيل الجولات» في الإعدادات: رقاقة لكل جولة يمكن فتح قسمها
/// من هنا. الرقاقة فعلٌ لا اختيار، فلا تحمل حالة تحديد.
class ToursSettings extends StatelessWidget {
  const ToursSettings({super.key, this.sheetController});

  /// كنترولر ورقة الإعدادات الحاضنة؛ تُغلق قبل بدء الجولة.
  final FlexibleSheetController? sheetController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Text('replayTours'.tr, style: AppTextStyles.titleMedium()),
          const Gap(4),
          Divider(
            thickness: 1.0,
            height: 1.0,
            endIndent: 32.0,
            indent: 32.0,
            color: Theme.of(context).primaryColorLight.withValues(alpha: .5),
          ),
          Wrap(
            children: [
              for (final tour in AppTourPick.values)
                ContainerButton(
                  onPressed: () => TourLauncher.instance.start(
                    tour,
                    settingsSheet: sheetController,
                  ),
                  horizontalPadding: 8.0,
                  verticalPadding: 8.0,
                  horizontalMargin: 4.0,
                  verticalMargin: 4.0,
                  title: tour.titleKey,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
