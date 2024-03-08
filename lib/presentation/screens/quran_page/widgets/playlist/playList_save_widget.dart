import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/widgets/container_button.dart';
import '../../../../controllers/playList_controller.dart';

class PlayListSaveWidget extends StatelessWidget {
  const PlayListSaveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final playList = sl<PlayListController>();
    return GestureDetector(
        onTap: () {
          playList.saveList();
          playList.reset();
          playList.saveCard.currentState?.expand();
        },
        child: ContainerButton(
          height: 35,
          child: Text(
            'save'.tr,
            style: TextStyle(
              color: Theme.of(context).canvasColor,
              fontSize: 14,
              fontFamily: 'kufi',
            ),
          ),
        ));
  }
}
