part of '../quran.dart';

class KhatmahController extends GetxController {
  static KhatmahController get instance =>
      GetInstance().putOrFind(() => KhatmahController());

  /// -------- [Variables] ----------
  final db = KhatmahDatabase();
  final RxList<Khatmah> khatmas = <Khatmah>[].obs;
  final int totalPages = 604;
  RxBool isTahzibSahabah = false.obs;
  RxInt screenPickerColor = 0xff404C6E.obs;
  DateTime now = DateTime.now();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController daysController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadKhatmas();
  }

  void loadKhatmas() async {
    final loadedKhatmas = await db.getAllKhatmas();
    final List<Khatmah> khatmahList = [];
    for (var khatmah in loadedKhatmas) {
      final days = await db.getDaysForKhatmah(khatmah.id);
      final dayStatuses = days
          .map((day) => DayStatus(
              day: day.day,
              isCompleted: day.isCompleted,
              startPage: day.startPage ?? 1,
              endPage: day.endPage ?? 604))
          .toList();
      khatmahList.add(Khatmah(
          id: khatmah.id,
          name: khatmah.name,
          currentPage: khatmah.currentPage,
          startAyahNumber: khatmah.startAyahNumber,
          endAyahNumber: khatmah.endAyahNumber,
          isCompleted: khatmah.isCompleted,
          daysCount: khatmah.daysCount,
          isTahzibSahabah: khatmah.isTahzibSahabah,
          dayStatuses: dayStatuses,
          color: khatmah.color ?? 0xff404C6E));
    }
    khatmas.assignAll(khatmahList);
  }

  void addKhatmah(
      {String? name,
      int? daysCount = 30,
      bool isTahzibSahabah = false,
      int? color}) async {
    final khatmaId = await db.insertKhatma(KhatmahsCompanion(
        name: drift.Value(name),
        currentPage: const drift.Value(1),
        isCompleted: const drift.Value(false),
        daysCount: drift.Value(daysCount!),
        isTahzibSahabah: drift.Value(isTahzibSahabah),
        color: drift.Value(color!)));

    if (isTahzibSahabah) {
      // استخدام تقسيم تحزيب السلف
      const pages = [
        1,
        106,
        107,
        207,
        208,
        281,
        282,
        366,
        367,
        445,
        446,
        517,
        518,
        604
      ];

      for (int i = 0; i < 7; i++) {
        await db.insertKhatmahDay(KhatmahDaysCompanion(
          khatmahId: drift.Value(khatmaId),
          day: drift.Value(i + 1),
          isCompleted: const drift.Value(false),
          startPage: drift.Value(pages[i * 2]),
          endPage: drift.Value(pages[i * 2 + 1]),
        ));
      }
    } else {
      // استخدام التقسيم العادي
      int pagesPerDay = totalPages ~/ daysCount;
      int remainder = totalPages % daysCount;
      int currentPage = 1;

      for (int i = 0; i < daysCount; i++) {
        int startPage = currentPage;
        int endPage = startPage + pagesPerDay - 1;

        if (remainder > 0) {
          endPage++;
          remainder--;
        }

        if (endPage > totalPages) {
          endPage = totalPages;
        }

        await db.insertKhatmahDay(KhatmahDaysCompanion(
          khatmahId: drift.Value(khatmaId),
          day: drift.Value(i + 1),
          isCompleted: const drift.Value(false),
          startPage: drift.Value(startPage),
          endPage: drift.Value(endPage),
        ));

        currentPage = endPage + 1;
      }
    }

    loadKhatmas();
  }

  void updateKhatmahDayStatus(int khatmaId, int day, bool isCompleted) async {
    try {
      final existingDay = await (db.select(db.khatmahDays)
            ..where(
                (tbl) => tbl.khatmahId.equals(khatmaId) & tbl.day.equals(day)))
          .getSingleOrNull();

      if (existingDay != null) {
        // تحديث الحالة في قاعدة البيانات
        await db.updateKhatmahDay(KhatmahDaysCompanion(
          id: drift.Value(existingDay.id),
          khatmahId: drift.Value(khatmaId),
          day: drift.Value(day),
          isCompleted: drift.Value(isCompleted),
        ));
        // تحميل البيانات المحدثة
        loadKhatmas();
      } else {
        print("Day $day for Khatmah with id $khatmaId not found.");
      }
    } catch (e) {
      print("Error in updateKhatmahDayStatus: $e");
    }
  }

  int getTahzibSahabahPageForDay(int day) {
    const pages = [
      1,
      106,
      106,
      207,
      208,
      281,
      282,
      366,
      367,
      445,
      446,
      517,
      518,
      604
    ];

    if (day < 1 || day > 7) {
      return 604; // عودة إلى الصفحة الأخيرة إذا كان اليوم خارج النطاق
    }
    return pages[day - 1];
  }

  /// -------- [OnTap] ----------
  void isTahzibSahabahOnTap() {
    isTahzibSahabah.value = !isTahzibSahabah.value;
    if (isTahzibSahabah.value) {
      daysController.text = '7';
    } else {
      daysController.clear();
    }
  }

  void addKhatmahOnTap() {
    String name = nameController.text.isEmpty
        ? '${'khatmah'.tr.replaceAll('ال', '')}: ${intl.DateFormat('yMd', Get.locale!.languageCode).format(now)}'
        : nameController.text;
    int days = int.tryParse(daysController.text) ?? 30;
    addKhatmah(
        name: name,
        daysCount: days,
        isTahzibSahabah: isTahzibSahabah.value,
        color: screenPickerColor.value);
    nameController.clear();
    daysController.clear();
    isTahzibSahabah.value = false;
  }

  void deleteKhatmahOnTap(int id) async {
    try {
      await db.deleteKhatmahDaysByKhatmahId(id);
      await db.deleteKhatmaById(id);
      khatmas.removeWhere((k) => k.id == id);
    } catch (e) {
      print("Error deleting Khatmah: $e");
    }
  }
}

class Khatmah {
  final int id;
  final String? name;
  final int? currentPage;
  final int? startAyahNumber;
  final int? endAyahNumber;
  final bool isCompleted;
  final int daysCount;
  final bool isTahzibSahabah;
  final List<DayStatus> dayStatuses;
  final int color;
  final int? startPage;
  final int? endPage;

  Khatmah({
    required this.id,
    this.name,
    this.currentPage,
    this.startAyahNumber,
    this.endAyahNumber,
    required this.isCompleted,
    required this.daysCount,
    required this.isTahzibSahabah,
    required this.dayStatuses,
    required this.color,
    this.startPage,
    this.endPage,
  });
}

class DayStatus {
  final int day;
  bool isCompleted;
  final int startPage;
  final int endPage;

  DayStatus({
    required this.day,
    this.isCompleted = false,
    required this.startPage,
    required this.endPage,
  });
}
