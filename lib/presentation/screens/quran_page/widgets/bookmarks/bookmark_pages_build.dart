import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/lottie.dart';
import '../../../../../core/widgets/delete_widget.dart';
import '../../../../controllers/bookmarks_controller.dart';
import '../../../../controllers/general_controller.dart';
import '/core/utils/constants/extensions.dart';

class BookmarkPagesBuild extends StatelessWidget {
  BookmarkPagesBuild({super.key});
  final bookmarkCtrl = sl<BookmarksController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'pages'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Get.theme.hintColor,
              fontFamily: 'kufi',
              fontWeight: FontWeight.w700,
              fontSize: 18),
        ),
        context.hDivider(width: MediaQuery.sizeOf(context).width),
        Obx(() {
          if (bookmarkCtrl.bookmarksList.isEmpty) {
            return bookmarks(150.0, 150.0);
          } else {
            return AnimationLimiter(
              child: Align(
                alignment: Alignment.topCenter,
                child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: bookmarkCtrl.bookmarksList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var bookmark = bookmarkCtrl.bookmarksList[index];
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
                                onDismissed: (DismissDirection direction) {
                                  bookmarkCtrl.deleteBookmarks(
                                      bookmark.pageNum!, context);
                                },
                                child: GestureDetector(
                                  onTap: () {
                                    sl<GeneralController>()
                                        .quranPageController
                                        .animateToPage(
                                          bookmark.pageNum! - 1,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.easeIn,
                                        );
                                    sl<GeneralController>().slideClose();
                                  },
                                  child: Container(
                                    width: MediaQuery.sizeOf(context).width,
                                    decoration: BoxDecoration(
                                        color: Get.theme.colorScheme.surface
                                            .withOpacity(.2),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: <Widget>[
                                                    const Icon(
                                                      Icons.bookmark,
                                                      color: Color(0x99f5410a),
                                                      size: 50,
                                                    ),
                                                    Text(
                                                      sl<GeneralController>()
                                                          .convertNumbers(
                                                              bookmark.pageNum
                                                                  .toString()),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Get.theme
                                                              .canvasColor,
                                                          fontFamily: 'kufi',
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: Text(
                                                  '${bookmark.sorahName}',
                                                  style: TextStyle(
                                                      color: Get.isDarkMode
                                                          ? Get
                                                              .theme.canvasColor
                                                          : Get.theme
                                                              .primaryColorDark,
                                                      fontSize: 16,
                                                      fontFamily: 'kufi',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  "${bookmark.lastRead}",
                                                  style: TextStyle(
                                                      color: Get.theme
                                                          .colorScheme.surface,
                                                      fontSize: 12,
                                                      fontFamily: 'kufi',
                                                      fontWeight:
                                                          FontWeight.w400),
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
            );
          }
        }),
      ],
    );
  }
}
