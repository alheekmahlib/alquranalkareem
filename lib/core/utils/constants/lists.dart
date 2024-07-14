import 'package:get/get.dart';

import '/presentation/screens/home/home_screen.dart';
import '../../../presentation/controllers/theme_controller.dart';
import '../../../presentation/screens/alwaqf_screen/alwaqf_screen.dart';
import '../../../presentation/screens/athkar/screens/alzkar_view.dart';
import '../../../presentation/screens/home/controller/adhan/adhan_controller.dart';
import '../../../presentation/screens/quran_page/screens/quran_home.dart';
import '../../../presentation/screens/surah_audio_screen/audio_surah.dart';
import '../../services/services_locator.dart';
import 'url_constants.dart';

final adhanCtrl = sl<AdhanController>();

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
  // 'تفسير السعدي'
];

const List<String> semanticsTranslateName = <String>[
  'English',
  'Spanish',
  'Bengal',
  'Urdu',
  'Somali',
  'Indonesian',
  'kurdish',
  'turkish'
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
    'readerD': '${UrlConstants.surahUrl}',
    'readerN': 'abdul_basit_murattal/',
    'readerI': 'basit'
  },
  {
    'name': 'reader2',
    'readerD': '${UrlConstants.surahUrl}',
    'readerN': 'muhammad_siddeeq_al-minshaawee/',
    'readerI': 'minshawy'
  },
  {
    'name': 'reader3',
    'readerD': '${UrlConstants.surahUrl}',
    'readerN': 'mahmood_khaleel_al-husaree_iza3a/',
    'readerI': 'husary'
  },
  {
    'name': 'reader4',
    'readerD': '${UrlConstants.surahUrl}',
    'readerN': 'ahmed_ibn_3ali_al-3ajamy/',
    'readerI': 'ajamy'
  },
  {
    'name': 'reader5',
    'readerD': '${UrlConstants.surahUrl}',
    'readerN': 'maher_almu3aiqly/year1440/',
    'readerI': 'muaiqly'
  },
  {
    'name': 'reader6',
    'readerD': '${UrlConstants.surahUrl}',
    'readerN': 'sa3ood_al-shuraym/',
    'readerI': 'saood'
  },
  {
    'name': 'reader7',
    'readerD': '${UrlConstants.surahUrl}',
    'readerN': 'sa3d_al-ghaamidi/complete/',
    'readerI': 'Ghamadi'
  },
  {
    'name': 'reader8',
    'readerD': '${UrlConstants.surahUrl}',
    'readerN': 'mustafa_al3azzawi/',
    'readerI': 'mustafa'
  },
  {
    'name': 'reader9',
    'readerD': '${UrlConstants.surahUrl}',
    'readerN': 'nasser_bin_ali_alqatami/',
    'readerI': 'nasser'
  },
  {
    'name': 'reader10',
    'readerD': '${UrlConstants.surahUrl2}',
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
    'readerD': '${UrlConstants.surahUrl}',
    'readerN': 'yasser_ad-dussary/',
    'readerI': 'yasser_ad-dussary'
  },
  {
    'name': 'reader15',
    'readerD': '${UrlConstants.surahUrl}',
    'readerN': 'abdullaah_3awwaad_al-juhaynee/',
    'readerI': 'Juhaynee'
  },
  {
    'name': 'reader16',
    'readerD': '${UrlConstants.surahUrl}',
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

List tafsirNameRandom = [
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
  }
];

