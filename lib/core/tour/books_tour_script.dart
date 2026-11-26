import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotlight_tour/spotlight_tour.dart';

/// محطات جولة قائمة الكتب (شاشة المكتبة الإسلامية). ترتيب التعداد هو ترتيب
/// الجولة.
///
/// تسير الجولة في شاشة القائمة من شريط البحث العلوي إلى شريط الأقسام ثم
/// محتوى التبويب. ومحطات قد غاب هدفها بحسب حالة الشاشة لحظة البدء تُحذف
/// من الجولة ([booksTourStopsFor]) لا أن تُعرض بلا إضاءة.
enum BooksTourStop {
  intro,

  /// حقل البحث في الكتب في الشريط العلوي.
  searchField,

  /// زر اسم القسم الحالي الذي يفتح شيت الأقسام.
  sectionsButton,

  /// زر الفواصل السريع في شريط الأقسام.
  bookmarksButton,

  /// شريط آخر قراءة: يدخل الجولة إن كان فيه كتاب.
  lastRead,

  /// زر ترتيب كتب القسم.
  sortButton,

  /// زر بحث داخل القسم: يظهر مطويًا (حقل البحث غير ممدَّد)، فتطويه
  /// الجولة خلال محطتي الترتيب والبحث ثم تعيد حالة المستخدم.
  sectionSearchButton,

  /// أول كتاب في شبكة الكتب: يدخل الجولة إن كان التبويب الحالي يعرض
  /// شبكة غير خاوية وأولُّ كتابها ظاهرٌ في أعلى القائمة (تبويب الأحاديث
  /// مستثنى: شبكاته المقدَّمة تدفع بقية الكتب تحت حافة القائمة).
  bookGrid,
  closing,
}

/// محطات جولة قائمة الكتب بحسب حالة الشاشة لحظة بدئها، بترتيب سيرها.
List<BooksTourStop> booksTourStopsFor({
  required bool hasLastRead,
  required bool hasGrid,
}) => [
  for (final stop in BooksTourStop.values)
    if (switch (stop) {
      BooksTourStop.lastRead => hasLastRead,
      BooksTourStop.bookGrid => hasGrid,
      _ => true,
    })
      stop,
];

/// مفاتيح ترجمة نصوص محطات جولة القائمة في ملفات اللغات.
// عناوين محطات لا تزيد على اسم الميزة نفسها تُقرأ بمفاتيحها القائمة في
// التطبيق، بدل تكرار الكلمة نفسها تحت مفتاح خاص بالجولة. وعنوان البطاقة
// الختامية نص عام تنتهي به كل جولة.
const Map<BooksTourStop, String> _featureNameTitleKeys = {
  BooksTourStop.searchField: 'searchInBooks',
  BooksTourStop.sectionsButton: 'sections',
  BooksTourStop.bookmarksButton: 'bookmarks',
  BooksTourStop.lastRead: 'lastRead',
  BooksTourStop.sortButton: 'sortBooks',
  BooksTourStop.sectionSearchButton: 'search',
  BooksTourStop.closing: 'mushafTourClosingTitle',
};

String booksTourTitleKey(BooksTourStop stop) =>
    _featureNameTitleKeys[stop] ?? '${_textKeyPrefix(stop)}Title';

String booksTourDescKey(BooksTourStop stop) => '${_textKeyPrefix(stop)}Desc';

String _textKeyPrefix(BooksTourStop stop) {
  final name = stop.name;
  return 'booksTour${name[0].toUpperCase()}${name.substring(1)}';
}

/// محطات جولة صفحة الكتاب. ترتيب التعداد هو ترتيب الجولة.
///
/// تشرح الجولة أزرار البحث والتحميل/الحذف والنبذة، ثم الفهرس: محتواه إن
/// كان الكتاب محمّلًا، أو رسالة التحميل أولًا إن لم يكن.
enum BooksChaptersTourStop {
  intro,

