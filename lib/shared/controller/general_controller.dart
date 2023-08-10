import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneralController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  late int cuMPage;
  RxString soMName = ''.obs;

  /// Shared Preferences
  // Save & Load Last Page For Quran Page
  saveMLastPlace(int currentPage, String lastSorah) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setInt("mstart_page", currentPage);
    await prefs.setString("mLast_sorah", lastSorah);
  }

  loadMCurrentPage() async {
    SharedPreferences prefs = await _prefs;
    cuMPage = (prefs.getInt('mstart_page') == null
        ? 1
        : prefs.getInt('mstart_page'))!;
    soMName.value = prefs.getString('mLast_sorah') ?? '1';
    print('cuMPage ${cuMPage}');
    print('last_sorah ${prefs.getString('mLast_sorah')}');
  }
}
