import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:alquranalkareem/core/utils/constants/extensions/custom_error_snackBar.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/utils/constants/url_constants.dart';
import '../../../../database/bookmark_db/bookmark_database.dart';
import '../../../../database/bookmark_db/db_bookmark_helper.dart';
import 'adhkar_state.dart';

class AzkarController extends GetxController {
  static AzkarController get instance => Get.isRegistered<AzkarController>()
      ? Get.find<AzkarController>()
      : Get.put<AzkarController>(AzkarController());

  AdhkarState state = AdhkarState();

  @override
  void onInit() async {
    super.onInit();
    await fetchDhekr();
  }

  /// -------- [Methods] ----------

  Future<List<AdhkarData>> readJsonData() async {
    final jsonData = await rootBundle.loadString('assets/json/azkar.json');
    final Map<String, dynamic> map = json.decode(jsonData);
    final list = map['data'] as List<dynamic>;

    return list.map((e) => AdhkarData.fromJson(e)).toList();
  }

  Future<void> fetchDhekr() async {
    var dhekrs = await readJsonData();
    state.allAdhkar.assignAll(dhekrs);
    state.filteredDhekrList.assignAll(dhekrs);

    // Extract unique categories
    state.categories
        .assignAll(state.allAdhkar.map((e) => e.category).toSet().toList());
  }

  void filterByCategory(String category) {
    if (category.isEmpty) {
      state.filteredDhekrList.assignAll(state.allAdhkar);
    } else {
      var filteredList =
          state.allAdhkar.where((zekr) => zekr.category == category).toList();
      state.filteredDhekrList.assignAll(filteredList);
    }
  }

  void filterFavByCategory(String category) {
    if (category.isEmpty) {
      state.filteredFavDhekrList.assignAll(state.adhkarList);
    } else {
      var filteredList =
          state.adhkarList.where((zekr) => zekr.category == category).toList();
      state.filteredFavDhekrList.assignAll(filteredList);
    }
  }

  Future<int?> addAdhkar(AdhkarData dhekr) {
    // تحويل كائن Dhekr إلى AdhkarCompanion
    final adhkarCompanion = AdhkarCompanion(
      category: drift.Value(dhekr.category),
      count: drift.Value(dhekr.count),
      description: drift.Value(dhekr.description),
      reference: drift.Value(dhekr.reference),
      zekr: drift.Value(dhekr.zekr),
    );
    log('${adhkarCompanion.zekr}', name: 'AzkarController');
    // إدخال البيانات إلى قاعدة البيانات باستخدام DbBookmarkHelper
    return DbBookmarkHelper.addAdhkar(adhkarCompanion).then((value) {
      Get.context!.showCustomErrorSnackBar('addZekrBookmark'.tr, isDone: true);
      getAdhkar();
      update();
      return value;
    });
  }

  Future<void> getAdhkar() async {
    final List<AdhkarData> adhkarList = await DbBookmarkHelper.getAllAdhkar();
    state.adhkarList.assignAll(adhkarList);
  }

  void deleteAdhkar(AdhkarData dhekr) async {
    await DbBookmarkHelper.deleteAdhkar(dhekr.category, dhekr.zekr);
    getAdhkar(); // تحديث القائمة بعد الحذف
  }

  void updateAdhkar(AdhkarData adhkar) async {
    final adhkarCompanion = AdhkarCompanion(
      category: drift.Value(adhkar.category),
      count: drift.Value(adhkar.count),
      description: drift.Value(adhkar.description),
      reference: drift.Value(adhkar.reference),
      zekr: drift.Value(adhkar.zekr),
    );
    await DbBookmarkHelper.updateAdhkar(adhkarCompanion, adhkar.id!);
    getAdhkar();
  }

  RxBool hasBookmark(String category, String zekr) {
    return (state.adhkarList.firstWhereOrNull(
                (a) => a.category == category && a.zekr == zekr) !=
            null)
        ? true.obs
        : false.obs;
  }

  List<TextSpan> buildTextSpans(String text) {
    final RegExp regExp = RegExp(r'\{(.*?)\}');
    final Iterable<Match> matches = regExp.allMatches(text);
    int lastMatchEnd = 0;
    List<TextSpan> spans = [];

    for (final Match match in matches) {
      final String preText = text.substring(lastMatchEnd, match.start);
      final String matchedText = match.group(1)!;

      if (preText.isNotEmpty) {
        spans.add(TextSpan(text: preText));
      }
      spans.add(TextSpan(
        text: matchedText,
        style: TextStyle(
          color: Get.theme.colorScheme.inversePrimary,
          fontFamily: 'uthmanic2',
        ),
      ));

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd)));
    }

    return spans;
  }

  List<TextSpan> shareTextSpans(String text) {
    final RegExp regExp = RegExp(r'\{(.*?)\}');
    final Iterable<Match> matches = regExp.allMatches(text);
    int lastMatchEnd = 0;
    List<TextSpan> spans = [];

    for (final Match match in matches) {
      final String preText = text.substring(lastMatchEnd, match.start);
      final String matchedText = match.group(1)!;

      if (preText.isNotEmpty) {
        spans.add(TextSpan(text: preText));
      }
      spans.add(TextSpan(
        text: matchedText,
        style: const TextStyle(
          color: Color(0xff161f07),
          fontFamily: 'uthmanic2',
        ),
      ));

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd)));
    }

    return spans;
  }

  shareText(String zekrText, String category, String reference,
      String description, String count) {
    Share.share(
        '$category\n'
        '$zekrText'
        '$reference\n'
        'التكرار: $count\n'
        '$description\n\n'
        '${'appName'.tr}\n${UrlConstants.downloadAppUrl}',
        subject: '${'appName'.tr}\n$category');
  }

  Future<void> createAndShowZekrImage() async {
    try {
      final Uint8List? imageBytes =
          await state.dhekrScreenController.capture(pixelRatio: 7);
      state.dhekrToImageBytes = imageBytes;
      update();
    } catch (e) {
      debugPrint('Error capturing verse image: $e');
    }
  }

  Future<void> shareZekr() async {
    if (state.dhekrToImageBytes != null) {
      final directory = await getTemporaryDirectory();
      final imagePath = await File('${directory.path}/zekr_image.png').create();
      await imagePath.writeAsBytes(state.dhekrToImageBytes!);
      await Share.shareXFiles([XFile((imagePath.path))], text: 'appName'.tr);
    }
  }
}
