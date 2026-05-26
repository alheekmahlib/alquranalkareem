class ApiConstants {
  static const ayahs1stSource = "https://cdn.islamic.network/quran/audio/";
  static const ayahs2ndSource = "https://everyayah.com/data/";
  static const surahUrl1 = "https://download.quranicaudio.com/quran/";
  static const surahUrl2 = "https://server16.mp3quran.net/";
  static const surahUrl3 = "https://server12.mp3quran.net/";
  static const surahUrl4 = "https://server6.mp3quran.net/";
  static const surahUrl5 = "https://server11.mp3quran.net/";
  static const downloadAppUrl =
      "https://alheekmahlib.github.io/alheekmahlib/#/download/quran";

  // ملاحظة: للوصول المباشر للملفات الخام في GitHub نستخدم raw.githubusercontent.com لتفادي صفحات HTML البطيئة.
  static const baseUrl = "https://raw.githubusercontent.com/";
  static const String notificationsUrl =
      'alheekmahlib/data/main/notifications.json';
  static const String ourAppsUrl =
      'alheekmahlib/thegarlanded/master/ourApps.json';

  // GitLab fallback URLs
  static const String notificationsGitLabUrl =
      'https://gitlab.com/haozo89/data/-/raw/main/noti.json?ref_type=heads';
  static const String ourAppsGitLabUrl =
      'https://gitlab.com/haozo89/data/-/raw/main/ourApps.json?ref_type=heads';
  static const String appUrl =
      'https://alheekmahlib.github.io/alheekmahlib/#/download/quran';
  static const String downloadAppsUrl =
      'https://alheekmahlib.github.io/alheekmahlib/#/download/';
  static const String quranShareUrl =
      'https://alheekmahlib.github.io/alheekmahlib/#/quran?page=';
  static const String tafsirUrl =
      'https://github.com/alheekmahlib/Islamic_database/releases/download/tafsir_books';
  static const String hadithsUrl =
      'https://github.com/alheekmahlib/Islamic_database/releases/download/hadith_books';
  static const String aqeedahUrl =
      'https://github.com/alheekmahlib/Islamic_database/releases/download/aqeedah_books';
  static const String asulElfqhUrl =
      'https://github.com/alheekmahlib/Islamic_database/releases/download/asul_el-feqh_books';
  static const String eulumFiqhUrl =
      'https://github.com/alheekmahlib/Islamic_database/releases/download/eulum_alfiqh_books';

  // GitLab fallback URLs - used when GitHub is blocked
  static const String _gitlabProjectId = 'haozo89%2Fislamic_database';
  static const String tafsirGitLabUrl =
      'https://gitlab.com/api/v4/projects/$_gitlabProjectId/packages/generic/tafsir_books/1.0.0';
  static const String hadithsGitLabUrl =
      'https://gitlab.com/api/v4/projects/$_gitlabProjectId/packages/generic/hadiths_books/1.0.0';
  static const String aqeedahGitLabUrl =
      'https://gitlab.com/api/v4/projects/$_gitlabProjectId/packages/generic/aqeedah_books/1.0.0';
  static const String asulElfqhGitLabUrl =
      'https://gitlab.com/api/v4/projects/$_gitlabProjectId/packages/generic/asul_el-feqh_books/1.0.0';
  static const String eulumFiqhGitLabUrl =
      'https://gitlab.com/api/v4/projects/$_gitlabProjectId/packages/generic/eulum_alfiqh_books/1.0.0';
}
