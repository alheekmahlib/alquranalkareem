import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../quran_page/data/model/ayat.dart';
import '../../quran_page/data/repository/translate2_repository.dart';

part 'translate_repository2_state.dart';

class TranslateRepositoryCubit2 extends Cubit<TranslateRepositoryCubit2State> {
  final TranslateRepository2 _translateRepository;
  TranslateRepositoryCubit2()
      : _translateRepository = TranslateRepository2(),
        super(TranslateRepositoryInitial2());

  Future<void> getPageTranslate(int pageNum) async {
    emit(TranslateRepositoryLoading2());
    try {
      final List<Ayat> ayaList = await _translateRepository.getPageTranslate(pageNum);
      emit(TranslateRepositoryLoaded2(ayaList: ayaList));
    } catch (e) {
      emit(TranslateRepositoryError2(message: e.toString()));
    }
  }

  Future<void> getAyahTranslate(int AID) async {
    emit(TranslateRepositoryLoading2());
    try {
      final List<Ayat> ayaList = await _translateRepository.getAyahTranslate(AID);
      emit(TranslateRepositoryLoaded2(ayaList: ayaList));
    } catch (e) {
      emit(TranslateRepositoryError2(message: e.toString()));
    }
  }
}
