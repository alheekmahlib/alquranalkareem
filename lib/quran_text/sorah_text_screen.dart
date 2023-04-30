import 'package:alquranalkareem/quran_text/sorah_list_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hijri/hijri_calendar.dart';
import '../cubit/cubit.dart';
import '../shared/widgets/widgets.dart';


class SorahTextScreen extends StatefulWidget {
  SorahTextScreen({Key? key}) : super(key: key);

  @override
  State<SorahTextScreen> createState() => _SorahTextScreenState();
}

class _SorahTextScreenState extends State<SorahTextScreen> {
  var sorahListKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    QuranCubit.get(context).loadQuranFontSize();
    QuranCubit.get(context).updateGreeting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _today = HijriCalendar.now();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: sorahListKey,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: orientation == Orientation.portrait
                        ? EdgeInsets.only(right: 16.0, left: 16.0, top: 40.0)
                        : EdgeInsets.only(right: 16.0, left: 16.0),
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: .1,
                          child: SvgPicture.asset(
                            'assets/svg/hijri/${_today.hMonth}.svg',
                            width: MediaQuery.of(context).size.width,
<<<<<<< Updated upstream
                            color: Theme.of(context).bottomAppBarColor,
=======
                            colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn),
>>>>>>> Stashed changes
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: orientation(context,
                              Container(
                                height: 100,
                                width: 110,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8)),
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.surface,
                                    width: 1
                                  )
                                ),
                                padding: EdgeInsets.only(top: 4),
                                child: Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 105,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.surface,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(8),
                                            topLeft: Radius.circular(8),
                                          )
                                        ),
                                    ),
                                    hijriDate2(context),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: 120, child: hijriDateLand(context))),
                        ),
<<<<<<< Updated upstream
=======
                    orientation(context,
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '| ${QuranCubit.get(context).greeting} |',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'kufi',
                              color: Theme.of(context).colorScheme.surface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '| ${QuranCubit.get(context).greeting} |',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'kufi',
                              color: Theme.of(context).colorScheme.surface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            children: [
                              bookmarksTextList(context, sorahListKey,
                                  orientation(context,
                                      MediaQuery.of(context).size.width * .9,
                                      platformView(MediaQuery.of(context).size.width  * .5, MediaQuery.of(context).size.width * .5))),
                              quranTextSearch(context, sorahListKey,
                                orientation(context,
                                    MediaQuery.of(context).size.width * .9,
                                    platformView(MediaQuery.of(context).size.width  * .5, MediaQuery.of(context).size.width * .5))),
                            ],
                          ),
                        ),
>>>>>>> Stashed changes
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 16,
                ),
                const Divider(
                  height: 1,
                  thickness: 2,
                  endIndent: 16,
                  indent: 16,
                ),
                Expanded(
                  flex: 8,
                  child: SizedBox(
                      // height: MediaQuery.of(context).size.height * 3 / 4,
                      width: MediaQuery.of(context).size.width,
                      child: const SorahListText()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
