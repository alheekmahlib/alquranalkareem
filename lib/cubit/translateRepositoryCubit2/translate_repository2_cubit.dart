// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import '../../quran_page/data/model/ayat.dart';
// import '../../quran_page/data/repository/translate_repository.dart';
//
// part 'translate_repository2_state.dart';
//
// class TranslateRepositoryCubit extends Cubit<TranslateRepositoryCubit2State> {
//   final TranslateRepository _translateRepository;
//   TranslateRepositoryCubit()
//       : _translateRepository = TranslateRepository(),
//         super(TranslateRepositoryInitial2());
//
//   Future<void> getPageTranslate(int pageNum) async {
//     emit(TranslateRepositoryLoading2());
//     try {
//       final List<Ayat> ayaList = await _translateRepository.getPageTranslate(pageNum);
//       emit(TranslateRepositoryLoaded2(ayaList: ayaList));
//     } catch (e) {
//       emit(TranslateRepositoryError2(message: e.toString()));
//     }
//   }
//
//   Future<void> getAyahTranslate(int AID) async {
//     emit(TranslateRepositoryLoading2());
//     try {
//       final List<Ayat> ayaList = await _translateRepository.getAyahTranslate(AID);
//       emit(TranslateRepositoryLoaded2(ayaList: ayaList));
//     } catch (e) {
//       emit(TranslateRepositoryError2(message: e.toString()));
//     }
//   }
// }
