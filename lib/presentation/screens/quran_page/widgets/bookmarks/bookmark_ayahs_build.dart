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
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  context.hDivider(width: MediaQuery.sizeOf(context).width),
                  Flexible(
                    child: AnimationLimiter(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withValues(alpha: .1),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8))),
                          child: ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: bookmarkCtrl.bookmarkTextList.length,
                              itemBuilder: (BuildContext context, int index) {
                                var bookmark =
                                    bookmarkCtrl.bookmarkTextList[index];
                                final ayah = sl<QuranController>()
                                    .state
                                    .allAyahs
                                    .firstWhere(
                                      (a) =>
                                          a.ayahUQNumber ==
                                          bookmark.ayahUQNumber,
                                    );
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 450),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8.0),
                                        child: Dismissible(
                                          background: const DeleteWidget(),
                                          key: ValueKey<int>(
                                              bookmark.ayahUQNumber),
                                          onDismissed:
                                              (DismissDirection direction) {
                                            bookmarkCtrl.deleteBookmarksText(
                                                bookmark.ayahUQNumber);
                                          },
                                          child: GestureDetector(
                                            onTap: () {
                                              quranCtrl.changeSurahListOnTap(
                                                  bookmark.pageNumber);

                                              Get.back();
                                            },
                                            child: Container(
                                              width: MediaQuery.sizeOf(context)
                                                  .width,
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface
                                                      .withValues(alpha: .2),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(8))),
                                              child: Directionality(
                                                textDirection:
                                                    TextDirection.rtl,
                                                child: ShaderMask(
                                                  shaderCallback:
                                                      (Rect bounds) {
                                                    return const LinearGradient(
                                                      begin:
                                                          Alignment.centerLeft,
                                                      end:
                                                          Alignment.centerRight,
                                                      colors: [
                                                        Colors.transparent,
                                                        Colors.black
                                                      ],
                                                      stops: [0.0, 0.2],
                                                    ).createShader(bounds);
                                                  },
                                                  blendMode: BlendMode.dstIn,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              flex: 2,
                                                              child: Stack(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                children: <Widget>[
                                                                  const Icon(
                                                                    Icons
                                                                        .bookmark,
                                                                    color: Color(
                                                                        0x99f5410a),
                                                                    size: 50,
                                                                  ),
                                                                  Text(
                                                                    '${bookmark.ayahNumber.toString().convertNumbers()}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .canvasColor,
                                                                        fontFamily:
                                                                            'kufi',
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 8,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    '${ayah.text}',
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .inversePrimary,
                                                                        fontSize:
                                                                            18,
                                                                        fontFamily:
                                                                            'uthmanic2',
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                    maxLines: 1,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        "${bookmark.surahName} - ${'page'.tr}: ${bookmark.pageNumber.toString().convertNumbers()}",
                                                                        style: TextStyle(
                                                                            color: Get
                                                                                .theme.colorScheme.surface,
                                                                            fontSize:
                                                                                12,
                                                                            fontFamily:
                                                                                'kufi',
                                                                            fontWeight:
                                                                                FontWeight.w400),
                                                                      ),
                                                                      const Spacer(),
                                                                      Text(
                                                                        "${bookmark.lastRead.toString().convertNumbers()}",
                                                                        style: TextStyle(
                                                                            color: Get
                                                                                .theme.colorScheme.surface,
                                                                            fontSize:
                                                                                12,
                                                                            fontFamily:
                                                                                'kufi',
                                                                            fontWeight:
                                                                                FontWeight.w400),
                                                                      ),
                                                                      const Gap(
                                                                          16),
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
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  }
}
