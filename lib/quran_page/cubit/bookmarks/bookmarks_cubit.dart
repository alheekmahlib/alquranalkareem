import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../data/model/sorah_bookmark.dart';
import '../../data/repository/bookmarks_controller.dart';
import '../../data/repository/sorah_bookmark_repository.dart';
import 'bookmarks_state.dart';

class BookmarksCubit extends Cubit<BookmarksState> {
  BookmarksCubit() : super(AddBookmarkState());

  static BookmarksCubit get(context) => BlocProvider.of(context);

  /// Bookmarks
  late final BookmarksController bookmarksController =
      Get.put(BookmarksController());

  int? id;
  addBookmark(int pageNum, String sorahName, String lastRead) async {
    try {
      int? bookmark = await bookmarksController.addBookmarks(
        pageNum,
        sorahName,
        lastRead,
      );
      print('$bookmark');
    } catch (e) {
      print('Error');
    }
  }

  /// Bookmarks
  SorahBookmarkRepository sorahBookmarkRepository = SorahBookmarkRepository();
  List<SoraBookmark>? soraBookmarkList;

  getBookmarksList() async {
    await sorahBookmarkRepository.all().then((values) {
      soraBookmarkList = values;
    });
  }
}
