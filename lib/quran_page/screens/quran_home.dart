import 'package:alquranalkareem/quran_page/screens/quran_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../cubit/cubit.dart';
import '../../cubit/states.dart';
import '../../database/notificationDatabase.dart';
import '../../home_page.dart';
import '../../shared/controller/general_controller.dart';
import '../../shared/widgets/audio_widget.dart';
import '../../shared/widgets/show_tafseer.dart';
import '../../shared/widgets/widgets.dart';
import '../widget/sliding_up.dart';

class QuranPage extends StatefulWidget {
  late final int sorahNum;
  QuranPage({Key? key}) : super(key: key);

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage>
    with SingleTickerProviderStateMixin {
  late String current;
  late final GeneralController generalController = Get.put(GeneralController());

  bool hasUnopenedNotifications() {
    return sentNotifications.any((notification) => !notification['opened']);
  }

  @override
  void initState() {
    generalController.controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    generalController.offset = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: generalController.controller,
      curve: Curves.easeIn,
    ));
    NotificationDatabaseHelper.loadNotifications();
    super.initState();
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
          resizeToAvoidBottomInset: true,
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
                        child: MPages(),
                      )),
                  SlideTransition(
                      position: generalController.offset, child: AudioWidget()),
                  Visibility(
                      visible: generalController.isShowControl.value,
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Sliding(
                            myWidget1: quranPageSearch(
                                context, MediaQuery.of(context).size.width),
                            myWidget2: quranPageSorahList(
                                context, MediaQuery.of(context).size.width),
                            myWidget3: notesList(
                                context, MediaQuery.of(context).size.width),
                            myWidget4: bookmarksList(
                                context, MediaQuery.of(context).size.width),
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
