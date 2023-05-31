import 'package:alquranalkareem/notes/model/Notes.dart';
import 'package:alquranalkareem/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';
import '../../shared/widgets/lottie.dart';
import '../cubit/quran_text_cubit.dart';
import '../cubit/surah_text_cubit.dart';
import '../model/QuranModel.dart';
import '../text_page_view.dart';

class BookmarksTextList extends StatefulWidget {
  const BookmarksTextList({Key? key}) : super(key: key);

  @override
  State<BookmarksTextList> createState() => _BookmarksTextListState();
}

class _BookmarksTextListState extends State<BookmarksTextList> {
  int? id;
  String? sorahName;
  int? pageName;
  String? lastRead;
  late final Notes notes;
  final sorahNameController = TextEditingController();
  final descriptionController = TextEditingController();
  var controller = ScrollController();

  @override
  void initState() {
    QuranTextCubit.get(context).bookmarksTextController.getBookmarksText();
    QuranTextCubit.get(context)
        .bookmarksTextAyahController
        .getBookmarksTextAyah();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    QuranTextCubit bookmarksCubit = QuranTextCubit.get(context);
    return Column(
      children: [
        topBar(context),
        const Divider(),
        Expanded(
          child: Obx(() {
            if (bookmarksCubit.bookmarksTextController.BookmarkList.isEmpty) {
              return bookmarks(150.0, 150.0);
            } else {
              return BlocBuilder<SurahTextCubit, List<SurahText>?>(
                builder: (context, state) {
                  if (state == null) {
                    return Center(
                      child: loadingLottie(200.0, 200.0),
                    );
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: bookmarksCubit
                          .bookmarksTextController.BookmarkList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var bookmark = bookmarksCubit
                            .bookmarksTextController.BookmarkList[index];

                        return Column(
                          children: [
                            AnimationLimiter(
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: AnimationConfiguration.staggeredList(
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
                                          onDismissed:
                                              (DismissDirection direction) {
                                            bookmarksCubit
                                                .bookmarksTextController
                                                .deleteBookmarksText(
                                                    bookmark, context);
                                          },
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                QuranTextCubit.get(context)
                                                    .value = 0;
                                              });
                                              Navigator.of(context).pop();
                                              Navigator.of(context).push(
                                                  animatRoute(TextPageView(
                                                surah: state[
                                                    bookmark.sorahNum! - 1],
                                                nomPageF: state[
                                                        bookmark.sorahNum! - 1]
                                                    .ayahs!
                                                    .first
                                                    .page!,
                                                nomPageL: state[
                                                        bookmark.sorahNum! - 1]
                                                    .ayahs!
                                                    .last
                                                    .page!,
                                                pageNum:
                                                    (bookmark.pageNum! - 1),
                                              )));
                                              print(
                                                  '${state[bookmark.sorahNum! - 1]}');
                                              print(
                                                  '${state[bookmark.sorahNum! - 1].ayahs!.first.page!}');
                                              print(
                                                  '${state[bookmark.sorahNum! - 1].ayahs!.last.page!}');
                                              print(
                                                  'pageNum: ${bookmark.pageNum!}');
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface
                                                      .withOpacity(.2),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(8))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16.0,
                                                        horizontal: 8.0),
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
                                                          alignment:
                                                              Alignment.center,
                                                          children: <Widget>[
                                                            SvgPicture.asset(
                                                              'assets/svg/ic_fram.svg',
                                                              height: 40,
                                                              width: 40,
                                                            ),
                                                            Text(
                                                              "${bookmark.pageNum}",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: ThemeProvider.themeOf(context)
                                                                              .id ==
                                                                          'dark'
                                                                      ? Theme.of(
                                                                              context)
                                                                          .canvasColor
                                                                      : Theme.of(
                                                                              context)
                                                                          .primaryColorDark,
                                                                  fontFamily:
                                                                      'kufi',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 12),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          '${bookmark.sorahName}',
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
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'kufi',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        Text(
                                                          "${bookmark.lastRead}",
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
                                                                      .primaryColorLight,
                                                              fontSize: 13,
                                                              fontFamily:
                                                                  'kufi',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                        const Icon(
                                                          Icons.bookmark,
                                                          color:
                                                              Color(0x99f5410a),
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
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                },
              );
            }
          }),
        ),
      ],
    );
  }
}
