import 'package:alquranalkareem/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../quran_page/cubit/audio/cubit.dart';
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

  @override
  void initState() {
    AudioCubit.get(context).loadSorahReader();
    AudioCubit.get(context).controllerSorah = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    AudioCubit.get(context).offset = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: AudioCubit.get(context).controllerSorah,
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
    QuranCubit cubit = QuranCubit.get(context);
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
