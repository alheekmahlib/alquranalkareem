import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/presentation/screens/books/controller/extensions/books_getters.dart';
import '/presentation/screens/books/controller/extensions/books_ui.dart';
import '../controller/books_controller.dart';

class BooksChapterBuild extends StatelessWidget {
  final int bookNumber;

  BooksChapterBuild({super.key, required this.bookNumber});

  final booksCtrl = BooksController.instance;

  @override
  Widget build(BuildContext context) {
    final parts = booksCtrl.getParts(bookNumber);
    return Stack(
      children: [
        Container(
            decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surface
                    .withValues(alpha: .15),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: Column(
              children: [
                Container(
                  height: 32,
                  width: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.all(Radius.circular(4))),
                  child: Text(
                    'chapterBook'.tr,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'kufi',
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    children: List.generate(parts.length, (index) {
                      final part = parts[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1.0),
                        child: ExpansionTile(
                          collapsedIconColor:
                              Theme.of(context).colorScheme.inversePrimary,
                          collapsedBackgroundColor: Theme.of(context)
                              .colorScheme
                              .surface
                              .withValues(alpha: .1),
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .surface
                              .withValues(alpha: .1),
                          title: Text(
                            '${'part'.tr} ${part.partNumber}',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'kufi',
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                          children: part.chapters.map((chapter) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 4.0),
                              child: GestureDetector(
                                onTap: () async =>
                                    await booksCtrl.moveToBookPage(
                                        chapter.chapterName, bookNumber),
                                child: GetX<BooksController>(
                                  builder: (booksCtrl) {
                                    return Opacity(
                                      opacity:
                                          booksCtrl.isBookDownloaded(bookNumber)
                                              ? 1
                                              : .5,
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface
                                                  .withValues(alpha: .6),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(8))),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Icon(
                                                  Icons.menu,
                                                  size: 20,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 9,
                                                  child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8.0,
                                                          vertical: 4.0),
                                                      child: Text(
                                                        chapter.chapterName,
                                                        style: TextStyle(
                                                          fontSize: 22.0,
                                                          fontFamily: 'naskh',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .inversePrimary,
                                                        ),
                                                        textAlign:
                                                            TextAlign.justify,
                                                      )))
                                            ],
                                          )),
                                    );
                                  },
                                ),
                              ),
                            );
                          }).toList(),

                          // else {
                          //   return const SizedBox.shrink();
                          // }
                        ),
                      );
                    }),
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
