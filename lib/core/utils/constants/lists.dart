import 'package:get/get.dart';

import '../../../presentation/controllers/theme_controller.dart';
import '../../../presentation/screens/alwaqf_screen/alwaqf_screen.dart';
import '../../../presentation/screens/athkar/screens/alzkar_view.dart';
import '../../../presentation/screens/quran_page/screens/quran_home.dart';
import '../../../presentation/screens/surah_audio_screen/audio_surah.dart';
import '/presentation/screens/home/home_screen.dart';
import 'url_constants.dart';

List<String> translateName = <String>[
  'English',
  'Español',
  'বাংলা',
  'اردو',
  'Soomaali',
  'bahasa Indonesia',
  'کوردی',
  'Türkçe'
];

List<String> shareTranslateName = <String>[
  'English',
  'Español',
  'বাংলা',
  'اردو',
  'Soomaali',
  'bahasa Indonesia',
  'کوردی',
  'Türkçe',
  'تفسير السعدي'
];

List<String> rtlLang = <String>[
  'العربية',
  'עברית',
  'فارسی',
  'اردو',
  'کوردی',
  'تفسير السعدي'
];

List<String> semanticsTranslateName = <String>[
  'English',
  'Spanish',
  'Bengal',
  'Urdu',
  'Somali',
  'Indonesian',
  'kurdish',
  'turkish'
];

final List<String> waqfMarks = <String>[
  'assets/svg/alwaqf/01.svg',
  'assets/svg/alwaqf/02.svg',
  'assets/svg/alwaqf/03.svg',
  'assets/svg/alwaqf/04.svg',
  'assets/svg/alwaqf/05.svg',
];

final List<String> waqfExplain = <String>[
  'عَلَامَة الوَقْفِ اللَّازم نَحوُ : {إِنَّمَا يَسْتَجِيبُ الَّذِينَ يَسْمَعُونَ ۘ وَالْمَوْتَىٰ يَبْعَثُهُمُ اللَّهُ}.',
  'عَلَامَة الوَقْفِ الجَائِزِ مَعَ كَوْنِ الوَقْفِ أَوْلَى نَحِوُ : {قُل رَّبِّي أَعْلَمُ بِعِدَّتِهِم مَّا يَعْلَمُهُمْ إِلَّا قَلِيلٌ ۗ فَلَا تُمَارِ فِيهِمْ}.',
  'عَلَامَة الوَقْفِ الجَائِزِ جَوَازًا مُسْتَوِيَ الطَّرَفَيْن نَحوُ : {نَّحْنُ نَقُصُّ عَلَيْكَ نَبَأَهُم بِالْحَقِّ ۚ إِنَّهُمْ فِتْيَةٌ آمَنُوا بِرَبِّهِمْ}.',
  'عَلَامَة الوَقْفِ الجَائِزِ مَعَ كَوْنِ الوَصْل أَوْلَى نَحِوُ : {وَإِن يَمْسَسْكَ اللَّهُ بِضُرٍّ فَلَا كَاشِفَ لَهُ إِلَّا هُوَ ۖ وَإِن يَمْسَسْكَ بِخَيْرٍ فَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ}.',
  'عَلَامَةُ تَعَانُق الوَقْفِ بِحَيْثُ إِِذَا وَقِفَ عَلى أَحَدِ المَوْضِعَيْن لَا يَصِحُّ الوَقفُ عَلى الآخَرِ نَحِوُ : {ذَٰلِكَ الْكِتَابُ لَا رَيْبَ ۛ فِيهِ ۛ هُدًى لِّلْمُتَّقِينَ}.',
];

