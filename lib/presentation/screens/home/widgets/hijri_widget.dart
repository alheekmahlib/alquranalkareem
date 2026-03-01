import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/core/utils/constants/extensions/extensions.dart';
import '../../../../core/widgets/elevated_button_widget.dart';
import '../../../controllers/general/general_controller.dart';
import '../../calendar/events.dart';

class HijriWidget extends StatelessWidget {
  HijriWidget({super.key});

  final generalCtrl = GeneralController.instance;
  final eventCtrl = EventController.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: ElevatedButtonWidget(
        onClick: () => Get.to(() => HijriCalendarScreen()),
        index: 0,
        height: 120,
        width: context.customOrientation(Get.width * .87, Get.width * .4),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.85),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Circular day badge
                      Container(
                        height: 56,
                        width: 56,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context).colorScheme.surface,
                              Theme.of(
                                context,
                              ).colorScheme.surface.withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(16),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).colorScheme.surface.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          '${eventCtrl.hijriNow.hDay}'
                              .convertNumbersToCurrentLang(),
                          style: TextStyle(
                            fontSize: 24.0,
                            fontFamily: 'kufi',
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).canvasColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Gap(10),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            eventCtrl.hijriNow.getDayName().tr,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'kufi',
                              color: Theme.of(context).canvasColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${'${eventCtrl.hijriNow.hYear}'.convertNumbersToCurrentLang()} هـ',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'kufi',
                              color: Theme.of(
                                context,
                              ).canvasColor.withValues(alpha: 0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  SvgPicture.asset(
                    'assets/svg/hijri/${eventCtrl.hijriNow.hMonth}.svg',
                    width: 110,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).canvasColor.withValues(alpha: 0.9),
                      BlendMode.srcIn,
                    ),
                  ),
                  const Gap(24),
                ],
              ),
              const Gap(8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: RoundedProgressBar(
                        height: 36,
                        style: RoundedProgressBarStyle(
                          borderWidth: 0,
                          widthShadow: 0,
                          backgroundProgress: Theme.of(
                            context,
                          ).canvasColor.withValues(alpha: 0.2),
                          colorProgress: Theme.of(context).colorScheme.surface,
                          colorProgressDark: Theme.of(
                            context,
                          ).colorScheme.surface.withValues(alpha: .5),
                          colorBorder: Colors.transparent,
                          colorBackgroundIcon: Colors.transparent,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                        percent:
                            ((eventCtrl.hijriNow.hDay /
                                eventCtrl.getLengthOfMonth) *
                            100),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Center(
                        child: eventCtrl.isLastDayOfMonth
                            ? Text(
                                '${'lastDayOf'.tr} ${'${eventCtrl.hijriNow.getLongMonthName()}'.tr}',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontFamily: 'kufi',
                                  color: Theme.of(context).disabledColor,
                                ),
                                textAlign: TextAlign.center,
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        '${'RemainsUntilTheEndOf'.tr} ${'${eventCtrl.hijriNow.getLongMonthName()}'.tr}',
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          fontFamily: 'kufi',
                                          color: Theme.of(
                                            context,
                                          ).disabledColor,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  const Gap(16),
                                  Expanded(
                                    flex: 3,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        '${'${eventCtrl.daysArabicConvert((eventCtrl.getLengthOfMonth - eventCtrl.hijriNow.hDay), (eventCtrl.getLengthOfMonth - eventCtrl.hijriNow.hDay).toString())}'}'
                                            .convertNumbersToCurrentLang(),
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          fontFamily: 'kufi',
                                          color: Theme.of(
                                            context,
                                          ).disabledColor,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(8),
            ],
          ),
        ),
      ),
    );
  }
}
