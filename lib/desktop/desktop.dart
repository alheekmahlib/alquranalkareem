import 'package:alquranalkareem/quran_page/screens/quran_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../database/notificationDatabase.dart';
import '../quran_page/widget/sliding_up.dart';
import '../shared/widgets/audio_widget.dart';
import '../shared/widgets/show_tafseer.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import '../shared/widgets/widgets.dart';

class Desktop extends StatefulWidget {
  Desktop({Key? key}) : super(key: key);

  @override
  State<Desktop> createState() => _DesktopState();
}

class _DesktopState extends State<Desktop> with TickerProviderStateMixin {
  SharedPreferences? prefs;
  late String current;

  var dSorahJuzListKey = GlobalKey<ScaffoldState>();
  var dQuranSearchKey = GlobalKey<ScaffoldState>();
  var dBScaffoldKey = GlobalKey<ScaffoldState>();
  late ScrollController slidingScrollController;
  SlidingUpPanelController slidingPanelController = SlidingUpPanelController();

  @override
  void initState() {
    super.initState();
    slidingScrollController = ScrollController();
    slidingScrollController.addListener(() {
      if (slidingScrollController.offset >=
              slidingScrollController.position.maxScrollExtent &&
          !slidingScrollController.position.outOfRange) {
        slidingPanelController.expand();
      } else if (slidingScrollController.offset <=
              slidingScrollController.position.minScrollExtent &&
          !slidingScrollController.position.outOfRange) {
        slidingPanelController.anchor();
      } else {}
    });

    QuranCubit.get(context).controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    QuranCubit.get(context).offset = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: QuranCubit.get(context).controller,
      curve: Curves.easeIn,
    ));
    NotificationDatabaseHelper.loadNotifications();
  }

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
          child: Scaffold(
            key: dScaffoldKey,
            body: Stack(
              children: <Widget>[
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: DPages(
                    cubit.cuMPage,
                  ),
                ),
                SlideTransition(position: cubit.offset, child: AudioWidget()),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Visibility(
                    visible: QuranCubit.get(context).isShowControl,
                    child: Sliding(
                      myWidget1: quranPageSearch(
                        context,
                        dScaffoldKey,
                        MediaQuery.of(context).size.width / 1 / 2,
                      ),
                      myWidget2: quranPageSorahList(
                        context,
                        dScaffoldKey,
                        MediaQuery.of(context).size.width / 1 / 2,
                      ),
                      myWidget3: notesList(
                        context,
                        dScaffoldKey,
                        MediaQuery.of(context).size.width / 1 / 2,
                      ),
                      myWidget4: bookmarksList(
                        context,
                        dScaffoldKey,
                        MediaQuery.of(context).size.width / 1 / 2,
                      ),
                      myWidget5: const ShowTafseer(),
                      cHeight: 90.0,
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
