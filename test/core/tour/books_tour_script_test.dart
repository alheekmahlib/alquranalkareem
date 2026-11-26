import 'dart:convert';
import 'dart:io';

import 'package:alquranalkareem/core/tour/books_tour_script.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotlight_tour/spotlight_tour.dart';

/// يسجّل ما طلب السيناريو من التطبيق بدل كنترولر الكتب والقارئ الحقيقيين.
class _FakeHooks implements BooksTourHooks {
  @override
  bool hasBooksLastRead = false;

  @override
  bool hasVisibleBooksGrid = true;

  @override
  bool isBooksSectionSearchActive = false;

  @override
  bool isBooksReaderBarsVisible = true;

  @override
  bool hasBooksChaptersDropdown = true;

  /// الكتب المحمّلة (رقم الكتاب → محمّل؟).
  final downloaded = <int, bool>{};

  /// كم مرة بدّلت الجولة حقل البحث داخل القسم.
  int sectionSearchSets = 0;

  /// كم مرة بدّلت الجولة شريطي القارئ.
  int barsSets = 0;

  /// موضع التمرير الحالي، وكل ما طلبت الجولة تمرير القائمة إليه.
  double offset = 0.0;
  final scrolledTo = <double>[];

  @override
  bool isBooksBookDownloaded(int bookNumber) => downloaded[bookNumber] ?? false;

  @override
  double get booksListScrollOffset => offset;

  @override
  void scrollBooksListTo(double value) {
    scrolledTo.add(value);
    offset = value;
  }

  @override
  void setBooksSectionSearchActive(bool active) {
    sectionSearchSets++;
    isBooksSectionSearchActive = active;
  }

  @override
  void setBooksReaderBarsVisible(bool visible) {
    barsSets++;
    isBooksReaderBarsVisible = visible;
  }
}

