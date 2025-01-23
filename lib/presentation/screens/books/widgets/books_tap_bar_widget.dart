import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/books_controller.dart';

class BooksTapBarWidget extends StatelessWidget {
  BooksTapBarWidget({super.key});
  final booksCtrl = BooksController.instance;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        height: 35,
        // padding: const EdgeInsets.all(4.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            border: Border.all(
              width: 1,
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: .3),
            )),
        child: TabBar(
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).colorScheme.surface,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontFamily: 'kufi',
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
          unselectedLabelStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontFamily: 'kufi',
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
          indicator: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              color: Theme.of(context).colorScheme.surface),
          tabs: [
            Tab(
              text: 'allBooks'.tr,
            ),
            Tab(
              text: 'myLibrary'.tr,
            ),
            Tab(
              text: 'bookmark'.tr,
            ),
          ],
        ),
      ),
    );
  }
}
