import 'package:alquranalkareem/quran_page/screens/quran_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
<<<<<<< HEAD
import '../../audio_screen/audio_screen.dart';
=======
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
import '../../cubit/cubit.dart';
import '../../quran_text/sorah_text_screen.dart';
import '../../azkar/screens/alzkar_view.dart';
import '../../screens/menu_screen.dart';
import '../../shared/widgets/theme_change.dart';
import '../../shared/widgets/animated_stack.dart';

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
<<<<<<< HEAD
    const AudioScreen(),
=======
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
    const MenuScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    QuranCubit cubit = QuranCubit.get(context);
<<<<<<< HEAD
    Orientation orientation = MediaQuery.of(context).orientation;
=======
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
    return Scaffold(
      body: Stack(
        children: [
          AnimatedStack(
            buttonIcon: Icons.list,
            openAnimationCurve: Curves.easeIn,
            closeAnimationCurve: Curves.easeOut,
            backgroundColor: Theme.of(context).primaryColorDark,
<<<<<<< HEAD
            fabBackgroundColor: Theme.of(context).colorScheme.surface,
            foregroundWidget: pages[pageIndex],
            fabIconColor: Theme.of(context).canvasColor,
            columnWidget: Column(
              children: [
                Padding(
=======
            fabBackgroundColor: Theme.of(context).bottomAppBarColor,
            foregroundWidget: pages[pageIndex],
            columnWidget: Column(
              children: [
                const Padding(
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
                  padding: EdgeInsets.only(bottom: 100.0),
                  child:
                      SizedBox(height: 150, width: 50, child: MThemeChange()),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: GestureDetector(
                    child: Container(
<<<<<<< HEAD
                      height: orientation == Orientation.portrait
                          ? 50
                          : 40,
                      width: orientation == Orientation.portrait
                          ? 50
                          : 40,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
=======
                      height: 50,
                      width: 50,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          color: Theme.of(context).bottomAppBarColor,
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      child: SvgPicture.asset(
                        'assets/svg/quran_ic.svg',
                        color: pageIndex == 0
                            ? null
<<<<<<< HEAD
                            : Theme.of(context).colorScheme.background,
=======
                            : Theme.of(context).backgroundColor,
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
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
<<<<<<< HEAD
                      height: orientation == Orientation.portrait
                          ? 50
                          : 40,
                      width: orientation == Orientation.portrait
                          ? 50
                          : 40,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
=======
                      height: 50,
                      width: 50,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Theme.of(context).bottomAppBarColor,
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      child: SvgPicture.asset(
                        'assets/svg/quran_te_ic.svg',
                        color: pageIndex == 1
                            ? null
<<<<<<< HEAD
                            : Theme.of(context).colorScheme.background,
=======
                            : Theme.of(context).backgroundColor,
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
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
<<<<<<< HEAD
                      height: orientation == Orientation.portrait
                          ? 50
                          : 40,
                      width: orientation == Orientation.portrait
                          ? 50
                          : 40,
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
=======
                      height: 50,
                      width: 50,
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                          color: Theme.of(context).bottomAppBarColor,
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      child: SvgPicture.asset(
                        'assets/svg/azkar.svg',
                        color: pageIndex == 2
                            ? null
<<<<<<< HEAD
                            : Theme.of(context).colorScheme.background,
=======
                            : Theme.of(context).backgroundColor,
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
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
<<<<<<< HEAD
                      height: orientation == Orientation.portrait
                          ? 50
                          : 40,
                      width: orientation == Orientation.portrait
                          ? 50
                          : 40,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      child: SvgPicture.asset(
                        'assets/svg/quran_au_ic.svg',
                        color: pageIndex == 3
                            ? null
                            : Theme.of(context).colorScheme.background,
=======
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
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
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
<<<<<<< HEAD
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: GestureDetector(
                    child: Container(
                      height: orientation == Orientation.portrait
                          ? 50
                          : 40,
                      width: orientation == Orientation.portrait
                          ? 50
                          : 40,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      child: SvgPicture.asset(
                        'assets/svg/menu_ic.svg',
                        color: pageIndex == 4
                            ? null
                            : Theme.of(context).colorScheme.background,
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
=======
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
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
