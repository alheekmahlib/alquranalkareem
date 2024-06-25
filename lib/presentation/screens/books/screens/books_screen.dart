import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '/core/utils/constants/svg_constants.dart';
import '../../../controllers/books_controller.dart';
import '../widgets/all_books_build.dart';
import '../widgets/books_last_read.dart';
import '../widgets/books_tap_bar_widget.dart';
import '../widgets/my_library_build.dart';
import '../widgets/search_screen.dart';
import 'books_bookmarks_screen.dart';

class BooksPage extends StatelessWidget {
  final booksCtrl = BooksController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('الكتب'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () =>
                  Get.bottomSheet(SearchScreen(), isScrollControlled: true),
              icon: customSvgWithColor(SvgPath.svgSearchIcon,
                  color: Theme.of(context).canvasColor)),
        ],
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: Container(
            height: Get.height,
            width: Get.width,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  topLeft: Radius.circular(8),
                )),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.primary.withOpacity(.1),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        topLeft: Radius.circular(8),
                      )),
                  child: Row(
                    children: [
                      customSvg(
                        SvgPath.svgTafseer,
                        height: 40,
                      ),
                      BooksTapBarWidget(),
                    ],
                  ),
                ),
                BooksLastRead(),
                Flexible(
                  child: Column(
                    children: [
                      Expanded(
                        child: TabBarView(
                          children: <Widget>[
                            AllBooksBuild(),
                            MyLibraryBuild(),
                            BookBookmarksScreen(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
