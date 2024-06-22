import 'package:alquranalkareem/core/utils/constants/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../controllers/books_controller.dart';
import '../../quran_page/widgets/search/search_bar_widget.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final booksCtrl = BooksController.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * .9,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
            topLeft: Radius.circular(8),
          )),
      child: Column(
        children: [
          const Gap(16),
          context.customClose(),
          const Gap(8),
          TextFieldBarWidget(
            controller: booksCtrl.searchController,
            hintText: 'Khatmah Name',
            horizontalPadding: 32.0,
            onPressed: () {
              booksCtrl.searchController.clear();
            },
            onChanged: null,
            onSubmitted: (value) => booksCtrl.searchBooks(value),
          ),
          Expanded(
            child: Obx(() {
              if (booksCtrl.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (booksCtrl.searchResults.isNotEmpty) {
                return ListView.builder(
                  itemCount: booksCtrl.searchResults.length,
                  itemBuilder: (context, index) {
                    final result = booksCtrl.searchResults[index];
                    return ListTile(
                      title: Text(result.title),
                      subtitle: Text(result.content),
                      trailing: Text(result.bookTitle),
                      onTap: () {
                        // التعامل مع النتيجة المحددة
                      },
                    );
                  },
                );
              } else {
                return const Center(child: Text('لا توجد نتائج'));
              }
            }),
          ),
        ],
      ),
    );
  }
}
