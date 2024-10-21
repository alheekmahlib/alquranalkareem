import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/presentation/screens/quran_page/widgets/search/search_extensions/highlight_extension.dart';
import '../../../../../core/utils/constants/extensions/extensions.dart';
import '../../../../../core/utils/constants/lottie.dart';
import '../../../../../core/utils/constants/lottie_constants.dart';
import '../../../../controllers/general/general_controller.dart';
import '../../controllers/extensions/quran/quran_ui.dart';
import '../../controllers/quran/quran_controller.dart';
import '../../data/data_source/quran_database.dart';
import '../../extensions/surah_name_with_banner.dart';
import 'controller/quran_search_controller.dart';
import 'last_search_widget.dart';
import 'search_bar_widget.dart';

class QuranSearch extends StatelessWidget {
  QuranSearch({super.key});
  final generalCtrl = GeneralController.instance;
  final quranCtrl = QuranController.instance;
  final searchCtrl = QuranSearchController.instance;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            const Gap(16),
            context.customClose(),
            const Gap(16),
            TextFieldBarWidget(
              controller: searchCtrl.state.searchTextEditing,
              onPressed: () {
                searchCtrl.state.searchTextEditing.clear();
                searchCtrl.state.ayahList.clear();
                searchCtrl.state.surahList.clear();
              },
              onChanged: (query) {
                if (searchCtrl.state.searchTextEditing.text.isNotEmpty ||
                    query.trim().isNotEmpty) {
                  searchCtrl.surahSearch(query);
                  searchCtrl.search(query);
                } else {
                  searchCtrl.state.searchTextEditing.clear();
                  searchCtrl.state.ayahList.clear();
                  searchCtrl.state.surahList.clear();
                }
              },
              onSubmitted: (query) {
                if (query.length <= 0 || query.trim().isNotEmpty) {
                  searchCtrl.addSearchItem(query);
                }
                // await sl<QuranSearchControllers>().addSearchItem(query);
                // searchCtrl.textSearchController.clear();
              },
            ),
            const Gap(16),
            Obx(
              () {
                if (searchCtrl.state.surahList.isEmpty ||
                    searchCtrl.state.surahList.isEmpty ||
                    searchCtrl.state.searchTextEditing.text.isEmpty) {
                  return LastSearchWidget();
                } else if (searchCtrl.state.surahList.isNotEmpty) {
                  return Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.builder(
                        itemCount: searchCtrl.state.surahList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          QuranTableData search =
                              searchCtrl.state.surahList[index];
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: GestureDetector(
                              onTap: () {
                                quranCtrl.changeSurahListOnTap(search.pageNum!);
                                Get.back();
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 4.0, vertical: 10.0),
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8))),
                                child: surahNameWidget(
                                    search.surahNum.toString(),
                                    Theme.of(context).canvasColor,
                                    height: 40),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  return customLottie(LottieConstants.assetsLottieNotFound,
                      height: 200.0, width: 200.0);
                }
              },
            ),
            Flexible(
              flex: 9,
              child: Obx(
                () {
                  if (searchCtrl.state.ayahList.isEmpty ||
                      searchCtrl.state.searchTextEditing.text.isEmpty) {
                    return customLottie(LottieConstants.assetsLottieSearch,
                        width: 200.0, height: 200.0);
                  } else if (searchCtrl.state.ayahList.isNotEmpty) {
                    return ListView.builder(
                      controller: searchCtrl.state.scrollController,
                      itemCount: searchCtrl.state.ayahList.length,
                      itemBuilder: (context, index) {
                        QuranTableData search =
                            searchCtrl.state.ayahList[index];
                        // List<TextSpan> highlightedTextSpans =
                        //     highlightLine(search.SearchText);
                        return Directionality(
                          textDirection: TextDirection.rtl,
                          child: Container(
                              child: Column(
                            children: <Widget>[
                              Container(
                                color: (index % 2 == 0
                                    ? Theme.of(context)
                                        .colorScheme
                                        .surface
                                        .withOpacity(.05)
                                    : Theme.of(context)
                                        .colorScheme
                                        .surface
                                        .withOpacity(.1)),
                                child: ListTile(
                                  onTap: () {
                                    quranCtrl.clearAndAddSelection(search.id);
                                    quranCtrl
                                        .changeSurahListOnTap(search.pageNum!);
                                    Get.back();
                                  },
                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RichText(
                                      text: TextSpan(
                                        children: search.searchTextColumn
                                            .highlightLine(searchCtrl
                                                .state.searchTextEditing.text),
                                        style: TextStyle(
                                          fontFamily: "uthmanic2",
                                          fontWeight: FontWeight.normal,
                                          fontSize: 22,
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                  subtitle: Container(
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4))),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: Get
                                                      .theme.colorScheme.primary
                                                      .withOpacity(.7),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(4),
                                                    bottomRight:
                                                        Radius.circular(4),
                                                  )),
                                              child: Text(
                                                " ${'part'.tr}: ${search.partNum}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .canvasColor,
                                                    fontSize: 12),
                                              )),
                                        ),
                                        Expanded(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft: Radius.circular(4),
                                                    bottomLeft:
                                                        Radius.circular(4),
                                                  )),
                                              child: Text(
                                                " ${'page'.tr}: ${search.pageNum}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .canvasColor,
                                                    fontSize: 12),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  leading: surahNameWidget(
                                      search.surahNum.toString(),
                                      Theme.of(context).hintColor),
                                ),
                              ),
                              const Divider()
                            ],
                          )),
                        );
                      },
                    );
                  } else {
                    return customLottie(LottieConstants.assetsLottieNotFound,
                        height: 200.0, width: 200.0);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