  /// زر البحث داخل الكتاب في شريط التطبيق.
  searchButton,

  /// زر التحميل، ويصير زر الحذف بعد التحميل: هدفهما واحد والوصف يشملهما.
  downloadButton,

  /// لوحة النبذة عن الكتاب.
  aboutBook,

  /// فهرس الكتاب (المحتويات/الأجزاء): يدخل الجولة إن كان الكتاب محمّلًا.
  tocContent,

  /// رسالة «حمّل الكتاب أولًا» مكان الفهرس: تدخل الجولة قبل التحميل.
  tocEmpty,
  closing,
}

/// محطات جولة صفحة الكتاب بحسب حالة تحميل الكتاب، بترتيب سيرها.
List<BooksChaptersTourStop> booksChaptersTourStopsFor({
  required bool isDownloaded,
}) => [
  for (final stop in BooksChaptersTourStop.values)
    if (switch (stop) {
      BooksChaptersTourStop.tocContent => isDownloaded,
      BooksChaptersTourStop.tocEmpty => !isDownloaded,
      _ => true,
    })
      stop,
];

/// مفاتيح ترجمة نصوص محطات صفحة الكتاب. عنوان زر التحميل يتبع حالة
/// الكتاب (تحميل/حذف)، فمفتاحه دالة في الحالة.
String booksChaptersTourTitleKey(
  BooksChaptersTourStop stop, {
  required bool isDownloaded,
}) => switch (stop) {
  BooksChaptersTourStop.searchButton => 'searchInBook',
  BooksChaptersTourStop.downloadButton => isDownloaded ? 'delete' : 'download',
  BooksChaptersTourStop.aboutBook => 'aboutBook',
  BooksChaptersTourStop.tocContent => 'chapterBook',
  BooksChaptersTourStop.closing => 'mushafTourClosingTitle',
  _ => '${_chaptersTextKeyPrefix(stop)}Title',
};

String booksChaptersTourDescKey(BooksChaptersTourStop stop) =>
    '${_chaptersTextKeyPrefix(stop)}Desc';

String _chaptersTextKeyPrefix(BooksChaptersTourStop stop) {
  final name = stop.name;
  return 'booksChaptersTour${name[0].toUpperCase()}${name.substring(1)}';
}

/// محطات جولة القارئ. ترتيب التعداد هو ترتيب الجولة.
///
/// تسير الجولة من عرض تقليب الصفحة إلى أزرار الشريطين زرًا زرًا، ثم تخفي
/// الشريطين وتشرح رأس الصفحة (الفاصل والفصول المنسدلة) — فهو يقع تحت
/// الشريط العلوي حين يظهر — وتختم. رأس الصفحة يُركَّب في كل صفحة، ونسخ
/// الصفحات المجاورة خارج مجال العرض فيتخطّاها باحث الأهداف وتبرز نسخة
/// الصفحة المرئية.
enum BooksReaderTourStop {
  intro,

  /// عرض تقليب الصفحة: تقلب الجولة الصفحة أمام المستخدم وتعيدها، على
  /// نمط محطة قلب الصفحة في جولة المصحف.
  pageFlip,

  /// حقل البحث داخل الكتاب في الشريط العلوي.
  searchInBook,

  /// زر التشكيل في الشريط السفلي.
  tashkil,

  /// منزلق حجم الخط في الشريط السفلي.
  fontSize,

  /// زر لون خلفية القراءة في الشريط السفلي.
  backgroundColor,

  /// زر الفاصل في رأس الصفحة: آخر الجولة، بعد إخفاء الشريطين، فهو تحت
  /// الشريط العلوي حين يظهر (قس على علامة الصفحة في جولة المصحف).
  bookmark,

  /// القائمة المنسدلة للفصول: تدخل الجولة إن كانت فصول الكتاب جاهزة،
  /// وتُشرَح بعد إخفاء الشريطين كذلك.
  chaptersDropdown,
  closing,
}

