import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hijri_date/hijri.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/core/utils/helpers/app_text_styles.dart';
import '../../../../core/utils/constants/extensions/svg_extensions.dart';
import '../../../controllers/general/general_controller.dart';
import '../../calendar/events.dart';

class HijriWidget extends StatelessWidget {
  final bool? isInCalendar;
  HijriWidget({super.key, this.isInCalendar = false});

  final generalCtrl = GeneralController.instance;
  final eventCtrl = EventController.instance;

  @override
  Widget build(BuildContext context) {
    final isInCalendar = this.isInCalendar == true;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isInCalendar ? 8.0 : 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IntrinsicHeight(
            child: InkWell(
              onTap: isInCalendar
                  ? null
                  : () => Get.to(
                      () => HijriCalendarScreen(),
                      transition: Transition.downToUp,
                    ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    decoration: BoxDecoration(
                      color: context.theme.primaryColorLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const Gap(8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.theme.primaryColorLight.withValues(
                          alpha: .2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              eventCtrl.hijriNow.getDayName().tr,
                              style: AppTextStyles.titleLarge().copyWith(
                                fontSize: 40,
                                color: context.theme.primaryColorLight
                                    .withValues(alpha: isInCalendar ? .9 : .3),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    _hijriWidget(context, isInCalendar),
                                    const Spacer(),
                                    _gregorianWidget(context, isInCalendar),
                                  ],
                                ),
                              ),
                              _progressBarWidget(context),
                              const Gap(8),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isInCalendar) ...[
            const Gap(8),
            GetBuilder<EventController>(
              builder: (eventCtrl) => HorizontalWeekCalendar(
                useHijriDates: true,
                showTopNavbar: false,
                translateNumbers: true,
                showNavigationButtons: false,
                showGregorianUnderHijri: true,
                weekStartFrom: WeekStartFrom.friday,
                initialDate: eventCtrl.now,
                minDate: eventCtrl.now.subtract(const Duration(days: 7)),
                maxDate: eventCtrl.now.add(const Duration(days: 7)),
                hijriMinDate: eventCtrl.hijriMin,
                hijriMaxDate: eventCtrl.hijriMax,
                hijriInitialDate: eventCtrl.hijriNow,
                itemBorderColor: Colors.transparent,
                disabledBackgroundColor: Colors.transparent,
                inactiveBackgroundColor: Colors.transparent,
                activeBackgroundColor: context.theme.colorScheme.surface
                    .withValues(alpha: .5),
                dayNameTextStyle: AppTextStyles.titleMedium().copyWith(
                  height: .9,
                  fontSize: 18,
                  color: context.theme.canvasColor,
                ),
                dayTextStyle: AppTextStyles.titleMedium().copyWith(
                  height: 1.1,
                  color: context.theme.canvasColor.withValues(alpha: .2),
                ),
                gregorianDayTextStyle: AppTextStyles.titleMedium().copyWith(
                  height: 1.1,
                  color: context.theme.canvasColor.withValues(alpha: .2),
                ),
                languageCode: Get.locale?.languageCode ?? 'ar',
                customDayNames: [
                  'Sun'.tr,
                  'Mon'.tr,
                  'Tue'.tr,
                  'Wed'.tr,
                  'Thu'.tr,
                  'Fri'.tr,
                  'Sat'.tr,
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Padding _progressBarWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        height: 40,
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.primaryContainer,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            RoundedProgressBar(
              height: 30,
              style: RoundedProgressBarStyle(
                borderWidth: 0,
                widthShadow: 5,
                backgroundProgress: context.theme.colorScheme.primaryContainer,
                colorProgress: context.theme.colorScheme.surface,
                colorProgressDark: context.theme.colorScheme.surface.withValues(
                  alpha: .5,
                ),
                colorBorder: context.theme.colorScheme.primaryContainer,
                colorBackgroundIcon: Colors.transparent,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              percent:
                  ((eventCtrl.hijriNow.hDay / eventCtrl.getLengthOfMonth) *
                  100),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: eventCtrl.isLastDayOfMonth
                    ? Text(
                        '${'lastDayOf'.tr} ${'${eventCtrl.hijriNow.getLongMonthName()}'.tr}',
                        style: AppTextStyles.titleMedium(fontSize: 16.0),
                        textAlign: TextAlign.center,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 7,
                            child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '${'RemainsUntilTheEndOf'.tr} ${'${eventCtrl.hijriNow.getLongMonthName()}'.tr}',
                                  style: AppTextStyles.titleMedium(
                                    fontSize: 16.0,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                          ),
                          const Gap(16),
                          Expanded(
                            flex: 3,
                            child: Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '${'${eventCtrl.daysArabicConvert((eventCtrl.getLengthOfMonth - eventCtrl.hijriNow.hDay), (eventCtrl.getLengthOfMonth - eventCtrl.hijriNow.hDay).toString())}'}'
                                      .convertNumbersToCurrentLang(),
                                  style: AppTextStyles.titleMedium(
                                    fontSize: 16.0,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
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
    );
  }

  Container _hijriWidget(BuildContext context, bool isInCalendar) {
    return Container(
      height: 90,
      width: 120,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: customSvgWithColor(
              'assets/svg/hijri/${eventCtrl.hijriNow.hMonth}.svg',
              width: 120,
              color: isInCalendar
                  ? context.theme.canvasColor
                  : Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Text(
              '${eventCtrl.hijriNow.hDay}'.convertNumbersToCurrentLang(),
              style: AppTextStyles.titleMedium().copyWith(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: isInCalendar
                    ? context.theme.canvasColor
                    : Theme.of(context).colorScheme.inversePrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              '${'${eventCtrl.hijriNow.hYear}'.convertNumbersToCurrentLang()} هـ',
              style: AppTextStyles.titleMedium().copyWith(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: isInCalendar
                    ? context.theme.canvasColor
                    : Theme.of(context).colorScheme.inversePrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Container _gregorianWidget(BuildContext context, bool isInCalendar) {
    return Container(
      height: 90,
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              '${eventCtrl.dateFormat}'.convertNumbersToCurrentLang(),
              style: AppTextStyles.titleLarge().copyWith(
                fontSize: 34,
                color: isInCalendar
                    ? context.theme.canvasColor
                    : Theme.of(context).colorScheme.inversePrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Text(
              '${eventCtrl.now.day}'.convertNumbersToCurrentLang(),
              style: AppTextStyles.titleMedium().copyWith(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: isInCalendar
                    ? context.theme.canvasColor
                    : Theme.of(context).colorScheme.inversePrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              '${'${eventCtrl.now.year}'.convertNumbersToCurrentLang()} م',
              style: AppTextStyles.titleMedium().copyWith(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: isInCalendar
                    ? context.theme.canvasColor
                    : Theme.of(context).colorScheme.inversePrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
