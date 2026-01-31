import 'dart:convert';
import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '/core/services/api_client.dart';
import '../../../../core/utils/constants/api_constants.dart';
import '../data/models/ourApp_model.dart';

class OurAppsController extends GetxController {
  static OurAppsController get instance =>
      GetInstance().putOrFind(() => OurAppsController());

  // جلب بيانات التطبيقات باستخدام ApiClient
  // Fetch apps data using ApiClient
  Future<List<OurAppInfo>> fetchApps() async {
    try {
      final apiClient = ApiClient();
      final result = await apiClient.request(
        endpoint: ApiConstants.ourAppsUrl,
        method: HttpMethod.get,
      );

      return result.fold(
        (failure) {
          log(
            'فشل في جلب البيانات: ${failure.message}',
            name: 'OurAppsController',
          );
          log(
            'Failed to fetch data: ${failure.message}',
            name: 'OurAppsController',
          );
          throw Exception('Failed to load data: ${failure.message}');
        },
        (data) {
          log('تم جلب البيانات بنجاح', name: 'OurAppsController');
          log('Data fetched successfully', name: 'OurAppsController');

          // تحويل البيانات من String إلى List إذا لزم الأمر
          // Convert data from String to List if needed
          List<dynamic> jsonData;
          if (data is String) {
            jsonData = jsonDecode(data) as List<dynamic>;
          } else {
            jsonData = data as List<dynamic>;
          }

          return jsonData.map((item) => OurAppInfo.fromJson(item)).toList();
        },
      );
    } catch (e) {
      log('خطأ في جلب البيانات: $e', name: 'OurAppsController');
      log('Error fetching data: $e', name: 'OurAppsController');
      throw Exception('Failed to load data');
    }
  }

  // إطلاق رابط التطبيق حسب النظام الأساسي
  // Launch app URL based on platform
  Future<void> launchURL(
    BuildContext context,
    int index,
    OurAppInfo ourAppInfo,
  ) async {
    if (await canLaunchUrl(
      Uri.parse('${ApiConstants.downloadAppsUrl}${ourAppInfo.appName}'),
    )) {
      await launchUrl(
        Uri.parse('${ApiConstants.downloadAppsUrl}${ourAppInfo.appName}'),
      );
    } else {
      throw 'Could not launch ${ApiConstants.downloadAppsUrl}${ourAppInfo.appName}';
    }
  }
}
