part of '../../quran.dart';

class BookmarkAyahsBuild extends StatelessWidget {
  BookmarkAyahsBuild({super.key});
  final generalCtrl = GeneralController.instance;
  final quranCtrl = QuranController.instance;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookmarksController>(
      id: 'bookmarked',
      builder: (bookmarkCtrl) => bookmarkCtrl.bookmarkTextList.isEmpty
          ? const SizedBox.shrink()
          : AnimationLimiter(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: bookmarkCtrl.bookmarkTextList.length,
                itemBuilder: (BuildContext context, int index) {
                  final bookmark = bookmarkCtrl.bookmarkTextList[index];
                  final ayah = sl<QuranController>().state.allAyahs.firstWhere(
                    (a) => a.ayahUQNumber == bookmark.ayahUQNumber,
                  );
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 450),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Dismissible(
                          background: const DeleteWidget(),
                          key: ValueKey<int>(bookmark.ayahUQNumber),
                          onDismissed: (DismissDirection direction) {
                            bookmarkCtrl.deleteBookmarksText(
                              bookmark.ayahUQNumber,
                            );
                          },
                          child: Container(
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
                                  bookmark.pageNumber - 1,
                                );
                                Get.back();
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      /// أيقونة البوكمارك مع رقم الآية
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Icon(
                                            Icons.bookmark_rounded,
                                            color: const Color(
                                              0xfff5410a,
                                            ).withValues(alpha: .7),
                                            size: 60,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 4.0,
                                            ),
                                            child: Text(
                                              '${bookmark.ayahNumber}'
                                                  .convertNumbersToCurrentLang(),
                                              style: AppTextStyles.titleMedium(
                                                color:
                                                    context.theme.canvasColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Gap(12),

                                      /// نص الآية واسم السورة
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: Text(
                                                '${ayah.text}',
                                                style: TextStyle(
                                                  color: Theme.of(
                                                    context,
                                                  ).hintColor,
                                                  fontSize: 18,
                                                  fontFamily: 'uthmanic2',
                                                  fontWeight: FontWeight.w500,
                                                  height: 1.8,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const Gap(4),
                                            Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 4.0,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primaryContainer,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    bookmark.surahName,
                                                    style:
                                                        AppTextStyles.titleSmall(
                                                          color: context
                                                              .theme
                                                              .colorScheme
                                                              .surface,
                                                        ),
                                                  ),
                                                ),
                                                const Gap(8),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 4.0,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primaryContainer,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        '${'page'.tr}:',
                                                        style:
                                                            AppTextStyles.titleSmall(
                                                              color: context
                                                                  .theme
                                                                  .colorScheme
                                                                  .surface,
                                                            ),
                                                      ),
                                                      const Gap(4),
                                                      Text(
                                                        '${bookmark.pageNumber - 1}'
                                                            .convertNumbersToCurrentLang(),
                                                        style:
                                                            AppTextStyles.titleSmall(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  bookmark.lastRead
                                                      .toString()
                                                      .convertNumbersToCurrentLang(),
                                                  style:
                                                      AppTextStyles.titleSmall(
                                                        color: context
                                                            .theme
                                                            .colorScheme
                                                            .surface,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
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
