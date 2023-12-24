import 'package:alquranalkareem/core/widgets/widgets.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../controllers/bookmarks_controller.dart';
import '../../../controllers/general_controller.dart';

class BookmarksList extends StatelessWidget {
  const BookmarksList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    sl<BookmarksController>().getBookmarks();
    ArabicNumbers arabicNumber = ArabicNumbers();
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        children: [
          Obx(() {
            if (sl<BookmarksController>().bookmarksList.isEmpty) {
              return bookmarks(150.0, 150.0);
            } else {
              return AnimationLimiter(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: sl<BookmarksController>().bookmarksList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var bookmark =
                            sl<BookmarksController>().bookmarksList[index];
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
                                    sl<BookmarksController>().deleteBookmarks(
                                        bookmark.pageNum!, context);
                                  },
                                  child: GestureDetector(
                                    onTap: () {
                                      sl<GeneralController>()
                                          .quranPageController
                                          .animateToPage(
                                            bookmark.pageNum! - 1,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.easeIn,
                                          );
                                      sl<GeneralController>().slideClose();
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
                                        padding: const EdgeInsets.all(16.0),
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
                                                      arabicNumber.convert(
                                                          bookmark.pageNum),
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
                                                      fontSize: 14,
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
        ],
      ),
    );
  }
}
