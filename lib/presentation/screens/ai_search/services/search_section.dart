part of '../ai_search.dart';

/// Defines a downloadable search section
class SearchSection {
  final String id;
  final String releaseTag;
  final String titleAr;
  final String description;
  final String sizeLabel;
  final int paragraphCount;

  const SearchSection({
    required this.id,
    required this.releaseTag,
    required this.titleAr,
    required this.description,
    required this.sizeLabel,
    required this.paragraphCount,
  });

  /// All available sections
  static List<SearchSection> all = [quranTafsir, hadith, aqeedah, fiqh, seerah];

  static SearchSection quranTafsir = SearchSection(
    id: 'quran_tafsir',
    releaseTag: 'semantic_quran_tafsir_v2',
    titleAr: 'quranTafsir'.tr,
    description: 'quranTafsirDescription'.tr,
    sizeLabel: '114 MB',
    paragraphCount: 169297,
  );

  static SearchSection hadith = SearchSection(
    id: 'hadith',
    releaseTag: 'semantic_hadith_v2',
    titleAr: 'hadith'.tr,
    description: 'hadithsDescription'.tr,
    sizeLabel: '53 MB',
    paragraphCount: 83999,
  );

  static SearchSection aqeedah = SearchSection(
    id: 'aqeedah',
    releaseTag: 'semantic_aqeedah_v2',
    titleAr: 'aqeedah'.tr,
    description: 'aqeedahDescription'.tr,
    sizeLabel: '4 MB',
    paragraphCount: 5453,
  );

  static SearchSection fiqh = SearchSection(
    id: 'fiqh',
    releaseTag: 'semantic_fiqh_v2',
    titleAr: 'fiqh'.tr,
    description: 'fiqhDescription'.tr,
    sizeLabel: '52 MB',
    paragraphCount: 75302,
  );

  static SearchSection seerah = SearchSection(
    id: 'seerah',
    releaseTag: 'semantic_seerah_v2',
    titleAr: 'seerah'.tr,
    description: 'seerahDescription'.tr,
    sizeLabel: '90 MB',
    paragraphCount: 128538,
  );

  /// GitHub base URL for releases
  static const String githubBase =
      'https://github.com/alheekmahlib/Islamic_database/releases/download';

  /// Shared files release tag
  static const String sharedReleaseTag = 'semantic_shared_v2';

  /// Files per section (gzipped on GitHub, decompressed locally)
  static const List<String> sectionFiles = [
    'vectors_int8.npz.gz',
    'metadata.json.gz',
    'bm25_index.json.gz',
  ];

  /// Shared model files (downloaded once)
  static const List<String> sharedFiles = [
    'e5_small_int8.onnx.gz',
    'tokenizer.json.gz',
  ];
}
