import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';

import '/core/widgets/widgets.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../controllers/bookmarksText_controller.dart';
import '../../../controllers/quranText_controller.dart';
import '../../../controllers/surahTextController.dart';
import '../screens/text_page_view.dart';

class BookmarksTextList extends StatelessWidget {
  const BookmarksTextList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    sl<BookmarksTextController>().getBookmarksText();
    return Column(
      children: [
        topBar(context),
        const Divider(),
        Expanded(
          child: Obx(() {
            if (sl<BookmarksTextController>().BookmarkList.isEmpty) {
              return bookmarks(150.0, 150.0);
            } else {
              return AnimationLimiter(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          sl<BookmarksTextController>().BookmarkList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var bookmark =
                            sl<BookmarksTextController>().BookmarkList[index];
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
                                  background: delete(context),
                                  key: ValueKey<int>(bookmark.id!),
                                  onDismissed: (DismissDirection direction) {
                                    sl<BookmarksTextController>()
                                        .deleteBookmarksText(
                                            bookmark.ayahNum!, context);
                                  },
                                  child: GestureDetector(
                                    onTap: () {
                                      sl<QuranTextController>().value.value = 0;
                                      Navigator.of(context).pop();
                                      Navigator.of(context)
                                          .push(animatRoute(TextPageView(
                                        surah: sl<SurahTextController>()
                                            .surahs[bookmark.sorahNum! - 1],
                                        nomPageF: sl<SurahTextController>()
                                            .surahs[bookmark.sorahNum! - 1]
                                            .ayahs!
                                            .first
                                            .page!,
                                        nomPageL: sl<SurahTextController>()
                                            .surahs[bookmark.sorahNum! - 1]
                                            .ayahs!
                                            .last
                                            .page!,
                                        pageNum: (bookmark.pageNum! - 1),
                                      )));
                                      print(
                                          '${sl<SurahTextController>().surahs[bookmark.sorahNum! - 1]}');
                                      print(
                                          '${sl<SurahTextController>().surahs[bookmark.sorahNum! - 1].ayahs!.first.page!}');
                                      print(
                                          '${sl<SurahTextController>().surahs[bookmark.sorahNum! - 1].ayahs!.last.page!}');
                                      print('pageNum: ${bookmark.pageNum!}');
                                    },
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface
                                              .withOpacity(.2),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16.0, horizontal: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Stack(
                                                  alignment: Alignment.center,
                                                  children: <Widget>[
                                                    SvgPicture.asset(
                                                      'assets/svg/ic_fram.svg',
                                                      height: 40,
                                                      width: 40,
                                                    ),
                                                    Text(
                                                      "${bookmark.pageNum}",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: ThemeProvider.themeOf(
                                                                          context)
                                                                      .id ==
                                                                  'dark'
                                                              ? Theme.of(
                                                                      context)
                                                                  .canvasColor
                                                              : Theme.of(
                                                                      context)
                                                                  .primaryColorDark,
                                                          fontFamily: 'kufi',
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  '${bookmark.sorahName}',
                                                  style: TextStyle(
                                                      color: ThemeProvider
                                                                      .themeOf(
                                                                          context)
                                                                  .id ==
                                                              'dark'
                                                          ? Theme.of(context)
                                                              .canvasColor
                                                          : Theme.of(context)
                                                              .primaryColorDark,
                                                      fontSize: 16,
                                                      fontFamily: 'kufi',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  "${bookmark.lastRead}",
                                                  style: TextStyle(
                                                      color: ThemeProvider
                                                                      .themeOf(
                                                                          context)
                                                                  .id ==
                                                              'dark'
                                                          ? Theme.of(context)
                                                              .canvasColor
                                                          : Theme.of(context)
                                                              .primaryColorLight,
                                                      fontSize: 13,
                                                      fontFamily: 'kufi',
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                const Icon(
                                                  Icons.bookmark,
                                                  color: Color(0x99f5410a),
                                                  size: 35,
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
                        );
                      }),
                ),
              );
            }
          }),
        ),
      ],
    );
  }
}
