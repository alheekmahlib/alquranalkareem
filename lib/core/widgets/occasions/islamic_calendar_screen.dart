import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../app_bar_widget.dart';
import 'all_calculating_events_widget.dart';
import 'hijri_calendar_widget.dart';

class IslamicCalendarScreen extends StatelessWidget {
  const IslamicCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBarWidget(
          isTitled: true,
          title: 'islamicCalendar'.tr,
          isFontSize: false,
          searchButton: const SizedBox.shrink(),
          isNotifi: false,
          isBooks: false,
          bottom: TabBar(
            indicatorColor: Theme.of(context).colorScheme.primary,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor:
                Theme.of(context).primaryColor.withOpacity(0.7),
            labelStyle: TextStyle(
              fontFamily: 'kufi',
              fontSize: 16.sp,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
            tabs: [
              Tab(text: 'calendar'.tr),
              Tab(text: 'events'.tr),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const HijriCalendarWidget(),
            AllCalculatingEventsWidget(),
          ],
        ),
      ),
    );
  }
}
