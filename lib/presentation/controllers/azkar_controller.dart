import 'dart:convert';
import 'dart:developer' show log;
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '/core/utils/constants/extensions/custom_error_snackBar.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import '../../core/utils/constants/url_constants.dart';
import '../../database/databaseHelper.dart';
import '../screens/athkar/models/zeker_model.dart';

class AzkarController extends GetxController {
  static AzkarController get instance => Get.isRegistered<AzkarController>()
      ? Get.find<AzkarController>()
      : Get.put<AzkarController>(AzkarController());
  final RxList<Dhekr> adhkarList = <Dhekr>[].obs;
  final listController = ScrollController();
  final favController = ScrollController();
  // math.Random random = math.Random();
  var allAdhkar = <Dhekr>[].obs;
  var filteredDhekrList = <Dhekr>[].obs;
  var filteredFavDhekrList = <Dhekr>[].obs;
  var categories = <String>[].obs;
  Dhekr? dhekrOfTheDay;
  final ScreenshotController dhekrScreenController = ScreenshotController();
  Uint8List? dhekrToImageBytes;
  final box = GetStorage();

  @override
  void onInit() async {
    super.onInit();
    await fetchDhekr();
  }

  Future<void> fetchDhekr() async {
    var dhekrs = await readJsonData();
    allAdhkar.assignAll(dhekrs);
    filteredDhekrList.assignAll(dhekrs);

    // Extract unique categories
    categories.assignAll(allAdhkar.map((e) => e.category).toSet().toList());
  }

  void filterByCategory(String category) {
    if (category.isEmpty) {
      filteredDhekrList.assignAll(allAdhkar);
    } else {
      var filteredList =
          allAdhkar.where((zekr) => zekr.category == category).toList();
      filteredDhekrList.assignAll(filteredList);
    }
  }

  void filterFavByCategory(String category) {
    if (category.isEmpty) {
      filteredFavDhekrList.assignAll(adhkarList);
    } else {
      var filteredList =
          adhkarList.where((zekr) => zekr.category == category).toList();
      filteredFavDhekrList.assignAll(filteredList);
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
    adhkarList.assignAll(adhkar.map((data) => Dhekr.fromJson(data)).toList());
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

  Future<Dhekr> getDailyDhekr() async {
    print('missing daily Dhekr');
    if (dhekrOfTheDay != null) return dhekrOfTheDay!;
    final String? zekerOfTheDayIdAndId = box.read(ZEKER_OF_THE_DAY_AND_ID);
    dhekrOfTheDay = await _getZekerForThisDay(
        _hasZekerSettedForThisDay ? zekerOfTheDayIdAndId : null);

    return dhekrOfTheDay!;
  }

  bool get _hasZekerSettedForThisDay {
    final settedDate = box.read(SETTED_DATE_FOR_ZEKER);
    return (settedDate != null && settedDate == HijriCalendar.now().fullDate());
  }

  Future<Dhekr> _getZekerForThisDay([String? zekerOfTheDayIdAndZekerId]) async {
    log("zekerOfTheDayIdAndZekerId: ${zekerOfTheDayIdAndZekerId == null ? "null" : "NOT NULL"}");
    if (zekerOfTheDayIdAndZekerId != null) {
      log("before trying to get ziker", name: 'BEFORE');
      final cachedZeker = allAdhkar[int.parse(zekerOfTheDayIdAndZekerId) - 1];
      log("date: ${HijriCalendar.now().fullDate()}", name: 'CAHECH HADITH');
      return cachedZeker;
    }
    final random = math.Random().nextInt(allAdhkar.length);
    log('allAzkar length: ${allAdhkar.length}');
    Dhekr? zeker = allAdhkar.firstWhereOrNull((z) => z.id == random);
    log('allAzkar length: ${allAdhkar.length} 2222');
    while (zeker == null) {
      log('allAzkar length: ${allAdhkar.length} ', name: 'while');
      zeker = allAdhkar.firstWhereOrNull((z) => z.id == random);
      log('zikr is null  ' * 5);
    }
    log('before listing');
    box
      ..write(ZEKER_OF_THE_DAY_AND_ID, '${zeker.id}')
      ..write(SETTED_DATE_FOR_ZEKER, HijriCalendar.now().fullDate());
    return zeker;
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
    return (adhkarList.obs.value
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
          await dhekrScreenController.capture(pixelRatio: 7);
      dhekrToImageBytes = imageBytes;
      update();
    } catch (e) {
      debugPrint('Error capturing verse image: $e');
    }
  }

  Future<void> shareZekr(BuildContext context) async {
    if (dhekrToImageBytes != null) {
      final directory = await getTemporaryDirectory();
      final imagePath = await File('${directory.path}/zekr_image.png').create();
      await imagePath.writeAsBytes(dhekrToImageBytes!);
      await Share.shareXFiles([XFile((imagePath.path))], text: 'appName'.tr);
    }
  }
}
