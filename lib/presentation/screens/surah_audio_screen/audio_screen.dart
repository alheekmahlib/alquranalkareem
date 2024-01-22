import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'audio_sorah_list.dart';

class AudioScreen extends StatelessWidget {
  const AudioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        bottom: false,
        right: false,
        left: false,
        child: Scaffold(
          backgroundColor: Get.theme.colorScheme.background,
          appBar: AppBar(
            backgroundColor: Get.theme.colorScheme.background,
          ),
          body: const AudioSorahList(),
        ));
  }
}
