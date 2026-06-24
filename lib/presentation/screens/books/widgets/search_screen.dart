part of '../books.dart';

class SearchScreen extends StatelessWidget {
  final void Function(String)? onSubmitted;
  final bool? isInBook;
  SearchScreen({super.key, this.onSubmitted, this.isInBook = false});

  final booksCtrl = BooksController.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Gap(16),
        Flexible(
          child: TextFieldBarWidget(
            controller: booksCtrl.state.searchController,
            hintText: 'searchInBooks'.tr,
            horizontalPadding: 32.0,
            onPressed: () {
              booksCtrl.state.searchController.clear();
              booksCtrl.state.searchResults.clear();
              booksCtrl.state.subjectSearchResults.clear();
              booksCtrl.state.sectionVisibleCount.clear();
              booksCtrl.state.searchedBookTypes.clear();
              booksCtrl.state.activeSearchQuery = null;
            },
            onChanged: null,
            onSubmitted: (value) {
              if (onSubmitted != null) {
                onSubmitted!(value);
              }
            },
          ),
        ),
        SearchBuild(),
      ],
    );
  }
}
