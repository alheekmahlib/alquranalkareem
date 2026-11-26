import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '/presentation/controllers/general/general_controller.dart';
import '../../../core/tour/app_tour.dart';
import '../../../core/tour/home_tour_script.dart';
import '../../../core/tour/tour_replay_button.dart';
import '../../../core/widgets/tab_bar_widget.dart';
import '../../controllers/daily_ayah_controller.dart';
import '../../controllers/theme_controller.dart';
import '../adhkar/controller/adhkar_controller.dart';
import 'widgets/ai_section.dart';
import 'widgets/books_section.dart';
import 'widgets/daily_zeker.dart';
import 'widgets/hijri_widget.dart';
import 'widgets/quran_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (_) {
        return ScreenUtilInit(
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primary,
            body: SafeArea(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Stack(
                  children: [
                    context.customOrientation(
                      ListView(
                        controller: GeneralController
                            .instance
                            .state
                            .homeScrollController,
                        padding: const EdgeInsets.only(top: 80),
                        children: [
                          HijriWidget(),
                          const Gap(16),
                          AiSection(),
                          QuranSection(),
                          const Gap(16),
                          DailyZeker(),
                          const Gap(16),
                          const BooksSection(),
                          const Gap(16),
                        ],
                      ),
                      SingleChildScrollView(
                        controller: GeneralController
                            .instance
                            .state
                            .homeScrollController,
                        padding: const EdgeInsets.only(top: 80),
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      HijriWidget(),
                                      const Gap(8),
                                      DailyZeker(),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      AiSection(),
                                      const Gap(8),
                                      QuranSection(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Gap(16),
                            const BooksSection(),
                            const Gap(16),
                          ],
                        ),
                      ),
                    ),
                    TopBarWidget(
                      isHomeChild: false,
                      isQuranSetting: false,
                      isNotification: true,
                      notificationButtonKey: HomeTourKeys.notifications,
                      tabBarController:
                          GeneralController.instance.state.tabBarController,
                    ),
                    // يشغّل جولة الصفحة الرئيسية تلقائياً أول مرة بعد جاهزية
                    // المحتوى اليومي، ويعيدها زر الاستفهام في أي وقت.
                    const _HomeTourTrigger(),
                    TourReplayButton(
                      onPressed: () => AppTour.instance.replayHomeTour(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// يشغّل جولة الصفحة الرئيسية تلقائياً أول مرة: آية اليوم وذكر اليوم
/// حقول عادية في كنترولريهما تُملأ بعد جلبهما من قاعدتي البيانات، فينتظر
/// البطاقة حضورهما (أو انقضاء مهلة انتظارهما) قبل البدء كي لا تفصل
/// محطاتهما من الجولة. وكونه ودجتاً داخل الشاشة يلغي التشغيل بعد
/// مغادرتها، فالبطاقة تُفكَّك معها فيُلغى النداء المعلّق ولا تبدأ الجولة
/// فوق شاشة أخرى.
class _HomeTourTrigger extends StatefulWidget {
  const _HomeTourTrigger();

  @override
  State<_HomeTourTrigger> createState() => _HomeTourTriggerState();
}

class _HomeTourTriggerState extends State<_HomeTourTrigger> {
  static const _checkInterval = Duration(milliseconds: 250);
  static const _waitLimit = Duration(seconds: 4);

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    var waited = Duration.zero;
    _timer = Timer.periodic(_checkInterval, (timer) {
      final ready =
          DailyAyahController.instance.ayahOfTheDay != null &&
          AzkarController.instance.state.dhekrOfTheDay != null;
      waited += _checkInterval;
      if (!ready && waited < _waitLimit) return;
      timer.cancel();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) AppTour.instance.startHomeTourOnce();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
