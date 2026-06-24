part of '../books.dart';

class BooksScreen extends StatelessWidget {
  final booksCtrl = BooksController.instance;

  BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.primary,
      body: SafeArea(
        child: Container(
          color: context.theme.colorScheme.primaryContainer,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 90.0),
                child: Obx(() {
                  final tabs = buildBooksTabs(booksCtrl.state.bookTypes);
                  return BooksTabBarWidget(topPadding: 120.0, tabs: tabs);
                }),
              ),
              TopBarWidget(
                isHomeChild: true,
                isQuranSetting: false,
                isNotification: false,
                tabBarController:
                    BooksController.instance.state.tabBarController,
                bodyChild: SearchBuild(),
                centerChild: TextFieldBarWidget(
                  hintText: 'searchInBooks'.tr,
                  controller: booksCtrl.state.searchController,
                  horizontalPadding: 0.0,
                  onPressed: () {
                    QuranController.instance.setTopBarType = TopBarType.search;
                    BooksController.instance.state.tabBarController.open();
                  },
                  onButtonPressed: () {
                    booksCtrl.state.searchResults.clear();
                    booksCtrl.state.subjectSearchResults.clear();
                    booksCtrl.state.searchedBookTypes.clear();
                    booksCtrl.state.sectionVisibleCount.clear();
                    booksCtrl.state.activeSearchQuery = null;
                    booksCtrl.state.searchController.clear();
                  },
                  // onChanged: (query) => booksCtrl.searchBooks(query),
                  onSubmitted: (query) => booksCtrl.searchBooks(query),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
