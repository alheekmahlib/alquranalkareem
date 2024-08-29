import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:screenshot/screenshot.dart';

import '../models/dheker_model.dart';

class AdhkarState {
  final RxList<Dhekr> adhkarList = <Dhekr>[].obs;
  final listController = ScrollController();
  final favController = ScrollController();
  var allAdhkar = <Dhekr>[].obs;
  var filteredDhekrList = <Dhekr>[].obs;
  var filteredFavDhekrList = <Dhekr>[].obs;
  var categories = <String>[].obs;
  Dhekr? dhekrOfTheDay;
  final ScreenshotController dhekrScreenController = ScreenshotController();
  Uint8List? dhekrToImageBytes;
  RxBool isMorningEnabled = false.obs;
  RxBool isEveningEnabled = false.obs;
  RxMap<String, String> customAdhkar = <String, String>{}.obs;
  RxMap<String, bool> customAdhkarEnabled = <String, bool>{}.obs;
  var selectedCategory = Rxn<String>();
  final box = GetStorage();
}
