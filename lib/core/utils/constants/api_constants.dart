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

  // قسم التطبيقات — مصدر REST حيّ (يُرجع البيانات مترجمةً لكل لغة).
  // Dio يتجاهل baseUrl عند تمرير URL مطلق في endpoint، لذا يعمل كما هو.
  static const String ourAppsUrl = 'https://dash.vexaltech.dev/api/apps';
  // مجال استضافة وسائط التطبيقات (الشعار/البنر) — تُضاف للمسارات النسبية القادمة من الـ API.
  static const String appsMediaBaseUrl = 'https://dash.vexaltech.dev';

  // GitLab fallback URLs
  static const String notificationsGitLabUrl =
      'https://gitlab.com/haozo89/data/-/raw/main/noti.json?ref_type=heads';
  static const String appUrl = 'https://alhikmah.vexaltech.dev/download/quran';
  static const String quranShareUrl =
      'https://alheekmahlib.github.io/alheekmahlib/#/quran?page=';

  static const String booksGithubUrl =
      'https://github.com/alheekmahlib/Islamic_database/releases/download';
  static const String booksGitLabUrl =
      'https://gitlab.com/api/v4/projects/haozo89%2Fislamic_database/packages/generic/';

  static const String tafsirUrl =
      'https://github.com/alheekmahlib/Islamic_database/releases/download/tafsir_books_v2';
  static const String hadithsUrl =
      'https://github.com/alheekmahlib/Islamic_database/releases/download/hadith_books_v2';
  static const String aqeedahUrl =
      'https://github.com/alheekmahlib/Islamic_database/releases/download/aqeedah_books_v2';
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

  // Feedback API — نطاق مستقل عن baseUrl (يُمرَّر URL كامل في ApiClient.request)
  static const String feedbackApiUrl = 'https://vexaltech.dev/api/feedback';
  static const String feedbackEndpoint =
      '/feedback'; // POST + GET /feedback/{token}
  static const String feedbackReplySuffix =
      '/reply'; // POST /feedback/{token}/reply
  static const String feedbackUploadEndpoint = '/upload'; // POST رفع وسائط

  // QR Device Sync — Cloudflare Worker + D1 (انظر sync_service/ بالمستودع)
  static const String syncApiUrl = 'https://alquran-sync.haozo89.workers.dev';
}
