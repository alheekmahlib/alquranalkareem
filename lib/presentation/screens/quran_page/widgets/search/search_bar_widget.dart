import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/extensions/extensions.dart';
import '../../../../controllers/aya_controller.dart';
import '/core/utils/constants/svg_picture.dart';

class SearchBarWidget extends StatelessWidget {
  SearchBarWidget({super.key});

  final ayahCtrl = sl<AyaController>();

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
          controller: ayahCtrl.searchTextEditing,
          maxLines: 1,
          style: TextStyle(
            fontSize: 16.0,
            fontFamily: 'naskh',
            fontWeight: FontWeight.w600,
            // height: 1.5.h,
            // FIXME: the text is being heidded by half size.
            color: Theme.of(context).hintColor.withOpacity(.7),
          ),
          decoration: InputDecoration(
            hintText: 'search_word'.tr,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            hintStyle: TextStyle(
              fontSize: 14.0,
              fontFamily: 'kufi',
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.surface.withOpacity(.3),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.background,
            prefixIcon: Container(
              height: 20,
              padding: const EdgeInsets.all(10.0),
              child: search_icon(),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.close,
                color: Theme.of(context).hintColor,
              ),
              onPressed: () {
                ayahCtrl.searchTextEditing.clear();
                ayahCtrl.ayahList.clear();
                ayahCtrl.surahList.clear();
              },
            ),
            labelText: 'search_word'.tr,
            labelStyle: TextStyle(
              fontSize: 14.0,
              fontFamily: 'kufi',
              color: Theme.of(context).hintColor.withOpacity(.7),
            ),
          ),
          onChanged: (query) {
            if (query.length > 3) ayahCtrl.surahSearch(query);
            if (query.length > 3) ayahCtrl.search(query);
          },
          onSubmitted: (query) {
            ayahCtrl.surahSearch(query);
            ayahCtrl.search(query);
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
