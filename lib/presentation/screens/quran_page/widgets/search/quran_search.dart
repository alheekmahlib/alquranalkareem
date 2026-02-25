part of '../../quran.dart';

class QuranSearch extends StatelessWidget {
  QuranSearch({super.key});
  final generalCtrl = GeneralController.instance;
  final quranCtrl = QuranController.instance;
  final searchCtrl = QuranSearchController.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: context.theme.colorScheme.primaryContainer,
      child: SafeArea(
        child: context.customOrientation(
          Column(
            children: <Widget>[
              const Gap(16),
              _surahsBuild(context),
              _ayahsBuild(context),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [const Gap(16), _surahsBuild(context)],
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(children: [const Gap(16), _ayahsBuild(context)]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _surahsBuild(BuildContext context) {
    return Obx(() {
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
                SurahModel search = searchCtrl.state.surahList[index];
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: GestureDetector(
                    onTap: () {
                      quranCtrl.changeSurahListOnTap(search.ayahs.first.page);
                      quranCtrl.state.searchController.close();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 4.0,
                        vertical: 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: surahNameWidget(
                        search.surahNumber.toString(),
                        Theme.of(context).canvasColor,
                        height: 40,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      } else {
        return customLottie(
          LottieConstants.assetsLottieNotFound,
          height: 200.0,
          width: 200.0,
        );
      }
    });
  }

  Widget _ayahsBuild(BuildContext context) {
    return Flexible(
      flex: 9,
      child: Center(
        child: Obx(() {
          if (searchCtrl.state.ayahList.isEmpty ||
              searchCtrl.state.searchTextEditing.text.isEmpty) {
            return customLottieWithColor(
              LottieConstants.assetsLottieSearch,
              width: 200.0,
              height: 200.0,
            );
          } else if (searchCtrl.state.ayahList.isNotEmpty) {
            return ListView.builder(
              controller: searchCtrl.state.scrollController,
              itemCount: searchCtrl.state.ayahList.length,
              itemBuilder: (context, index) {
                AyahModel search = searchCtrl.state.ayahList[index];
                // List<TextSpan> highlightedTextSpans =
                //     highlightLine(search.SearchText);
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: (index % 2 == 0
                              ? Theme.of(
                                  context,
                                ).colorScheme.surface.withValues(alpha: .05)
                              : Theme.of(
                                  context,
                                ).colorScheme.surface.withValues(alpha: .1)),
                          child: ListTile(
                            onTap: () {
                              quranCtrl.changeSurahListOnTap(search.page);
                              QuranLibrary.quranCtrl.toggleAyahSelection(
                                search.ayahUQNumber,
                              );
                              quranCtrl.state.searchController.close();
                            },
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RichText(
                                text: TextSpan(
                                  children: search.ayaTextEmlaey.highlightLine(
                                    searchCtrl.state.searchTextEditing.text,
                                  ),
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
                                color: Theme.of(context).primaryColorLight,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Get.theme.colorScheme.primary
                                            .withValues(alpha: .7),
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(4),
                                          bottomRight: Radius.circular(4),
                                        ),
                                      ),
                                      child: Text(
                                        " ${'part'.tr}: ${search.juz}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Theme.of(context).canvasColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4),
                                          bottomLeft: Radius.circular(4),
                                        ),
                                      ),
                                      child: Text(
                                        " ${'page'.tr}: ${search.page}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Theme.of(context).canvasColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            leading: surahNameWidget(
                              search.surahNumber.toString(),
                              Theme.of(context).hintColor,
                            ),
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return customLottie(
              LottieConstants.assetsLottieNotFound,
              height: 200.0,
              width: 200.0,
            );
          }
        }),
      ),
    );
  }
}
