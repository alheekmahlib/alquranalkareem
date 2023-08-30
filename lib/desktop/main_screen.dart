import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spring/spring.dart';

import '../audio_screen/audio_screen.dart';
import '../azkar/screens/alzkar_view.dart';
import '../quran_text/sorah_text_screen.dart';
import '../screens/menu_screen.dart';
import '../services_locator.dart';
import '../shared/controller/notifications_controller.dart';
import '../shared/widgets/animated_stack.dart';
import '../shared/widgets/controllers_put.dart';
import '../shared/widgets/widgets.dart';
import 'desktop.dart';

class MainDScreen extends StatefulWidget {
  const MainDScreen({Key? key}) : super(key: key);

  @override
  State<MainDScreen> createState() => _MainDScreenState();
}

class _MainDScreenState extends State<MainDScreen> {
  int pageIndex = 0;

  final pages = [
    Desktop(),
    SorahTextScreen(),
    const AzkarView(),
    AudioScreen(),
    const MenuScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Spring.scale(
        springController: screenSpringController,
        start: 1,
        end: .95,
        animDuration: const Duration(milliseconds: 400), //def=1s
        animStatus: (AnimStatus status) {
          print(status);
        },
        curve: Curves.easeInOut, //def=Curves.easInOut
        delay: const Duration(seconds: 0),
        child: Stack(
          children: [
            AnimatedStack(
              buttonIcon: Icons.list,
              openAnimationCurve: Curves.easeIn,
              closeAnimationCurve: Curves.easeOut,
              backgroundColor: Theme.of(context).primaryColorDark,
              fabBackgroundColor: Theme.of(context).colorScheme.surface,
              fabIconColor: Theme.of(context).canvasColor,
              foregroundWidget: pages[pageIndex],
              columnWidget: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 32.0, bottom: 120.0, right: 6.0),
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
                            Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surface
                                    .withOpacity(.3),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Icon(
                                Icons.notifications,
                                color: Theme.of(context).canvasColor,
                              ),
                            ),
                            // Add the red dot indicator
                            if (sl<NotificationsController>()
                                .sentNotifications
                                .any((notification) => !notification['opened']))
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
                            animatRoute(sentNotification(
                                context,
                                sl<NotificationsController>().sentNotifications,
                                () => sl<NotificationsController>()
                                    .updateNotificationStatus())),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    child: GestureDetector(
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        child: SvgPicture.asset(
                          'assets/svg/quran_ic.svg',
                          colorFilter: pageIndex == 0
                              ? null
                              : ColorFilter.mode(
                                  Theme.of(context).colorScheme.background,
                                  BlendMode.srcIn),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          pageIndex = 0;
                          generalController.opened.value =
                              !generalController.opened.value;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    child: GestureDetector(
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        child: SvgPicture.asset(
                          'assets/svg/quran_te_ic.svg',
                          colorFilter: pageIndex == 1
                              ? null
                              : ColorFilter.mode(
                                  Theme.of(context).colorScheme.background,
                                  BlendMode.srcIn),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          pageIndex = 1;
                          generalController.opened.value =
                              !generalController.opened.value;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    child: GestureDetector(
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        child: SvgPicture.asset(
                          'assets/svg/azkar.svg',
                          colorFilter: pageIndex == 2
                              ? null
                              : ColorFilter.mode(
                                  Theme.of(context).colorScheme.background,
                                  BlendMode.srcIn),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          pageIndex = 2;
                          generalController.opened.value =
                              !generalController.opened.value;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    child: GestureDetector(
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        child: SvgPicture.asset(
                          'assets/svg/quran_au_ic.svg',
                          colorFilter: pageIndex == 3
                              ? null
                              : ColorFilter.mode(
                                  Theme.of(context).colorScheme.background,
                                  BlendMode.srcIn),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          pageIndex = 3;
                          generalController.opened.value =
                              !generalController.opened.value;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    child: GestureDetector(
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        child: SvgPicture.asset(
                          'assets/svg/menu_ic.svg',
                          colorFilter: pageIndex == 4
                              ? null
                              : ColorFilter.mode(
                                  Theme.of(context).colorScheme.background,
                                  BlendMode.srcIn),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          pageIndex = 4;
                          generalController.opened.value =
                              !generalController.opened.value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              bottomWidget: Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/alheekmah_logo.svg',
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).canvasColor, BlendMode.srcIn),
                      width: 100,
                    ),
                    Container(
                      height: 2,
                      margin:
                          const EdgeInsets.only(right: 16, left: 16, top: 20),
                      width: MediaQuery.of(context).size.width,
                      color: Theme.of(context).canvasColor,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
