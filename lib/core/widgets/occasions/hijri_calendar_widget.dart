import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../../presentation/controllers/general/general_controller.dart';
import '../../utils/constants/lists.dart';
import 'controller/event_controller.dart';

class HijriCalendarWidget extends StatefulWidget {
  const HijriCalendarWidget({super.key});

  @override
  State<HijriCalendarWidget> createState() => _HijriCalendarWidgetState();
}

class _HijriCalendarWidgetState extends State<HijriCalendarWidget> {
  final generalCtrl = GeneralController.instance;
  final eventCtrl = EventController.instance;
  late HijriCalendar _selectedDate;
  late PageController _pageController;
  late List<HijriCalendar> _months;
  final int _startYear = 1400; // Starting year for selection
  final int _endYear = 1500; // Ending year for selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      // appBar: AppBarWidget(
      //   isTitled: true,
      //   title: 'hijriCalendar'.tr,
      //   isFontSize: true,
      //   searchButton: const SizedBox.shrink(),
      //   isNotifi: false,
      //   isBooks: false,
      // ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            color: Theme.of(context).colorScheme.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_left,
                    color: Theme.of(context).canvasColor,
                  ),
                  onPressed: () => _onYearChanged(_selectedDate.hYear - 1),
                ),
                GestureDetector(
                  onTap: _showYearPicker,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).canvasColor.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${'year'.tr} ${_selectedDate.hYear} ${'hijri'.tr}',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontFamily: 'kufi',
                            color: Theme.of(context).canvasColor,
                          ),
                        ),
                        Gap(4.w),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Theme.of(context).canvasColor,
                          size: 20.sp,
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_right,
                    color: Theme.of(context).canvasColor,
                  ),
                  onPressed: () => _onYearChanged(_selectedDate.hYear + 1),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onMonthChanged,
                itemCount: 12,
                itemBuilder: (context, monthIndex) {
                  final month = _months[monthIndex];
                  final daysInMonth =
                      month.getDaysInMonth(month.hYear, month.hMonth);
                  final firstDayWeekday = month.weekDay();

                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.arrow_left,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                              ),
                              onPressed: () {
                                if (_pageController.page! > 0) {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                            ),
                            GestureDetector(
                              onTap: _showMonthPicker,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color!
                                          .withOpacity(0.5),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      month.longMonthName.tr,
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontFamily: 'kufi',
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Gap(4.w),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color,
                                      size: 20.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.arrow_right,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                              ),
                              onPressed: () {
                                if (_pageController.page! < 11) {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Gap(8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(
                          7,
                          (index) => SizedBox(
                            width: 40.w,
                            child: Text(
                              _getWeekdayName(index).tr,
                              style: TextStyle(
                                fontFamily: 'kufi',
                                fontSize: 12.sp,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          padding: EdgeInsets.all(8.w),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            childAspectRatio: 1,
                            mainAxisSpacing: 4.h,
                            crossAxisSpacing: 4.w,
                          ),
                          itemCount: 42,
                          itemBuilder: (context, index) {
                            final dayOffset = index - firstDayWeekday + 1;
                            if (dayOffset < 1 || dayOffset > daysInMonth) {
                              return const SizedBox();
                            }

                            final isCurrentDay =
                                month.hYear == generalCtrl.state.today.hYear &&
                                    month.hMonth ==
                                        generalCtrl.state.today.hMonth &&
                                    dayOffset == generalCtrl.state.today.hDay;

                            final hasEvent = occasionList.any((event) =>
                                event['month'] == month.hMonth &&
                                event['day'] == dayOffset);

                            final eventTitle = hasEvent
                                ? occasionList
                                    .firstWhere(
                                      (event) =>
                                          event['month'] == month.hMonth &&
                                          event['day'] == dayOffset,
                                    )['title']
                                    .toString()
                                    .tr
                                : null;

                            return Container(
                              decoration: BoxDecoration(
                                color: isCurrentDay
                                    ? Theme.of(context).colorScheme.surface
                                    : hasEvent
                                        ? Theme.of(context)
                                            .colorScheme
                                            .surface
                                            .withOpacity(0.3)
                                        : null,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.surface,
                                  width: 1,
                                ),
                              ),
                              child: Tooltip(
                                message: eventTitle ?? '',
                                child: Center(
                                  child: Text(
                                    dayOffset.toString(),
                                    style: TextStyle(
                                      fontFamily: 'kufi',
                                      fontSize: 14.sp,
                                      color: isCurrentDay
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primaryContainer
                                          : Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color,
                                      fontWeight: isCurrentDay
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = generalCtrl.state.today;
    _pageController = PageController(
      initialPage: _selectedDate.hMonth - 1,
    );
    _initializeMonths();
  }

  String _getWeekdayName(int index) {
    final weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return weekdays[index].tr;
  }

  void _initializeMonths() {
    _months = List.generate(12, (index) {
      var hijri = HijriCalendar.setLocal(
        Get.locale!.languageCode,
      );
      hijri.hYear = _selectedDate.hYear;
      hijri.hMonth = index + 1;
      hijri.hDay = 1;
      hijri.gregorianToHijri(
        hijri.hijriToGregorian(hijri.hYear, hijri.hMonth, hijri.hDay).year,
        hijri.hijriToGregorian(hijri.hYear, hijri.hMonth, hijri.hDay).month,
        hijri.hijriToGregorian(hijri.hYear, hijri.hMonth, hijri.hDay).day,
      );
      return hijri;
    });
  }

  void _onMonthChanged(int month) {
    setState(() {
      _selectedDate = HijriCalendar()
        ..hYear = _selectedDate.hYear
        ..hMonth = month + 1
        ..hDay = _selectedDate.hDay;
    });
  }

  void _onYearChanged(int year) {
    setState(() {
      _selectedDate = HijriCalendar()
        ..hYear = year
        ..hMonth = _selectedDate.hMonth
        ..hDay = _selectedDate.hDay;
      _initializeMonths();
    });
  }

  void _showMonthPicker() {
    final currentMonth = _selectedDate.hMonth;
    final months = List.generate(12, (index) {
      var hijri = HijriCalendar();
      hijri.hYear = _selectedDate.hYear;
      hijri.hMonth = index + 1;
      hijri.hDay = 1;
      return hijri;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'month'.tr,
          style: TextStyle(
            fontFamily: 'kufi',
            fontSize: 18.sp,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8.h,
              crossAxisSpacing: 8.w,
              childAspectRatio: 3,
            ),
            itemCount: months.length,
            itemBuilder: (context, index) {
              final month = months[index];
              final isSelected = month.hMonth == currentMonth;
              return InkWell(
                onTap: () {
                  _pageController.animateToPage(
                    month.hMonth - 1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : null,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    month.getLongMonthName().tr,
                    style: TextStyle(
                      fontFamily: 'kufi',
                      fontSize: 14.sp,
                      color: isSelected
                          ? Theme.of(context).canvasColor
                          : Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showYearPicker() {
    final currentYear = _selectedDate.hYear;
    final years = List.generate(
      _endYear - _startYear + 1,
      (index) => _startYear + index,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'year'.tr,
          style: TextStyle(
            fontFamily: 'kufi',
            fontSize: 18.sp,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8.h,
              crossAxisSpacing: 8.w,
              childAspectRatio: 2,
            ),
            itemCount: years.length,
            itemBuilder: (context, index) {
              final year = years[index];
              final isSelected = year == currentYear;
              return InkWell(
                onTap: () {
                  _onYearChanged(year);
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : null,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      year.toString(),
                      style: TextStyle(
                        fontFamily: 'kufi',
                        fontSize: 14.sp,
                        color: isSelected
                            ? Theme.of(context).canvasColor
                            : Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
