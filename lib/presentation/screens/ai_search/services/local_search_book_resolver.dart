part of '../ai_search.dart';

/// A book and its download collection, resolved from the local search source.
class LocalSearchBookMatch {
  final Book book;
  final BookCollection collection;

  const LocalSearchBookMatch({required this.book, required this.collection});
}

/// Search index IDs are not the same as the library's book numbers.
/// Match the complete source title, including edition, and refuse ambiguity.
class LocalSearchBookResolver {
  static String _normalizeTitle(String title) {
    var value = title.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (value.startsWith('كتاب '))
      value = value.substring('كتاب '.length).trim();
    return value;
  }

  static LocalSearchBookMatch? resolve(
    String source,
    List<BookCollection> collections,
  ) {
    final title = _normalizeTitle(source);
    if (title.isEmpty) return null;

    LocalSearchBookMatch? match;
    for (final collection in collections) {
      for (final book in collection.books) {
        if (_normalizeTitle(book.bookFullName) != title) continue;
        if (match != null) return null;
        match = LocalSearchBookMatch(book: book, collection: collection);
      }
    }
    if (match == null ||
        match.collection.type != match.book.bookType ||
        match.collection.bookUrlType.trim().isEmpty) {
      return null;
    }
    return match;
  }
}
