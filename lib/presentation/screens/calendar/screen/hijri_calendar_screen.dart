part of '../events.dart';

class HijriCalendarScreen extends StatelessWidget {
  HijriCalendarScreen({super.key});

  final eventsCtrl = EventController.instance;

  @override
  Widget build(BuildContext context) {
    eventsCtrl.resetDate();
    // ضبط ذاتي لكسر الـ PageView حسب الاتجاه الحالي — يعالج حالة فوات
    // إشعار الدوران (دخول الشاشة بكسر الاتجاه الخاطئ).
    eventsCtrl.ensureViewportFraction(MediaQuery.orientationOf(context));
    return GetBuilder<EventController>(
      builder: (eventCtrl) => Scaffold(
        backgroundColor: Get.theme.colorScheme.primary,
        body: SafeArea(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              context.customOrientation(
                const SizedBox.shrink(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _pageViewBuild(context, eventCtrl),
                ),
              ),
              context.customOrientation(
                Stack(
                  children: [
                    _valueListenableBuilderWidget(eventCtrl),
                    CustomSheetWidget(
                      controller: eventCtrl.controller,
                      scrollController: eventCtrl.scrollController,
                      minSheetOffset: 0.2,
                      maxSheetOffset: 0.65,
                      child: AllCalculatingEventsWidget(),
                    ),
                  ],
                ),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: FractionallySizedBox(
                    alignment: AlignmentDirectional.centerStart,
                    widthFactor: .5,
                    child: Column(
                      children: [
                        const Gap(8),
                        HijriWidget(isInCalendar: true, width: double.infinity),
                        const Gap(8),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: AllCalculatingEventsWidget(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              TopBarWidget(
                isHomeChild: true,
                isQuranSetting: false,
                isNotification: false,
                isCalendarSetting: true,
                tabBarController: EventController.instance.tabBarController,
                squareColor: context.theme.primaryColorLight,
              ),
            ],
          ),
        ),
      ),
    );
  }

  ValueListenableBuilder<double?> _valueListenableBuilderWidget(
    EventController eventCtrl,
  ) {
    return ValueListenableBuilder(
      valueListenable: eventCtrl.controller,
      builder: (context, offset, child) {
        final isSheetOpen = offset != null && offset > Get.height * .3;
        return Column(
          children: [
            if (isSheetOpen) ...[
              const Gap(80),
              context.customOrientation(
                HijriWidget(isInCalendar: true),
                const SizedBox.shrink(),
              ),
            ],
            if (!isSheetOpen) ...[
              const Gap(16.0),
              context.customOrientation(
                _pageViewBuild(context, eventCtrl),
                const SizedBox.shrink(),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _pageViewBuild(BuildContext context, EventController eventCtrl) {
    return Align(
      alignment: context.customOrientation(
        Alignment.center,
        AlignmentDirectional.centerEnd,
      ),
      child: SizedBox(
        height: context.customOrientation(Get.height * .8, Get.height * .9),
        width: context.customOrientation(Get.width, Get.width * .4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            context.customOrientation(const SizedBox.shrink(), const Gap(72)),
            Expanded(
              child: PageView.builder(
                padEnds: true,
                scrollDirection: Axis.vertical,
                controller: eventCtrl.pageController,
                onPageChanged: eventCtrl.onMonthChanged,
                physics: const ClampingScrollPhysics(),
                itemCount: 12,
                itemBuilder: (context, monthIndex) {
                  eventCtrl.calenderMonth.value = eventCtrl.months[monthIndex];
                  final daysInMonth = eventCtrl.getDaysInMonth(
                    eventCtrl.calenderMonth.value,
                    eventCtrl.calenderMonth.value.hYear,
                    eventCtrl.calenderMonth.value.hMonth,
                  );
                  final firstDayWeekday = eventCtrl.calculateFirstDayOfMonth(
                    eventCtrl.calenderMonth.value.hMonth,
                    eventCtrl.calenderMonth.value.hYear,
                  );
                  // أثناء الدوران قد يبقى موضع الـ PageView الآخر ملتصقًا
                  // بالمتحكم لحظة، وقراءة page تشترط موضعًا واحدًا.
                  final controller = eventCtrl.pageController;
                  final currentPage =
                      controller.hasClients && controller.positions.length == 1
                      ? controller.page?.round()
                      : null;
                  return Opacity(
                    opacity: monthIndex == currentPage ? 1.0 : 0.5,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customSvgWithColor(
                                'assets/svg/hijri/${eventCtrl.calenderMonth.value.hMonth}.svg',
                                color: context.theme.canvasColor,
                                height: 40,
                              ),
                              Text(
                                eventCtrl.calenderMonth.value.hYear
                                    .toString()
                                    .convertNumbersToCurrentLang(),
                                style: AppTextStyles.titleLarge().copyWith(
                                  color: context.theme.canvasColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DaysName(),
                        const Gap(8),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: CalendarBuild(
                              daysInMonth: daysInMonth,
                              firstDayWeekday: firstDayWeekday,
                              month: eventCtrl.calenderMonth.value,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
