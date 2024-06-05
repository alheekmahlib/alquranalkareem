import 'package:drift/drift.dart' as drift;
import 'package:get/get.dart';

import '../../core/widgets/khatmah/data/data_source/khatmah_database.dart';

class KhatmahController extends GetxController {
  static KhatmahController get instance => Get.isRegistered<KhatmahController>()
      ? Get.find<KhatmahController>()
      : Get.put<KhatmahController>(KhatmahController());
  final db = KhatmahDatabase();
  final RxList<Khatmah> khatmas = <Khatmah>[].obs;
  final int totalPages = 604;
  final int daysCount = 40;

  @override
  void onInit() {
    super.onInit();
    loadKhatmas();
  }

  void loadKhatmas() async {
    final loadedKhatmas = await db.getAllKhatmas();
    khatmas.assignAll(loadedKhatmas);
  }

  void addKhatmah({
    String? name,
    String? surahName,
    int? startAyahNumber,
    int? endAyahNumber,
  }) {
    final newKhatma = KhatmahsCompanion(
      name: drift.Value(name),
      surahName: drift.Value(surahName),
      currentPage: drift.Value(1),
      startAyahNumber: drift.Value(startAyahNumber),
      endAyahNumber: drift.Value(endAyahNumber),
      isCompleted: drift.Value(false),
    );
    db.insertKhatma(newKhatma).then((_) => loadKhatmas());
  }

  void markDayAsRead(int khatmaId, int day) {
    final pagesPerDay = (totalPages / daysCount).ceil();
    final newPage = day * pagesPerDay + 1;
    final isCompleted = newPage >= totalPages;
    db
        .updateKhatma(KhatmahsCompanion(
          id: drift.Value(khatmaId),
          currentPage: drift.Value(newPage),
          isCompleted: drift.Value(isCompleted),
        ))
        .then((_) => loadKhatmas());
  }

  void deleteKhatmah(int id) async {
    try {
      await db.deleteKhatmaById(id);
      khatmas.remove(id);
      loadKhatmas(); // Refresh the list after deletion
    } catch (e) {
      print("Error deleting Khatmah: $e");
      // Handle the error or inform the user
    }
  }
}
