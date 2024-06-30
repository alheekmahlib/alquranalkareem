import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/core/utils/constants/extensions/extensions.dart';
import '/core/utils/constants/extensions/text_span_extension.dart';
import '/presentation/screens/quran_page/widgets/search/search_extensions/highlight_extension.dart';
import '../../../../core/widgets/shimmer_effect_build.dart';
import '../../../controllers/books_bookmarks_controller.dart';
import '../../../controllers/books_controller.dart';
import '../../../controllers/general_controller.dart';
import '../data/models/page_model.dart';
import '../widgets/books_top_title_widget.dart';

class PagesPage extends StatelessWidget {
  final int bookNumber;
  final booksCtrl = BooksController.instance;
  final booksBookmarksCtrl = BooksBookmarksController.instance;
  final generalCtrl = GeneralController.instance;

  PagesPage({required this.bookNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(
          booksCtrl.booksList[bookNumber - 1].bookName,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'kufi',
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<PageContent>>(
          future: Future.delayed(const Duration(milliseconds: 600))
              .then((_) => booksCtrl.getPages(bookNumber)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ShimmerEffectBuild();
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No pages available'));
            } else {
              final pages = snapshot.data!;
              return PageView.builder(
                controller: booksCtrl.pageController,
                itemCount: pages.length,
                onPageChanged: (i) => booksCtrl.currentPageNumber.value = i,
                itemBuilder: (context, index) {
                  final page = pages[index];
                  booksCtrl.saveLastRead(
                      page.pageNumber,
                      booksCtrl.booksList[bookNumber - 1].bookName,
                      bookNumber,
                      pages.length);
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        children: [
                          BooksTopTitleWidget(
                            bookNumber: bookNumber,
                            index: index,
                            page: page,
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SingleChildScrollView(
                                child: GetX<GeneralController>(
                                  builder: (generalCtrl) {
                                    return SelectionArea(
                                      child: Column(
                                        children: [
                                          Text.rich(
                                            TextSpan(children: <InlineSpan>[
                                              TextSpan(
                                                children:
                                                    booksCtrl.isTashkil.value
                                                        ? page.content
                                                            .buildTextSpans()
                                                        : page.content
                                                            .removeDiacritics(
                                                                page.content)
                                                            .buildTextSpans(),
                                                style: TextStyle(
                                                  color: Get.theme.colorScheme
                                                      .inversePrimary,
                                                  height: 1.5,
                                                  fontSize: generalCtrl
                                                      .fontSizeArabic.value,
                                                ),
                                              ),
                                            ]),
                                            textDirection: TextDirection.rtl,
                                            textAlign: TextAlign.justify,
                                          ),
                                          context.hDivider(width: Get.width),
                                          ...page.footnotes.map((footnote) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Text(
                                                footnote,
                                                style: TextStyle(
                                                  color: Get.theme.colorScheme
                                                      .inversePrimary
                                                      .withOpacity(.5),
                                                  height: 1.5,
                                                  fontSize: generalCtrl
                                                          .fontSizeArabic
                                                          .value -
                                                      5,
                                                ),
                                                textDirection:
                                                    TextDirection.rtl,
                                              ),
                                            );
                                          }).toList(),
                                          const Gap(32),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: AlignmentDirectional.bottomEnd,
                        child: Container(
                          padding: const EdgeInsets.all(6.0),
                          margin: const EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context).colorScheme.surface,
                              )),
                          child: Text(
                            page.pageNumber.toString().convertNumbers(),
                            style: TextStyle(
                              fontSize: 16,
                              height: .5,
                              // fontFamily: 'kufi',
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