void main() {
  const locales = [
    'ar',
    'bn',
    'en',
    'es',
    'id',
    'ku',
    'ph',
    'ru',
    'so',
    'tr',
    'ur',
  ];

  late _FakeHooks hooks;
  late SpotlightTourController tour;

  setUp(() {
    hooks = _FakeHooks();
    tour = SpotlightTourController(
      completionStore: InMemoryTourCompletionStore(),
    );
  });

  /// سيناريو جولة القائمة مربوطاً على الكنترولر.
  BooksTourScript listScriptFor() {
    final script = BooksTourScript(
      tour: tour,
      hooks: hooks,
      style: const TourStepStyle(),
      hasLastRead: hooks.hasBooksLastRead,
      hasGrid: hooks.hasVisibleBooksGrid,
    );
    tour.onStepChanged = script.onStepChanged;
    return script;
  }

  /// سيناريو جولة صفحة الكتاب [bookNumber] مربوطاً على الكنترولر.
  BooksChaptersTourScript chaptersScriptFor({required int bookNumber}) {
    final script = BooksChaptersTourScript(
      tour: tour,
      hooks: hooks,
      style: const TourStepStyle(),
      bookNumber: bookNumber,
    );
    tour.onStepChanged = script.onStepChanged;
    return script;
  }

  /// سيناريو جولة القارئ مربوطاً على الكنترولر. العرض لا يُمرَّر هنا: اختبارات
  /// السيناريو لا تقلب صفحات.
  BooksReaderTourScript readerScriptFor() {
    final script = BooksReaderTourScript(
      tour: tour,
      hooks: hooks,
      style: const TourStepStyle(),
      swipeDemo: null,
      hasChaptersDropdown: hooks.hasBooksChaptersDropdown,
    );
    tour.onStepChanged = script.onStepChanged;
    return script;
  }

  /// يبدأ الجولة على محطة معيّنة من محطات سيناريو القائمة.
  void startListAt(BooksTourScript script, BooksTourStop stop) =>
      tour.start(steps: script.steps, initialIndex: script.stops.indexOf(stop));

  /// يبدأ جولة القارئ على محطة معيّنة.
  void startReaderAt(BooksReaderTourScript script, BooksReaderTourStop stop) =>
      tour.start(steps: script.steps, initialIndex: script.stops.indexOf(stop));

  test('list tour texts are read under keys derived from the stop name', () {
    expect(booksTourTitleKey(BooksTourStop.intro), 'booksTourIntroTitle');
    expect(
      booksTourDescKey(BooksTourStop.sectionsButton),
      'booksTourSectionsButtonDesc',
    );
    // A title that is only the feature's own name reuses the app's key
    // for it instead of duplicating the same word under a tour key.
    expect(booksTourTitleKey(BooksTourStop.searchField), 'searchInBooks');
    expect(booksTourTitleKey(BooksTourStop.sectionsButton), 'sections');
    expect(booksTourTitleKey(BooksTourStop.bookmarksButton), 'bookmarks');
    expect(booksTourTitleKey(BooksTourStop.lastRead), 'lastRead');
    expect(booksTourTitleKey(BooksTourStop.sortButton), 'sortBooks');
    expect(booksTourTitleKey(BooksTourStop.sectionSearchButton), 'search');
    // The closing card's title is the same for every tour.
    expect(booksTourTitleKey(BooksTourStop.closing), 'mushafTourClosingTitle');
  });

  test(
    'chapters tour texts are read under keys derived from the stop name',
    () {
      expect(
        booksChaptersTourTitleKey(
          BooksChaptersTourStop.intro,
          isDownloaded: false,
        ),
        'booksChaptersTourIntroTitle',
      );
      expect(
        booksChaptersTourDescKey(BooksChaptersTourStop.aboutBook),
        'booksChaptersTourAboutBookDesc',
      );
      // Feature-name titles reuse the app's keys for them.
      expect(
        booksChaptersTourTitleKey(
          BooksChaptersTourStop.searchButton,
          isDownloaded: false,
        ),
        'searchInBook',
      );
      expect(
        booksChaptersTourTitleKey(
          BooksChaptersTourStop.aboutBook,
          isDownloaded: false,
        ),
        'aboutBook',
      );
      expect(
        booksChaptersTourTitleKey(
          BooksChaptersTourStop.tocContent,
          isDownloaded: true,
        ),
        'chapterBook',
      );
      expect(
        booksChaptersTourTitleKey(
          BooksChaptersTourStop.closing,
          isDownloaded: false,
        ),
        'mushafTourClosingTitle',
      );
    },
  );

  test('the download button title follows the book download state', () {
    // Not downloaded: the button downloads.
    expect(
      booksChaptersTourTitleKey(
        BooksChaptersTourStop.downloadButton,
        isDownloaded: false,
      ),
      'download',
    );
    // Downloaded: the same target is the delete button.
    expect(
      booksChaptersTourTitleKey(
        BooksChaptersTourStop.downloadButton,
        isDownloaded: true,
      ),
      'delete',
    );
  });

  test('reader tour texts are read under keys derived from the stop name', () {
    expect(
      booksReaderTourTitleKey(BooksReaderTourStop.intro),
      'booksReaderTourIntroTitle',
    );
    expect(
      booksReaderTourDescKey(BooksReaderTourStop.tashkil),
      'booksReaderTourTashkilDesc',
    );
    // Feature-name titles reuse the app's keys for them.
    expect(booksReaderTourTitleKey(BooksReaderTourStop.bookmark), 'bookmarks');
    expect(
      booksReaderTourTitleKey(BooksReaderTourStop.chaptersDropdown),
      'chapterBook',
    );
    expect(
      booksReaderTourTitleKey(BooksReaderTourStop.searchInBook),
      'searchInBook',
    );
    expect(booksReaderTourTitleKey(BooksReaderTourStop.fontSize), 'fontSize');
    expect(
      booksReaderTourTitleKey(BooksReaderTourStop.backgroundColor),
      'choiceBackgroundColor',
    );
    expect(
      booksReaderTourTitleKey(BooksReaderTourStop.closing),
      'mushafTourClosingTitle',
    );
    // The page flip texts are the mushaf tour's own: one gesture, two readers.
    expect(
      booksReaderTourTitleKey(BooksReaderTourStop.pageFlip),
      'mushafTourPageFlipTitle',
    );
    expect(
      booksReaderTourDescKey(BooksReaderTourStop.pageFlip),
      'mushafTourPageFlipDesc',
    );
  });

  test('each tour has one step per stop, intro first and closing last', () {
    // Full state: the strip has a book and the tab shows a grid.
    hooks.hasBooksLastRead = true;
    final list = listScriptFor();
    expect(list.steps.length, BooksTourStop.values.length);
    expect(list.steps.first.title, 'booksTourIntroTitle');
    expect(list.steps.first.targetKey, isNull);
    expect(list.steps.last.title, 'mushafTourClosingTitle');
    expect(list.steps.last.targetKey, isNull);

    hooks.downloaded[1] = true;
    final chapters = chaptersScriptFor(bookNumber: 1);
    // One toc state always rides: the contents with the book downloaded,
    // the empty message without it, so one stop short of the enum.
    expect(chapters.steps.length, BooksChaptersTourStop.values.length - 1);
    expect(chapters.steps.first.targetKey, isNull);
    expect(chapters.steps.last.targetKey, isNull);

    final reader = readerScriptFor();
    expect(reader.steps.length, BooksReaderTourStop.values.length);
    expect(reader.steps.first.targetKey, isNull);
    expect(reader.steps.last.targetKey, isNull);
  });

  test('each list stop points at the widget tagged for it', () {
    // Full state so no stop is dropped; the step is looked up in the stops
    // list of the very tour, not by the enum index, in case a state drops
    // a stop before it.
    hooks.hasBooksLastRead = true;
    Key? targetOf(BooksTourStop stop) {
      final script = listScriptFor();
      return script.steps[script.stops.indexOf(stop)].targetKey;
    }

    expect(
      targetOf(BooksTourStop.searchField),
      same(BooksTourKeys.searchField),
    );
    expect(
      targetOf(BooksTourStop.sectionsButton),
      same(BooksTourKeys.sectionsButton),
    );
    expect(
      targetOf(BooksTourStop.bookmarksButton),
      same(BooksTourKeys.bookmarksButton),
    );
    expect(targetOf(BooksTourStop.lastRead), same(BooksTourKeys.lastRead));
    expect(targetOf(BooksTourStop.sortButton), same(BooksTourKeys.sortButton));
    expect(
      targetOf(BooksTourStop.sectionSearchButton),
      same(BooksTourKeys.sectionSearchButton),
    );
    expect(targetOf(BooksTourStop.bookGrid), same(BooksTourKeys.bookGrid));
  });

  test('each chapters stop points at the widget tagged for it', () {
    hooks.downloaded[1] = true;
    hooks.downloaded[2] = false;
    // The step is looked up in the stops list of the tour for this state,
    // not by the enum index: one toc stop always drops before the other.
    Key? targetOf(BooksChaptersTourStop stop) {
      final script = chaptersScriptFor(bookNumber: 1);
      return script.steps[script.stops.indexOf(stop)].targetKey;
    }

    expect(
      targetOf(BooksChaptersTourStop.searchButton),
      same(BooksTourKeys.chaptersSearchButton),
    );
    // One key for the download button and the delete button: only one of
    // them is ever mounted.
    expect(
      targetOf(BooksChaptersTourStop.downloadButton),
      same(BooksTourKeys.downloadButton),
    );
    expect(
      targetOf(BooksChaptersTourStop.aboutBook),
      same(BooksTourKeys.aboutBook),
    );
    // The toc card is one target for both its states: its contents in the
    // downloaded tour, and the empty state in the not-downloaded one.
    expect(targetOf(BooksChaptersTourStop.tocContent), same(BooksTourKeys.toc));
    final empty = chaptersScriptFor(bookNumber: 2);
    expect(
      empty
          .steps[empty.stops.indexOf(BooksChaptersTourStop.tocEmpty)]
          .targetKey,
      same(BooksTourKeys.toc),
    );
  });

  test('each reader stop points at the widget tagged for it', () {
    // The step is looked up in the stops list of the very tour.
    Key? targetOf(BooksReaderTourStop stop) {
      final script = readerScriptFor();
      return script.steps[script.stops.indexOf(stop)].targetKey;
    }

    // The page flip spotlights the reading page itself.
    expect(targetOf(BooksReaderTourStop.pageFlip), same(BooksTourKeys.page));
    expect(
      targetOf(BooksReaderTourStop.bookmark),
      same(BooksTourKeys.readerBookmark),
    );
    expect(
      targetOf(BooksReaderTourStop.chaptersDropdown),
      same(BooksTourKeys.chaptersDropdown),
    );
    expect(
      targetOf(BooksReaderTourStop.searchInBook),
      same(BooksTourKeys.readerSearchField),
    );
    expect(targetOf(BooksReaderTourStop.tashkil), same(BooksTourKeys.tashkil));
    expect(
      targetOf(BooksReaderTourStop.fontSize),
      same(BooksTourKeys.fontSize),
    );
    expect(
      targetOf(BooksReaderTourStop.backgroundColor),
      same(BooksTourKeys.backgroundColor),
    );
  });

  test('list stops missing their target are dropped from the tour', () {
    // Fresh session: no last-read strip and no grid — both stops drop.
    hooks.hasBooksLastRead = false;
    hooks.hasVisibleBooksGrid = false;
    final script = listScriptFor();
    expect(script.stops, isNot(contains(BooksTourStop.lastRead)));
    expect(script.stops, isNot(contains(BooksTourStop.bookGrid)));

    // And with them present, both are back in.
    hooks.hasBooksLastRead = true;
    hooks.hasVisibleBooksGrid = true;
    final full = listScriptFor();
    expect(
      full.stops,
      containsAll(<BooksTourStop>[
        BooksTourStop.lastRead,
        BooksTourStop.bookGrid,
      ]),
    );
    // The tour order is preserved either way.
    expect(full.stops.length, BooksTourStop.values.length);
  });

  test('the toc stop swaps content/empty with the download state', () {
    hooks.downloaded[1] = true;
    hooks.downloaded[2] = false;

    final downloaded = chaptersScriptFor(bookNumber: 1);
    expect(downloaded.isDownloaded, isTrue);
    expect(downloaded.stops, contains(BooksChaptersTourStop.tocContent));
    expect(downloaded.stops, isNot(contains(BooksChaptersTourStop.tocEmpty)));

    final notDownloaded = chaptersScriptFor(bookNumber: 2);
    expect(notDownloaded.isDownloaded, isFalse);
    expect(notDownloaded.stops, contains(BooksChaptersTourStop.tocEmpty));
    expect(
      notDownloaded.stops,
      isNot(contains(BooksChaptersTourStop.tocContent)),
    );
  });

  test('the reader chapters dropdown drops while chapters are not ready', () {
    hooks.hasBooksChaptersDropdown = false;
    final script = readerScriptFor();
    expect(script.stops, isNot(contains(BooksReaderTourStop.chaptersDropdown)));

    hooks.hasBooksChaptersDropdown = true;
    final full = readerScriptFor();
    expect(full.stops, contains(BooksReaderTourStop.chaptersDropdown));
    expect(full.stops.length, BooksReaderTourStop.values.length);
  });

  test('the reader tour order: flip first, the page header last', () {
    // The page header (bookmark + chapters dropdown) is explained after the
    // reading bars are hidden, so its stops close the tour before the
    // closing card; the page flip follows the intro like the mushaf tour.
    final script = readerScriptFor();
    expect(script.stops.first, BooksReaderTourStop.intro);
    expect(script.stops[1], BooksReaderTourStop.pageFlip);
    expect(script.stops.last, BooksReaderTourStop.closing);
    expect(script.stops.sublist(script.stops.length - 4), <BooksReaderTourStop>[
      BooksReaderTourStop.backgroundColor,
      BooksReaderTourStop.bookmark,
      BooksReaderTourStop.chaptersDropdown,
      BooksReaderTourStop.closing,
    ]);
  });

  test('the page flip step carries the swipe demo and its indicator', () {
    final script = readerScriptFor();
    final flip =
        script.steps[script.stops.indexOf(BooksReaderTourStop.pageFlip)];
    // No demo in this test's script: the step still asks for the swipe
    // indicator, and it is the only step that does.
    expect(flip.swipeDemo, isNull);
    expect(flip.indicator, TourIndicator.swipeLeftToRight);
    for (final step in script.steps.where((s) => s != flip)) {
      expect(step.indicator, isNot(TourIndicator.swipeLeftToRight));
    }
    // A demo, when built with one, rides on the flip step alone.
    final withDemo = BooksReaderTourScript(
      tour: tour,
      hooks: hooks,
      style: const TourStepStyle(),
      swipeDemo: PageSwipeDemo(
        pageController: PageController(),
        vsync: const TestVSync(),
      ),
      hasChaptersDropdown: true,
    );
    final demoStep =
        withDemo.steps[withDemo.stops.indexOf(BooksReaderTourStop.pageFlip)];
    expect(demoStep.swipeDemo, isNotNull);
    for (final step in withDemo.steps.where((s) => s != demoStep)) {
      expect(step.swipeDemo, isNull);
    }
    // The tour shows the gesture, it does not ask the user to perform it.
    for (final step in script.steps) {
      expect(step.requireInteraction, isFalse, reason: step.title);
    }
  });

  test('the list tour folds the section search open while explaining it', () {
    // The user left the in-section search field expanded; the sort and the
    // search buttons are only mounted collapsed, so the tour folds it for
    // its two stops and returns the user's own state afterwards.
    hooks.isBooksSectionSearchActive = true;
    final script = listScriptFor();

    startListAt(script, BooksTourStop.sortButton);
    expect(hooks.isBooksSectionSearchActive, isFalse);
    expect(hooks.sectionSearchSets, 1);

    // Still folded on the next stop, with no further sets.
    script.onStepChanged(
      script.stops.indexOf(BooksTourStop.sectionSearchButton),
    );
    expect(hooks.isBooksSectionSearchActive, isFalse);
    expect(hooks.sectionSearchSets, 1);

    // Leaving the two stops restores the user's expanded field at once.
    script.onStepChanged(script.stops.indexOf(BooksTourStop.bookGrid));
    expect(hooks.isBooksSectionSearchActive, isTrue);
    expect(hooks.sectionSearchSets, 2);

    // And the end is a no-op restore.
    script.onTourEnd();
    expect(hooks.sectionSearchSets, 2);
  });

  test(
    'the list tour pins the list to its top for the grid, then restores',
    () {
      hooks.offset = 120;
      hooks.hasBooksLastRead = false;
      final script = listScriptFor();

      startListAt(script, BooksTourStop.bookGrid);
      expect(hooks.scrolledTo, [0]);
      expect(hooks.offset, 0);

      // The closing card leaves the list where the tour needs nothing of it.
      script.onStepChanged(script.stops.indexOf(BooksTourStop.closing));
      expect(hooks.scrolledTo, [0, 120]);

      script.onTourEnd();
      expect(hooks.scrolledTo, [0, 120]);
    },
  );

  test('the reader tour hides the bars for the header stops and restores', () {
    // The user shows both bars; the tour keeps them for its bar stops, then
    // HIDES them for the page header (it sits under the top bar) and
    // returns the user's own state afterwards.
    hooks.isBooksReaderBarsVisible = true;
    final script = readerScriptFor();

    startReaderAt(script, BooksReaderTourStop.pageFlip);
    // The flip and the intro leave the bars as the user has them.
    expect(hooks.barsSets, 0);
    expect(hooks.isBooksReaderBarsVisible, isTrue);

    script.onStepChanged(
      script.stops.indexOf(BooksReaderTourStop.searchInBook),
    );
    expect(hooks.isBooksReaderBarsVisible, isTrue);
    expect(hooks.barsSets, 0);

    // The rest of the bar stops keep them shown, no further sets.
    script.onStepChanged(script.stops.indexOf(BooksReaderTourStop.tashkil));
    expect(hooks.barsSets, 0);

    // The header stops hide the bars: the bookmark and the chapters
    // dropdown sit under the top bar whenever it shows.
    script.onStepChanged(script.stops.indexOf(BooksReaderTourStop.bookmark));
    expect(hooks.isBooksReaderBarsVisible, isFalse);
    expect(hooks.barsSets, 1);

    script.onStepChanged(
      script.stops.indexOf(BooksReaderTourStop.chaptersDropdown),
    );
    expect(hooks.isBooksReaderBarsVisible, isFalse);
    expect(hooks.barsSets, 1);

    // The closing card leaves the bars hidden as the tour left them.
    script.onStepChanged(script.stops.indexOf(BooksReaderTourStop.closing));
    expect(hooks.isBooksReaderBarsVisible, isFalse);

    // And the end returns the user's shown bars.
    script.onTourEnd();
    expect(hooks.isBooksReaderBarsVisible, isTrue);
    expect(hooks.barsSets, 2);
  });

  test('a step report from another tour moves nothing', () {
    final script = listScriptFor();
    tour.start(
      steps: const [TourStep(title: 'other', description: '')],
    );
    script.onStepChanged(0);
    expect(hooks.sectionSearchSets, 0);
    expect(hooks.scrolledTo, isEmpty);

    // Nor an index this tour does not have.
    startListAt(script, BooksTourStop.intro);
    script.onStepChanged(script.stops.length);
    expect(hooks.sectionSearchSets, 0);

    // The same guard holds for the reader script.
    final reader = readerScriptFor();
    tour.start(
      steps: const [TourStep(title: 'other', description: '')],
    );
    reader.onStepChanged(0);
    expect(hooks.barsSets, 0);
  });

  test('every tour text exists in all 11 locale files', () {
    for (final locale in locales) {
      final strings =
          jsonDecode(File('assets/locales/$locale.json').readAsStringSync())
              as Map<String, dynamic>;
      for (final stop in BooksTourStop.values) {
        for (final key in [booksTourTitleKey(stop), booksTourDescKey(stop)]) {
          expect(
            strings[key],
            isA<String>().having((s) => s.trim(), 'not blank', isNotEmpty),
            reason: '$locale.json is missing "$key"',
          );
        }
      }
      for (final isDownloaded in [true, false]) {
        for (final stop in BooksChaptersTourStop.values) {
          for (final key in [
            booksChaptersTourTitleKey(stop, isDownloaded: isDownloaded),
            booksChaptersTourDescKey(stop),
          ]) {
            expect(
              strings[key],
              isA<String>().having((s) => s.trim(), 'not blank', isNotEmpty),
              reason: '$locale.json is missing "$key"',
            );
          }
        }
      }
      for (final stop in BooksReaderTourStop.values) {
        for (final key in [
          booksReaderTourTitleKey(stop),
          booksReaderTourDescKey(stop),
        ]) {
          expect(
            strings[key],
            isA<String>().having((s) => s.trim(), 'not blank', isNotEmpty),
            reason: '$locale.json is missing "$key"',
          );
        }
      }
    }
  });
}
