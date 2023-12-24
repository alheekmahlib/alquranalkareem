import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../../../core/widgets/widgets.dart';
import '../widgets/widgets.dart';
import '/presentation/screens/quran_text/screens/surah_list_text.dart';

class SurahTextScreen extends StatelessWidget {
  const SurahTextScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                  width: 2, color: Theme.of(context).colorScheme.surface)),
          child: platformView(
            orientation(
              context,
              Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: topBar(context),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
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
                        // height: MediaQuery.sizeOf(context).height * 3 / 4,
                        width: MediaQuery.sizeOf(context).width,
                        child: SorahListText()),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: SizedBox(
                        // height: MediaQuery.sizeOf(context).height * 3 / 4,
                        width: MediaQuery.sizeOf(context).width,
                        child: SorahListText()),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: orientation == Orientation.portrait
                          ? const EdgeInsets.only(
                              right: 16.0, left: 16.0, top: 40.0)
                          : const EdgeInsets.only(right: 16.0, left: 16.0),
                      child: topBar(context),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 5,
                  child: SorahListText(),
                ),
                Expanded(
                  flex: 5,
                  child: SizedBox(child: topBar(context)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget topBar(BuildContext context) {
    var _today = HijriCalendar.now();
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: .1,
          child: SvgPicture.asset(
            'assets/svg/hijri/${_today.hMonth}.svg',
            width: MediaQuery.sizeOf(context).width,
            colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.surface, BlendMode.srcIn),
          ),
        ),
        Align(
          alignment:
              orientation(context, Alignment.topCenter, Alignment.center),
          child: Container(
            // height: platformView(100.0, 150.0),
            width: platformView(110.0, 160.0),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                    color: Theme.of(context).colorScheme.surface, width: 1)),
            padding: const EdgeInsets.only(top: 4),
            margin: const EdgeInsets.only(top: 16.0),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: platformView(50.0, 75.0),
                  width: platformView(105.0, 155.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        topLeft: Radius.circular(8),
                      )),
                ),
                hijriDate2(context),
              ],
            ),
          ),
        ),
        orientation(
          context,
          Align(
            alignment: Alignment.bottomLeft,
            child: greeting(context),
          ),
          Align(
            alignment: Alignment.topRight,
            child: greeting(context),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Row(
            children: [
              bookmarksTextList(
                  context,
                  orientation(
                      context,
                      MediaQuery.sizeOf(context).width * .9,
                      platformView(MediaQuery.sizeOf(context).width * .5,
                          MediaQuery.sizeOf(context).width * .5))),
              quranTextSearch(
                  context,
                  orientation(
                      context,
                      MediaQuery.sizeOf(context).width * .9,
                      platformView(MediaQuery.sizeOf(context).width * .5,
                          MediaQuery.sizeOf(context).width * .5))),
              notesListText(
                  context,
                  orientation(
                      context,
                      MediaQuery.sizeOf(context).width * .9,
                      platformView(MediaQuery.sizeOf(context).width * .5,
                          MediaQuery.sizeOf(context).width * .5))),
            ],
          ),
        ),
      ],
    );
  }
}
