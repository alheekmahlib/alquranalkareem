part of 'quran_text_cubit.dart';

@immutable
abstract class QuranTextState {}

class QuranTextInitial extends QuranTextState {}
class ChangeBottomShowState extends QuranTextState {}
class CloseBottomShowState extends QuranTextState {}
class SharedPreferencesState extends QuranTextState {}
class ChangeSelectedIndexState extends QuranTextState {}
class QuranTafseerState extends QuranTextState {}
class QuranTextTranslationChanged extends QuranTextState {}
class TextTextUpdated extends QuranTextState {
  final String translateAyah;
  final String translate;

  TextTextUpdated(this.translateAyah, this.translate) {
    print("TextTextUpdated created with: $translateAyah, $translate");
  }
}
