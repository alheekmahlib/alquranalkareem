import 'dart:convert';
import 'dart:developer' show log;

import 'package:connectivity_kit/connectivity_kit.dart';
import 'package:floating_menu_expendable/floating_menu_expendable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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

  // نعرض فقط تطبيقات مكتبة الحكمة
  static const _companyName = 'Alheekmah Library';

  /// يُرجع التطبيقات التي تنتمي لمكتبة الحكمة فقط.
  List<OurAppInfo> _filterByCompany(List<OurAppInfo> apps) =>
      apps.where((app) => app.companyName == _companyName).toList();

  /// جلب بيانات التطبيقات: من الشبكة مع حفظ في الكاش، أو من الكاش عند عدم وجود اتصال
  Future<List<OurAppInfo>> fetchApps() async {
    final isConnected = ConnectionController.instance.isOnline;

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

            // الـ API الجديد يُغلّف المصفوفة داخل { "apps": [...] }
            // يدعم أيضاً الردود غير المغلّفة (Array مباشرة) للمرونة.
            List<dynamic> jsonData;
            if (data is String) {
              final decoded = jsonDecode(data);
              jsonData = decoded is List
                  ? decoded
                  : (decoded['apps'] as List<dynamic>? ?? const []);
            } else if (data is List) {
              jsonData = data;
            } else {
              final map = data as Map<String, dynamic>;
              jsonData = map['apps'] as List<dynamic>? ?? const [];
            }

            // حفظ البيانات في الكاش
            _box.write(_cacheKey, jsonData);

            final apps = jsonData
                .map((item) => OurAppInfo.fromJson(item))
                .toList();
            return _filterByCompany(apps);
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
      final apps = cached
          .map((item) => OurAppInfo.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      return _filterByCompany(apps);
    }
    log('No cached data available', name: 'OurAppsController');
    return [];
  }

  // إطلاق رابط التحميل القادم من الـ API (dynamicLink)
  // Launch the app's dynamic download link from the API
  Future<void> launchURL(BuildContext context, OurAppInfo ourAppInfo) async {
    final uri = Uri.parse(ourAppInfo.dynamicLink);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch ${ourAppInfo.dynamicLink}';
    }
  }
}
