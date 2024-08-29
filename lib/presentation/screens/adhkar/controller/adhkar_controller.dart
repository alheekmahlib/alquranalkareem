import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '/core/utils/constants/extensions/custom_error_snackBar.dart';
import '../../../../core/utils/constants/url_constants.dart';
import '../../../../database/databaseHelper.dart';
import '../models/dheker_model.dart';
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

  Future<List<Dhekr>> readJsonData() async {
    final jsonData = await rootBundle.loadString('assets/json/azkar.json');
    final Map<String, dynamic> map = json.decode(jsonData);
    final list = map['data'] as List<dynamic>;

    return list.map((e) => Dhekr.fromJson(e)).toList();
  }

  Future<int?> addAdhkar(Dhekr? azkar) {
    return DatabaseHelper.addAdhkar(azkar!);
  }

  Future<void> getAdhkar() async {
    final List<Map<String, dynamic>> adhkar = await DatabaseHelper.queryC();
    state.adhkarList
        .assignAll(adhkar.map((data) => Dhekr.fromJson(data)).toList());
  }

  void deleteAdhkar(Dhekr? azkar, BuildContext context) async {
    await DatabaseHelper.deleteAdhkar(azkar!).then((value) {
      context.showCustomErrorSnackBar('deletedZekrBookmark'.tr);
      update();
    });
    getAdhkar();
  }

  void updateAdhkar(Dhekr? adhkar) async {
    await DatabaseHelper.updateAdhkar(adhkar!);
    getAdhkar();
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

  RxBool hasBookmark(String category, String zekr) {
    return (state.adhkarList.obs.value
                    .firstWhereOrNull(
                        ((a) => a.category == category && a.zekr == zekr))
                    .obs)
                .value ==
            null
        ? false.obs
        : true.obs;
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
