import 'dart:developer';

import 'package:get/get.dart';

import '../../../../models/waqf_model.dart';
import '../services/waqf_service.dart';

// Controller to manage Waqf data and logic.
// كنترولر لإدارة بيانات الوقف والمنطق الخاص بها.
class WaqfController extends GetxController {
  static WaqfController get instance =>
      GetInstance().putOrFind(() => WaqfController());

  RxList<WaqfModel> waqfList = <WaqfModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadWaqfData();

    // Listen for language changes and reload data.
    // الاستماع لتغيير اللغة وإعادة تحميل البيانات.
    ever(Get.locale.obs, (_) => loadWaqfData());
  }

  // Load Waqf data based on the app's language.
  // تحميل بيانات الوقف بناءً على لغة التطبيق.
  Future<void> loadWaqfData() async {
    final langCode = Get.locale?.languageCode ?? 'ar';
    final data = await WaqfService.loadWaqfData();
    log('Language code: $langCode', name: 'WaqfController');

    // Filter translations based on the current language.
    // تصفية الترجمات بناءً على اللغة الحالية.
    waqfList.value = data.map((item) {
      return WaqfModel(
        image: item.image,
        translations: {langCode: item.translations[langCode] ?? ''},
      );
    }).toList();
  }
}
