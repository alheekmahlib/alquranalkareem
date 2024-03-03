import 'dart:convert';
import 'dart:developer' show log;
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/services_locator.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import '../../core/utils/constants/url_constants.dart';
import '../../database/databaseHelper.dart';
import '../screens/athkar/models/zeker_model.dart';
import '/core/utils/constants/extensions/custom_error_snackBar.dart';

class AzkarController extends GetxController {
  final RxList<Zekr> azkarList = <Zekr>[].obs;
  final listController = ScrollController();
  final favController = ScrollController();
  late TabController tabController;
  // math.Random random = math.Random();
  var allAzkar = <Zekr>[].obs;
  var filteredZekrList = <Zekr>[].obs;
  var filteredFavZekrList = <Zekr>[].obs;
  var categories = <String>[].obs;
  Zekr? zekerOfTheDay;
  final ScreenshotController zekrScreenController = ScreenshotController();
  Uint8List? ayahToImageBytes;

  @override
  void onInit() async {
    super.onInit();
    await fetchZekr();
  }

  Future<void> fetchZekr() async {
    var zekrs = await readJsonData();
    allAzkar.assignAll(zekrs);
    filteredZekrList.assignAll(zekrs);

    // Extract unique categories
    categories.assignAll(allAzkar.map((e) => e.category).toSet().toList());
  }

  void filterByCategory(String category) {
    if (category.isEmpty) {
      filteredZekrList.assignAll(allAzkar);
    } else {
      var filteredList =
          allAzkar.where((zekr) => zekr.category == category).toList();
      filteredZekrList.assignAll(filteredList);
    }
  }

  void filterFavByCategory(String category) {
    if (category.isEmpty) {
      filteredFavZekrList.assignAll(azkarList);
    } else {
      var filteredList =
          azkarList.where((zekr) => zekr.category == category).toList();
      filteredFavZekrList.assignAll(filteredList);
    }
  }

  Future<List<Zekr>> readJsonData() async {
    final jsondata = await rootBundle.loadString('assets/json/azkar.json');
    final Map<String, dynamic> map = json.decode(jsondata);
    final list = map['data'] as List<dynamic>;

    return list.map((e) => Zekr.fromJson(e)).toList();
  }

  Future<int?> addAzkar(Zekr? azkar) {
    return DatabaseHelper.addAzkar(azkar!);
  }

  Future<void> getAzkar() async {
    final List<Map<String, dynamic>> azkar = await DatabaseHelper.queryC();
    azkarList.assignAll(azkar.map((data) => Zekr.fromJson(data)).toList());
  }

  void deleteAzkar(Zekr? azkar, BuildContext context) async {
    await DatabaseHelper.deleteAzkar(azkar!).then((value) {
      context.showCustomErrorSnackBar('deletedZekrBookmark'.tr);
      update();
    });
    getAzkar();
  }

  void updateAzkar(Zekr? azkar) async {
    await DatabaseHelper.updateAzkar(azkar!);
    getAzkar();
  }

  Future<Zekr> getDailyZeker() async {
    print('missing daily Zeker');
    if (zekerOfTheDay != null) return zekerOfTheDay!;
    final String? zekerOfTheDayIdAndId =
        sl<SharedPreferences>().getString(ZEKER_OF_THE_DAY_AND_ID);
    zekerOfTheDay = await _getZekerForThisDay(
        _hasZekerSettedForThisDay ? zekerOfTheDayIdAndId : null);

    return zekerOfTheDay!;
  }

  bool get _hasZekerSettedForThisDay {
    final settedDate = sl<SharedPreferences>().getString(SETTED_DATE_FOR_ZEKER);
    return (settedDate != null && settedDate == HijriCalendar.now().fullDate());
  }

  Future<Zekr> _getZekerForThisDay([String? zekerOfTheDayIdAndZekerId]) async {
    log("zekerOfTheDayIdAndZekerId: ${zekerOfTheDayIdAndZekerId == null ? "null" : "NOT NULL"}");
    if (zekerOfTheDayIdAndZekerId != null) {
      log("before trying to get ziker", name: 'BEFORE');
      final cachedZeker = allAzkar[int.parse(zekerOfTheDayIdAndZekerId) - 1];
      log("date: ${HijriCalendar.now().fullDate()}", name: 'CAHECH HADITH');
      return cachedZeker;
    }
    final random = math.Random().nextInt(allAzkar.length);
    log('allAzkar length: ${allAzkar.length}');
    Zekr? zeker = allAzkar.firstWhereOrNull((z) => z.id == random);
    log('allAzkar length: ${allAzkar.length} 2222');
    while (zeker == null) {
      log('allAzkar length: ${allAzkar.length} ', name: 'while');
      zeker = allAzkar.firstWhereOrNull((z) => z.id == random);
      log('zikr is null  ' * 5);
    }
    log('before listing');
    sl<SharedPreferences>()
      ..setString(ZEKER_OF_THE_DAY_AND_ID, '${zeker.id}')
      ..setString(SETTED_DATE_FOR_ZEKER, HijriCalendar.now().fullDate());
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
    return (azkarList.obs.value
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
      final Uint8List? imageBytes = await zekrScreenController.capture();
      ayahToImageBytes = imageBytes;
      update();
    } catch (e) {
      debugPrint('Error capturing verse image: $e');
    }
  }

  Future<void> shareZekr(BuildContext context) async {
    if (ayahToImageBytes! != null) {
      final directory = await getTemporaryDirectory();
      final imagePath = await File('${directory.path}/zekr_image.png').create();
      await imagePath.writeAsBytes(ayahToImageBytes!);
      await Share.shareXFiles([XFile((imagePath.path))], text: 'appName'.tr);
    }
  }
}
