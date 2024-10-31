import 'dart:typed_data';

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
}
