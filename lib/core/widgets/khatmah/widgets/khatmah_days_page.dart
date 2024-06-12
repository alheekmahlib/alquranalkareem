import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../presentation/controllers/khatmah_controller.dart';
import '../data/data_source/khatmah_database.dart';

class KhatmahDaysPage extends StatelessWidget {
  final Khatmah khatmah;
  KhatmahDaysPage({super.key, required this.khatmah});

  final khatmahCtrl = KhatmahController.instance;

  @override
  Widget build(BuildContext context) {
    final int daysCount = khatmah.daysCount ?? 30; // عدد الأيام
    final int pagesPerDay = (khatmahCtrl.totalPages / daysCount).ceil();

    return Scaffold(
      appBar: AppBar(
        title: Text('${khatmah.name} - Days'),
      ),
      body: ListView.builder(
        itemCount: daysCount,
        itemBuilder: (context, index) {
          final int startPage = index * pagesPerDay + 1;
          final int endPage = (index + 1) * pagesPerDay;
          final bool isCompleted = khatmah.currentPage! >= endPage;

          return ListTile(
            title: Text('Day ${index + 1}'),
            subtitle: Text('Pages: $startPage - $endPage'),
            trailing: isCompleted
                ? Icon(Icons.check, color: Colors.green)
                : Icon(Icons.circle, color: Colors.grey),
            onTap: () {
              // قم بتحويل المستخدم إلى الصفحة المناسبة
              khatmahCtrl.markDayAsRead(khatmah.id, index + 1, daysCount);
              Get.back(); // ارجع إلى الشاشة السابقة بعد التحديث
            },
          );
        },
      ),
    );
  }
}