/// محطات جولة القارئ بحسب جاهزية الفصول المنسدلة، بترتيب سيرها.
List<BooksReaderTourStop> booksReaderTourStopsFor({
  required bool hasChaptersDropdown,
}) => [
  for (final stop in BooksReaderTourStop.values)
    if (stop != BooksReaderTourStop.chaptersDropdown || hasChaptersDropdown)
      stop,
];

/// مفاتيح ترجمة نصوص محطات القارئ. عنوان زر لون الخلفية يقرأ بمفتاح
/// الميزة القائمة في إعدادات القرآن، ونصا محطة تقليب الصفحة نصا جولة
/// المصحف نفسيه: الحركة واحدة في القارئين.
const Map<BooksReaderTourStop, String> _readerFeatureTitleKeys = {
  BooksReaderTourStop.pageFlip: 'mushafTourPageFlipTitle',
  BooksReaderTourStop.bookmark: 'bookmarks',
  BooksReaderTourStop.chaptersDropdown: 'chapterBook',
  BooksReaderTourStop.searchInBook: 'searchInBook',
  BooksReaderTourStop.fontSize: 'fontSize',
  BooksReaderTourStop.backgroundColor: 'choiceBackgroundColor',
  BooksReaderTourStop.closing: 'mushafTourClosingTitle',
};

String booksReaderTourTitleKey(BooksReaderTourStop stop) =>
    _readerFeatureTitleKeys[stop] ?? '${_readerTextKeyPrefix(stop)}Title';

/// أوصاف تُقرأ بنص قائم لا بمفتاح مشتق من اسم المحطة.
const Map<BooksReaderTourStop, String> _readerSharedDescKeys = {
  BooksReaderTourStop.pageFlip: 'mushafTourPageFlipDesc',
};

String booksReaderTourDescKey(BooksReaderTourStop stop) =>
    _readerSharedDescKeys[stop] ?? '${_readerTextKeyPrefix(stop)}Desc';

String _readerTextKeyPrefix(BooksReaderTourStop stop) {
  final name = stop.name;
  return 'booksReaderTour${name[0].toUpperCase()}${name.substring(1)}';
}

/// مفاتيح عادية لأهداف الجولات الثلاث، فلا يصلح لها GlobalKey: شاشات
/// المكتبة تدخل فوق شاشات أخر في المكدس، وشريط آخر قراءة يُركَّب على بطاقة
/// الشاشة الرئيسية أيضًا، ورأس صفحة القارئ يُركَّب في كل صفحة. تُبرز الجولة
/// آخر نسخة ظاهرة من الهدف.
///
/// مواضع تركيبها: [searchField] في books_screen.dart، و[sectionsButton]
/// و[bookmarksButton] في books_tab_bar_widget.dart، و[lastRead] على جذر
/// شريط آخر قراءة في books_last_read.dart، و[sortButton] و
/// [sectionSearchButton] في section_search_widget.dart، و[bookGrid] على
/// غلاف أول كتاب في الشبكة العادية في all_books_build.dart، و
/// [chaptersSearchButton] في chapters_screen.dart، و[downloadButton] على زر
/// التحميل وزر الحذف معًا في book_details_widget.dart، و[aboutBook] و[toc]
/// في book_details_widget.dart وbooks_chapters_build.dart، و[readerBookmark]
/// و[chaptersDropdown] و[readerSearchField] و[page] على صفحة القارئ في
/// read_view_screen.dart، وبقية
/// أزرار القارئ في books_top_title_widget.dart.
abstract final class BooksTourKeys {
  static const searchField = ValueKey<String>('books_tour.search_field');
  static const sectionsButton = ValueKey<String>('books_tour.sections_button');
  static const bookmarksButton = ValueKey<String>(
    'books_tour.bookmarks_button',
  );
  static const lastRead = ValueKey<String>('books_tour.last_read');
  static const sortButton = ValueKey<String>('books_tour.sort_button');
  static const sectionSearchButton = ValueKey<String>(
    'books_tour.section_search_button',
  );
  static const bookGrid = ValueKey<String>('books_tour.book_grid');
  static const chaptersSearchButton = ValueKey<String>(
    'books_tour.chapters_search_button',
  );
  static const downloadButton = ValueKey<String>('books_tour.download_button');
  static const aboutBook = ValueKey<String>('books_tour.about_book');
  static const toc = ValueKey<String>('books_tour.toc');
  static const readerBookmark = ValueKey<String>('books_tour.reader_bookmark');
  static const page = ValueKey<String>('books_tour.page');
  static const chaptersDropdown = ValueKey<String>(
    'books_tour.chapters_dropdown',
  );
  static const readerSearchField = ValueKey<String>(
    'books_tour.reader_search_field',
  );
  static const tashkil = ValueKey<String>('books_tour.tashkil');
  static const fontSize = ValueKey<String>('books_tour.font_size');
  static const backgroundColor = ValueKey<String>(
    'books_tour.background_color',
  );
}

