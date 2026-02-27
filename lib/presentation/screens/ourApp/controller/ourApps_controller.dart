import 'dart:convert';
import 'dart:developer' show log;

import 'package:floating_menu_expendable/floating_menu_expendable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran_library/src/service/internet_connection_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '/core/services/api_client.dart';
import '../../../../core/utils/constants/api_constants.dart';
import '../data/models/ourApp_model.dart';

class OurAppsController extends GetxController {
  static OurAppsController get instance =>
      GetInstance().putOrFind(() => OurAppsController());

  FloatingMenuAnchoredOverlayController controller =
      FloatingMenuAnchoredOverlayController();

  static const _cacheKey = 'our_apps_cache';
  final _box = GetStorage();

  /// جلب بيانات التطبيقات: من الشبكة مع حفظ في الكاش، أو من الكاش عند عدم وجود اتصال
  Future<List<OurAppInfo>> fetchApps() async {
    final isConnected = InternetConnectionController.instance.isConnected;

    if (isConnected) {
      try {
        final apiClient = ApiClient();
        final result = await apiClient.request(
          endpoint: ApiConstants.ourAppsUrl,
          method: HttpMethod.get,
        );

        return result.fold(
          (failure) {
            log(
              'Failed to fetch data: ${failure.message}',
              name: 'OurAppsController',
            );
            // عند فشل الطلب، حاول استخدام الكاش
            return _loadFromCache();
          },
          (data) {
            log('Data fetched successfully', name: 'OurAppsController');

            List<dynamic> jsonData;
            if (data is String) {
              jsonData = jsonDecode(data) as List<dynamic>;
            } else {
              jsonData = data as List<dynamic>;
            }

            // حفظ البيانات في الكاش
            _box.write(_cacheKey, jsonData);

            return jsonData.map((item) => OurAppInfo.fromJson(item)).toList();
          },
        );
      } catch (e) {
        log('Error fetching data: $e', name: 'OurAppsController');
        // عند حدوث خطأ، حاول استخدام الكاش
        return _loadFromCache();
      }
    } else {
      // لا يوجد اتصال، استخدم الكاش
      return _loadFromCache();
    }
  }

  /// تحميل البيانات من الكاش المحلي
  List<OurAppInfo> _loadFromCache() {
    final cached = _box.read<List<dynamic>>(_cacheKey);
    if (cached != null && cached.isNotEmpty) {
      log('Loading data from cache', name: 'OurAppsController');
      return cached
          .map((item) => OurAppInfo.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    log('No cached data available', name: 'OurAppsController');
    return [];
  }

  // إطلاق رابط التطبيق حسب النظام الأساسي
  // Launch app URL based on platform
  Future<void> launchURL(BuildContext context, OurAppInfo ourAppInfo) async {
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
