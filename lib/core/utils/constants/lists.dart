import 'package:get/get.dart';

import '/presentation/screens/home/home_screen.dart';
import '../../../presentation/controllers/theme_controller.dart';
import '../../../presentation/screens/adhkar/screens/adhkar_view.dart';
import '../../../presentation/screens/alwaqf_screen/alwaqf_screen.dart';
import '../../../presentation/screens/books/screens/books_screen.dart';
import '../../../presentation/screens/quran_page/quran.dart';
import '../../../presentation/screens/surah_audio/screen/audio_surah.dart';
import 'url_constants.dart';

List<String> translateName = <String>[
  'nothing',
  'English',
  'Español',
  'বাংলা',
  'اردو',
  'Soomaali',
  'bahasa Indonesia',
  'کوردی',
  'Türkçe',
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
  // 'تفسير السعدي'
];

const List<String> semanticsTranslateName = <String>[
  'nothing',
  'English',
  'Spanish',
  'Bengal',
  'Urdu',
  'Somali',
  'Indonesian',
  'kurdish',
  'turkish',
];

const List<String> waqfMarks = <String>[
  'assets/svg/alwaqf/01.svg',
  'assets/svg/alwaqf/02.svg',
  'assets/svg/alwaqf/03.svg',
  'assets/svg/alwaqf/04.svg',
  'assets/svg/alwaqf/05.svg',
];

const List<String> waqfExplain = <String>[
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
    'route': () => const AdhkarView(),
    'width': 70.0
  },
  {
    'name': 'quranAudio',
    'svgUrl': 'assets/svg/quran_au_ic.svg',
    'imagePath': 'assets/images/audio.png',
    'route': () => const AudioScreen(),
    'width': 240.0
  },
  {
    'name': 'tafsirLibrary',
    'svgUrl': 'assets/svg/tafseer_white.svg',
    'imagePath': 'assets/images/tafsir_books.jpg',
    'route': () => BooksScreen(),
    'width': 326.0
  },
];

const List mushafSettingsList = [
  {
    'name': 'pages',
    'imageUrl': 'assets/images/pages.png',
  },
  {
    'name': 'ayahs',
    'imageUrl': 'assets/images/ayahs.png',
  },
];

