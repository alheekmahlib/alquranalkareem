import 'package:alquranalkareem/cubit/cubit.dart';
import 'package:alquranalkareem/notes/model/Notes.dart';
import 'package:alquranalkareem/quran_page/cubit/bookmarks/bookmarks_cubit.dart';
import 'package:alquranalkareem/shared/widgets/widgets.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:theme_provider/theme_provider.dart';

class BookmarksList extends StatefulWidget {
  const BookmarksList({Key? key}) : super(key: key);

  @override
  State<BookmarksList> createState() => _BookmarksListState();
}

class _BookmarksListState extends State<BookmarksList> {
  int? id;
  String? sorahName;
  int? pageName;
  String? lastRead;
  late final Notes notes;
  final sorahNameController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    BookmarksCubit.get(context).bookmarksController.getBookmarks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ArabicNumbers arabicNumber = ArabicNumbers();
    BookmarksCubit bookmarksCubit = BookmarksCubit.get(context);
    return Column(
      children: [
        topBar(context),
        const Divider(),
        Expanded(
          child: Obx(() {
            if (bookmarksCubit.bookmarksController.bookmarksList.isEmpty) {
              return Lottie.asset('assets/lottie/bookmarks.json',
                  width: 150, height: 150);
            } else {
              return AnimationLimiter(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: bookmarksCubit
                          .bookmarksController.bookmarksList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var bookmark = bookmarksCubit
                            .bookmarksController.bookmarksList[index];
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
                                  background: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: delete(context),
                                  ),
                                  key: ValueKey<int>(bookmark.id!),
                                  onDismissed: (DismissDirection direction) {
                                    bookmarksCubit.bookmarksController
                                        .deleteBookmarks(bookmark.pageNum!, context);
                                  },
                                  child: GestureDetector(
                                    onTap: () {
                                      QuranCubit.get(context)
                                          .dPageController
                                          ?.animateToPage(
                                            bookmark.pageNum! - 1,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.easeIn,
                                          );
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme.surface
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
                                                      "${arabicNumber.convert(bookmark.pageNum)}",
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
        )
      ],
    );
  }
}
