import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/audio_screen/controller/surah_audio_controller.dart';
import '../shared/controller/general_controller.dart';
import 'audio_sorah_list.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({Key? key}) : super(key: key);

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final GeneralController generalController = Get.put(GeneralController());
  late final SurahAudioController surahAudioController =
      Get.put(SurahAudioController());

  @override
  void initState() {
    surahAudioController.controllerSorah = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    surahAudioController.offset = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: surahAudioController.controllerSorah,
      curve: Curves.easeIn,
    ));
    generalController.screenController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    generalController.screenAnimation = Tween<double>(begin: 1, end: 0.95)
        .animate(generalController.screenController!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        bottom: false,
        right: false,
        left: false,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: AnimatedBuilder(
              animation: generalController.screenAnimation!,
              builder: (context, child) {
                return Transform.scale(
                  scale: generalController.screenAnimation!.value,
                  child: child,
                );
              },
              child: const AudioSorahList()),
        ));
  }
}