final List screensList = [
  {
    'name': 'home',
    'svgUrl': 'assets/svg/splash_icon_w.svg',
    'imagePath': 'assets/images/home.png',
    'route': () => const HomeScreen(),
    'width': 240.0
  },
  {
    'name': 'quran',
    'svgUrl': 'assets/svg/splash_icon_w.svg',
    'imagePath': 'assets/images/pages.png',
    'route': () => QuranHome(),
    'width': 240.0
  },
  {
    'name': '',
    'svgUrl': 'assets/svg/alwaqf.svg',
    'imagePath': 'assets/images/audio.png',
    'route': () => AlwaqfScreen(),
    'width': 70.0
  },
  {
    'name': 'azkar',
    'svgUrl': 'assets/svg/azkar.svg',
    'imagePath': 'assets/images/athkar.png',
    'route': () => const AzkarView(),
    'width': 70.0
  },
  {
    'name': 'quranAudio',
    'svgUrl': 'assets/svg/quran_au_ic.svg',
    'imagePath': 'assets/images/audio.png',
    'route': () => const AudioScreen(),
    'width': 240.0
  },
];

final List mushafSettingsList = [
  {
    'name': 'pages',
    'imageUrl': 'assets/images/pages.png',
  },
  {
    'name': 'ayahs',
    'imageUrl': 'assets/images/ayahs.png',
  },
];

final List themeList = [
  {
    'name': AppTheme.blue,
    'title': 'blueMode',
    'svgUrl': 'assets/svg/theme0.svg',
  },
  {
    'name': AppTheme.brown,
    'title': 'brownMode',
    'svgUrl': 'assets/svg/theme1.svg',
  },
  {
    'name': AppTheme.old,
    'title': 'oldMode',
    'svgUrl': 'assets/svg/theme3.svg',
  },
  {
    'name': AppTheme.dark,
    'title': 'darkMode',
    'svgUrl': 'assets/svg/theme2.svg',
  }
];

List surahReaderInfo = [
  {
    'name': 'reader1'.tr,
    'readerD': '${UrlConstants.surahUrl}',
    'readerN': 'abdul_basit_murattal/',
    'readerI': 'basit'
  },
  {
    'name': 'reader2'.tr,
    'readerD': '${UrlConstants.surahUrl}',
    'readerN': 'muhammad_siddeeq_al-minshaawee/',
    'readerI': 'minshawy'
  },
  {
    'name': 'reader3'.tr,
    'readerD': '${UrlConstants.surahUrl}',
    'readerN': 'mahmood_khaleel_al-husaree_iza3a/',
    'readerI': 'husary'
  },
  {
    'name': 'reader4'.tr,
    'readerD': '${UrlConstants.surahUrl}',
    'readerN': 'ahmed_ibn_3ali_al-3ajamy/',
    'readerI': 'ajamy'
  },
  {
    'name': 'reader5'.tr,
    'readerD': '${UrlConstants.surahUrl}',
    'readerN': 'maher_almu3aiqly/year1440/',
    'readerI': 'muaiqly'
  },
  {
    'name': 'reader6'.tr,
    'readerD': '${UrlConstants.surahUrl}',
    'readerN': 'sa3ood_al-shuraym/',
    'readerI': 'saood'
  },
  {
    'name': 'reader7'.tr,
    'readerD': '${UrlConstants.surahUrl}',
    'readerN': 'sa3d_al-ghaamidi/complete/',
    'readerI': 'Ghamadi'
  },
  {
    'name': 'reader8'.tr,
    'readerD': '${UrlConstants.surahUrl}',
    'readerN': 'mustafa_al3azzawi/',
    'readerI': 'mustafa'
  },
  {
    'name': 'reader9'.tr,
    'readerD': '${UrlConstants.surahUrl}',
    'readerN': 'nasser_bin_ali_alqatami/',
    'readerI': 'nasser'
  },
  {
    'name': 'reader10'.tr,
    'readerD': '${UrlConstants.surahUrl2}',
    'readerN': 'peshawa/Rewayat-Hafs-A-n-Assem/',
    'readerI': 'qader'
  },
  {
    'name': 'reader11'.tr,
    'readerD': '${UrlConstants.surahUrl3}',
    'readerN': 'taher/',
    'readerI': 'taher'
  },
  {
    'name': 'reader12'.tr,
    'readerD': '${UrlConstants.surahUrl4}',
    'readerN': 'aloosi/',
    'readerI': 'aloosi'
  },
  {
    'name': 'reader13'.tr,
    'readerD': '${UrlConstants.surahUrl4}',
    'readerN': 'wdee3/',
    'readerI': 'wdee3'
  }
];

