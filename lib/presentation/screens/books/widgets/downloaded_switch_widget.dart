import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/books_controller.dart';

class DownloadedSwitchWidget extends StatelessWidget {
  DownloadedSwitchWidget({super.key});
  final bookCtrl = BooksController.instance;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: Obx(
        () => AnimatedToggleSwitch<bool>.dual(
            current: bookCtrl.state.isDownloaded.value,
            first: true,
            second: false,
            spacing: 0,
            style: ToggleStyle(
              borderColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              indicatorColor: Theme.of(context).colorScheme.primary,
            ),
            borderWidth: 1,
            height: 30,
            onChanged: (b) => bookCtrl.state.isDownloaded.value = b,
            styleBuilder: (b) => ToggleStyle(
                indicatorColor: b == 0
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.primary),
            textBuilder: (value) => value
                ? Icon(Icons.download_for_offline_outlined,
                    size: 20, color: Theme.of(context).colorScheme.surface)
                : Icon(Icons.file_download_done_outlined,
                    size: 20, color: Theme.of(context).colorScheme.surface)),
      ),
    );
  }
}
