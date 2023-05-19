import '../../data/model/bookmark.dart';

abstract class BookmarksState {}

class AddBookmarkState extends BookmarksState{}
class ChangeBottomShowState extends BookmarksState{}
class CloseBottomShowState extends BookmarksState{}
class BookmarkInitial extends BookmarksState {}

class BookmarkLoadInProgress extends BookmarksState {}

class BookmarkLoadSuccess extends BookmarksState {
  final List<Bookmarks> bookmarks;

  BookmarkLoadSuccess({required this.bookmarks});
}

class BookmarkOperationFailure extends BookmarksState {}