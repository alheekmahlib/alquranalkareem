import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';

import '../../../controllers/books_controller.dart';
import 'chapters_screen.dart';

class BooksPage extends StatelessWidget {
  final booksCtrl = BooksController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الكتب'),
      ),
      body: Obx(() {
        if (booksCtrl.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: booksCtrl.booksList.length,
          itemBuilder: (context, index) {
            final book = booksCtrl.booksList[index];
            return ListTile(
              title: Text(book.bookName),
              onTap: () {
                Get.to(() => ChaptersPage(bookNumber: book.bookNumber));
              },
              trailing: Obx(
                () => booksCtrl.downloaded[book.bookNumber] == true
                    ? Icon(Icons.check, color: Colors.green)
                    : booksCtrl.downloading[book.bookNumber] == true
                        ? SquarePercentIndicator(
                            width: 50,
                            height: 50,
                            startAngle: StartAngle.topRight,
                            reverse: false,
                            borderRadius: 12,
                            shadowWidth: 1.5,
                            progressWidth: 5,
                            shadowColor: Colors.grey,
                            progressColor: Colors.blue,
                            progress:
                                booksCtrl.downloadProgress[book.bookNumber] ??
                                    0,
                            child: Center(
                              child: Text(
                                '${((booksCtrl.downloadProgress[book.bookNumber] ?? 0) * 100).toStringAsFixed(0)}%',
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                          )
                        : IconButton(
                            icon: Icon(Icons.download),
                            onPressed: () async {
                              await booksCtrl.downloadBook(book.bookNumber);
                            },
                          ),
              ),
            );
          },
        );
      }),
    );
  }
}
