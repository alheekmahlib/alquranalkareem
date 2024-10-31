import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/core/utils/constants/extensions/extensions.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../../../core/utils/constants/svg_constants.dart';
import 'controller/quran_search_controller.dart';

class LastSearchWidget extends StatelessWidget {
  LastSearchWidget({super.key});

  final searchCtrl = QuranSearchController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() => searchCtrl.state.searchHistory.isNotEmpty &&
            searchCtrl.state.ayahList.isEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const Gap(16),
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    'lastSearch'.tr,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'kufi',
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                SizedBox(
                  height: 250,
                  child: ListView.builder(
                    itemCount: searchCtrl.state.searchHistory.length,
                    itemBuilder: (context, index) {
                      final item = searchCtrl.state.searchHistory[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            searchCtrl.state.searchTextEditing.text =
                                item.query;
                            searchCtrl.surahSearch(item.query);
                            searchCtrl.search(item.query);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      customSvgWithColor(SvgPath.svgSearchIcon,
                                          width: 22.h,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface),
                                      context.vDivider(height: 25),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.query,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontFamily: 'kufi',
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(.8),
                                        ),
                                      ),
                                      Text(
                                        item.timestamp.convertNumbers(),
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontFamily: 'kufi',
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                      onPressed: () =>
                                          searchCtrl.removeSearchItem(searchCtrl
                                              .state.searchHistory[index]),
                                      icon: Icon(
                                        Icons.delete,
                                        size: 20,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                      )),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink());
  }
}
