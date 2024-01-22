import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../presentation/controllers/playList_controller.dart';
import '../../services/services_locator.dart';

class PlayListSaveWidget extends StatelessWidget {
  const PlayListSaveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final playList = sl<PlayListController>();
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
          color: Get.theme.dividerColor.withOpacity(.4),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(width: 1, color: Get.theme.dividerColor)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 200,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextField(
                // key: playListTextFieldKeys[index],
                controller: playList.controller,
                // focusNode: _textFocusNode,
                autofocus: false,
                cursorHeight: 18,
                cursorWidth: 3,
                cursorColor: Get.theme.dividerColor,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                    color:
                        Get.isDarkMode ? Colors.white : Get.theme.primaryColor,
                    fontFamily: 'kufi',
                    fontSize: 14),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                  labelText: 'playListName'.tr,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontFamily: 'kufi',
                    color: Get.isDarkMode
                        ? Colors.white.withOpacity(.7)
                        : Get.theme.primaryColorLight.withOpacity(.7),
                  ),
                  hintText: 'playListName'.tr,
                  hintStyle: TextStyle(
                    fontSize: 12,
                    fontFamily: 'kufi',
                    color: Get.isDarkMode
                        ? Colors.white.withOpacity(.5)
                        : Get.theme.primaryColor.withOpacity(.5),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
              onTap: () {
                playList.saveList();
                playList.reset();
                playList.saveCard.currentState?.expand();
              },
              child: Container(
                height: 35,
                width: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  color: Get.theme.colorScheme.surface,
                  border: Border.all(
                    width: 1.0,
                    color: Get.theme.dividerColor,
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'save'.tr,
                    style: TextStyle(
                      color: Get.theme.canvasColor,
                      fontSize: 14,
                      fontFamily: 'kufi',
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
