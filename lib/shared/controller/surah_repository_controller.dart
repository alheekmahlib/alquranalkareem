import 'package:get/get.dart';

import '../../quran_page/data/model/sorah.dart';
import '../../quran_page/data/repository/sorah_repository.dart';

class SorahRepositoryController extends GetxController {
  final surahs = RxList<Sorah>([]);

  SorahRepository _sorahRepository = SorahRepository();

  List<Sorah> get sorahs => surahs.value;

  @override
  void onInit() {
    super.onInit();
    loadSorahs();
  }

  Future<void> loadSorahs() async {
    List<Sorah> sorahList = await _sorahRepository.all();
    surahs.value = sorahList;
  }
}
