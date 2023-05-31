import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:theme_provider/theme_provider.dart';
import '../../cubit/cubit.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/lists.dart';
import '../../shared/widgets/widgets.dart';
import '../models/all_azkar.dart';
import 'azkar_fav.dart';
import 'azkar_item.dart';



class AzkarView extends StatefulWidget {
  const AzkarView({Key? key}) : super(key: key);

  @override
  State<AzkarView> createState() => _AzkarViewState();
}

class _AzkarViewState extends State<AzkarView> {
  var controller = ScrollController();

  @override
  void initState() {
    QuranCubit.get(context).loadAzkarFontSize();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Random rnd = Random();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        // backgroundColor: Theme.of(context).colorScheme.background,
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: DefaultTabController(
                length: 2,
                child: platformView(
                    orientation(context,
                        Column(
                      children: [
                        zekrWidget(context),

                        Expanded(child: tabBar(context)),
                      ],
                    ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: zekrWidget(context),
                            ),

                            Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 1/2 * .90,
                                child: tabBar(context),
                              ),
                            ),
                          ],
                        )),
                    Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: zekrWidget(context),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1/2,
                        child: tabBar(context),
                      ),
                    ),
                  ],
                )),
              ),
            ),
          ),
        ),
      ),
    );

  }

  Widget tabBar(BuildContext context) {
    return Column(
      children: [
        TabBar(
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColorLight,
          tabs: [
            Tab(
              child: Text(
                AppLocalizations.of(context)!.azkar,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontFamily: 'kufi',
                ),
              ),
            ),
            Tab(
              child: Text(
                AppLocalizations.of(context)!.azkarfav,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                    fontFamily: 'kufi',
                    fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            children: <Widget>[
              Stack(
                children: [
                  AnimationLimiter(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: azkarDataList.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext context, int index) {
                        return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 450),
                            child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                    child: _buildListItem(context, index))));
                      },
                    ),
                  ),
                ],
              ),
              const AzkarFav(),
            ],
          ),
        ),
      ],
    );
  }

  Widget zekrWidget(BuildContext context) {
    var element = zikr[rnd.nextInt(zikr.length)];
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: .05,
          child: SvgPicture.asset(
            'assets/svg/athkar.svg',
            height: orientation(context, 220.0, 250.0),
            width: orientation(context, 220.0, 250.0),
          ),
        ),
        Container(
          height: 170.0,
          width: orientation(context,
              MediaQuery.of(context).size.width,
              platformView(
                MediaQuery.of(context).size.width / 1/2 * .65,
                MediaQuery.of(context).size.width / 1/2 * .8
              )),
          alignment: Alignment.center,
          padding:
          const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          margin:
          orientation(context,
              const EdgeInsets.only(left: 64.0, right: 16.0, top: 48.0),
              const EdgeInsets.only(left: 32.0, right: 32.0)),
          decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme.surface
                  .withOpacity(.2),
              border: Border.symmetric(
                  vertical: BorderSide(
                      color: Theme.of(context)
                          .colorScheme.surface,
                      width: 2))),
          child: Text(
            element,
            style: TextStyle(
                color: ThemeProvider.themeOf(context).id ==
                    'dark'
                    ? Colors.white
                    : Theme.of(context).primaryColor,
                fontSize: platformView(orientation(context, 16.0, 18.0), 18.0),
                height: 1.7,
                fontFamily: 'kufi',
                fontWeight: FontWeight.w100
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    return Container(
      height: 70,
      margin: const EdgeInsets.only(top: 5.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: index == 0
                ? const Radius.circular(20.0)
                : const Radius.circular(5.0),
            topRight: index == 0
                ? const Radius.circular(20.0)
                : const Radius.circular(5.0),
            bottomLeft: index == azkarDataList.length - 1
                ? const Radius.circular(20.0)
                : const Radius.circular(5.0),
            bottomRight: index == azkarDataList.length - 1
                ? const Radius.circular(20.0)
                : const Radius.circular(5.0),
          ),
          color: (index % 2 == 0
              ? Theme.of(context).colorScheme.surface
              .withOpacity(.2)
              : Theme.of(context)
              .colorScheme.background),
          ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
              animatRoute(AzkarItem(
                azkar: azkarDataList[index].toString().trim(),
              ),
          ));
        },
        child: Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Text(
                  azkarDataList[index].toString(),
                  style: TextStyle(
                      color: ThemeProvider.themeOf(context).id ==
                          'dark'
                          ? Theme.of(context)
                          .canvasColor
                          : Theme.of(context).primaryColorDark,
                      fontSize: 20,
                      fontFamily: 'kufi',
                  ),
                  softWrap: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}