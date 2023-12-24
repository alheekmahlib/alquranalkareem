import 'package:get/get.dart';

import '../screens/quran_page/data/model/surah.dart';
import '../screens/quran_page/data/repository/sorah_repository.dart';

class SurahRepositoryController extends GetxController {
  final surahs = RxList<Surah>([]);

  final SurahRepository _sorahRepository = SurahRepository();

  List<Surah> get sorahs => surahs;

  @override
  void onInit() {
    super.onInit();
    loadSorahs();
  }

  Future<void> loadSorahs() async {
    List<Surah> sorahList = await _sorahRepository.all();
    surahs.value = sorahList;
  }
}
