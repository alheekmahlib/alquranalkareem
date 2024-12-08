part of '../quran.dart';

class ScreenSwitch extends StatelessWidget {
  ScreenSwitch({super.key});

  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuranController>(builder: (quranCtrl) {
      return Container(
        child:
            quranCtrl.state.isPages.value == 1 ? AyahsWidget() : QuranPages(),
      );
    });
  }
}
