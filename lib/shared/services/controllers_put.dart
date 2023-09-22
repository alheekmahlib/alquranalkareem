import 'package:alquranalkareem/shared/services/shared_pref_services.dart';

import '../../audio_screen/controller/surah_audio_controller.dart';
import '../../azkar/azkar_controller.dart';
import '../../quran_page/data/repository/bookmarks_controller.dart';
import '../../services_locator.dart';
import '../controller/audio_controller.dart';
import '../controller/aya_controller.dart';
import '../controller/ayat_controller.dart';
import '../controller/bookmarksText_controller.dart';
import '../controller/general_controller.dart';
import '../controller/notes_controller.dart';
import '../controller/quranText_controller.dart';
import '../controller/reminder_controller.dart';
import '../controller/settings_controller.dart';
import '../controller/surahTextController.dart';
import '../controller/surah_repository_controller.dart';
import '../controller/translate_controller.dart';

var pref = sl<SharedPrefServices>();

final GeneralController generalController = sl<GeneralController>();

final SorahRepositoryController sorahRepositoryController =
    sl<SorahRepositoryController>();

final AudioController audioController = sl<AudioController>();

final SurahAudioController surahAudioController = sl<SurahAudioController>();

final NotesController notesController = sl<NotesController>();

final BookmarksController bookmarksController = sl<BookmarksController>();

final AyatController ayatController = sl<AyatController>();

final QuranTextController quranTextController = sl<QuranTextController>();

final BookmarksTextController bookmarksTextController =
    sl<BookmarksTextController>();

final SurahTextController surahTextController = sl<SurahTextController>();

final AyaController ayaController = sl<AyaController>();

final TranslateDataController translateController =
    sl<TranslateDataController>();

final SettingsController settingsController = sl<SettingsController>();

final ReminderController reminderController = sl<ReminderController>();

final AzkarController azkarController = sl<AzkarController>();
