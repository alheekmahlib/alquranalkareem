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
import '../../controllers/quran_search_controller.dart';
import '../../data/data_source/quran_database.dart';
import '../../extensions/surah_name_with_banner.dart';
import 'search_bar_widget.dart';

class QuranSearch extends StatelessWidget {
  QuranSearch({super.key});
  final generalCtrl = GeneralController.instance;
  final quranCtrl = QuranController.instance;
  final ayahCtrl = QuranSearchController.instance;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            const Gap(16),
            context.customClose(),
            const Gap(16),
            TextFieldBarWidget(
              controller: ayahCtrl.searchTextEditing,
              onPressed: () {
                ayahCtrl.searchTextEditing.clear();
                ayahCtrl.ayahList.clear();
                ayahCtrl.surahList.clear();
              },
              onChanged: (query) {
                if (ayahCtrl.searchTextEditing.text.isNotEmpty ||
                    query.trim().isNotEmpty) {
                  ayahCtrl.surahSearch(query);
                  ayahCtrl.search(query);
                }
              },
              onSubmitted: (query) {
                if (query.length <= 0 || query.trim().isNotEmpty) {
                  ayahCtrl.surahSearch(query);
                  ayahCtrl.search(query);
                }
                // await sl<QuranSearchControllers>().addSearchItem(query);
                // searchCtrl.textSearchController.clear();
              },
            ),
            const Gap(16),
            Obx(
              () {
                if (ayahCtrl.surahList.isEmpty) {
                  return const SizedBox.shrink();
                } else if (ayahCtrl.surahList.isNotEmpty) {
                  return Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.builder(
                        itemCount: ayahCtrl.surahList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          QuranTableData search = ayahCtrl.surahList[index];
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
                  if (ayahCtrl.ayahList.isEmpty ||
                      ayahCtrl.searchTextEditing.text.isEmpty) {
                    return customLottie(LottieConstants.assetsLottieSearch,
                        width: 200.0, height: 200.0);
                  } else if (ayahCtrl.ayahList.isNotEmpty) {
                    return ListView.builder(
                      controller: ayahCtrl.scrollController,
                      itemCount: ayahCtrl.ayahList.length,
                      itemBuilder: (context, index) {
                        QuranTableData search = ayahCtrl.ayahList[index];
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
                                            .highlightLine(ayahCtrl
                                                .searchTextEditing.text),
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
