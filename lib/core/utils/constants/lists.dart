import 'package:alquranalkareem/presentation/screens/home/home_screen.dart';
import 'package:get/get.dart';

import '../../../presentation/controllers/theme_controller.dart';
import '../../../presentation/screens/alwaqf_screen/alwaqf_screen.dart';
import '../../../presentation/screens/athkar/screens/alzkar_view.dart';
import '../../../presentation/screens/quran_page/screens/quran_home.dart';
import '../../../presentation/screens/surah_audio_screen/audio_surah.dart';
import 'constants.dart';

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

final List<String> surahNameList = <String>[
  "سُورَةُ ٱلْفَاتِحَةِ",
  "سُورَةُ البَقَرَةِ",
  "سُورَةُ آلِ عِمۡرَانَ",
  "سُورَةُ النِّسَاءِ",
  "سُورَةُ المَائـِدَةِ",
  "سُورَةُ الأَنۡعَامِ",
  "سُورَةُ الأَعۡرَافِ",
  "سُورَةُ الأَنفَالِ",
  "سُورَةُ التَّوۡبَةِ",
  "سُورَةُ يُونُسَ",
  "سُورَةُ هُودٍ",
  "سُورَةُ يُوسُفَ",
  "سُورَةُ الرَّعۡدِ",
  "سُورَةُ إِبۡرَاهِيمَ",
  "سُورَةُ الحِجۡرِ",
  "سُورَةُ النَّحۡلِ",
  "سُورَةُ الإِسۡرَاءِ",
  "سُورَةُ الكَهۡفِ",
  "سُورَةُ مَرۡيَمَ",
  "سُورَةُ طه",
  "سُورَةُ الأَنبِيَاءِ",
  "سُورَةُ الحَجِّ",
  "سُورَةُ المُؤۡمِنُونَ",
  "سُورَةُ النُّورِ",
  "سُورَةُ الفُرۡقَانِ",
  "سُورَةُ الشُّعَرَاءِ",
  "سُورَةُ النَّمۡلِ",
  "سُورَةُ القَصَصِ",
  "سُورَةُ العَنكَبُوتِ",
  "سُورَةُ الرُّومِ",
  "سُورَةُ لُقۡمَانَ",
  "سُورَةُ السَّجۡدَةِ",
  "سُورَةُ الأَحۡزَابِ",
  "سُورَةُ سَبَإٍ",
  "سُورَةُ فَاطِرٍ",
  "سُورَةُ يسٓ",
  "سُورَةُ الصَّافَّاتِ",
  "سُورَةُ صٓ",
  "سُورَةُ الزُّمَرِ",
  "سُورَةُ غَافِرٍ",
  "سُورَةُ فُصِّلَتۡ",
  "سُورَةُ الشُّورَىٰ",
  "سُورَةُ الزُّخۡرُفِ",
  "سُورَةُ الدُّخَانِ",
  "سُورَةُ الجَاثِيَةِ",
  "سُورَةُ الأَحۡقَافِ",
  "سُورَةُ مُحَمَّدٍ",
  "سُورَةُ الفَتۡحِ",
  "سُورَةُ الحُجُرَاتِ",
  "سُورَةُ قٓ",
  "سُورَةُ الذَّارِيَاتِ",
  "سُورَةُ الطُّورِ",
  "سُورَةُ النَّجۡمِ",
  "سُورَةُ القَمَرِ",
  "سُورَةُ الرَّحۡمَٰن",
  "سُورَةُ الوَاقِعَةِ",
  "سُورَةُ الحَدِيدِ",
  "سُورَةُ المُجَادلَةِ",
  "سُورَةُ الحَشۡرِ",
  "سُورَةُ المُمۡتَحنَةِ",
  "سُورَةُ الصَّفِّ",
  "سُورَةُ الجُمُعَةِ",
  "سُورَةُ المُنَافِقُونَ",
  "سُورَةُ التَّغَابُنِ",
  "سُورَةُ الطَّلَاقِ",
  "سُورَةُ التَّحۡرِيمِ",
  "سُورَةُ المُلۡكِ",
  "سُورَةُ القَلَمِ",
  "سُورَةُ الحَاقَّةِ",
  "سُورَةُ المَعَارِجِ",
  "سُورَةُ نُوحٍ",
  "سُورَةُ الجِنِّ",
  "سُورَةُ المُزَّمِّلِ",
  "سُورَةُ المُدَّثِّرِ",
  "سُورَةُ القِيَامَةِ",
  "سُورَةُ الإِنسَانِ",
  "سُورَةُ المُرۡسَلَاتِ",
  "سُورَةُ النَّبَإِ",
  "سُورَةُ النَّازِعَاتِ",
  "سُورَةُ عَبَسَ",
  "سُورَةُ التَّكۡوِيرِ",
  "سُورَةُ الانفِطَارِ",
  "سُورَةُ المُطَفِّفِينَ",
  "سُورَةُ الانشِقَاقِ",
  "سُورَةُ البُرُوجِ",
  "سُورَةُ الطَّارِقِ",
  "سُورَةُ الأَعۡلَىٰ",
  "سُورَةُ الغَاشِيَةِ",
  "سُورَةُ الفَجۡرِ",
  "سُورَةُ البَلَدِ",
  "سُورَةُ الشَّمۡسِ",
  "سُورَةُ اللَّيۡلِ",
  "سُورَةُ الضُّحَىٰ",
  "سُورَةُ الشَّرۡحِ",
  "سُورَةُ التِّينِ",
  "سُورَةُ العَلَقِ",
  "سُورَةُ القَدۡرِ",
  "سُورَةُ البَيِّنَةِ",
  "سُورَةُ الزَّلۡزَلَةِ",
  "سُورَةُ العَادِيَاتِ",
  "سُورَةُ القَارِعَةِ",
  "سُورَةُ التَّكَاثُرِ",
  "سُورَةُ العَصۡرِ",
  "سُورَةُ الهُمَزَةِ",
  "سُورَةُ الفِيلِ",
  "سُورَةُ قُرَيۡشٍ",
  "سُورَةُ المَاعُونِ",
  "سُورَةُ الكَوۡثَرِ",
  "سُورَةُ الكَافِرُونَ",
  "سُورَةُ النَّصۡرِ",
  "سُورَةُ المَسَدِ",
  "سُورَةُ الإِخۡلَاصِ",
  "سُورَةُ الفَلَقِ",
  "سُورَةُ النَّاسِ",
];

