import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/bottom_sheet_extension.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '/core/utils/constants/svg_constants.dart';
import '../../../../core/widgets/settings_list.dart';
import '../../home/home_screen.dart';
import '../controller/books_controller.dart';
import '../widgets/all_books_build.dart';
import '../widgets/books_last_read.dart';
import '../widgets/books_tap_bar_widget.dart';
import '../widgets/my_library_build.dart';
import '../widgets/search_screen.dart';
import 'books_bookmarks_screen.dart';

class BooksScreen extends StatelessWidget {
  final booksCtrl = BooksController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'tafsirLibrary'.tr,
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'kufi',
            color: Theme.of(context).canvasColor,
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Get.offAll(
            () => const HomeScreen(),
            transition: Transition.upToDown,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                child: customSvgWithColor(
                  SvgPath.svgHome,
                  height: 25.0,
                  width: 25.0,
                  color: Get.theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => Get.bottomSheet(
              SearchScreen(
                onSubmitted: (value) => booksCtrl.searchBooks(
                  booksCtrl.state.searchController.text,
                ),
              ),
              isScrollControlled: true,
            ),
            child: Container(
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                border: Border.all(
                  width: 1,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
              child: customSvgWithColor(
                SvgPath.svgSearchIcon,
                color: Theme.of(context).canvasColor,
                height: 25.0,
                width: 25.0,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => customBottomSheet(SettingsList(isQuranSetting: false)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  child: customSvgWithColor(
                    SvgPath.svgOptions,
                    height: 25.0,
                    width: 25.0,
                    color: Get.theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
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
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: .1),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                      topLeft: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      customSvgWithCustomColor(SvgPath.svgTafseer, height: 40),
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
