import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../screens/menu_screen.dart';
import '../shared/widgets/animated_stack.dart';
import '../quran_text/sorah_text_screen.dart';
import '../azkar/screens/alzkar_view.dart';
import '../shared/widgets/theme_change.dart';
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
                    ],
                  ),
                  bottomWidget: Padding(
                    padding: const EdgeInsets.only(bottom: 14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/alheekmah_logo.svg',
                          color: Theme.of(context).canvasColor,
                          width: 100,
                        ),
                        Container(
                          height: 2,
                          margin: const EdgeInsets.only(
                              right: 16, left: 16, top: 20),
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
      },
    );
  }
}
