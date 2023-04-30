// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import '../../quran_page/data/model/aya.dart';
// import '../../quran_page/data/model/ayat.dart';
// import '../../quran_page/data/repository/aya_repository.dart';
//
// class AyaRepositoryCubit extends Cubit<List<Ayat>?> {
//   final AyaRepository _repository;
//
//   AyaRepositoryCubit({AyaRepository? repository})
//       : _repository = repository ?? AyaRepository(),
//         super(null);
//
//   Future<void> search(String text) async {
//     List<Ayat>? result = await _repository.search(text);
//     emit(result);
//   }
//
//   Future<void> getPage(int pageNum) async {
//     List<Ayat> result = await _repository.getPage(pageNum);
//     emit(result);
//   }
//
//   Future<void> allTafseer(int ayahNum) async {
//     List<Ayat> result = await _repository.allTafseer(ayahNum);
//     emit(result);
//   }
//
//   Future<void> all() async {
//     List<Ayat> result = await _repository.all();
//     emit(result);
//   }
// }