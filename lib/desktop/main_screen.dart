import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../home_page.dart';
import '../screens/menu_screen.dart';
import '../shared/widgets/animated_stack.dart';
import '../quran_text/sorah_text_screen.dart';
import '../azkar/screens/alzkar_view.dart';
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
    const MenuScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuranCubit, QuranState>(
      listener: (BuildContext context, state) {
        if (state is QuranPageState) {
          print('page');
          // print("Current Page ${QuranCubit.get(context).currentPage}");
        } else if (state is SoundPageState) {
          print('sound');
        }
      },
      builder: (BuildContext context, state) {
        QuranCubit cubit = QuranCubit.get(context);
<<<<<<< Updated upstream
        return SafeArea(
          top: false,
          bottom: false,
          right: false,
          left: false,
          child: Scaffold(
            body: Stack(
              children: [
                AnimatedStack(
                  buttonIcon: Icons.list,
                  openAnimationCurve: Curves.easeIn,
                  closeAnimationCurve: Curves.easeOut,
                  backgroundColor: Theme.of(context).primaryColorDark,
                  fabBackgroundColor: Theme.of(context).bottomAppBarColor,
                  foregroundWidget: pages[pageIndex],
                  columnWidget: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 150.0),
                        child: SizedBox(
                            height: 150, width: 50, child: MThemeChange()),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: GestureDetector(
                          child: Container(
                            height: 50,
                            width: 50,
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                color: Theme.of(context).bottomAppBarColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                            child: SvgPicture.asset(
                              'assets/svg/quran_ic.svg',
                              color: pageIndex == 0
                                  ? null
                                  : Theme.of(context).backgroundColor,
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
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: GestureDetector(
                          child: Container(
                            height: 50,
                            width: 50,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Theme.of(context).bottomAppBarColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                            child: SvgPicture.asset(
                              'assets/svg/quran_te_ic.svg',
                              color: pageIndex == 1
                                  ? null
                                  : Theme.of(context).backgroundColor,
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
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: GestureDetector(
                          child: Container(
                            height: 50,
                            width: 50,
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                color: Theme.of(context).bottomAppBarColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                            child: SvgPicture.asset(
                              'assets/svg/azkar.svg',
                              color: pageIndex == 2
                                  ? null
                                  : Theme.of(context).backgroundColor,
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
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: GestureDetector(
                          child: Container(
                            height: 50,
                            width: 50,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Theme.of(context).bottomAppBarColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                            child: SvgPicture.asset(
                              'assets/svg/menu_ic.svg',
                              color: pageIndex == 3
                                  ? null
                                  : Theme.of(context).backgroundColor,
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
=======
        return Scaffold(
          body: Stack(
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
                      padding: const EdgeInsets.only(top: 32.0, bottom: 120.0, right: 6.0),
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
                                : ColorFilter.mode(Theme.of(context).colorScheme.background,
                                BlendMode.srcIn),
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
                                : ColorFilter.mode(Theme.of(context).colorScheme.background,
                                BlendMode.srcIn),
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
                                : ColorFilter.mode(Theme.of(context).colorScheme.background,
                                BlendMode.srcIn),
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
                                : ColorFilter.mode(Theme.of(context).colorScheme.background,
                                BlendMode.srcIn),
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
                                : ColorFilter.mode(Theme.of(context).colorScheme.background,
                                BlendMode.srcIn),
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
                        margin: const EdgeInsets.only(
                            right: 16, left: 16, top: 20),
                        width: MediaQuery.of(context).size.width,
                        color: Theme.of(context).canvasColor,
                      )
>>>>>>> Stashed changes
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
