import 'package:alquranalkareem/presentation/controllers/quran_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/lottie.dart';
import '../../../../../core/widgets/delete_widget.dart';
import '../../../../controllers/bookmarks_controller.dart';
import '../../../../controllers/general_controller.dart';
import '/core/utils/constants/extensions.dart';

class BookmarkAyahsBuild extends StatelessWidget {
  BookmarkAyahsBuild({super.key});
  final bookmarkCtrl = sl<BookmarksController>();
  final generalCtrl = sl<GeneralController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ayahs'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Get.theme.hintColor,
              fontFamily: 'kufi',
              fontWeight: FontWeight.w700,
              fontSize: 18),
        ),
        context.hDivider(width: MediaQuery.sizeOf(context).width),
        Obx(() {
          if (bookmarkCtrl.BookmarkTextList.isEmpty) {
            return bookmarks(150.0, 150.0);
          } else {
            return AnimationLimiter(
              child: Align(
                alignment: Alignment.topCenter,
                child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: bookmarkCtrl.BookmarkTextList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var bookmark = bookmarkCtrl.BookmarkTextList[index];
                      final ayah = sl<QuranController>().allAyahs.firstWhere(
                            (a) => a.ayahUQNumber == bookmark.ayahUQNum,
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
                                key: ValueKey<int>(bookmark.id!),
                                onDismissed: (DismissDirection direction) {
                                  bookmarkCtrl
                                      .deleteBookmarksText(bookmark.ayahUQNum!);
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
                                    Get.back();
                                  },
                                  child: Container(
                                    width: MediaQuery.sizeOf(context).width,
                                    decoration: BoxDecoration(
                                        color: Get.theme.colorScheme.surface
                                            .withOpacity(.2),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ShaderMask(
                                        shaderCallback: (Rect bounds) {
                                          return const LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black
                                            ],
                                            stops: [0.0, 0.2],
                                          ).createShader(bounds);
                                        },
                                        blendMode: BlendMode.dstIn,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
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
                                                      alignment:
                                                          Alignment.center,
                                                      children: <Widget>[
                                                        const Icon(
                                                          Icons.bookmark,
                                                          color:
                                                              Color(0x99f5410a),
                                                          size: 50,
                                                        ),
                                                        Text(
                                                          sl<GeneralController>()
                                                              .convertNumbers(
                                                                  bookmark
                                                                      .ayahNum
                                                                      .toString()),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Get.theme
                                                                  .canvasColor,
                                                              fontFamily:
                                                                  'kufi',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 12),
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
                                                              color: Get
                                                                      .isDarkMode
                                                                  ? Get.theme
                                                                      .canvasColor
                                                                  : Get.theme
                                                                      .primaryColorDark,
                                                              fontSize: 18,
                                                              fontFamily:
                                                                  'uthmanic2',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                          maxLines: 1,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "${bookmark.sorahName} - ${'page'.tr}: ${generalCtrl.convertNumbers(bookmark.pageNum.toString())}",
                                                              style: TextStyle(
                                                                  color: Get
                                                                      .theme
                                                                      .colorScheme
                                                                      .surface,
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      'kufi',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                            const Gap(68),
                                                            Text(
                                                              "${generalCtrl.convertNumbers(bookmark.lastRead.toString())}",
                                                              style: TextStyle(
                                                                  color: Get
                                                                      .theme
                                                                      .colorScheme
                                                                      .surface,
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      'kufi',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
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
