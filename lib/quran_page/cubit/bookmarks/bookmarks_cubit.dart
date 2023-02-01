import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../data/model/bookmark.dart';
import '../../data/model/sorah_bookmark.dart';
import '../../data/repository/bookmarks_controller.dart';
import '../../data/repository/sorah_bookmark_repository.dart';
import 'bookmarks_state.dart';

class BookmarksCubit extends Cubit<BookmarksState> {
  BookmarksCubit() : super(AddBookmarkState());

  static BookmarksCubit get(context) => BlocProvider.of(context);

  bool isShowBottomSheet = false;
  IconData bookmarksFabIcon = Icons.bookmarks_outlined;

  void bookmarksChangeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isShowBottomSheet = isShow;
    bookmarksFabIcon = icon;
    emit(ChangeBottomShowState());
  }

  void bookmarksCloseBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isShowBottomSheet = isShow;
    bookmarksFabIcon = icon;
    emit(CloseBottomShowState());
  }

  /// Bookmarks

  late final BookmarksController bookmarksController =
      Get.put(BookmarksController());

  int? id;
  addBookmark(pageNum, String sorahName, lastRead) async {
    try {
      int? bookmark = await bookmarksController.addBookmarks(
        Bookmarks(
          id,
          sorahName,
          pageNum,
          lastRead,
        ),
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