const List themeList = [
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

const List surahReaderInfo = [
  {
    'name': 'reader1',
    'readerD': '${UrlConstants.ayahs3rdSource}',
    'readerN': 'abdul_basit_murattal/',
    'readerI': 'basit'
  },
  {
    'name': 'reader2',
    'readerD': '${UrlConstants.ayahs3rdSource}',
    'readerN': 'muhammad_siddeeq_al-minshaawee/',
    'readerI': 'minshawy'
  },
  {
    'name': 'reader3',
    'readerD': '${UrlConstants.ayahs3rdSource}',
    'readerN': 'mahmood_khaleel_al-husaree_iza3a/',
    'readerI': 'husary'
  },
  {
    'name': 'reader4',
    'readerD': '${UrlConstants.ayahs3rdSource}',
    'readerN': 'ahmed_ibn_3ali_al-3ajamy/',
    'readerI': 'ajamy'
  },
  {
    'name': 'reader5',
    'readerD': '${UrlConstants.ayahs3rdSource}',
    'readerN': 'maher_almu3aiqly/year1440/',
    'readerI': 'muaiqly'
  },
  {
    'name': 'reader6',
    'readerD': '${UrlConstants.ayahs3rdSource}',
    'readerN': 'sa3ood_al-shuraym/',
    'readerI': 'saood'
  },
  {
    'name': 'reader7',
    'readerD': '${UrlConstants.ayahs3rdSource}',
    'readerN': 'sa3d_al-ghaamidi/complete/',
    'readerI': 'Ghamadi'
  },
  {
    'name': 'reader8',
    'readerD': '${UrlConstants.ayahs3rdSource}',
    'readerN': 'mustafa_al3azzawi/',
    'readerI': 'mustafa'
  },
  {
    'name': 'reader9',
    'readerD': '${UrlConstants.ayahs3rdSource}',
    'readerN': 'nasser_bin_ali_alqatami/',
    'readerI': 'nasser'
  },
  {
    'name': 'reader10',
    'readerD': '${UrlConstants.ayahs4thSource}',
    'readerN': 'peshawa/Rewayat-Hafs-A-n-Assem/',
    'readerI': 'qader'
  },
  {
    'name': 'reader11',
    'readerD': '${UrlConstants.surahUrl3}',
    'readerN': 'taher/',
    'readerI': 'taher'
  },
  {
    'name': 'reader12',
    'readerD': '${UrlConstants.surahUrl4}',
    'readerN': 'aloosi/',
    'readerI': 'aloosi'
  },
  {
    'name': 'reader13',
    'readerD': '${UrlConstants.surahUrl4}',
    'readerN': 'wdee3/',
    'readerI': 'wdee3'
  },
  {
    'name': 'reader14',
    'readerD': '${UrlConstants.ayahs3rdSource}',
    'readerN': 'yasser_ad-dussary/',
    'readerI': 'yasser_ad-dussary'
  },
  {
    'name': 'reader15',
    'readerD': '${UrlConstants.ayahs3rdSource}',
    'readerN': 'abdullaah_3awwaad_al-juhaynee/',
    'readerI': 'Juhaynee'
  },
  {
    'name': 'reader16',
    'readerD': '${UrlConstants.ayahs3rdSource}',
    'readerN': 'fares/',
    'readerI': 'Fares'
  },
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

const List tafsirNameRandom = [
  {
    'name': '${'tafIbnkatheerN'}',
    'bookName': '${'tafIbnkatheerD'}',
  },
  {
    'name': '${'tafBaghawyN'}',
    'bookName': '${'tafBaghawyD'}',
  },
  {
    'name': '${'tafQurtubiN'}',
    'bookName': '${'tafQurtubiD'}',
  },
  {
    'name': '${'tafSaadiN'}',
    'bookName': '${'tafSaadiD'}',
  },
  {
    'name': '${'tafTabariN'}',
    'bookName': '${'tafTabariD'}',
  }
];

const List ayahReaderInfo = [
  {
    'name': 'reader1',
    'readerD': 'Abdul_Basit_Murattal_192kbps',
    'readerI': 'basit',
    'url': '${UrlConstants.ayahs2ndSource}'
  },
  {
    'name': 'reader2',
    'readerD': 'Minshawy_Murattal_128kbps',
    'readerI': 'minshawy',
    'url': '${UrlConstants.ayahs2ndSource}'
  },
  {
    'name': 'reader3',
    'readerD': 'Husary_128kbps',
    'readerI': 'husary',
    'url': '${UrlConstants.ayahs2ndSource}'
  },
  {
    'name': 'reader4',
    'readerD': '128/ar.ahmedajamy',
    'readerI': 'ajamy',
    'url': '${UrlConstants.ayahs1stSource}'
  },
  {
    'name': 'reader5',
    'readerD': 'MaherAlMuaiqly128kbps',
    'readerI': 'muaiqly',
    'url': '${UrlConstants.ayahs2ndSource}'
  },
  {
    'name': 'reader6',
    'readerD': 'Saood_ash-Shuraym_128kbps',
    'readerI': 'saood',
    'url': '${UrlConstants.ayahs2ndSource}'
  },
  {
    'name': 'reader15',
    'readerD': 'Abdullaah_3awwaad_Al-Juhaynee_128kbps',
    'readerI': 'Juhaynee',
    'url': '${UrlConstants.ayahs2ndSource}'
  },
  {
    'name': 'reader16',
    'readerD': 'Fares_Abbad_64kbps',
    'readerI': 'Fares',
    'url': '${UrlConstants.ayahs2ndSource}'
  },
];

List<Map<String, dynamic>> whatsNewList = [
  {
    'index': 11,
    'title': "",
    'details': "What'sNewDetails10",
    'imagePath': '',
  },
];

const List monthHadithsList = [
  {
    'hadithPart1': '',
    'hadithPart2':
        'أَفْضَلُ الصِّيامِ، بَعْدَ رَمَضانَ، شَهْرُ اللهِ المُحَرَّمُ، وأَفْضَلُ الصَّلاةِ، بَعْدَ الفَرِيضَةِ، صَلاةُ اللَّيْلِ.\n',
    'bookName':
        'الراوي : أبو هريرة | المحدث : مسلم | المصدر : صحيح مسلم | الصفحة أو الرقم : 1163',
  },
  {
    'hadithPart1':
        'كان أصحابُ النَّبيِّ صلَّى اللَّهُ عليهِ وآلِهِ وسلَّمَ يَتعلَّمونَ الدُّعاءَ كمَا يتعلَّمونَ القُرْآنَ إذا دخل الشَّهرُ أوِ السَّنةُ : ',
    'hadithPart2':
        'اللَّهُمَّ أدْخِلْهُ علينا بالأمْنِ والإيمَانِ والسَّلامَةِ والإسْلامِ وجِوارٍ منَ الشَّيطَانِ ورِضْوانٍ مَنَ الرَّحمَنِ.\n',
    'bookName':
        'الراوي : عبدالله بن هشام | المحدث : ابن حجر العسقلاني | المصدر : الإصابة في تمييز الصحابة | الصفحة أو الرقم : 2/378 | خلاصة حكم المحدث : موقوف على شرط الصحيح ',
  },
  {
    'hadithPart1': '',
    'hadithPart2': '',
    'bookName': '',
  },
  {
    'hadithPart1': '',
    'hadithPart2': '',
    'bookName': '',
  },
  {
    'hadithPart1': '',
    'hadithPart2': '',
    'bookName': '',
  },
  {
    'hadithPart1': '',
    'hadithPart2': '',
    'bookName': '',
  },
  {
    'hadithPart1': '',
    'hadithPart2':
        'الزَّمانُ قَدِ اسْتَدارَ كَهَيْئَتِهِ يَومَ خَلَقَ اللَّهُ السَّمَواتِ والأرْضَ، السَّنَةُ اثْنا عَشَرَ شَهْرًا، مِنْها أرْبَعَةٌ حُرُمٌ، ثَلاثَةٌ مُتَوالِياتٌ: ذُو القَعْدَةِ وذُو الحِجَّةِ والمُحَرَّمُ، ورَجَبُ مُضَرَ، الذي بيْنَ جُمادَى وشَعْبانَ.\n',
    'bookName':
        'الراوي : أبو بكرة نفيع بن الحارث | المحدث : البخاري | المصدر : صحيح البخاري | الصفحة أو الرقم : 3197',
  },
  {
    'hadithPart1': '',
    'hadithPart2':
        'عَنْ عَائِشَةَ رَضِيَ اللَّهُ عَنْهَا، قَالَتْ: كانَ رَسولُ اللَّهِ صَلَّى اللهُ عليه وسلَّمَ يَصُومُ حتَّى نَقُولَ: لا يُفْطِرُ، ويُفْطِرُ حتَّى نَقُولَ: لا يَصُومُ، فَما رَأَيْتُ رَسولَ اللَّهِ صَلَّى اللهُ عليه وسلَّمَ اسْتَكْمَلَ صِيَامَ شَهْرٍ إلَّا رَمَضَانَ، وما رَأَيْتُهُ أكْثَرَ صِيَامًا منه في شَعْبَانَ.\n',
    'bookName':
        'الراوي : عائشة أم المؤمنين | المحدث : البخاري | المصدر : صحيح البخاري | الصفحة أو الرقم : 1969',
  },
  {
    'hadithPart1': '',
    'hadithPart2':
        'مَن قَامَ رَمَضَانَ إيمَانًا واحْتِسَابًا، غُفِرَ له ما تَقَدَّمَ مِن ذَنْبِهِ.\n',
    'bookName':
        'الراوي : أبو هريرة | المحدث : البخاري | المصدر : صحيح البخاري | الصفحة أو الرقم : 37',
  },
  {
    'hadithPart1': '',
    'hadithPart2':
        'مَن صامَ رَمَضانَ ثُمَّ أتْبَعَهُ سِتًّا مِن شَوَّالٍ، كانَ كَصِيامِ الدَّهْرِ.\n',
    'bookName':
        'الراوي : أبو أيوب الأنصاري | المحدث : مسلم | المصدر : صحيح مسلم | الصفحة أو الرقم : 1164',
  },
  {
    'hadithPart1': '',
    'hadithPart2':
        'الزَّمانُ قَدِ اسْتَدارَ كَهَيْئَتِهِ يَومَ خَلَقَ اللَّهُ السَّمَواتِ والأرْضَ، السَّنَةُ اثْنا عَشَرَ شَهْرًا، مِنْها أرْبَعَةٌ حُرُمٌ، ثَلاثَةٌ مُتَوالِياتٌ: ذُو القَعْدَةِ وذُو الحِجَّةِ والمُحَرَّمُ، ورَجَبُ مُضَرَ، الذي بيْنَ جُمادَى وشَعْبانَ.\n',
    'bookName':
        'الراوي : أبو بكرة نفيع بن الحارث | المحدث : البخاري | المصدر : صحيح البخاري | الصفحة أو الرقم : 3197',
  },
  {
    'hadithPart1': '',
    'hadithPart2':
        'شَهْرَانِ لا يَنْقُصَانِ، شَهْرَا عِيدٍ: رَمَضَانُ، وذُو الحَجَّةِ.\n',
    'bookName':
        'الراوي : أبو بكرة نفيع بن الحارث | المحدث : البخاري | المصدر : صحيح البخاري | الصفحة أو الرقم : 1912',
  },
];
