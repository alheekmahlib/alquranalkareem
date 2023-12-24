import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_be.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_so.dart';
import 'app_localizations_ur.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('be'),
    Locale('en'),
    Locale('es'),
    Locale('so'),
    Locale('ur'),
    Locale('ar')
  ];

  /// appName
  ///
  /// In en, this message translates to:
  /// **'Al Quran Al Kareem - Al Heekmah Library'**
  String get appName;

  /// search_hint
  ///
  /// In en, this message translates to:
  /// **'Search the verses of the Quran'**
  String get search_hint;

  /// menu
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// notes
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// note_title
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get note_title;

  /// No description provided for @add_new_note.
  ///
  /// In en, this message translates to:
  /// **'Add a new note'**
  String get add_new_note;

  /// No description provided for @note_details.
  ///
  /// In en, this message translates to:
  /// **'Note Details'**
  String get note_details;

  /// No description provided for @bookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks Saved'**
  String get bookmarks;

  /// No description provided for @bookmark_title.
  ///
  /// In en, this message translates to:
  /// **'Bookmark Name'**
  String get bookmark_title;

  /// No description provided for @add_new_bookmark.
  ///
  /// In en, this message translates to:
  /// **'Add a new Bookmark'**
  String get add_new_bookmark;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @azkar.
  ///
  /// In en, this message translates to:
  /// **'Athkar'**
  String get azkar;

  /// No description provided for @qibla.
  ///
  /// In en, this message translates to:
  /// **'Qibla Direction'**
  String get qibla;

  /// No description provided for @salat.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get salat;

  /// aya_count
  ///
  /// In en, this message translates to:
  /// **'Number of verses'**
  String get aya_count;

  /// No description provided for @quran_sorah.
  ///
  /// In en, this message translates to:
  /// **'All Sorah'**
  String get quran_sorah;

  /// No description provided for @about_us.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get about_us;

  /// No description provided for @stop_title.
  ///
  /// In en, this message translates to:
  /// **'The noble Qur’an - Al-Heekmah Library'**
  String get stop_title;

  /// No description provided for @about_app.
  ///
  /// In en, this message translates to:
  /// **'The application of the Qur’an Al Kareem is characterized by its approval of the edition of the King Fahd Complex for Printing the Noble Qur’an in Madinah because of its reliability and mastery.\nThe Quran Al Kareem application is sponsored by the \"Al-Heekmah Library\".\nIt is a well-designed application that allows you to read interactively with the text of the electronic Quran, listen to recitations, study the  Quran Al Kareem and memorize it with ease.'**
  String get about_app;

  /// No description provided for @about_app2.
  ///
  /// In en, this message translates to:
  /// **'Among the most important features of the application :'**
  String get about_app2;

  /// No description provided for @about_app3.
  ///
  /// In en, this message translates to:
  /// **'◉ This application enables you to read the Quran as if you were reading in the Mus\'haf, and you can read in vertical and horizontal mode.\\n◉ You can also read in variable mode that enables you to zoom in and out as you like.\\n◉ The application has the feature of textual search in the verses of the Qur’an through real-time search and display of results with pages in addition to the possibility of going to the page as needed.\\n◉ Addition to bookmarks so that the reader can save the page and return to it whenever he wants.\\n◉ Addition to notes.\\n◉ Ability to listen to each verse in voice of different readers.\\n◉ The app allows interpretation for each verse, you can change between interpretations, and you can resize the interpretation line.\\n◉ Index of Surahs.\\n◉ Move between Surahs easily.\\n◉ The app lets you read the meaning of stop signs.\\n◉ The application enables you to read the Muslim fortress in full and divided by remembrance so that it is easy for the reader to navigate between sections, and you can add any mention to favorites.\\n◉ The application allows the reader to read to change color patterns, including the dark pattern, which changes the background color in black and white lines to give the reader complete comfort when reading in a low-light atmosphere. \\n◉ The app enables you to listen to the Surahs or download and listen to them at any time without the need for the internet.'**
  String get about_app3;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get email;

  /// No description provided for @select_player.
  ///
  /// In en, this message translates to:
  /// **'Reader selected'**
  String get select_player;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @page.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get page;

  /// No description provided for @search_word.
  ///
  /// In en, this message translates to:
  /// **'Ayah To search'**
  String get search_word;

  /// No description provided for @search_description.
  ///
  /// In en, this message translates to:
  /// **'You can search for all verses of the Noble Qur’an, just type a word from the verse.'**
  String get search_description;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Change Font Size'**
  String get fontSize;

  /// No description provided for @waqfName.
  ///
  /// In en, this message translates to:
  /// **'Stop Signs'**
  String get waqfName;

  /// No description provided for @onboardTitle1.
  ///
  /// In en, this message translates to:
  /// **'Easy interface'**
  String get onboardTitle1;

  /// No description provided for @onboardDesc1.
  ///
  /// In en, this message translates to:
  /// **'- Ease of searching for a verse.\n- Change the language.\n- Listen to the page.\n- Change the reader.'**
  String get onboardDesc1;

  /// No description provided for @onboardTitle2.
  ///
  /// In en, this message translates to:
  /// **'Show The Tafseer'**
  String get onboardTitle2;

  /// No description provided for @onboardDesc2.
  ///
  /// In en, this message translates to:
  /// **'The interpretation of each verse can be read by pulling the list up.'**
  String get onboardDesc2;

  /// No description provided for @onboardTitle3.
  ///
  /// In en, this message translates to:
  /// **'Click Options'**
  String get onboardTitle3;

  /// No description provided for @onboardDesc3.
  ///
  /// In en, this message translates to:
  /// **'1- When you double click the page is enlarged.\n2- Upon long click you will be presented with the option to save the page.\n3- When you press once, the menus appear.'**
  String get onboardDesc3;

  /// No description provided for @green.
  ///
  /// In en, this message translates to:
  /// **'Green Mode'**
  String get green;

  /// No description provided for @brown.
  ///
  /// In en, this message translates to:
  /// **'Brown Mode'**
  String get brown;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get dark;

  /// No description provided for @azkarfav.
  ///
  /// In en, this message translates to:
  /// **'Athkar Favorite'**
  String get azkarfav;

  /// No description provided for @themeTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Appearance'**
  String get themeTitle;

  /// No description provided for @sorah.
  ///
  /// In en, this message translates to:
  /// **'Surah'**
  String get sorah;

  /// No description provided for @part.
  ///
  /// In en, this message translates to:
  /// **'Part'**
  String get part;

  /// No description provided for @langChange.
  ///
  /// In en, this message translates to:
  /// **'Change the language'**
  String get langChange;

  /// No description provided for @tafChange.
  ///
  /// In en, this message translates to:
  /// **'Choose an tafsir'**
  String get tafChange;

  /// No description provided for @tafIbnkatheerN.
  ///
  /// In en, this message translates to:
  /// **'Tafsir Ibn Kathir'**
  String get tafIbnkatheerN;

  /// No description provided for @tafBaghawyN.
  ///
  /// In en, this message translates to:
  /// **'Tafsir al-Baghawi'**
  String get tafBaghawyN;

  /// No description provided for @tafQurtubiN.
  ///
  /// In en, this message translates to:
  /// **'Tafsir al-Qurtubi'**
  String get tafQurtubiN;

  /// No description provided for @tafSaadiN.
  ///
  /// In en, this message translates to:
  /// **'Tafsir As-Sadi'**
  String get tafSaadiN;

  /// No description provided for @tafTabariN.
  ///
  /// In en, this message translates to:
  /// **'Tafsir al-Tabari'**
  String get tafTabariN;

  /// No description provided for @tafIbnkatheerD.
  ///
  /// In en, this message translates to:
  /// **'Tafsir al-Quran al-Azim'**
  String get tafIbnkatheerD;

  /// No description provided for @tafBaghawyD.
  ///
  /// In en, this message translates to:
  /// **'Maalim al-Tanzil'**
  String get tafBaghawyD;

  /// No description provided for @tafQurtubiD.
  ///
  /// In en, this message translates to:
  /// **'Al-Jami li Ahkam al-Quran'**
  String get tafQurtubiD;

  /// No description provided for @tafSaadiD.
  ///
  /// In en, this message translates to:
  /// **'Taiseer Kalam Almannan'**
  String get tafSaadiD;

  /// No description provided for @tafTabariD.
  ///
  /// In en, this message translates to:
  /// **'Jami al-Bayan an Tawil [ay] al Quran'**
  String get tafTabariD;

  /// No description provided for @appLang.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLang;

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get setting;

  /// No description provided for @reader1.
  ///
  /// In en, this message translates to:
  /// **'Abdul Basit'**
  String get reader1;

  /// No description provided for @reader2.
  ///
  /// In en, this message translates to:
  /// **'Mohamed Siddiq El-Minshawi'**
  String get reader2;

  /// No description provided for @reader3.
  ///
  /// In en, this message translates to:
  /// **'Mahmoud Khalil Al-Hussary'**
  String get reader3;

  /// No description provided for @reader4.
  ///
  /// In en, this message translates to:
  /// **'Ahmed Ibn Ali Al-Ajamy'**
  String get reader4;

  /// No description provided for @reader5.
  ///
  /// In en, this message translates to:
  /// **'Maher Al Muaiqly'**
  String get reader5;

  /// No description provided for @reader6.
  ///
  /// In en, this message translates to:
  /// **'Saad Al Ghamdi'**
  String get reader6;

  /// No description provided for @alheekmahlib.
  ///
  /// In en, this message translates to:
  /// **'Alheekmah Library'**
  String get alheekmahlib;

  /// No description provided for @backTo.
  ///
  /// In en, this message translates to:
  /// **'Back To'**
  String get backTo;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @quranPages.
  ///
  /// In en, this message translates to:
  /// **'Al Quran (Pages)'**
  String get quranPages;

  /// No description provided for @quranText.
  ///
  /// In en, this message translates to:
  /// **'Al Quran (Ayah)'**
  String get quranText;

  /// No description provided for @tafseer.
  ///
  /// In en, this message translates to:
  /// **'Al Tafseer'**
  String get tafseer;

  /// No description provided for @allJuz.
  ///
  /// In en, this message translates to:
  /// **'Parts of the Qur\'an'**
  String get allJuz;

  /// No description provided for @copyAzkarText.
  ///
  /// In en, this message translates to:
  /// **'The Azkar has been copied!'**
  String get copyAzkarText;

  /// No description provided for @addBookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark added!'**
  String get addBookmark;

  /// No description provided for @deletedBookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark deleted!'**
  String get deletedBookmark;

  /// No description provided for @deletedReminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder deleted!'**
  String get deletedReminder;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in the fields!'**
  String get fillAllFields;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share The App'**
  String get share;

  /// No description provided for @facebook.
  ///
  /// In en, this message translates to:
  /// **'Follow us on Facebook'**
  String get facebook;

  /// No description provided for @addZekrBookmark.
  ///
  /// In en, this message translates to:
  /// **'The Zekr has been added to favourites'**
  String get addZekrBookmark;

  /// No description provided for @deletedZekrBookmark.
  ///
  /// In en, this message translates to:
  /// **'The Zekr has been removed to favourites!'**
  String get deletedZekrBookmark;

  /// No description provided for @pageNo.
  ///
  /// In en, this message translates to:
  /// **'Page No'**
  String get pageNo;

  /// No description provided for @lastRead.
  ///
  /// In en, this message translates to:
  /// **'Last Read'**
  String get lastRead;

  /// No description provided for @copyAyah.
  ///
  /// In en, this message translates to:
  /// **'The verse has been copied'**
  String get copyAyah;

  /// No description provided for @copyTafseer.
  ///
  /// In en, this message translates to:
  /// **'The Tafseer has been copied'**
  String get copyTafseer;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'The device is not connected to the Internet!'**
  String get noInternet;

  /// No description provided for @mobileDataAyat.
  ///
  /// In en, this message translates to:
  /// **'Note: You are using cellular data to download verses!'**
  String get mobileDataAyat;

  /// No description provided for @mobileDataSurahs.
  ///
  /// In en, this message translates to:
  /// **'Note: You are using cellular data to download the surahs!'**
  String get mobileDataSurahs;

  /// No description provided for @mobileDataListen.
  ///
  /// In en, this message translates to:
  /// **'Note: You are using cellular data to listen to surahs!'**
  String get mobileDataListen;

  /// No description provided for @choiceAyah.
  ///
  /// In en, this message translates to:
  /// **'Please choose the verse first!'**
  String get choiceAyah;

  /// No description provided for @stopSigns.
  ///
  /// In en, this message translates to:
  /// **'Stop Signs'**
  String get stopSigns;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read More'**
  String get readMore;

  /// No description provided for @readLess.
  ///
  /// In en, this message translates to:
  /// **'Read Less'**
  String get readLess;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @searchToSurah.
  ///
  /// In en, this message translates to:
  /// **'Search To Surah'**
  String get searchToSurah;

  /// No description provided for @addReminder.
  ///
  /// In en, this message translates to:
  /// **'Add New Reminder'**
  String get addReminder;

  /// No description provided for @lastListen.
  ///
  /// In en, this message translates to:
  /// **'Last Listen'**
  String get lastListen;

  /// No description provided for @hizb.
  ///
  /// In en, this message translates to:
  /// **'Hizb'**
  String get hizb;

  /// No description provided for @shareText.
  ///
  /// In en, this message translates to:
  /// **'As text'**
  String get shareText;

  /// No description provided for @shareImage.
  ///
  /// In en, this message translates to:
  /// **'As an image'**
  String get shareImage;

  /// No description provided for @shareImageWTrans.
  ///
  /// In en, this message translates to:
  /// **'As an image with additional content'**
  String get shareImageWTrans;

  /// No description provided for @shareTrans.
  ///
  /// In en, this message translates to:
  /// **'Note: Sharing the interpretation in an image only supports the interpretation of Al-Saadi, because the interpretation is not lengthy.'**
  String get shareTrans;

  /// No description provided for @translation.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get translation;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @surahsList.
  ///
  /// In en, this message translates to:
  /// **'Surahs List'**
  String get surahsList;

  /// No description provided for @bookmarksList.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks List'**
  String get bookmarksList;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @shareTafseer.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareTafseer;

  /// No description provided for @addToBookmark.
  ///
  /// In en, this message translates to:
  /// **'Add To Bookmark'**
  String get addToBookmark;

  /// No description provided for @repeatSurah.
  ///
  /// In en, this message translates to:
  /// **'Repeat Surah'**
  String get repeatSurah;

  /// No description provided for @pauseSurah.
  ///
  /// In en, this message translates to:
  /// **'Pause Surah'**
  String get pauseSurah;

  /// No description provided for @replaySurah.
  ///
  /// In en, this message translates to:
  /// **'Replay Surah'**
  String get replaySurah;

  /// No description provided for @skipToPrevious.
  ///
  /// In en, this message translates to:
  /// **'Skip To Previous'**
  String get skipToPrevious;

  /// No description provided for @deletedPlayList.
  ///
  /// In en, this message translates to:
  /// **'Deleted Play List'**
  String get deletedPlayList;

  /// No description provided for @createPlayList.
  ///
  /// In en, this message translates to:
  /// **'createPlayList'**
  String get createPlayList;

  /// No description provided for @playList.
  ///
  /// In en, this message translates to:
  /// **'playList'**
  String get playList;

  /// No description provided for @playListName.
  ///
  /// In en, this message translates to:
  /// **'playListName'**
  String get playListName;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'from'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get to;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'be',
        'en',
        'es',
        'so',
        'ur',
        'ar'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'be':
      return AppLocalizationsBe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'so':
      return AppLocalizationsSo();
    case 'ur':
      return AppLocalizationsUr();
    case 'ar':
      return AppLocalizationsAr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
