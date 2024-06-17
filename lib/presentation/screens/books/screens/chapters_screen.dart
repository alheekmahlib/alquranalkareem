import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/books_controller.dart';
import 'read_view_screen.dart';

class ChaptersPage extends StatelessWidget {
  final int bookNumber;
  final BooksController booksCtrl = BooksController.instance;

  ChaptersPage({required this.bookNumber});

  @override
  Widget build(BuildContext context) {
    final chapters = booksCtrl.getChapters(bookNumber);
    return Scaffold(
      appBar: AppBar(
        title: Text('الفصول'),
      ),
      body: ListView.builder(
        itemCount: chapters.length,
        itemBuilder: (context, index) {
          final chapter = chapters[index];
          return ListTile(
            title: Text(chapter.chapterName),
            onTap: () async {
              int initialPage = await booksCtrl.getChapterStartPage(
                  bookNumber, chapter.chapterName);
              log('Initial page for chapter ${chapter.chapterName}: $initialPage');
              Get.to(() =>
                  PagesPage(bookNumber: bookNumber, initialPage: initialPage));
            },
          );
        },
      ),
    );
  }
}
