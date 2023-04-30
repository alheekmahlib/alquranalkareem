import 'package:bloc/bloc.dart';
import '../../quran_page/data/model/quarter.dart';
import '../../quran_page/data/repository/quarter_repository.dart';
part 'quarter_state.dart';


class QuarterCubit extends Cubit<QuarterState> {
  final QuarterRepository _repository;

  QuarterCubit(this._repository) : super(QuarterLoading());

  Future<void> getAllQuarters() async {
    try {
      emit(QuarterLoading());
      List<Quarter> quarters = await _repository.all();
      emit(QuarterLoaded(quarters));
    } catch (e) {
      emit(QuarterError(e.toString()));
    }
  }
}
