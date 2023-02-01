import 'package:alquranalkareem/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../cubit/cubit.dart';
import 'about_app.dart';
import '../shared/widgets/widgets.dart';
import 'info_app.dart';
import 'alwaqf_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    QuranCubit.get(context).loadMCurrentPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    QuranCubit cubit = QuranCubit.get(context);
    return SafeArea(
      top: false,
      bottom: false,
      right: false,
      left: false,
      child: Scaffold(
<<<<<<< HEAD
        backgroundColor: Theme.of(context).colorScheme.background,
=======
        backgroundColor: Theme.of(context).backgroundColor,
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
        body: Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 64.0),
          child: ListView(
            children: [
              const Divider(
                thickness: 1,
              ),
              Container(
                height: orientation == Orientation.portrait ? 220 : 350,
                // width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/hijiri_widget.svg',
                    ),
                    hijriDate(context),
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
                height: 30,
              ),
              Wrap(
                children: [
                  orientation == Orientation.portrait
                      ? Container(
                          height: 100,
                          width: 170,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Stack(
                            children: [
                              SvgPicture.asset(
                                'assets/svg/last_read.svg',
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context)!.lastRead,
                                    style: TextStyle(
                                      fontFamily: 'kufi',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color:
<<<<<<< HEAD
                                          Theme.of(context).colorScheme.surface,
=======
                                          Theme.of(context).bottomAppBarColor,
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Divider(
                                    height: 1,
                                    endIndent: 20,
                                    indent: 20,
                                  ),
                                  SvgPicture.asset(
                                    'assets/svg/surah_name/00${cubit.soMName}.svg',
                                    height: 36,
<<<<<<< HEAD
                                    color: Theme.of(context).colorScheme.surface,
=======
                                    color: Theme.of(context).bottomAppBarColor,
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
                                  ),
                                  Divider(
                                    height: 1,
                                    endIndent: 20,
                                    indent: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '|${AppLocalizations.of(context)!.pageNo} ${cubit.cuMPage}|',
                                        style: TextStyle(
                                          fontFamily: 'kufi',
                                          fontSize: 12,
                                          color: Theme.of(context)
<<<<<<< HEAD
                                              .colorScheme.surface,
=======
                                              .bottomAppBarColor,
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.menu_book,
                                        color:
<<<<<<< HEAD
                                            Theme.of(context).colorScheme.surface,
=======
                                            Theme.of(context).bottomAppBarColor,
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
                                        size: 14,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : Container(
                          height: 300,
                          width: 370,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Stack(
                            children: [
                              SvgPicture.asset(
                                'assets/svg/last_read.svg',
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context)!.lastRead,
                                    style: TextStyle(
                                      fontFamily: 'kufi',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color:
<<<<<<< HEAD
                                          Theme.of(context).colorScheme.surface,
=======
                                          Theme.of(context).bottomAppBarColor,
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
                                    ),
                                  ),
                                  SizedBox(
                                    height: 70,
                                  ),
                                  Divider(
                                    height: 1,
                                    endIndent: 120,
                                    indent: 120,
                                  ),
                                  SvgPicture.asset(
                                    'assets/svg/surah_name/00${cubit.soMName}.svg',
                                    height: 52,
<<<<<<< HEAD
                                    color: Theme.of(context).colorScheme.surface,
=======
                                    color: Theme.of(context).bottomAppBarColor,
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
                                  ),
                                  Divider(
                                    height: 1,
                                    endIndent: 120,
                                    indent: 120,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '|${AppLocalizations.of(context)!.pageNo} ${cubit.cuMPage}|',
                                        style: TextStyle(
                                          fontFamily: 'kufi',
                                          fontSize: 14,
                                          color: Theme.of(context)
<<<<<<< HEAD
                                              .colorScheme.surface,
=======
                                              .bottomAppBarColor,
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.menu_book,
                                        color:
<<<<<<< HEAD
                                            Theme.of(context).colorScheme.surface,
=======
                                            Theme.of(context).bottomAppBarColor,
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                  SizedBox(
                    width: 8,
                  ),
                  Column(
                    children: [
                      GestureDetector(
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
<<<<<<< HEAD
                                          .colorScheme.surface
=======
                                          .bottomAppBarColor
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
                                          .withOpacity(.4),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8))),
                                ),
                                Opacity(
                                  opacity: .1,
                                  child: SvgPicture.asset(
                                    'assets/svg/alwaqf.svg',
                                    width: 90,
                                  ),
                                ),
                                SvgPicture.asset(
                                  'assets/svg/alwaqf.svg',
                                  width: 70,
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .push(animatRoute(AlwaqfScreen()));
                          }),
                      SizedBox(
                        height: 8,
                      ),
                      GestureDetector(
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
<<<<<<< HEAD
                                          .colorScheme.surface
=======
                                          .bottomAppBarColor
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
                                          .withOpacity(.4),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8))),
                                ),
                                Opacity(
                                    opacity: .1,
                                    child: SvgPicture.asset(
                                      'assets/svg/menu_ic.svg',
                                      width: 110,
                                    )),
                                SvgPicture.asset(
                                  'assets/svg/menu_ic.svg',
                                  width: 80,
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .push(animatRoute(const AboutApp()));
                          }),
                    ],
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
<<<<<<< HEAD
                                      .colorScheme.surface
=======
                                      .bottomAppBarColor
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
                                      .withOpacity(.4),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8))),
                            ),
                            Opacity(
                              opacity: .1,
                              child: SvgPicture.asset(
                                'assets/svg/info_ic.svg',
                                width: 130,
                              ),
                            ),
                            SvgPicture.asset(
                              'assets/svg/info_ic.svg',
                              width: 90,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context)
                            .push(animatRoute(const InfoApp()));
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
