import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/presentation/screens/quran_page/controllers/extensions/quran_ui.dart';
import '../../../../../core/utils/constants/extensions/extensions.dart';
import '../../../../../core/widgets/delete_widget.dart';
import '../../../../controllers/general_controller.dart';
import '../../controllers/bookmarks_controller.dart';
import '../../controllers/quran/quran_controller.dart';

class BookmarkPagesBuild extends StatelessWidget {
  BookmarkPagesBuild({super.key});
  final quranCtrl = QuranController.instance;
  final generalCtrl = GeneralController.instance;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookmarksController>(
        builder: (bookmarkCtrl) => bookmarkCtrl.bookmarksList.isEmpty
            ? const SizedBox.shrink()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'pages'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontFamily: 'kufi',
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  ),
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
                                  .withOpacity(.1),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8))),
                          child: ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: bookmarkCtrl.bookmarksList.length,
                              itemBuilder: (BuildContext context, int index) {
                                var bookmark =
                                    bookmarkCtrl.bookmarksList[index];
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
                                          key: ValueKey<int>(bookmark.id!),
                                          onDismissed:
                                              (DismissDirection direction) {
                                            bookmarkCtrl.deleteBookmarks(
                                                bookmark.pageNum!, context);
                                          },
                                          child: GestureDetector(
                                            onTap: () {
                                              quranCtrl.changeSurahListOnTap(
                                                  bookmark.pageNum!);
                                              Get.back();
                                            },
                                            child: Container(
                                              width: MediaQuery.sizeOf(context)
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
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Stack(
                                                            alignment: Alignment
                                                                .center,
                                                            children: <Widget>[
                                                              const Icon(
                                                                Icons.bookmark,
                                                                color: Color(
                                                                    0x99f5410a),
                                                                size: 50,
                                                              ),
                                                              Text(
                                                                '${bookmark.pageNum.toString().convertNumbers()}',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
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
                                                          flex: 5,
                                                          child: Text(
                                                            '${bookmark.sorahName}',
                                                            style: TextStyle(
                                                                color: Get
                                                                        .isDarkMode
                                                                    ? Get.theme
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
                                                        ),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Text(
                                                            "${bookmark.lastRead.toString().convertNumbers()}",
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .surface,
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'kufi',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
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
