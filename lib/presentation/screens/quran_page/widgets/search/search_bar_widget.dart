import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../controllers/search_controller.dart';
import '/core/utils/constants/extensions.dart';
import '/core/utils/constants/svg_picture.dart';

class SearchBarWidget extends StatelessWidget {
  SearchBarWidget({super.key});

  final searchCtrl = sl<QuranSearchController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      margin: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 32.0),
      child: SizedBox(
        height: 50,
        width: context.customOrientation(MediaQuery.sizeOf(context).width * .7,
            MediaQuery.sizeOf(context).width * .5),
        child: TextField(
          controller: searchCtrl.searchTextEditing,
          maxLines: 1,
          style: TextStyle(
            fontSize: 16.0,
            fontFamily: 'naskh',
            fontWeight: FontWeight.w600,
            // height: 1.5.h,
            // FIXME: the text is being heidded by half size.
            color: Get.theme.hintColor.withOpacity(.7),
          ),
          decoration: InputDecoration(
            hintText: 'search_word'.tr,
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Get.theme.colorScheme.primary, width: 1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            border: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Get.theme.colorScheme.primary, width: 1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            hintStyle: TextStyle(
              fontSize: 14.0,
              fontFamily: 'kufi',
              fontWeight: FontWeight.w600,
              color: Get.theme.colorScheme.surface.withOpacity(.3),
            ),
            filled: true,
            fillColor: Get.theme.colorScheme.background,
            prefixIcon: Container(
              height: 20,
              padding: const EdgeInsets.all(10.0),
              child: search_icon(),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.close,
                color: Get.theme.hintColor,
              ),
              onPressed: () {
                searchCtrl.searchTextEditing.clear();
                searchCtrl.update();
              },
            ),
            labelText: 'search_word'.tr,
            labelStyle: TextStyle(
              fontSize: 14.0,
              fontFamily: 'kufi',
              color: Get.theme.hintColor.withOpacity(.7),
            ),
          ),
          onChanged: (query) => searchCtrl.searchQuran(query),
          onSubmitted: (query) {
            searchCtrl.searchQuran(query);
            // await sl<QuranSearchControllers>().addSearchItem(query);
            // searchCtrl.textSearchController.clear();
          },
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
        ),
      ),
    );
  }
}
