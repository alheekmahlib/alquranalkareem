import 'dart:async';
import 'dart:typed_data';

import 'package:flexible_sheet/flexible_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../database/bookmark_db/bookmark_database.dart';

class AdhkarState {
  final RxList<AdhkarData> adhkarList = <AdhkarData>[].obs;
  final listController = ScrollController();
  final favController = ScrollController();
  var allAdhkar = <AdhkarData>[].obs;
  var filteredDhekrList = <AdhkarData>[].obs;
  var filteredFavDhekrList = <AdhkarData>[].obs;
  var categories = <String>[].obs;
  AdhkarData? dhekrOfTheDay;
  final ScreenshotController dhekrScreenController = ScreenshotController();
  Uint8List? dhekrToImageBytes;
  RxBool isMorningEnabled = false.obs;
  RxBool isEveningEnabled = false.obs;
  RxMap<String, String> customAdhkar = <String, String>{}.obs;
  RxMap<String, bool> customAdhkarEnabled = <String, bool>{}.obs;
  var selectedCategory = Rxn<String>();
  final box = GetStorage();
  final tabBarController = FlexibleSheetController();

  // ---- حقول البحث في الأذكار ----
  /// متحكّم حقل نص البحث في شاشة قائمة الأقسام
  final TextEditingController searchController = TextEditingController();

  /// نص استعلام البحث الحالي (يُراقَب لإظهار/إخفاء النتائج)
  var searchQuery = ''.obs;

  /// نتائج البحث المعروضة في قائمة الأقسام
  var searchResults = <AdhkarData>[].obs;

  // ---- التنقّل من نتيجة البحث إلى الذكر داخل شاشة القسم ----
  /// معرّف الذكر المستهدف للتمرير إليه داخل شاشة AdhkarItem
  var targetZekrId = Rxn<int>();

  /// معرّف الذكر المُراد تمييزه بصرياً بشكل مؤقت
  var highlightedZekrId = Rxn<int>();

  /// متحكّم تمرير شاشة AdhkarItem (للتمرير السلس للذكر المستهدف)
  final ScrollController itemScrollController = ScrollController();

  /// مفاتيح عناصر AdhkarItem لاستخدامها مع Scrollable.ensureVisible
  final Map<int, GlobalKey> itemKeys = <int, GlobalKey>{};

  /// مؤقّت إزالة التمييز البصري (يُعاد جدولته عند كل تمييز جديد)
  Timer? highlightTimer;
}
