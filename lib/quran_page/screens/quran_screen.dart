import 'package:alquranalkareem/quran_page/screens/quran_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../audio_screen/audio_screen.dart';
import '../../cubit/cubit.dart';
import '../../home_page.dart';
import '../../quran_text/sorah_text_screen.dart';
import '../../azkar/screens/alzkar_view.dart';
import '../../screens/menu_screen.dart';
import '../../shared/widgets/animated_stack.dart';
import '../../shared/widgets/widgets.dart';

class QuranPageScreen extends StatefulWidget {
  QuranPageScreen({Key? key}) : super(key: key);

  @override
  State<QuranPageScreen> createState() => _QuranPageScreenState();
}

class _QuranPageScreenState extends State<QuranPageScreen> {
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  final pages = [
    QuranPage(),
    SorahTextScreen(),
    const AzkarView(),
    const AudioScreen(),
    const MenuScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    QuranCubit cubit = QuranCubit.get(context);
    return Scaffold(
      body: Stack(
        children: [
          AnimatedStack(
            buttonIcon: Icons.list,
            openAnimationCurve: Curves.easeIn,
            closeAnimationCurve: Curves.easeOut,
            backgroundColor: Theme.of(context).primaryColorDark,
            fabBackgroundColor: Theme.of(context).colorScheme.surface,
            foregroundWidget: pages[pageIndex],
            fabIconColor: Theme.of(context).canvasColor,
            scaleWidth: 60,
            // scaleHeight: 60,
            columnWidget: Padding(
              padding: orientation(context,
                  EdgeInsets.all(0.0),
                  EdgeInsets.only(top: 140.0)),
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 52.0, bottom: 140.0, right: 6.0),
                    child: SvgPicture.asset(
                      'assets/svg/splash_icon.svg',
                      height: 100,
                      width: 100,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 16.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        child: Stack(
                          children: [
                            Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface.withOpacity(.3),
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Icon(
                                Icons.notifications,
                                color: Theme.of(context).canvasColor,
                              ),
                            ),
                            // Add the red dot indicator
                            if (sentNotifications.any((notification) => !notification['opened']))
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            animatRoute(sentNotification(context, sentNotifications, HomePage.of(context)!.updateNotificationStatus)),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    child: GestureDetector(
                      child: Container(
                        height: orientation(context, 50.0, 40.0),
                        width: orientation(context, 50.0, 40.0),
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        child: SvgPicture.asset(
                          'assets/svg/quran_ic.svg',
                          colorFilter: pageIndex == 0
                              ? null
                              : ColorFilter.mode(Theme.of(context).colorScheme.background, BlendMode.srcIn),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          pageIndex = 0;
                          cubit.opened = !cubit.opened;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    child: GestureDetector(
                      child: Container(
                        height: orientation(context, 50.0, 40.0),
                        width: orientation(context, 50.0, 40.0),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        child: SvgPicture.asset(
                          'assets/svg/quran_te_ic.svg',
                          colorFilter: pageIndex == 1
                              ? null
                              : ColorFilter.mode(Theme.of(context).colorScheme.background, BlendMode.srcIn),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          pageIndex = 1;
                          cubit.opened = !cubit.opened;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    child: GestureDetector(
                      child: Container(
                        height: orientation(context, 50.0, 40.0),
                        width: orientation(context, 50.0, 40.0),
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        child: SvgPicture.asset(
                          'assets/svg/azkar.svg',
                          colorFilter: pageIndex == 2
                              ? null
                              : ColorFilter.mode(Theme.of(context).colorScheme.background, BlendMode.srcIn),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          pageIndex = 2;
                          cubit.opened = !cubit.opened;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    child: GestureDetector(
                      child: Container(
                        height: orientation(context, 50.0, 40.0),
                        width: orientation(context, 50.0, 40.0),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        child: SvgPicture.asset(
                          'assets/svg/quran_au_ic.svg',
                          colorFilter: pageIndex == 3
                              ? null
                              : ColorFilter.mode(Theme.of(context).colorScheme.background, BlendMode.srcIn),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          pageIndex = 3;
                          cubit.opened = !cubit.opened;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    child: GestureDetector(
                      child: Container(
                        height: orientation(context, 50.0, 40.0),
                        width: orientation(context, 50.0, 40.0),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        child: SvgPicture.asset(
                          'assets/svg/menu_ic.svg',
                          colorFilter: pageIndex == 4
                              ? null
                              : ColorFilter.mode(Theme.of(context).colorScheme.background, BlendMode.srcIn),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          pageIndex = 4;
                          cubit.opened = !cubit.opened;
                        });
                      },
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
                    colorFilter: ColorFilter.mode(Theme.of(context).canvasColor, BlendMode.srcIn),
                    width: 100,
                  ),
                  Container(
                    height: 2,
                    margin: const EdgeInsets.only(right: 16, left: 16, top: 20),
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).canvasColor,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
