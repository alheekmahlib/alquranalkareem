import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/services_locator.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import '../../core/widgets/khatmah/khatmah_model.dart';

class KhatmahController extends GetxController {
  RxList<KhatmahModel> khatmasList = <KhatmahModel>[].obs;

  @override
  void onInit() async {
    khatmasList.value = await loadKhatmahs();
    super.onInit();
  }

  Future<void> saveKhatmahs(List<KhatmahModel> khatmas) async {
    final prefs = sl<SharedPreferences>();
    final String encodedData =
        jsonEncode(khatmas.map((k) => k.toMap()).toList());
    await prefs.setString(KHATMAH, encodedData);
  }

  static Future<List<KhatmahModel>> loadKhatmahs() async {
    final prefs = sl<SharedPreferences>();
    final String? khatmasData = prefs.getString(KHATMAH);
    if (khatmasData != null) {
      List<dynamic> decodedData = jsonDecode(khatmasData);
      return decodedData.map((item) => KhatmahModel.fromMap(item)).toList();
    }
    return [];
  }

  void saveLastKhatmah({int? surahNumber, int? pageNumber}) {
    // khatmasList.add(KhatmahModel(
    //   name: '',
    //   surahNumber: surahNumber ?? 1,
    //   pageNumber: pageNumber ?? 1,
    // ));
    saveKhatmahs(khatmasList);
  }
}