const Map<BooksTourStop, Key> _plainKeys = {
  BooksTourStop.searchField: BooksTourKeys.searchField,
  BooksTourStop.sectionsButton: BooksTourKeys.sectionsButton,
  BooksTourStop.bookmarksButton: BooksTourKeys.bookmarksButton,
  BooksTourStop.lastRead: BooksTourKeys.lastRead,
  BooksTourStop.sortButton: BooksTourKeys.sortButton,
  BooksTourStop.sectionSearchButton: BooksTourKeys.sectionSearchButton,
  BooksTourStop.bookGrid: BooksTourKeys.bookGrid,
};

const Map<BooksTourStop, IconData> _icons = {
  BooksTourStop.intro: Icons.local_library_outlined,
  BooksTourStop.searchField: Icons.search,
  BooksTourStop.sectionsButton: Icons.category_outlined,
  BooksTourStop.bookmarksButton: Icons.bookmark_border,
  BooksTourStop.lastRead: Icons.history,
  BooksTourStop.sortButton: Icons.sort,
  BooksTourStop.sectionSearchButton: Icons.search,
  BooksTourStop.bookGrid: Icons.grid_view,
  BooksTourStop.closing: Icons.task_alt,
};

const Map<BooksChaptersTourStop, Key> _chaptersPlainKeys = {
  BooksChaptersTourStop.searchButton: BooksTourKeys.chaptersSearchButton,
  BooksChaptersTourStop.downloadButton: BooksTourKeys.downloadButton,
  BooksChaptersTourStop.aboutBook: BooksTourKeys.aboutBook,
  BooksChaptersTourStop.tocContent: BooksTourKeys.toc,
  BooksChaptersTourStop.tocEmpty: BooksTourKeys.toc,
};

const Map<BooksChaptersTourStop, IconData> _chaptersIcons = {
  BooksChaptersTourStop.intro: Icons.menu_book_outlined,
  BooksChaptersTourStop.searchButton: Icons.search,
  BooksChaptersTourStop.downloadButton: Icons.cloud_download_outlined,
  BooksChaptersTourStop.aboutBook: Icons.info_outline,
  BooksChaptersTourStop.tocContent: Icons.format_list_numbered,
  BooksChaptersTourStop.tocEmpty: Icons.cloud_off_outlined,
  BooksChaptersTourStop.closing: Icons.task_alt,
};

const Map<BooksReaderTourStop, Key> _readerPlainKeys = {
  BooksReaderTourStop.pageFlip: BooksTourKeys.page,
  BooksReaderTourStop.bookmark: BooksTourKeys.readerBookmark,
  BooksReaderTourStop.chaptersDropdown: BooksTourKeys.chaptersDropdown,
  BooksReaderTourStop.searchInBook: BooksTourKeys.readerSearchField,
  BooksReaderTourStop.tashkil: BooksTourKeys.tashkil,
  BooksReaderTourStop.fontSize: BooksTourKeys.fontSize,
  BooksReaderTourStop.backgroundColor: BooksTourKeys.backgroundColor,
};