const List ayahReaderInfo = [
  {
    'name': 'reader1',
    'readerD': 'Abdul_Basit_Murattal_192kbps',
    'readerI': 'basit',
    'url': '${UrlConstants.ayahUrl2}'
  },
  {
    'name': 'reader2',
    'readerD': 'Minshawy_Murattal_128kbps',
    'readerI': 'minshawy',
    'url': '${UrlConstants.ayahUrl2}'
  },
  {
    'name': 'reader3',
    'readerD': 'Husary_128kbps',
    'readerI': 'husary',
    'url': '${UrlConstants.ayahUrl2}'
  },
  {
    'name': 'reader4',
    'readerD': '128/ar.ahmedajamy',
    'readerI': 'ajamy',
    'url': '${UrlConstants.ayahUrl}'
  },
  {
    'name': 'reader5',
    'readerD': 'MaherAlMuaiqly128kbps',
    'readerI': 'muaiqly',
    'url': '${UrlConstants.ayahUrl2}'
  },
  {
    'name': 'reader6',
    'readerD': 'Saood_ash-Shuraym_128kbps',
    'readerI': 'saood',
    'url': '${UrlConstants.ayahUrl2}'
  },
  {
    'name': 'reader15',
    'readerD': 'Abdullaah_3awwaad_Al-Juhaynee_128kbps',
    'readerI': 'Juhaynee',
    'url': '${UrlConstants.ayahUrl2}'
  },
  {
    'name': 'reader16',
    'readerD': 'Fares_Abbad_64kbps',
    'readerI': 'Fares',
    'url': '${UrlConstants.ayahUrl2}'
  },
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
    'index': 11,
    'title': "What'sNewTitle5",
    'details':
        "${'ayahs'.tr}:\n\n◉ ${'reader4'.tr}\n◉ ${'reader5'.tr}\n◉ ${'reader6'.tr}\n◉ ${'reader15'.tr}\n◉ ${'reader16'.tr}\n\n${'quran_sorah'.tr}:\n\n◉ ${'reader7'.tr}\n◉ ${'reader8'.tr}\n◉ ${'reader9'.tr}\n◉ ${'reader10'.tr}\n◉ ${'reader11'.tr}\n◉ ${'reader12'.tr}\n◉ ${'reader13'.tr}\n◉ ${'reader15'.tr}\n◉ ${'reader16'.tr}\n◉ ${'reader14'.tr}",
    'imagePath': '',
  },
  {
    'index': 6,
    'title': "",
    'details': "What'sNewDetails6",
    'imagePath': 'assets/images/sajda.png',
  },
  {
    'index': 7,
    'title': "",
    'details': "What'sNewDetails7",
    'imagePath': 'assets/images/fontSize.png',
  },
  {
    'index': 8,
    'title': "What'sNewTitle8",
    'details': "What'sNewDetails8",
    'imagePath': 'assets/images/ayahAndTafsir.png',
  },
  {
    'index': 9,
    'title': "What'sNewDetails9",
    'details': "",
    'imagePath': 'assets/images/IslamicOccasions.png',
  },
];

const List occasionList = [
  {'title': 'Start of the Hijri Year', 'month': 1, 'day': 1},
  {'title': 'Ramadan', 'month': 9, 'day': 1},
  {'title': 'Blessed Eid al-Fitr', 'month': 10, 'day': 1},
  {'title': 'Day of Arafah', 'month': 12, 'day': 9},
  {'title': 'Blessed Eid al-Adha', 'month': 12, 'day': 10}
];

