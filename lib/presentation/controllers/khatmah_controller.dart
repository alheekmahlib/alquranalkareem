import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/quran_page/widgets/khatmah/data/data_source/khatmah_database.dart';

class KhatmahController extends GetxController {
  static KhatmahController get instance => Get.isRegistered<KhatmahController>()
      ? Get.find<KhatmahController>()
      : Get.put(KhatmahController());

  final db = KhatmahDatabase();
  final RxList<Khatmah> khatmas = <Khatmah>[].obs;
  final int totalPages = 604;
  RxBool isTahzibSalaf = false.obs;
  RxInt screenPickerColor = 0xff404C6E.obs;

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
          .map((day) => DayStatus(day: day.day, isCompleted: day.isCompleted))
          .toList();
      khatmahList.add(Khatmah(
          id: khatmah.id,
          name: khatmah.name,
          currentPage: khatmah.currentPage,
          startAyahNumber: khatmah.startAyahNumber,
          endAyahNumber: khatmah.endAyahNumber,
          isCompleted: khatmah.isCompleted,
          daysCount: khatmah.daysCount,
          isTahzibSalaf: khatmah.isTahzibSalaf,
          dayStatuses: dayStatuses,
          color: khatmah.color ?? 0xff404C6E));
    }
    khatmas.assignAll(khatmahList);
  }

  void addKhatmah(
      {String? name,
      int? daysCount = 30,
      bool isTahzibSalaf = false,
      int? color}) async {
    final khatmaId = await db.insertKhatma(KhatmahsCompanion(
        name: drift.Value(name),
        currentPage: drift.Value(1),
        isCompleted: drift.Value(false),
        daysCount: drift.Value(daysCount!),
        isTahzibSalaf: drift.Value(isTahzibSalaf),
        color: drift.Value(color!)));

    for (int i = 1; i <= daysCount; i++) {
      await db.insertKhatmahDay(KhatmahDaysCompanion(
        khatmahId: drift.Value(khatmaId),
        day: drift.Value(i),
        isCompleted: drift.Value(false),
      ));
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
        await db.updateKhatmahDay(KhatmahDaysCompanion(
          id: drift.Value(existingDay.id),
          khatmahId: drift.Value(khatmaId),
          day: drift.Value(day),
          isCompleted: drift.Value(isCompleted),
        ));
        loadKhatmas();
      } else {
        print("Day $day for Khatmah with id $khatmaId not found.");
      }
    } catch (e) {
      print("Error in updateKhatmahDayStatus: $e");
    }
  }

  void deleteKhatmah(int id) async {
    try {
      await db.deleteKhatmahDaysByKhatmahId(id);
      await db.deleteKhatmaById(id);
      khatmas.removeWhere((k) => k.id == id);
    } catch (e) {
      print("Error deleting Khatmah: $e");
    }
  }

  int getTahzibSalafPageForDay(int day) {
    const pages = [
      1, // بداية اليوم الأول
      106, // نهاية اليوم الأول
      107, // بداية اليوم الثاني
      207, // نهاية اليوم الثاني
      208, // بداية اليوم الثالث
      281, // نهاية اليوم الثالث
      282, // بداية اليوم الرابع
      366, // نهاية اليوم الرابع
      367, // بداية اليوم الخامس
      440, // نهاية اليوم الخامس
      441, // بداية اليوم السادس
      517, // نهاية اليوم السادس
      518, // بداية اليوم السابع
      604 // نهاية اليوم السابع
    ];

    if (day < 1 || day > 7) {
      return 604; // عودة إلى الصفحة الأخيرة إذا كان اليوم خارج النطاق
    }
    return pages[day - 1];
  }

  void isTahzibSalafOnTap() {
    isTahzibSalaf.value = !isTahzibSalaf.value;
    if (isTahzibSalaf.value) {
      daysController.text = '7';
    } else {
      daysController.clear();
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
  final bool isTahzibSalaf;
  final List<DayStatus> dayStatuses;
  final int color;

  Khatmah({
    required this.id,
    this.name,
    this.currentPage,
    this.startAyahNumber,
    this.endAyahNumber,
    required this.isCompleted,
    required this.daysCount,
    required this.isTahzibSalaf,
    required this.dayStatuses,
    required this.color,
  });
}

class DayStatus {
  final int day;
  bool isCompleted;

  DayStatus({required this.day, this.isCompleted = false});
}
