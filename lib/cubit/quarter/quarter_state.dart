part of 'quarter_cubit.dart';


abstract class QuarterState {}

class QuarterLoading extends QuarterState {}

class QuarterLoaded extends QuarterState {
  final List<Quarter> quarters;

  QuarterLoaded(this.quarters);
}

class QuarterError extends QuarterState {
  final String message;

  QuarterError(this.message);
}

