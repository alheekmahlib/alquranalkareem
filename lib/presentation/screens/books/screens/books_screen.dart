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
                child: BooksTabBarWidget(
                  topPadding: 120.0,
                  firstTabChild: AllBooksBuild(title: 'allBooks'),
                  secondTabChild: AllBooksBuild(
                    title: 'myLibrary',
                    isDownloadedBooks: true,
                  ),
                  thirdTabChild: AllBooksBuild(
                    title: 'hadiths',
                    isHadithsBooks: true,
                  ),
                  fourthTabChild: AllBooksBuild(
                    title: 'tafsir',
                    isTafsirBooks: true,
                  ),
                  fifthTabChild: BookBookmarksScreen(),
                ),
              ),
              TopBarWidget(
                isHomeChild: true,
                isQuranSetting: false,
                isNotification: false,
                bodyChild: SearchBuild(),
                centerChild: TextFieldBarWidget(
                  hintText: 'searchInBooks'.tr,
                  controller: booksCtrl.state.searchController,
                  horizontalPadding: 0.0,
                  onPressed: () {
                    QuranController.instance.setTopBarType = TopBarType.search;
                    QuranController.instance.state.tabBarController.open();
                  },
                  onButtonPressed: () {
                    booksCtrl.state.searchResults.clear();
                    booksCtrl.state.searchController.clear();
                  },
                  onChanged: (query) => booksCtrl.searchBooks(query),
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
