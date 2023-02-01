part of 'quran_text_cubit.dart';

@immutable
abstract class QuranTextState {}

class QuranTextInitial extends QuranTextState {}
class ChangeBottomShowState extends QuranTextState {}
class CloseBottomShowState extends QuranTextState {}