const Map<BooksReaderTourStop, IconData> _readerIcons = {
  BooksReaderTourStop.intro: Icons.auto_stories,
  BooksReaderTourStop.pageFlip: Icons.swipe_outlined,
  BooksReaderTourStop.bookmark: Icons.bookmark_border,
  BooksReaderTourStop.chaptersDropdown: Icons.list,
  BooksReaderTourStop.searchInBook: Icons.search,
  BooksReaderTourStop.tashkil: Icons.text_fields,
  BooksReaderTourStop.fontSize: Icons.format_size,
  BooksReaderTourStop.backgroundColor: Icons.palette,
  BooksReaderTourStop.closing: Icons.task_alt,
};

/// ما تنفّذه خدمة الجولة (AppTour) لجولات المكتبة بحلول تُحقن من main.dart،
/// فلا يستورد هذا الملف شاشات التطبيق وتبقى قابلة للاختبار: حالة أشرطة
/// القارئ وإظهارها، وتمرير قائمة الكتب، وحقل البحث داخل القسم، وحالة
/// الفصول المنسدلة، ومحطات تُفصل بحسب وجودها.
abstract interface class BooksTourHooks {
  /// هل في شريط آخر قراءة كتاب؟ يفصل محطته في جولة القائمة.
  bool get hasBooksLastRead;

  /// هل التبويب الحالي يعرض شبكة كتب يظهر أول كتابها أعلى القائمة؟
  bool get hasVisibleBooksGrid;

  /// موضع تمرير قائمة الكتب (0 إن لم تُركَّب القائمة بعد).
  double get booksListScrollOffset;

  /// يمرر قائمة الكتب إلى موضع [offset].
  void scrollBooksListTo(double offset);

  /// هل حقل البحث داخل القسم ممدَّد؟
  bool get isBooksSectionSearchActive;

  /// يمدّد حقل البحث داخل القسم أو يطويه.
  void setBooksSectionSearchActive(bool active);

  /// هل شريطا القارئ (العلوي والسفلي) ظاهران؟
  bool get isBooksReaderBarsVisible;

  /// يظهر شريطا القارئ أو يخفيهما.
  void setBooksReaderBarsVisible(bool visible);

  /// هل فصول الكتاب جاهزة في القائمة المنسدلة للقارئ؟
  bool get hasBooksChaptersDropdown;

  /// هل الكتاب [bookNumber] محمّل؟ تفصل محطتي الفهرس في جولة صفحة الكتاب.
  bool isBooksBookDownloaded(int bookNumber);
}

/// يتولى الجولةُ حقلَ البحث داخل القسم نيابةً عن المستخدم ثم يعيده إليه،
/// على نمط _PlayerPanelSync في جولة الصوتي: أول طلب يحفظ حالة المستخدم،
/// والبطاقة الختامية لا تطلبه شيئًا (null) فتبقى كما انتهت عنده الجولة.
class _SectionSearchSync {
  _SectionSearchSync(this.hooks);

  final BooksTourHooks hooks;

  /// حالة الحقل التي تركها المستخدم حين تولّته الجولة (null: لم تتوله
  /// بعد).
  bool? _userActive;

  /// يضبط الحقل لخطوة قادمة (null: يُترك كما هو).
  void sync({required bool? active}) {
    if (active == null) {
      restore();
      return;
    }
    _userActive ??= hooks.isBooksSectionSearchActive;
    if (hooks.isBooksSectionSearchActive != active) {
      hooks.setBooksSectionSearchActive(active);
    }
  }

