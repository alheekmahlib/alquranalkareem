

import '../quran_page/data/model/ayat.dart';

abstract class QuranState {}

class QuranPageState extends QuranState{}
class SoundPageState extends QuranState{}
class SharedPreferencesState extends QuranState{}
class SharedPreferencesStateBookmark extends QuranState{}
class CreateDatabaseState extends QuranState{}
class GetDatabaseState extends QuranState{}
class AddDatabaseState extends QuranState{}
class ChangeBottomShowState extends QuranState{}
class CloseBottomShowState extends QuranState{}
class greetingState extends QuranState{}
class LoadRemindersState extends QuranState{}
class ShowTimePickerState extends QuranState{}
class AddReminderState extends QuranState{}
class DeleteReminderState extends QuranState{}
class OnTimeChangedState extends QuranState{}
class loadMCurrentPageState extends QuranState{}
class AyaInitial extends QuranState {}
class AyaLoading extends QuranState {}
class AyaLoaded extends QuranState {
  final List<Ayat> ayahList;

  AyaLoaded(this.ayahList);
}
class AyaError extends QuranState {
  final String message;

  AyaError(this.message);
}
class TranslationUpdatedState extends QuranState {
  final String translateAyah;
  final String translate;

  TranslationUpdatedState({required this.translateAyah, required this.translate});
}
class TextUpdated extends QuranState {
  final String translateAyah;
  final String translate;

  TextUpdated(this.translateAyah, this.translate);
}
class FontSizeUpdated extends QuranState {
  final double fontSize;

  FontSizeUpdated(this.fontSize);
}
