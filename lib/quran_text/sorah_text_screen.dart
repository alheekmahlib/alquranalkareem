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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
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
                            color: Theme.of(context).bottomAppBarColor,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: orientation == Orientation.portrait
                              ? hijriDate(context)
                              : SizedBox(
                                  height: 120, child: hijriDateLand(context)),
                        ),
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
                  flex: 7,
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height * 3 / 4,
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