  /// يعيد الحقل إلى حالة المستخدم إن كانت الجولة قد غيّرته.
  void restore() {
    final user = _userActive;
    if (user == null) return;
    _userActive = null;
    if (hooks.isBooksSectionSearchActive != user) {
      hooks.setBooksSectionSearchActive(user);
    }
  }
}

/// يتولى الجولةُ شريطي القارئ نيابةً عن المستخدم ثم يعيدهما، على نمط
/// _MidadModeSync في جولة مداد: أول طلب يحفظ حالة المستخدم، والبطاقة
/// الختامية لا تطلبهما شيئًا (null) فتبقيان في الحالة التي انتهت عندها
/// الجولة، ويعاد ما كان للمستخدم عند انتهائها.
class _ReaderBarsSync {
  _ReaderBarsSync(this.hooks);

  final BooksTourHooks hooks;

  /// حالة الشريطين التي تركها المستخدم حين تولّتهما الجولة (null: لم
  /// تتولهما بعد).
  bool? _userVisible;

  /// يضبط الشريطين لخطوة قادمة (null: يُتركان كما هما).
  void sync({required bool? visible}) {
    if (visible == null) return;
    _userVisible ??= hooks.isBooksReaderBarsVisible;
    if (hooks.isBooksReaderBarsVisible != visible) {
      hooks.setBooksReaderBarsVisible(visible);
    }
  }

  /// يعيد الشريطين إلى حالة المستخدم إن كانت الجولة قد غيّرتهما.
  void restore() {
    final user = _userVisible;
    if (user == null) return;
    _userVisible = null;
    if (hooks.isBooksReaderBarsVisible != user) {
      hooks.setBooksReaderBarsVisible(user);
    }
  }
}

/// سيناريو جولة قائمة الكتب: محطاتها بحسب حالة الشاشة لحظة بدئها،
/// والتجهيز مركزي في [onStepChanged] (يُربط بـ
/// `SpotlightTourController.onStepChanged`): يثبّت القائمة على أعلاها
/// خلال محطتي آخر قراءة والشبكة، ويطوي حقل البحث داخل القسم خلال محطتي
/// الترتيب والبحث، ويعاد كل شيء إلى المستخدم حالما تغادر الجولة نطاقه أو
/// تنتهي.
class BooksTourScript {
  BooksTourScript({
    required this.tour,
    required this.hooks,
    required this.style,
    required bool hasLastRead,
    required bool hasGrid,
  }) : stops = booksTourStopsFor(hasLastRead: hasLastRead, hasGrid: hasGrid);

  final SpotlightTourController tour;
  final BooksTourHooks hooks;
  final TourStepStyle style;

  /// محطات هذه الجولة بحسب الحالة التي بدئت فيها، بترتيب سيرها.
  final List<BooksTourStop> stops;

  late final _SectionSearchSync _sectionSearch = _SectionSearchSync(hooks);

  /// موضع القائمة الذي تركه المستخدم حين مرّرتها الجولة (null: لم تمررها
  /// بعد). هدف الشبكة غلاف أول كتاب فيها، فتُثبَّت القائمة على أعلاها خلال
  /// محطتي آخر القراءة والشبكة ثم يعاد موضع المستخدم.
  double? _userListOffset;

  late final List<TourStep> steps = [for (final stop in stops) _build(stop)];

  TourStep _build(BooksTourStop stop) => TourStep(
    targetKey: switch (stop) {
      BooksTourStop.intro || BooksTourStop.closing => null,
      _ => _plainKeys[stop],
    },
    title: booksTourTitleKey(stop).tr,
    description: booksTourDescKey(stop).tr,
    icon: _icons[stop],
    style: style,
  );

  /// يُربط بـ `SpotlightTourController.onStepChanged`.
  void onStepChanged(int index) {
    final stop = _stopAt(index);
    if (stop == null) return;
    _syncListTop(top: _needsListTop(stop));
    _sectionSearch.sync(active: _sectionSearchActiveFor(stop));
  }