final List screensList = [
  {
    'name': 'home',
    'svgUrl': 'assets/svg/splash_icon_w.svg',
    'route': () => const HomeScreen(),
    'width': 240.0
  },
  {
    'name': 'quran',
    'svgUrl': 'assets/svg/splash_icon_w.svg',
    'route': () => QuranHome(),
    'width': 240.0
  },
  {
    'name': '',
    'svgUrl': 'assets/svg/alwaqf.svg',
    'route': () => AlwaqfScreen(),
    'width': 70.0
  },
  {
    'name': 'azkar',
    'svgUrl': 'assets/svg/azkar.svg',
    'route': () => const AzkarView(),
    'width': 70.0
  },
  {
    'name': 'quranAudio',
    'svgUrl': 'assets/svg/quran_au_ic.svg',
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
    'svgUrl': 'assets/svg/theme0.svg',
  },
  {
    'name': AppTheme.brown,
    'svgUrl': 'assets/svg/theme1.svg',
  },
  {
    'name': AppTheme.dark,
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
    'readerN': 'sa3d_al-ghaamidi/complete/',
    'readerI': 'Ghamadi'
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
    'name': 'reader1'.tr,
    'readerD': '192/ar.abdulbasitmurattal',
    'readerI': 'basit'
  },
  {'name': 'reader2'.tr, 'readerD': '128/ar.minshawi', 'readerI': 'minshawy'},
  {'name': 'reader3'.tr, 'readerD': '128/ar.husary', 'readerI': 'husary'},
  {'name': 'reader4'.tr, 'readerD': '128/ar.ahmedajamy', 'readerI': 'ajamy'},
  {
    'name': 'reader5'.tr,
    'readerD': '128/ar.mahermuaiqly',
    'readerI': 'muaiqly'
  },
  // {'name': 'reader6'.tr, 'readerD': 'Ghamadi_40kbps', 'readerI': 'Ghamadi'}
];
