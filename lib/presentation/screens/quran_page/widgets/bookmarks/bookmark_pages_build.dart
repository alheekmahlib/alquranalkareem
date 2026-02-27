part of '../../quran.dart';

class BookmarkPagesBuild extends StatelessWidget {
  BookmarkPagesBuild({super.key});
  final quranCtrl = QuranController.instance;
  final generalCtrl = GeneralController.instance;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookmarksController>(
      id: 'pageBookmarked',
      builder: (bookmarkCtrl) => bookmarkCtrl.bookmarksList.isEmpty
          ? const SizedBox.shrink()
          : AnimationLimiter(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: bookmarkCtrl.bookmarksList.length,
                itemBuilder: (BuildContext context, int index) {
                  final bookmark = bookmarkCtrl.bookmarksList[index];
                  final surah = quranCtrl.getCurrentSurahByPage(
                    bookmark.pageNum,
                  );
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 450),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Dismissible(
                          background: const DeleteWidget(),
                          key: ValueKey<int>(bookmark.pageNum),
                          onDismissed: (DismissDirection direction) {
                            bookmarkCtrl.deleteBookmarks(bookmark.pageNum);
                          },
                          child: Container(
                            height: 73,
                            width: Get.width,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 8.0,
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            decoration: BoxDecoration(
                              color: context.theme.primaryColorLight.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: InkWell(
                              onTap: () {
                                quranCtrl.changeSurahListOnTap(
                                  bookmark.pageNum,
                                );
                                Get.back();
                              },
                              child: Row(
                                children: [
                                  /// أيقونة البوكمارك مع رقم الصفحة
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Icon(
                                        Icons.bookmark_rounded,
                                        color: const Color(
                                          0xfff5410a,
                                        ).withValues(alpha: .7),
                                        size: 50,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 4.0,
                                        ),
                                        child: Text(
                                          '${bookmark.pageNum}'
                                              .convertNumbersToCurrentLang(),
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).canvasColor,
                                            fontFamily: 'kufi',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(12),

                                  /// اسم السورة
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primaryContainer,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          RepaintBoundary(
                                            child: customSvgWithColor(
                                              'assets/svg/surah_name/00${surah.surahNumber}.svg',
                                              color: Theme.of(
                                                context,
                                              ).hintColor,
                                              width: 90,
                                            ),
                                          ),
                                          Text(
                                            surah.englishName,
                                            style: AppTextStyles.titleSmall(
                                              color: context
                                                  .theme
                                                  .primaryColorDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Gap(12),

                                  /// الصفحة والتاريخ
                                  Expanded(
                                    flex: 3,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0,
                                              vertical: 6.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primaryContainer,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${'page'.tr}:',
                                                  style:
                                                      AppTextStyles.titleSmall(
                                                        color: context
                                                            .theme
                                                            .primaryColorDark,
                                                      ),
                                                ),
                                                const Gap(4),
                                                Text(
                                                  '${bookmark.pageNum}'
                                                      .convertNumbersToCurrentLang(),
                                                  style:
                                                      AppTextStyles.titleSmall(),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Gap(6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0,
                                              vertical: 6.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primaryContainer,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              bookmark.lastRead
                                                  .toString()
                                                  .convertNumbersToCurrentLang(),
                                              style: AppTextStyles.titleSmall(
                                                color: context
                                                    .theme
                                                    .primaryColorDark,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