  /// انتهت الجولة (إتمامًا أو تخطيًا أو مغادرة الشاشة): يعاد موضع القائمة
  /// وحقل البحث إلى المستخدم.
  void onTourEnd() {
    _syncListTop(top: false);
    _sectionSearch.restore();
  }

  /// هل تحتاج المحطة القائمةَ مثبتة على أعلاها؟
  bool _needsListTop(BooksTourStop stop) =>
      stop == BooksTourStop.lastRead || stop == BooksTourStop.bookGrid;

  /// حالة حقل البحث التي تحتاجها المحطة (null: كما تُرك).
  bool? _sectionSearchActiveFor(BooksTourStop stop) => switch (stop) {
    BooksTourStop.sortButton || BooksTourStop.sectionSearchButton => false,
    BooksTourStop.closing => null,
    _ => null,
  };

  /// يثبّت القائمة على أعلاها خلال محطتيها أو يعيد موضع المستخدم.
  void _syncListTop({required bool top}) {
    if (!top) {
      final user = _userListOffset;
      if (user == null) return;
      _userListOffset = null;
      if (hooks.booksListScrollOffset != user) {
        hooks.scrollBooksListTo(user);
      }
      return;
    }
    _userListOffset ??= hooks.booksListScrollOffset;
    if (hooks.booksListScrollOffset != 0) hooks.scrollBooksListTo(0);
  }

  /// محطة الخطوة [index] إن كانت الجولة الجارية هي هذا السيناريو.
  BooksTourStop? _stopAt(int index) {
    if (!identical(tour.steps, steps)) return null;
    if (index < 0 || index >= stops.length) return null;
    return stops[index];
  }
}

/// سيناريو جولة صفحة الكتاب: كل أهدافه مركَّبة دائمًا فلا تجهيز له ولا
/// تبديل حالة. دالتا [onStepChanged] و[onTourEnd] فارغتان عمداً: تُربطان
/// كغيرها حتى لا يبقى على الكنترولر ردُّ جولة أقدم إذا انتهت هذه الجولة.
class BooksChaptersTourScript {
  BooksChaptersTourScript({
    required this.tour,
    required this.hooks,
    required this.style,
    required int bookNumber,
  }) : isDownloaded = hooks.isBooksBookDownloaded(bookNumber),
       stops = booksChaptersTourStopsFor(
         isDownloaded: hooks.isBooksBookDownloaded(bookNumber),
       );

  final SpotlightTourController tour;
  final BooksTourHooks hooks;
  final TourStepStyle style;

  /// هل الكتاب المفتوح محمّل؟ به يتبع عنوان زر التحميل/الحذف ومحطتا
  /// الفهرس.
  final bool isDownloaded;

  /// محطات هذه الجولة بحسب حالة تحميل الكتاب، بترتيب سيرها.
  final List<BooksChaptersTourStop> stops;

  late final List<TourStep> steps = [for (final stop in stops) _build(stop)];

  TourStep _build(BooksChaptersTourStop stop) => TourStep(
    targetKey: switch (stop) {
      BooksChaptersTourStop.intro || BooksChaptersTourStop.closing => null,
      _ => _chaptersPlainKeys[stop],
    },
    title: booksChaptersTourTitleKey(stop, isDownloaded: isDownloaded).tr,
    description: booksChaptersTourDescKey(stop).tr,
    icon: _chaptersIcons[stop],
    style: style,
  );

  /// لا تجهيز لهذه الجولة؛ مربوطة لتُلغي ردّ أي جولة أقدم.
  void onStepChanged(int index) {}

  /// لا شيء لاسترجاعه؛ مربوطة لتُلغي ردّ أي جولة أقدم.
  void onTourEnd() {}
}

