import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/extensions/bottom_sheet_extension.dart';
import '../../../../core/utils/constants/extensions/extensions.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../../core/utils/constants/lottie_constants.dart';
import '../../../../core/utils/constants/svg_constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../screens/adhkar_fav.dart';
import 'adhkar_list.dart';
import 'azkar_reminder_widget.dart';

class TabBarViewWidget extends StatelessWidget {
  const TabBarViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return context.customOrientation(
      Column(
        children: [
          const Gap(110),
          LogoWidget(),
          const Gap(32),
          Expanded(
            child: TabBarView(
              children: <Widget>[AdhkarList(), const AdhkarFav()],
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(child: LogoWidget()),
          Expanded(
            child: TabBarView(
              children: <Widget>[AdhkarList(), const AdhkarFav()],
            ),
          ),
        ],
      ),
    );
  }
}

class LogoWidget extends StatelessWidget {
  LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Container(
            height: 45,
            width: 100,
            alignment: AlignmentDirectional.centerStart,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: context.theme.primaryColorLight.withValues(alpha: .2),
              borderRadius: const BorderRadiusDirectional.only(
                topStart: Radius.circular(8),
                bottomStart: Radius.circular(8),
              ),
            ),
            child: CustomButton(
              onPressed: () => customBottomSheet(AdhkarReminderWidget()),
              height: 40,
              width: 35,
              isCustomSvgColor: true,
              svgPath: SvgPath.svgAthkarAlarm,
              svgColor: context.theme.colorScheme.primary,
              backgroundColor: context.theme.canvasColor,
            ),
          ),
        ),
        customLottieWithColor(
          LottieConstants.assetsLottieAzkar,
          height: 120,
          isRepeat: false,
          color: context.theme.colorScheme.surface,
        ),
      ],
    );
  }
}
