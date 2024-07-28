import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/font_size_extension.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '/presentation/screens/books/controller/extensions/books_ui.dart';
import '/presentation/screens/quran_page/extensions/bookmark_page_icon_path.dart';
import '../../../../core/utils/constants/svg_constants.dart';
import '../../../../core/widgets/settings_list.dart';
import '../controller/books_bookmarks_controller.dart';
import '../controller/books_controller.dart';
import '../data/models/page_model.dart';
import 'search_screen.dart';

class BooksTopTitleWidget extends StatelessWidget {
  final int bookNumber;
  final int index;
  final PageContent page;
  final booksCtrl = BooksController.instance;

  BooksTopTitleWidget(
      {super.key,
      required this.bookNumber,
      required this.index,
      required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.3),
              offset: const Offset(0, 5),
              blurRadius: 70,
              spreadRadius: 0,
            )
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 7,
            child: Text(
              page.title,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'kufi',
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GetX<BooksController>(
            builder: (booksCtrl) {
              return GestureDetector(
                onTap: () => booksCtrl.isTashkilOnTap(),
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context).colorScheme.surface,
                      )),
                  child: customSvgWithColor(
                    SvgPath.svgTashkil,
                    height: 30.0,
                    color: booksCtrl.state.isTashkil.value
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              );
            },
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).colorScheme.surface,
                    )),
              ),
              Transform.translate(
                  offset: const Offset(0, 5),
                  child: fontSizeDropDown(
                    height: 30.0,
                    color: Theme.of(context).colorScheme.primary,
                  )),
            ],
          ),
          GetX<BooksBookmarksController>(
            builder: (booksBookmarksCtrl) {
              return GestureDetector(
                onTap: () => booksBookmarksCtrl.addBookmarkOnTap(
                    bookNumber, index, page),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          border: Border.all(
                            width: 1,
                            color: Theme.of(context).colorScheme.surface,
                          )),
                    ),
                    SvgPicture.asset(
                        height: 20,
                        booksBookmarksCtrl.isPageBookmarked(
                                bookNumber, page.pageNumber)
                            ? 'assets/svg/bookmarked.svg'
                            : Get.context!.bookmarkPageIconPath()),
                  ],
                ),
              );
            },
          ),
          const Gap(11),
          GestureDetector(
            onTap: () => Get.bottomSheet(
              SettingsList(
                isQuranSetting: false,
              ),
              isScrollControlled: true,
            ),
            child: Container(
              height: 30,
              width: 30,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).colorScheme.surface,
                  )),
              child: customSvgWithColor(SvgPath.svgOptions,
                  height: 20.0,
                  width: 20.0,
                  color: Get.theme.colorScheme.primary),
            ),
          ),
          const Gap(11),
          GestureDetector(
            onTap: () => Get.bottomSheet(
                SearchScreen(
                  onSubmitted: (v) => booksCtrl.searchBooks(
                      booksCtrl.state.searchController.text,
                      bookNumber: bookNumber),
                  isInBook: true,
                ),
                isScrollControlled: true),
            child: Container(
              height: 30,
              width: 30,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).colorScheme.surface,
                  )),
              child: customSvgWithColor(SvgPath.svgSearchIcon,
                  height: 20.0,
                  width: 20.0,
                  color: Get.theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
