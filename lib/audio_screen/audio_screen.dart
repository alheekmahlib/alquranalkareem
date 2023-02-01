import 'package:flutter/material.dart';

import '../quran_page/cubit/audio/cubit.dart';
import 'audio_sorah_list.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({Key? key}) : super(key: key);

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {

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
          body: AudioSorahList(),
        ));
  }
}