List tafsirName = [
  {'name': '${'tafIbnkatheerN'.tr}', 'bookName': '${'tafIbnkatheerD'.tr}'},
  {
    'name': '${'tafBaghawyN'.tr}',
    'bookName': '${'tafBaghawyD'.tr}',
  },
  {
    'name': '${'tafQurtubiN'.tr}',
    'bookName': '${'tafQurtubiD'.tr}',
  },
  {
    'name': '${'tafSaadiN'.tr}',
    'bookName': '${'tafSaadiD'.tr}',
  },
  {
    'name': '${'tafTabariN'.tr}',
    'bookName': '${'tafTabariD'.tr}',
  },
  {
    'name': 'English',
    'bookName': '',
  },
  {
    'name': 'Español',
    'bookName': '',
  },
  {
    'name': 'বাংলা',
    'bookName': '',
  },
  {
    'name': 'اردو',
    'bookName': '',
  },
  {
    'name': 'Soomaali',
    'bookName': '',
  },
  {
    'name': 'bahasa Indonesia',
    'bookName': '',
  },
  {
    'name': 'کوردی',
    'bookName': '',
  },
  {
    'name': 'Türkçe',
    'bookName': '',
  },
];

List ayahReaderInfo = [
  {
    'name': 'reader1',
    'readerD': '192/ar.abdulbasitmurattal',
    'readerI': 'basit'
  },
  {'name': 'reader2', 'readerD': '128/ar.minshawi', 'readerI': 'minshawy'},
  {'name': 'reader3', 'readerD': '128/ar.husary', 'readerI': 'husary'},
  {'name': 'reader4', 'readerD': '128/ar.ahmedajamy', 'readerI': 'ajamy'},
  {'name': 'reader5', 'readerD': '128/ar.mahermuaiqly', 'readerI': 'muaiqly'},
  {'name': 'reader6', 'readerD': '64/ar.saoodshuraym', 'readerI': 'saood'}
];

List<Map<String, dynamic>> whatsNewList = [
  {
    'index': 1,
    'title': "What'sNewTitle",
    'details': "What'sNewDetails",
    'imagePath': 'assets/images/allScreens.png',
  },
  {
    'index': 2,
    'title': "What'sNewTitle2",
    'details': "What'sNewDetails2",
    'imagePath': 'assets/images/ayahSelect.png',
  },
  {
    'index': 3,
    'title': "What'sNewTitle3",
    'details': "What'sNewDetails3",
    'imagePath': 'assets/images/ayahSearch.png',
  },
  {
    'index': 4,
    'title': "What'sNewTitle4",
    'details': "What'sNewDetails4",
    'imagePath': 'assets/images/ayahTranslate.png',
  },
  {
    'index': 5,
    'title': "What'sNewTitle5",
    'details':
        "${'ayahs'.tr}:\n\n◉ ${'reader4'.tr}\n◉ ${'reader5'.tr}\n◉ ${'reader6'.tr}\n\n${'quran_sorah'.tr}:\n\n◉ ${'reader7'.tr}\n◉ ${'reader8'.tr}\n◉ ${'reader9'.tr}\n◉ ${'reader10'.tr}\n◉ ${'reader11'.tr}\n◉ ${'reader12'.tr}\n◉ ${'reader13'.tr}",
    'imagePath': '',
  },
  {
    'index': 6,
    'title': "",
    'details': "۞ إضافة الأحزاب للصفحات\n۞ إضافة السجدة للصفحات",
    'imagePath': 'assets/images/sajda.png',
  },
];
