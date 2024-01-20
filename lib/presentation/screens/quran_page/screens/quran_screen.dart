import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/widgets/animated_stack.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/general_controller.dart';
import '../../../controllers/notifications_controller.dart';
import '../../athkar/screens/alzkar_view.dart';
import '../../menu/menu_screen.dart';
import '../../notification/notification_screen.dart';
import '../../quran_text/screens/surah_text_screen.dart';
import '../../surah_audio_screen/audio_screen.dart';
import '/core/utils/constants/extensions.dart';
import '/presentation/screens/quran_page/screens/quran_home.dart';

class QuranPageScreen extends StatefulWidget {
  const QuranPageScreen({Key? key}) : super(key: key);

  @override
  State<QuranPageScreen> createState() => _QuranPageScreenState();
}

class _QuranPageScreenState extends State<QuranPageScreen> {
  @override
  void initState() {
    // getLastPage();
    super.initState();
  }

  final pages = [
    QuranPage(),
    const SurahTextScreen(),
    const AzkarView(),
    const AudioScreen(),
    const MenuScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (_) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Stack(
          children: [
            AnimatedStack(
              buttonIcon: Icons.list,
              openAnimationCurve: Curves.easeIn,
              closeAnimationCurve: Curves.easeOut,
              backgroundColor: Theme.of(context).colorScheme.background,
              fabBackgroundColor: Theme.of(context).colorScheme.surface,
              foregroundWidget: pages[sl<GeneralController>().pageIndex.value],
              fabIconColor: Theme.of(context).canvasColor,
              scaleWidth: 60,
              // scaleHeight: 60,
              columnWidget: Padding(
                padding: context.customOrientation(const EdgeInsets.all(0.0),
                    const EdgeInsets.only(top: 140.0)),
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 52.0, bottom: 70.0, right: 6.0),
                      child: SvgPicture.asset(
                        'assets/svg/splash_icon.svg',
                        height: 100,
                        width: 100,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 16.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          child: Stack(
                            children: [
                              Semantics(
                                button: true,
                                enabled: true,
                                excludeSemantics: true,
                                label: 'Notification',
                                child: Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surface
                                        .withOpacity(.3),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                  ),
                                  child: Icon(
                                    Icons.notifications,
                                    color: Theme.of(context).canvasColor,
                                  ),
                                ),
                              ),
                              // Add the red dot indicator
                              if (sl<NotificationsController>()
                                  .sentNotifications
                                  .any((notification) =>
                                      !notification['opened']))
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              animatRoute(NotificationScreen(
                                  notifications: sl<NotificationsController>()
                                      .sentNotifications,
                                  updateStatus: () =>
                                      sl<NotificationsController>()
                                          .updateNotificationStatus())),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      child: Semantics(
                        button: true,
                        enabled: true,
                        excludeSemantics: true,
                        label: 'Quran Screen',
                        child: GestureDetector(
                          child: Container(
                            height: context.customOrientation(50.0, 40.0),
                            width: context.customOrientation(50.0, 40.0),
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                            child: SvgPicture.asset(
                              'assets/svg/quran_ic.svg',
                              colorFilter:
                                  sl<GeneralController>().pageIndex.value == 0
                                      ? null
                                      : ColorFilter.mode(
                                          Theme.of(context)
                                              .colorScheme
                                              .background,
                                          BlendMode.srcIn),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              sl<GeneralController>().pageIndex.value = 0;
                              sl<GeneralController>().opened.value =
                                  !sl<GeneralController>().opened.value;
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      child: Semantics(
                        button: true,
                        enabled: true,
                        excludeSemantics: true,
                        label: 'Quran Text Screen',
                        child: GestureDetector(
                          child: Container(
                            height: context.customOrientation(50.0, 40.0),
                            width: context.customOrientation(50.0, 40.0),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                            child: SvgPicture.asset(
                              'assets/svg/quran_te_ic.svg',
                              colorFilter:
                                  sl<GeneralController>().pageIndex.value == 1
                                      ? null
                                      : ColorFilter.mode(
                                          Theme.of(context)
                                              .colorScheme
                                              .background,
                                          BlendMode.srcIn),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              sl<GeneralController>().pageIndex.value = 1;
                              sl<GeneralController>().opened.value =
                                  !sl<GeneralController>().opened.value;
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      child: Semantics(
                        button: true,
                        enabled: true,
                        excludeSemantics: true,
                        label: 'Athkar Screen',
                        child: GestureDetector(
                          child: Container(
                            height: context.customOrientation(50.0, 40.0),
                            width: context.customOrientation(50.0, 40.0),
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                            child: SvgPicture.asset(
                              'assets/svg/azkar.svg',
                              colorFilter:
                                  sl<GeneralController>().pageIndex.value == 2
                                      ? null
                                      : ColorFilter.mode(
                                          Theme.of(context)
                                              .colorScheme
                                              .background,
                                          BlendMode.srcIn),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              sl<GeneralController>().pageIndex.value = 2;
                              sl<GeneralController>().opened.value =
                                  !sl<GeneralController>().opened.value;
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      child: Semantics(
                        button: true,
                        enabled: true,
                        excludeSemantics: true,
                        label: 'Audio Screen',
                        child: GestureDetector(
                          child: Container(
                            height: context.customOrientation(50.0, 40.0),
                            width: context.customOrientation(50.0, 40.0),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                            child: SvgPicture.asset(
                              'assets/svg/quran_au_ic.svg',
                              colorFilter:
                                  sl<GeneralController>().pageIndex.value == 3
                                      ? null
                                      : ColorFilter.mode(
                                          Theme.of(context)
                                              .colorScheme
                                              .background,
                                          BlendMode.srcIn),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              sl<GeneralController>().pageIndex.value = 3;
                              sl<GeneralController>().opened.value =
                                  !sl<GeneralController>().opened.value;
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      child: Semantics(
                        button: true,
                        enabled: true,
                        excludeSemantics: true,
                        label: 'Menu Screen',
                        child: GestureDetector(
                          child: Container(
                            height: context.customOrientation(50.0, 40.0),
                            width: context.customOrientation(50.0, 40.0),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                            child: SvgPicture.asset(
                              'assets/svg/menu_ic.svg',
                              colorFilter:
                                  sl<GeneralController>().pageIndex.value == 4
                                      ? null
                                      : ColorFilter.mode(
                                          Theme.of(context)
                                              .colorScheme
                                              .background,
                                          BlendMode.srcIn),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              sl<GeneralController>().pageIndex.value = 4;
                              sl<GeneralController>().opened.value =
                                  !sl<GeneralController>().opened.value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              bottomWidget: Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/alheekmah_logo.svg',
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.surface,
                          BlendMode.srcIn),
                      width: 100,
                    ),
                    Container(
                      height: 2,
                      margin:
                          const EdgeInsets.only(right: 16, left: 16, top: 20),
                      width: MediaQuery.sizeOf(context).width,
                      color: Theme.of(context).colorScheme.surface,
                    )
                  ],
                ),
              ),
            ),
            // ),
          ],
        ),
      );
    });
  }
}