const List monthHadithsList = [
  {
    'hadithPart1':
        'عَنْ أَبِي هُرَيْرَةَ، - رضى الله عنه - قَالَ قَالَ رَسُولُ اللَّهِ صلى الله عليه وسلم',
    'hadithPart2':
        '"‏ أَفْضَلُ الصِّيَامِ بَعْدَ رَمَضَانَ شَهْرُ اللَّهِ الْمُحَرَّمُ وَأَفْضَلُ الصَّلاَةِ بَعْدَ الْفَرِيضَةِ صَلاَةُ اللَّيْلِ ‏"‏ ‏.‏',
    'bookName': ' صحيح مسلم كتاب الصيام - ٤٠٤',
  },
  {
    'hadithPart1':
        ' كَانَ أَصْحَابُ رَسُولِ اللهِ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ، يَتَعَلَّمُونَ هَذَا الدُّعَاءَ كَمَا يَتَعَلَّمُونَ القُرآنَ إِذَا دَخَل الشَّهْرُ أَوِ السَّنَةُ: ',
    'hadithPart2':
        'اللَّهُمَّ أَدْخِلْهُ عَلَيْنَا بِالْأَمْنِ، وَالْإِيمَانِ، وَالسَّلَامَةِ، وَالْإِسْلَامِ، وَجوار مِنَ الشَّيْطَانِ، وَرِضْوَانٍ مِنَ الرَّحْمَنِ ".',
    'bookName': ' صححه الحافظ ابن حجر في "الإصابة" ٦ / ٤٠٧ - ٤٠٨',
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
    'hadithPart2': '',
    'bookName': '',
  },
  {
    'hadithPart1':
        'عَنْ أَبِي بَكْرَةَ ـ رضى الله عنه ـ عَنِ النَّبِيِّ صلى الله عليه وسلم قَالَ',
    'hadithPart2':
        '"‏ الزَّمَانُ قَدِ اسْتَدَارَ كَهَيْئَتِهِ يَوْمَ خَلَقَ السَّمَوَاتِ وَالأَرْضَ، السَّنَةُ اثْنَا عَشَرَ شَهْرًا، مِنْهَا أَرْبَعَةٌ حُرُمٌ، ثَلاَثَةٌ مُتَوَالِيَاتٌ ذُو الْقَعْدَةِ وَذُو الْحِجَّةِ وَالْمُحَرَّمُ، وَرَجَبُ مُضَرَ الَّذِي بَيْنَ جُمَادَى وَشَعْبَانَ ‏"‏‏.‏',
    'bookName': ' صحيح البخاري كتاب بدء الخلق - ٣١٩٧',
  },
  {
    'hadithPart1': 'عَنْ عَائِشَةَ ـ رضى الله عنها ـ قَالَتْ',
    'hadithPart2':
        '"كَانَ رَسُولُ اللَّهِ صلى الله عليه وسلم يَصُومُ حَتَّى نَقُولَ لاَ يُفْطِرُ، وَيُفْطِرُ حَتَّى نَقُولَ لاَ يَصُومُ‏.‏ فَمَا رَأَيْتُ رَسُولَ اللَّهِ صلى الله عليه وسلم اسْتَكْمَلَ صِيَامَ شَهْرٍ إِلاَّ رَمَضَانَ، وَمَا رَأَيْتُهُ أَكْثَرَ صِيَامًا مِنْهُ فِي شَعْبَانَ‏.‏"',
    'bookName': ' صحيح البخاري كتاب الصوم - ١٩٦٩',
  },
  {
    'hadithPart1':
        'عَنْ أَبِي هُرَيْرَةَ، أَنَّ رَسُولَ اللَّهِ صلى الله عليه وسلم قَالَ',
    'hadithPart2':
        '"‏ مَنْ قَامَ رَمَضَانَ إِيمَانًا وَاحْتِسَابًا غُفِرَ لَهُ مَا تَقَدَّمَ مِنْ ذَنْبِهِ ‏"‏‏.‏',
    'bookName': ' صحيح البخاري كتاب الإيمان - ٣٧',
  },
  {
    'hadithPart1':
        'عَنْ أَبِي أَيُّوبَ الأَنْصَارِيِّ، - رضى الله عنه - أَنَّهُ حَدَّثَهُ أَنَّ رَسُولَ اللَّهِ صلى الله عليه وسلم قَالَ',
    'hadithPart2':
        '"‏ مَنْ صَامَ رَمَضَانَ ثُمَّ أَتْبَعَهُ سِتًّا مِنْ شَوَّالٍ كَانَ كَصِيَامِ الدَّهْرِ ‏"‏ ‏.‏',
    'bookName': ' صحيح مسلم كتاب الصيام - ٤٠٤',
  },
  {
    'hadithPart1':
        'عَنِ ابْنِ عَبَّاسٍ ـ رضى الله عنهما ـ أَنَّهُ سُئِلَ عَنْ مُتْعَةِ الْحَجِّ، فَقَالَ أَهَلَّ الْمُهَاجِرُونَ وَالأَنْصَارُ وَأَزْوَاجُ النَّبِيِّ صلى الله عليه وسلم فِي حَجَّةِ الْوَدَاعِ وَأَهْلَلْنَا، فَلَمَّا قَدِمْنَا مَكَّةَ قَالَ رَسُولُ اللَّهِ صلى الله عليه وسلم',
    'hadithPart2':
        '"‏ اجْعَلُوا إِهْلاَلَكُمْ بِالْحَجِّ عُمْرَةً إِلاَّ مَنْ قَلَّدَ الْهَدْىَ ‏"‏‏.‏ فَطُفْنَا بِالْبَيْتِ وَبِالصَّفَا وَالْمَرْوَةِ وَأَتَيْنَا النِّسَاءَ، وَلَبِسْنَا الثِّيَابَ وَقَالَ ‏"‏ مَنْ قَلَّدَ الْهَدْىَ فَإِنَّهُ لاَ يَحِلُّ لَهُ حَتَّى يَبْلُغَ الْهَدْىُ مَحِلَّهُ ‏"‏‏.‏ ثُمَّ أَمَرَنَا عَشِيَّةَ التَّرْوِيَةِ أَنْ نُهِلَّ بِالْحَجِّ، فَإِذَا فَرَغْنَا مِنَ الْمَنَاسِكِ جِئْنَا فَطُفْنَا بِالْبَيْتِ وَبِالصَّفَا وَالْمَرْوَةِ فَقَدْ تَمَّ حَجُّنَا، وَعَلَيْنَا الْهَدْىُ كَمَا قَالَ اللَّهُ تَعَالَى ‏{‏فَمَا اسْتَيْسَرَ مِنَ الْهَدْىِ فَمَنْ لَمْ يَجِدْ فَصِيَامُ ثَلاَثَةِ أَيَّامٍ فِي الْحَجِّ وَسَبْعَةٍ إِذَا رَجَعْتُمْ‏}‏ إِلَى أَمْصَارِكُمْ‏.‏ الشَّاةُ تَجْزِي، فَجَمَعُوا نُسُكَيْنِ فِي عَامٍ بَيْنَ الْحَجِّ وَالْعُمْرَةِ، فَإِنَّ اللَّهَ تَعَالَى أَنْزَلَهُ فِي كِتَابِهِ وَسَنَّهُ نَبِيُّهُ صلى الله عليه وسلم وَأَبَاحَهُ لِلنَّاسِ غَيْرَ أَهْلِ مَكَّةَ، قَالَ اللَّهُ ‏{‏ذَلِكَ لِمَنْ لَمْ يَكُنْ أَهْلُهُ حَاضِرِي الْمَسْجِدِ الْحَرَامِ‏}‏ وَأَشْهُرُ الْحَجِّ الَّتِي ذَكَرَ اللَّهُ تَعَالَى شَوَّالٌ وَذُو الْقَعْدَةِ وَذُو الْحَجَّةِ، فَمَنْ تَمَتَّعَ فِي هَذِهِ الأَشْهُرِ فَعَلَيْهِ دَمٌ أَوْ صَوْمٌ، وَالرَّفَثُ الْجِمَاعُ، وَالْفُسُوقُ الْمَعَاصِي، وَالْجِدَالُ الْمِرَاءُ‏.‏',
    'bookName': ' صحيح البخاري كتاب الحج - ١٥٧٢',
  },
  {
    'hadithPart1':
        'أَخْبَرَنِي عَبْدُ الرَّحْمَنِ بْنُ أَبِي بَكْرَةَ، عَنْ أَبِيهِ ـ رضى الله عنه ـ عَنِ النَّبِيِّ صلى الله عليه وسلم قَالَ',
    'hadithPart2':
        '"‏ شَهْرَانِ لاَ يَنْقُصَانِ شَهْرَا عِيدٍ رَمَضَانُ وَذُو الْحَجَّةِ ‏"‏‏.‏',
    'bookName': ' صحيح البخاري كتاب الصوم - ١٩١٢',
  },
];

const List adhanSoundsList = [
  {
    'country': '',
    'sounds': [
      {
        'partOfAdhan': '',
        'urlAdhanPart': '',
        'fullAdhan': '',
        'urlAdhanFull': '',
      }
    ]
  },
];
