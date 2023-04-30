import 'package:alquranalkareem/quran_page/screens/quran_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bookmarks_notes_db/notificationDatabase.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';
import '../../shared/widgets/audio_widget.dart';
import '../../shared/widgets/show_tafseer.dart';
import '../../shared/widgets/widgets.dart';
import '../cubit/bookmarks/bookmarks_cubit.dart';
import '../widget/sliding_up.dart';
import '../../home_page.dart';

class QuranPage extends StatefulWidget {
  late int sorahNum;
  QuranPage({Key? key}) : super(key: key);

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage>
    with SingleTickerProviderStateMixin {
  late String current;

  bool hasUnopenedNotifications() {
    return sentNotifications.any((notification) => !notification['opened']);
  }


  @override
  void initState() {
    BookmarksCubit.get(context).getBookmarksList();
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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuranCubit, QuranState>(
      listener: (BuildContext context, state) {
        if (state is QuranPageState) {
          print('page');
        } else if (state is SoundPageState) {
          print('sound');
        }
      },
      builder: (BuildContext context, state) {
        QuranCubit cubit = QuranCubit.get(context);
        return Scaffold(
          key: mScaffoldKey,
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: OrientationBuilder(builder: (context, orientation) {
            return Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: Stack(
                children: <Widget>[
                  Directionality(
                      textDirection: TextDirection.rtl,
                      child: Center(
                        child: MPages(
                          initialPageNum: cubit.cuMPage,
                        ),
                      )),
                  SlideTransition(position: cubit.offset, child: AudioWidget()),
                  Visibility(
                      visible: cubit.isShowControl,
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Sliding(
                            myWidget1: quranPageSearch(context, mScaffoldKey,
                                MediaQuery.of(context).size.width),
                            myWidget2: quranPageSorahList(context, mScaffoldKey,
                                MediaQuery.of(context).size.width),
                            myWidget3: notesList(context, mScaffoldKey,
                                MediaQuery.of(context).size.width),
                            myWidget4: bookmarksList(context, mScaffoldKey,
                                MediaQuery.of(context).size.width),
                            myWidget5: const ShowTafseer(),
                            cHeight: 110.0,
                          ))),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
