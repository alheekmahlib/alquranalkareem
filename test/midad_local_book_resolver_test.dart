import 'dart:convert';
import 'dart:io';

import 'package:alquranalkareem/presentation/screens/ai_search/ai_search.dart';
import 'package:alquranalkareem/presentation/screens/books/books.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late List<BookCollection> collections;

  setUpAll(() async {
    final json =
        jsonDecode(await File('assets/json/collections_v2.json').readAsString())
            as List;
    collections = json
        .map((item) => BookCollection.fromJson(item as Map<String, dynamic>))
        .toList();
  });

  test(
    'all indexed hadith sources resolve to the library book and release',
    () {
      const expected = <String, int>{
        'كتاب صحيح البخاري - ط السلطانية': 1681,
        'كتاب صحيح مسلم - ت عبد الباقي': 1727,
        'كتاب سنن الترمذي - ط الرسالة': 1363,
        'كتاب سنن أبي داود - ت الأرنؤوط': 117359,
        'كتاب السنن الكبرى - النسائي - ط الرسالة': 8361,
        'كتاب سنن ابن ماجه - ت الأرنؤوط': 98138,
      };
      for (final entry in expected.entries) {
        final match = LocalSearchBookResolver.resolve(entry.key, collections);
        expect(match, isNotNull, reason: entry.key);
        expect(match!.book.bookNumber, entry.value, reason: entry.key);
        expect(match.book.bookType, 'hadiths', reason: entry.key);
        expect(
          match.collection.bookUrlType,
          'hadiths_books_v2',
          reason: entry.key,
        );
      }
    },
  );

  test('uses the release of each book collection across search sections', () {
    const cases = <String, (int, String)>{
      'كتاب تفسير ابن كثير - ت السلامة': (8473, 'tafsir_books_v2'),
      'كتاب التوحيد لابن عبد الوهاب': (11318, 'aqeedah_books_v2'),
      'كتاب المغني لابن قدامة - ت التركي': (6910, 'fegh_hanbali'),
      'كتاب المجموع شرح المهذب - ط المنيرية': (2186, 'fegh_shafii'),
      'كتاب البداية والنهاية - ت التركي': (4445, 'history'),
      'كتاب سير أعلام النبلاء - ط الرسالة': (10906, 'altarajim_waltabaqat'),
    };
    for (final entry in cases.entries) {
      final match = LocalSearchBookResolver.resolve(entry.key, collections);
      expect(match?.book.bookNumber, entry.value.$1, reason: entry.key);
      expect(match?.collection.bookUrlType, entry.value.$2, reason: entry.key);
    }
  });

  test('refuses a similar title, missing source, and ambiguous editions', () {
    expect(
      LocalSearchBookResolver.resolve('كتاب الرحيق المختوم', collections),
      isNull,
    );
    expect(
      LocalSearchBookResolver.resolve('كتاب فقه السنة', collections),
      isNull,
    );
    expect(LocalSearchBookResolver.resolve('', collections), isNull);

    final real = LocalSearchBookResolver.resolve(
      'كتاب سنن الترمذي - ط الرسالة',
      collections,
    )!;
    final duplicate = BookCollection(
      type: real.collection.type,
      bookUrlType: real.collection.bookUrlType,
      books: [real.book, real.book],
    );
    expect(
      LocalSearchBookResolver.resolve(real.book.bookFullName, [duplicate]),
      isNull,
    );
  });

  test(
    'normalizes whitespace and an optional كتاب prefix without discarding the edition',
    () {
      final match = LocalSearchBookResolver.resolve(
        '  سنن  الترمذي - ط الرسالة  ',
        collections,
      );
      expect(match?.book.bookNumber, 1363);
      final otherEdition = LocalSearchBookResolver.resolve(
        'كتاب سنن الترمذي - ت بشار',
        collections,
      );
      expect(otherEdition, isNotNull);
      expect(otherEdition!.book.bookNumber, isNot(1363));
    },
  );
}
