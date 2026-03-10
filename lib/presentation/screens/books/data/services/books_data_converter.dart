part of '../../books.dart';

/// خدمة مساعدة لتحويل البيانات من البنية الجديدة - Helper service for converting data from new structure
class BooksDataConverter {
  /// تحويل ملف JSON للكتاب إلى نموذج Book - Convert book JSON file to Book model
  static Book convertJsonToBook(Map<String, dynamic> jsonData, int bookNumber) {
    try {
      if (jsonData.containsKey('info') && jsonData.containsKey('pages')) {
        // البنية الجديدة - New structure
        return Book.fromDownloadedJson(jsonData, bookNumber);
      } else {
        // البنية القديمة - Old structure
        return _convertOldFormatToBook(jsonData, bookNumber);
      }
    } catch (e) {
      log('Error converting JSON to Book: $e', name: 'BooksDataConverter');
      return Book.empty();
    }
  }

  /// تحويل البنية القديمة للكتاب - Convert old book structure
  static Book _convertOldFormatToBook(
      Map<String, dynamic> jsonData, int bookNumber) {
    List<PageContent> pages = [];
    List<Volume> volumes = [];
    List<TocItem> toc = [];

    String bookTitle = 'كتاب رقم $bookNumber';

    // استخراج الصفحات من البنية القديمة - Extract pages from old structure
    if (jsonData.containsKey('parts')) {
      var parts = jsonData['parts'] as List<dynamic>;
      for (var part in parts) {
        if (part.containsKey('pages')) {
          var partPages = part['pages'] as List<dynamic>;
          for (var page in partPages) {
            pages.add(PageContent.fromJson(page, bookTitle, bookNumber));
          }
        }
      }
    }

    return Book(
      bookNumber: bookNumber,
      bookName: bookTitle,
      bookFullName: bookTitle,
      aboutBook: '',
      bookType: '',
      author: '',
      hasChapters: true,
      partsCount: volumes.length,
      chapterCount: toc.length,
      pageTotal: pages.length,
      pages: pages,
      volumes: volumes,
      toc: toc,
    );
  }

  /// استخراج النص من جدول المحتويات - Extract text from table of contents
  static List<String> extractTocTexts(List<TocItem> toc) {
    List<String> texts = [];
    for (var item in toc) {
      if (item.text.isNotEmpty) {
        texts.add(item.text);
      }
      if (item.children.isNotEmpty) {
        texts.addAll(extractTocTexts(item.children));
      }
    }
    return texts;
  }

  /// البحث في جدول المحتويات - Search in table of contents
  static int findPageInToc(List<TocItem> toc, String searchText) {
    for (var item in toc) {
      if (item.text == searchText && item.page > 0) {
        return item.page;
      }
      if (item.children.isNotEmpty) {
        int result = findPageInToc(item.children, searchText);
        if (result > 0) return result;
      }
    }
    return 0;
  }

  /// الحصول على أسماء الأجزاء - Get volume names
  static List<String> getVolumeNames(List<Volume> volumes) {
    return volumes.map((v) => v.name).toList();
  }

  /// التحقق من صحة البيانات - Validate data
  static bool validateBookData(Map<String, dynamic> jsonData) {
    return jsonData.containsKey('info') || jsonData.containsKey('parts');
  }

  /// تنظيف النص من التشكيل - Clean text from diacritics
  static String cleanText(String text) {
    return text.replaceAll(RegExp(r'[\u064B-\u0652\u0670\u0640]'), '');
  }

  /// تحويل نص إلى HTML - Convert text to HTML
  static String convertToHtml(String text) {
    return text
        .replaceAll('\n', '<br>')
        .replaceAll('\t', '&nbsp;&nbsp;&nbsp;&nbsp;');
  }

  /// استخراج المعلومات الأساسية للكتاب - Extract basic book information
  static Map<String, dynamic> extractBookInfo(Map<String, dynamic> jsonData) {
    if (jsonData.containsKey('info')) {
      return jsonData['info'];
    } else {
      // إنشاء معلومات افتراضية - Create default information
      return {
        'title': 'كتاب غير معروف',
        'author': 'مؤلف غير معروف',
        'bookType': 'book',
        'about': '',
        'pages': jsonData.containsKey('parts')
            ? _countPagesInParts(jsonData['parts'])
            : 0,
      };
    }
  }

  /// عد الصفحات في الأجزاء - Count pages in parts
  static int _countPagesInParts(List<dynamic> parts) {
    int count = 0;
    for (var part in parts) {
      if (part.containsKey('pages')) {
        count += (part['pages'] as List).length;
      }
    }
    return count;
  }
}
