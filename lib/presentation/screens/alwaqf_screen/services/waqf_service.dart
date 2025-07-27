import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/waqf_model.dart';

// Service to load Waqf data from JSON file.
// خدمة لتحميل بيانات الوقف من ملف JSON.
class WaqfService {
  static Future<List<WaqfModel>> loadWaqfData() async {
    try {
      // Load JSON file as a string.
      // تحميل ملف JSON كسلسلة نصية.
      final String response =
          await rootBundle.loadString('assets/json/waqf_translated.json');
      final List<dynamic> data = json.decode(response);

      // Map JSON data to a list of WaqfModel.
      // تحويل بيانات JSON إلى قائمة من WaqfModel.
      return data.map((item) => WaqfModel.fromJson(item)).toList();
    } catch (e) {
      // Log error if loading fails.
      // تسجيل الخطأ إذا فشل التحميل.
      print('Error loading Waqf data: $e');
      return [];
    }
  }
}