/// سيناريو جولة القارئ: تعرض تقليب الصفحة (محطة [BooksReaderTourStop.pageFlip]
/// تُشغّل [PageSwipeDemo] بنفسها عبر [TourStep.swipeDemo]، فتقلب الصفحة أمام
/// المستخدم وتعيدها إلى موضعه)، وتُظهر شريطي القراءة خلال محطاتهما زرًا زرًا،
/// ثم تُخفيهما لمحطتي رأس الصفحة — فالفاصل والفصول المنسدلة يقعان تحت
/// الشريط العلوي حين يظهر — وتعيد حالة المستخدم عند انتهائها. والتجهيز
/// مركزي في [onStepChanged]، ومحطة البطاقة الختامية لا تطلب الشريطين
/// شيئًا (null) فتبقيان في الحالة التي انتهت عندها الجولة.
class BooksReaderTourScript {
  BooksReaderTourScript({
    required this.tour,
    required this.hooks,
    required this.style,
    required this.swipeDemo,
    required bool hasChaptersDropdown,
  }) : stops = booksReaderTourStopsFor(
         hasChaptersDropdown: hasChaptersDropdown,
       );

  final SpotlightTourController tour;
  final BooksTourHooks hooks;
  final TourStepStyle style;

  /// عرض قلب صفحة القارئ، مربوط بكنترولر صفحاته الحيّ. null في الاختبارات.
  final PageSwipeDemo? swipeDemo;

  /// محطات هذه الجولة بحسب جاهزية الفصول المنسدلة، بترتيب سيرها.
  final List<BooksReaderTourStop> stops;

  late final _ReaderBarsSync _bars = _ReaderBarsSync(hooks);

  late final List<TourStep> steps = [for (final stop in stops) _build(stop)];

  TourStep _build(BooksReaderTourStop stop) {
    final isPageFlip = stop == BooksReaderTourStop.pageFlip;
    return TourStep(
      targetKey: switch (stop) {
        BooksReaderTourStop.intro || BooksReaderTourStop.closing => null,
        _ => _readerPlainKeys[stop],
      },
      title: booksReaderTourTitleKey(stop).tr,
      description: booksReaderTourDescKey(stop).tr,
      icon: _readerIcons[stop],
      style: style,
      // محطة التقليب: المؤشر يسحب يميناً (التالية في قارئ RTL) ويتبع
      // العرضَ، فتقلب الجولة الصفحة فعلاً وتعيدها (على نمط جولة المصحف).
      indicator: isPageFlip
          ? TourIndicator.swipeLeftToRight
          : TourIndicator.pulse,
      swipeDemo: isPageFlip ? swipeDemo : null,
    );
  }

  /// يُربط بـ `SpotlightTourController.onStepChanged`.
  void onStepChanged(int index) {
    final stop = _stopAt(index);
    if (stop == null) return;
    _bars.sync(visible: _barsVisibleFor(stop));
  }

  /// انتهت الجولة (إتمامًا أو تخطيًا أو مغادرة الشاشة): يعاد شريطا القارئ
  /// إلى حالة المستخدم.
  void onTourEnd() => _bars.restore();

  /// حالة الشريطين التي تحتاجها المحطة (null: كما تُركا).
  bool? _barsVisibleFor(BooksReaderTourStop stop) => switch (stop) {
    BooksReaderTourStop.searchInBook ||
    BooksReaderTourStop.tashkil ||
    BooksReaderTourStop.fontSize ||
    BooksReaderTourStop.backgroundColor => true,
    // رأس الصفحة تحت الشريط العلوي حين يظهر: تُخفى المحطتان الشريطين.
    BooksReaderTourStop.bookmark ||
    BooksReaderTourStop.chaptersDropdown => false,
    _ => null,
  };

  /// محطة الخطوة [index] إن كانت الجولة الجارية هي هذا السيناريو.
  BooksReaderTourStop? _stopAt(int index) {
    if (!identical(tour.steps, steps)) return null;
    if (index < 0 || index >= stops.length) return null;
    return stops[index];
  }
}
