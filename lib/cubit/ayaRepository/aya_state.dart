part of 'aya_cubit.dart';

@immutable
abstract class AyaState {

}

class AyaLoading extends AyaState {}

class AyaLoaded extends AyaState {
  final List<Aya> ayahList;

  AyaLoaded(this.ayahList);
}

class AyaError extends AyaState {
  final String message;

  AyaError(this.message);
}