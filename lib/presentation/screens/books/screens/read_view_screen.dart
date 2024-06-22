import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../controllers/books_controller.dart';
import '../data/models/page_model.dart';

class PagesPage extends StatelessWidget {
  final int bookNumber;
  final int initialPage;
  final booksCtrl = BooksController.instance;

  PagesPage({required this.bookNumber, required this.initialPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('صفحات الكتاب'),
      ),
      body: FutureBuilder<List<PageContent>>(
        future: booksCtrl.getPages(bookNumber),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerEffect();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No pages available'));
          } else {
            final pages = snapshot.data!;
            return PageView.builder(
              controller: PageController(initialPage: initialPage),
              itemCount: pages.length,
              itemBuilder: (context, index) {
                final page = pages[index];
                booksCtrl.saveLastRead(
                    page.pageNumber, page.bookTitle, bookNumber, pages.length);
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Text(
                      page.content,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Container(
            height: 200,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
