import 'package:get/get.dart';
import 'package:quran_library/quran_library.dart';

/// Controller for managing the active section (Waqf / Tajweed)
/// and loading Tajweed rules data.
class WaqfTajweedScreenController extends GetxController {
  static WaqfTajweedScreenController get instance =>
      GetInstance().putOrFind(() => WaqfTajweedScreenController());

  /// 0 = Waqf section, 1 = Tajweed section.
  final RxInt selectedTab = 0.obs;

  /// Tajweed rules list for the current language.
  final RxList<TajweedRuleModel> tajweedRules = <TajweedRuleModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadTajweedRules();
    ever(Get.locale.obs, (_) => _loadTajweedRules());
  }

  void switchTab(int index) {
    if (index == selectedTab.value) return;
    selectedTab.value = index;
  }

  void _loadTajweedRules() {
    final langCode = Get.locale?.languageCode ?? 'ar';
    tajweedRules.value = QuranCtrl.instance.getTajweedRulesListForLanguage(
      languageCode: langCode,
    );
  }
}
