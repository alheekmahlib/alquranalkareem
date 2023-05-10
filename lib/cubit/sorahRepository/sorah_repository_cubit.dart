import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../quran_page/data/model/sorah.dart';
import '../../quran_page/data/repository/sorah_repository.dart';

part 'sorah_repository_state.dart';

class SorahRepositoryCubit extends Cubit<List<Sorah>?> {
  SorahRepositoryCubit() : super(null);

  SorahRepository _sorahRepository = SorahRepository();

  Future<void> loadSorahs() async {
    List<Sorah> sorahs = await _sorahRepository.all();
    emit(sorahs);
  }
}
