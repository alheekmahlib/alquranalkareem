part of '../../books.dart';

// تعريف تاب واحد - Single tab definition
class BooksTabConfig {
  final String title;
  final String svgPath;
  final bool isDownloadedBooks;
  final String? filterBookType;
  final Widget? customChild;

  const BooksTabConfig({
    required this.title,
    required this.svgPath,
    this.isDownloadedBooks = false,
    this.filterBookType,
    this.customChild,
  });

  /// بناء محتوى التاب - Build tab content
  Widget buildChild() {
    if (customChild != null) return customChild!;
    return AllBooksBuild(
      title: title,
      isDownloadedBooks: isDownloadedBooks,
      filterBookType: filterBookType,
    );
  }
}

// خريطة ربط نوع الكتاب بأيقونته - Book type to SVG icon mapping
// أضف أي نوع جديد هنا مع أيقونته - Add new types with their icons here
const _typeSvgMap = <String, String>{
  'tafsir': SvgPath.svgBooksTafsir,
  'hadiths': SvgPath.svgBooksHadith,
  'aqeedah': SvgPath.svgBooksAqeedahIcon,
  'asul_el-feqh': SvgPath.svgBooksOpenBook,
  'eulum_alfiqh_wal_awaeid_alfiqhia': SvgPath.svgBooksOpenBook,
};

const _defaultTypeSvg = SvgPath.svgBooksOpenBook;

// بناء قائمة التابات ديناميكياً من أنواع collections.json
// Build tabs dynamically from collections.json types
// [كل الكتب] → [مكتبتي] → [كل نوع من collections.json] → [الفواصل]
List<BooksTabConfig> buildBooksTabs(List<String> bookTypes) {
  return [
    // ── تابات ثابتة في البداية ──
    const BooksTabConfig(
      title: 'allBooks',
      svgPath: SvgPath.svgBooksAllBooks,
    ),
    const BooksTabConfig(
      title: 'myLibrary',
      svgPath: SvgPath.svgBooksMyLibrary,
      isDownloadedBooks: true,
    ),
    // ── تابات ديناميكية من collections.json ──
    for (final type in bookTypes)
      BooksTabConfig(
        title: type,
        svgPath: _typeSvgMap[type] ?? _defaultTypeSvg,
        filterBookType: type,
      ),
    // ── تاب ثابت في النهاية: الفواصل ──
    BooksTabConfig(
      title: 'bookmarks',
      svgPath: SvgPath.svgBooksBookmarks,
      customChild: BookBookmarksScreen(),
    ),
  ];
}
